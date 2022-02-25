function [tee, bp, cannon, live] = remove_Fun_All_Tables(tee, bp, cannon, live, phases, names)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% For each struct, loop over each table
for i = 1:length(fieldnames(tee))
    tee.(phases{i}).Properties.VariableNames = names{i};
end

for i = 1:length(fieldnames(bp))
    bp.(phases{i}).Properties.VariableNames = names{i};
end

for i = 1:length(fieldnames(cannon))
    cannon.(phases{i}).Properties.VariableNames = names{i};
end

for i = 1:length(fieldnames(live))
    live.(phases{i}).Properties.VariableNames = names{i};
end



end

