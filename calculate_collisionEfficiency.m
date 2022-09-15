function [allTables] = calculate_collisionEfficiency(allTables)
% Calculates the collision efficiency and adds it to the tables, for each
% trial

% The first table contains all of the bat/ball data

% Input: allTables: cell array (nPitchModes(4) x nSubjects x
% nTables/Subject(10) , (nTrials x nVars)


% Loop for each pitch mode
for i = 1:numel(allTables)
    % Loop for each participant
    for j = 1:numel(allTables{i})
        % Calculate the Ea for each trial
        allTables{i}{j}{1} = calc_Ea(allTables{i}{j}{1});
    end
end

end