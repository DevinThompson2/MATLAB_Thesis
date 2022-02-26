function [missingMarkerData] = getMissingMarkerData(markerData, missingMarkers)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here


nRows = size(missingMarkers,1);
fields = fieldnames(markerData);
missingMarkerData = {};
for i = 1:nRows
    for j  = 1:length(fields)
        if strcmp(missingMarkers{i},fields{j})
            missingMarkerData{i,1} = markerData.(fields{j});
            missingMarkerData{i,1} = missingMarkerData{i}(:,1:4);
            % disp(strcat("Used marker data ", fields{k}," for marker ", markers{i,j}))
            break
        end
    end
end


end

