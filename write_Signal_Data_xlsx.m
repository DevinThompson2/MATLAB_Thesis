function write_Signal_Data_xlsx(output, name, sheet)
% Put the signals into a table and write them to excel
% Create the path and filename to read and write to
path = "Z:\SSL\Research\Graduate Students\Thompson, Devin\Thesis Docs\Pitch Modality (RIP)\Thesis\Data\";
filename = strcat(name, "Data.xlsx");
pathAndFile = strcat(path,filename);
sheetList = {"Tee"; "BP"; "Cannon"; "Live"};
% Sheet: Tee = 1; BP = 2, Cannon = 3, Live = 4


% Determine if the file exists
if isfile(pathAndFile) == 1 % File exists
    % If the file exists, check the sheets
elseif isfile(pathAndFile) == 0 % File does not exist, need to create it
    % Read and create the heading for the file
    headingPath = "Z:\SSL\Research\Graduate Students\Thompson, Devin\Thesis Docs\Pitch Modality (RIP)\Thesis\Data\SignalHeading.xlsx";
    heading = readcell(headingPath);
    % Convert heading cell array to proper output formats for "missing"
    % values
    mask = cellfun(@ismissing, heading, 'UniformOutput',false);
    mask = cellfun(@mean, mask);
    mask = ceil(mask);
    mask = logical(mask);
    heading(mask) = {""};
    % Write the heading to create the new file, write it for each sheet
    writecell(heading, pathAndFile,'Sheet',sheetList{1});
    writecell(heading, pathAndFile,'Sheet',sheetList{2});
    writecell(heading, pathAndFile,'Sheet',sheetList{3});
    writecell(heading, pathAndFile,'Sheet',sheetList{4});
else
    error("Something has gone horribly wrong when determining if the output Excel file exists. Fix it you dummy!!!!!!!")
end

% Loop over all variabes and output them, also need to get the current
% index to output the matrix to
for i = 1:length(output)
    inCell = readcell(pathAndFile, 'FileType','spreadsheet', 'Range','1:4', 'Sheet', sheet);
    % Get the first index that is open in the table
    index = 1;
    while ~ismissing(inCell{4,index})
        index = index + 1; 
    end
    %dataIndex = index + 1; % Excel index always going to be one more than the table
    outCellName = xlRC2A1(4,index);
    % Write each matrix to the correct location
    writematrix(output{i}, pathAndFile, 'Sheet',sheet,'Range',outCellName);
end

end

