function [outTable] = create_Table(subjectData, phaseNames, metricNames, tableToMake)
%Input: subjectData: the data for one subject
%       phaseNames: cell vector of names of phases in data (stance, load,
%       etc...
%       metricNames: cell array that contains names of metrics in each phase
%       tableToMake: string, files of data to used
% Output: outTable, the table to output

% Put data from one data file into a table

% Loop over each variable in the data set
for i = 1:length(metricNames{tableToMake})
    %i
    T{i} = table(subjectData.(phaseNames{tableToMake}).(metricNames{tableToMake}{i}), 'VariableNames',metricNames{tableToMake}(i));
    outTable(:,i) = T{i};
end

% For some reason, only the name of the first variable was labeleled. Set
% the names of the other variables to the correct name
outTable.Properties.VariableNames = metricNames{tableToMake};

end