function [averageTables] = average_All_Tables(inTables,tablePitchNames, numSubjects, numTablesPerPlayer)
% Input: inTables: teeTables
%               bpTables
%               cannonTables
%               liveTables
%

% Average each table 
for i = 1:length(tablePitchNames) % Number of table types
    for j = 1:numSubjects % For each player
        for k = 1:numTablesPerPlayer % For each table per player
            averageTables{i,1}{j,1}{k,1} = average_Table(inTables{i}{j}{k});
        end
    end
end

end

