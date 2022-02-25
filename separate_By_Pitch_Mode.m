function [teeTable,bpTable,cannonTable,liveTable] = separate_By_Pitch_Mode(inTable)
% Input: inTable: table, with all data for each phase

% Need to separate the table into 4 different tables
% Loop through each entry in the table, separate it based on the trial name
teeCount = 1;
bpCount = 1;
cannonCount = 1;
liveCount = 1;
for i = 1:height(inTable)
    % Tee
    if contains(inTable{i,1}, 'Tee') == 1
        teeTable(teeCount,:) = inTable(i,:);
        teeCount = teeCount +1;
    % BP
    elseif contains(inTable{i,1}, 'BP') == 1
        bpTable(bpCount,:) = inTable(i,:);
        bpCount = bpCount + 1;
    % Cannon
    elseif contains(inTable{i,1}, 'Cannon') == 1
        cannonTable(cannonCount,:) = inTable(i,:);
        cannonCount = cannonCount + 1;
    % Live
    elseif contains(inTable{i,1}, 'Live') == 1
        liveTable(liveCount,:) = inTable(i,:);
        liveCount = liveCount + 1;
    else
        error("There is an error in the logic in separate_By_Pitch_Mode")
    end
    
end


end

