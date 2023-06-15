function [goodMarkers] = getGoodMarkers(missingMarkers, segMarkers)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

count = 1;
goodMarkers = {};
for i = 1:length(segMarkers.markers) % Loop through each segment
    for j = 1:length(segMarkers.markers{i}) % Loop through each marker in each segment
        % If the missing marker is not the same as the missing marker, add it to the list
        if strcmp(segMarkers.markers{i}(j),missingMarkers{i}) == 0
            goodMarkers{i,count} = segMarkers.markers{i}(j);
            count = count + 1;
        end      
    end
    count = 1;
end

end

