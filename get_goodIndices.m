function [goodAllMarkers, goodBatBall, goodBody] = get_goodIndices(data, markerNames)
%UNTITLED5 Summary of this function goes here
%   Get good indices of markers. 
% Inputs:   data: Marker position data, x, y, x, good, index. As a struct,
%               either filtered or raw
%           markerName: cell array containing the marker names
% Output:   good: Indices where there is good data for all markers
%           goodNoBall: Indices where there is good data for all markers but ball
%           batBall: Indices where there is good data for Bat and Ball markers
           

fields = fieldnames(data);

% Find indices of good frames for each marker
for i = 1:numel(fields);
   goodIndices.(fields{i}) = find(data.(fields{i})(:,4)); 
end

% Get indices with good data for all markers

goodAllMarkers = goodIndices.(fields{1}); % Set the first markers to be the baseline comparison when using intersect 
for i = 2:numel(fields)
   goodAllMarkers = intersect(goodAllMarkers, goodIndices.(fields{i})); 
end

% Get indices for just Bat and Ball markers
goodBatBall = goodIndices.(fields{numel(fields)- 4}); % Good indices of knob, first of bat and ball markers
for i = numel(fields)-3:numel(fields) % Know that last five markers are the Bat and Ball markers, first use of intersect
    goodBatBall = intersect(goodBatBall, goodIndices.(fields{i}));
end

% goodBatBall = intersect(goodIndices.KNOB,...
%                  intersect(goodIndices.ECAP,...
%                      intersect(goodIndices.MIDK,...
%                          intersect(goodIndices.MIDE, goodIndices.Ball))));
                     
% Get indices for just body markers
goodBody = goodIndices.(fields{1});; % Set the first markers to be the baseline comparison when using intersect 
for i = 2:numel(fields)-5 % Know that last five markers are the Bat and Ball markers
    goodBody = intersect(goodBody, goodIndices.(fields{i}));
end

end

