function [teeTable, bpTable, cannonTable, liveTable] = separate_All_Tables(phaseTables)
% Input: playerTables:
%        phaseNames:
%        metricNames:phase

% Loop over each table per subject
for i = 1:length(phaseTables)
    [teeTable{i,1}, bpTable{i,1}, cannonTable{i,1}, liveTable{i,1}] = separate_By_Pitch_Mode(phaseTables{i});
end
    
end

