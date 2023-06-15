function [goodMarkersOut] = getGoodMarkersAtFrame(data, goodMarkers, begOrEnd)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

fields = fieldnames(data);
numRows = size(goodMarkers,1);
numCols = size(goodMarkers,2);

% Get indices of the markers that aren't missing on the segment
index = [];
for i=1:numRows
    for j = 1:numCols
        for k = 1:numel(fields)
            if strcmp(goodMarkers{i,j},fields{k}) == 1
                index{i}(j) = k;             
            end
        end
    end
end

% Use only markers with data at ends
goodMarkersOut = {};
if begOrEnd == 1 % For markers at beginning
    for i = 1:numRows
        ind = 1;
        for j = 1:length(index{i})
            if data.(fields{index{i}(j)})(1,4) == 1 % Data is good
                goodMarkersOut{i,ind} = goodMarkers{i,j};
                ind = ind + 1;
            end
        end
    end
    
elseif begOrEnd == 2 % For markers at end  
    for i = 1:numRows
        ind = 1;
        for j = 1:length(index{i})
            if data.(fields{index{i}(j)})(end,4) == 1 % Data is good
                goodMarkersOut{i,ind} = goodMarkers{i,j};
                ind = ind + 1;
            end
        end
    end
else
   error("Error in getGoodMarkersAtFrame logic") 
end


end

