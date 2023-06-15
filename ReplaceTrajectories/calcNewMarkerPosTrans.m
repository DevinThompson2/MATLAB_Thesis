function [outputArg1,outputArg2] = calcNewMarkerPosTrans(missingMarker,aRef,bRef,cRef,sFrame,subName,markerName, begOrEnd)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

vicon = ViconNexus();

% Decide whether to get beginning or end frame
if begOrEnd == 1 % Beginning
    % Get first frames where all source markers have data
    firstFrame_aRef = min(find(aRef(:,4) == 1));
    firstFrame_bRef = min(find(bRef(:,4) == 1));
    firstFrame_cRef = min(find(cRef(:,4) == 1));
    % Get first frame where missing marker has data
    firstFrame_missing = min(find(missingMarker(:,4) == 1));
    % Get the source frame
    sourceFrame = max([firstFrame_aRef firstFrame_bRef firstFrame_cRef firstFrame_missing]);
    % sourceFrame = min(find(missingMarker(:,4) == 1));
    
    % Get source frame points
    aSource = aRef(sourceFrame,1:3)';
    bSource = bRef(sourceFrame,1:3)';
    cSource = cRef(sourceFrame,1:3)';
    sourcePoints = [aSource bSource cSource];
    sourceMissing = missingMarker(sourceFrame,1:3)';
    sourceMissing(4,1) = 1;
    % Get target frame points
    placementFrame = max([sFrame,firstFrame_aRef,firstFrame_bRef,firstFrame_cRef]);
    aPlacement = aRef(placementFrame,1:3)';
    bPlacement = bRef(placementFrame,1:3)';
    cPlacement = cRef(placementFrame,1:3)';
    placementPoints = [aPlacement bPlacement cPlacement];
    % Process through absor to get transformation matrix in homogeneous
    % coordinates
    [regParams,Bfit,ErrorStats]=absor(sourcePoints,placementPoints);
    
    % Apply the transformation to the missing marker source frame point
    missingPoint = regParams.M*sourceMissing;
    
    % Write the point to the trial
    if missingMarker(placementFrame,4) ~= 1
        vicon.SetTrajectoryAtFrame(subName{1},markerName,placementFrame, missingPoint(1), missingPoint(2), missingPoint(3), true);
    end
    
elseif begOrEnd == 2% End
    % Get last frames where all source markers have data
    firstFrame_aRef = max(find(aRef(:,4) == 1));
    firstFrame_bRef = max(find(bRef(:,4) == 1));
    firstFrame_cRef = max(find(cRef(:,4) == 1));
    % Get last frame where missing marker has data
    firstFrame_missing = max(find(missingMarker(:,4) == 1));
    % Get the source frame
    sourceFrame = min([firstFrame_aRef firstFrame_bRef firstFrame_cRef firstFrame_missing]);
    % sourceFrame = min(find(missingMarker(:,4) == 1));
    
    % Get source frame points
    aSource = aRef(sourceFrame,1:3)';
    bSource = bRef(sourceFrame,1:3)';
    cSource = cRef(sourceFrame,1:3)';
    sourcePoints = [aSource bSource cSource];
    sourceMissing = missingMarker(sourceFrame,1:3)';
    sourceMissing(4,1) = 1;
    % Get target frame points
    placementFrame = min([sFrame,firstFrame_aRef,firstFrame_bRef,firstFrame_cRef]);
    aPlacement = aRef(placementFrame,1:3)';
    bPlacement = bRef(placementFrame,1:3)';
    cPlacement = cRef(placementFrame,1:3)';
    placementPoints = [aPlacement bPlacement cPlacement];
    % Process through absor to get transformation matrix in homogeneous
    % coordinates
    [regParams,Bfit,ErrorStats]=absor(sourcePoints,placementPoints);
    
    % Apply the transformation to the missing marker source frame point
    missingPoint = regParams.M*sourceMissing;
    
    % Write the point to the trial
    if missingMarker(placementFrame,4) ~= 1
        vicon.SetTrajectoryAtFrame(subName{1},markerName,placementFrame, missingPoint(1), missingPoint(2), missingPoint(3), true);
    end

end


end

