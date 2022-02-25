function [data, tables, names] = remove_Signal(data, subjects, tables, names)
% Remove the signal data from the player event data
% Inputs: data, tables, metrics

numParticipants = length(fieldnames(data));

% Remove from the data first
for i = 1:numParticipants
    data.(subjects{i}) = rmfield(data.(subjects{i}), "SignalData");
end

% Remove signals from the tables list
for i = 1:length(tables)
    if tables{i} == "SignalData"
        tables(i) = [];
        signalIndex = i;
        break
    end
end

% Remove names for signal data
names(signalIndex) = [];

end

