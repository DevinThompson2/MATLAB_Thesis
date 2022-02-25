function [data] = open_Mat_Files(pathName, folderList)
% Input: pathName: String, name of the path that the data folders are in
%         folderList: List of the folder names that contain the matfiles

% Set pattern for folders to look in, get names of those files
for i = 1:length(folderList)
    % Set the path, file type to look at in folders
    fullPath{i,1} = fullfile(pathName,folderList{i}, '*.mat');
    % Names of files to open, in a dir struct
    filesToOpenStruct = dir(fullPath{i});
    % Remove SignalsData from this structure
    filesToOpenStruct(8) = [];
    [numFiles, ~] = size(filesToOpenStruct);
    % Open each file into a data structure
    for j=1:numFiles
        filesToOpen{j,i} = filesToOpenStruct(j).name;
        % Remove the extension from the filename
        [~,filesToOpenNoExt{j,i},~] = fileparts(filesToOpen{j,i});
        % Open the data to a struct
        data.(folderList{i}).(filesToOpenNoExt{j,i}) = load(fullfile(pathName, folderList{i}, filesToOpen{j,i})); 
    end
end


end

