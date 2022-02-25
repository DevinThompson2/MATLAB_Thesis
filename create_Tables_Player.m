function [outTables] = create_Tables_Player(subjectData, phaseNames, metricNames)
%Input: subjectData: the data for one subject
%       phaseNames: cell vector of names of phases in data (stance, load,
%       etc...
%       metricNames: cell array that contains names of metrics in each phase
%       tableToMake: string, files of data to used
% Output: outTable, the table to output

% Create an array of tables and the corresponding code - Don't think this
% is actually necessary

% This isn't being used at all
% tables = {'BatBall', 'FirstMove','FollowThrough', 'EventTime','FootDown','FootUp','Impact','Load','Stance','MaxTime','Timing'};
% tablesVec = num2cell([1:11]);
% tablesArray = [tables; tablesVec]'; 

% Loop over create_Table to make each table, store these tables in an array
for i = 1:length(phaseNames)
    outTables{i,1} = create_Table(subjectData, phaseNames, metricNames, i);
    %disp(strcat("create_Table: ", num2str(i)))
end





end

