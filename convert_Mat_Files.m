function convert_Mat_Files(pathName, folderList, folderPath)
% Input: pathName: String, name of the path that the data folders are in
%         folderList: List of the folder names that contain the matfiles

% Set pattern for folders to look in, get names of those files
for i = 1:length(folderList)
    % Set the path, file type to look at in folders
    fullPath{i,1} = fullfile(pathName,folderList{i}, '*.mat');
    % Names of files to convert, in a dir struct
    filesToConvertStruct = dir(fullPath{i});
    % Get the number of files in each subject folder (should be the same for each subject)
    [numFiles, ~] = size(filesToConvertStruct);
    
    % Loop to read the data and convert it to .csv files
    for j=1:numFiles
        % Load the file
        inFile = load(strcat(filesToConvertStruct(j).folder,"\", filesToConvertStruct(j).name));
        %inFile = readstruct()
        % Remove the .mat from the filename
        noMatFileName = erase(filesToConvertStruct(j).name, ".mat");

        if noMatFileName == "SignalData" % The signals can't be written effectively as a table, need to write as xml
            % Convert the input structure into a table
            convert_SignalData(inFile, noMatFileName, filesToConvertStruct(j).folder)
            %inFileTable = struct2table(inFile, "AsArray",true);
            %writetable(inFileTable,strcat(filesToConvertStruct(j).folder,"\",noMatFileName, ".txt"))
        else % The data can be converted to a table, write it as as csv
            % Convert the input structure into a table
            inFileTable = struct2table(inFile);
            % Write it as a .csv
            writetable(inFileTable, strcat(filesToConvertStruct(j).folder,"\",noMatFileName, ".csv"))
        end
        
        
        %readFiles{j,i} = load()
        
%         filesToOpen{j,i} = filesToOpenStruct(j).name;
%         % Remove the extension from the filename
%         [~,filesToOpenNoExt{j,i},~] = fileparts(filesToOpen{j,i});
%         % Open the data to a struct
%         data.(folderList{i}).(filesToOpenNoExt{j,i}) = load(fullfile(pathName, folderList{i}, filesToOpen{j,i})); 
    end

end


end

