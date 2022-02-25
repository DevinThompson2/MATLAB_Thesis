function [trimmedData] = trim_data(data, indices)
%UNTITLED10 Summary of this function goes here
%   Inputs: data: Marker data, as a struct, either raw or filterd
%           indices: 1-D array of desired indices to get data from
%   Outputs: trimmedData: data trimmed to be the correct indices

% Get fields, to use numel
fields = fieldnames(data);

% Loop over each field (marker)
for i = 1:numel(fields)
    trimmedData.(fields{i}) = data.(fields{i})(indices,:);
end


end

