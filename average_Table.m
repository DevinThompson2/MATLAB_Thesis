function [outTable] = average_Table(inTable)
% Input: typeTable: cell array of all of the tables for each phase table
%        phases: a cell array of the phase tables

% for FILE_Name field, create name of the variable
[path, name, ext] = fileparts(char(inTable{1,1}));
index = find(isletter(name), 1,'last');
name = {name(1:index)};
outTableName = cell2table(name);

% Compute the average for each metric in the table
takeMeans = @(input) mean(input,'omitnan');
outTableMeans = varfun(takeMeans, inTable(:,2:end));
outTable = [outTableName outTableMeans];
end

