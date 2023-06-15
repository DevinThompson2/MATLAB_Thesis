function [outputArg1,outputArg2] = convert_SignalData(data, fileName, outPath)
% Write some loops to write the data to the correct

% Get the trial names to write 
trialPaths = data.FILE_NAME;
trialNames = extractAfter(trialPaths,'Session');
trialNames = extractAfter(trialNames,'\');
trialNames = extractBefore(trialNames,'.');
numVars = length(fieldnames(data)) - 3; % -3 due to three variables not actually being variables
frameRate = data.FRAME_RATE{1};

%pathName = extractBefore(trialPaths,)

% Get the number of rows and columns in each variable
varNames = fieldnames(data);
varNames = varNames(4:end);
for i = 1:numVars
    varSizes(i,:) = size(data.(varNames{i}){1});
end

startCols = 1;
for i = 2:numVars
    startCols(i,1) = startCols(i-1,1) + varSizes(i-1,2);
end

for i = 1:length(trialPaths)
    % Write the trial name and frame rate
    writecell(trialNames(i), strcat(outPath, "\", fileName, ".xlsx"), 'Sheet', trialNames{i}, 'Range', 'A1')
    writematrix("Frame Rate", strcat(outPath, "\", fileName, ".xlsx"), 'Sheet', trialNames{i}, 'Range', 'A2')
    writematrix(frameRate, strcat(outPath, "\", fileName, ".xlsx"), 'Sheet', trialNames{i}, 'Range', 'B2')

    % Write the variable names and the data to the Excell sheet
    writematrix("Variables", strcat(outPath, "\", fileName, ".xlsx"), 'Sheet', trialNames{i}, 'Range', 'A3')
    for j = 1:numVars
        % Convert the row and column start point of the data into an excel
        % sheet
        varNameCell = xlRC2A1(4,startCols(j));
        % Determine the component variable names
        writematrix(varNames{j}, strcat(outPath, "\", fileName, ".xlsx"), 'Sheet', trialNames{i}, 'Range', varNameCell)
        if varSizes(j,2) == 3
            varComponents = ["X" "Y" "Z"];
        elseif varSizes(j,2) == 1
            varComponents = ["MAG"];
        elseif varSizes(j,2) == 5
            varComponents = ["X" "Y" "Z" "Valid Frame" "Zeros"];
        else
            error("Variable size other than 1,3,or 5. Need to add a conditional statement in")
        end
        % Convert this value to a row and column
        compNameCell = xlRC2A1(5, startCols(j));
        writematrix(varComponents, strcat(outPath, "\", fileName, ".xlsx"), 'Sheet', trialNames{i}, 'Range', compNameCell)
        
        % Convert the variable data rows, columns to cells and write to
        % excel sheet
        dataNameCell = xlRC2A1(6, startCols(j));
        writematrix(data.(varNames{j}){i}, strcat(outPath, "\", fileName, ".xlsx"), 'Sheet', trialNames{i}, 'Range', dataNameCell)

    end
    disp(strcat(trialNames(i), " written to Excel sheet"))
end

end