function [goodMarkerData] = getSegmentMarkerData(markerData, markers)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

nRows = size(markers,1);
nCols = size(markers,2);
fields = fieldnames(markerData);
goodMarkerData = {};
for i = 1:nRows
    for j  = 1:nCols
        for k = 1:length(fields)
            if strcmp(markers{i,j},fields{k})
                goodMarkerData{i,j} = markerData.(fields{k});
                goodMarkerData{i,j} = goodMarkerData{i,j}(:,1:4);
                % disp(strcat("Used marker data ", fields{k}," for marker ", markers{i,j}))
                break
            end
        end
    end
end


end

