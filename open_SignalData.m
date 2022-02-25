function [data] = open_SignalData(pathName, folderList)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Set pattern for folders to look in, get names of those files
for i = 1:length(folderList)
    % Set the path, file type to look at in folders
    fullPath{i,1} = fullfile(pathName,folderList{i}, '*.mat');
    % Names of files to open, in a dir struct
    filesToOpenStruct = dir(fullPath{i});
    % Remove SignalsData from this structure
    filesToOpenStruct = filesToOpenStruct(9); % Change this number is new mat files were added in V3d, or just figure out a better way to extract these
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

