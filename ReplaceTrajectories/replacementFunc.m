function replacementFunc(missingMarker,aRef,bRef,cRef,sFrame,subName,markerName, begOrEnd)

% Establish link between Vicon Nexus 2 and Matlab
vicon = ViconNexus();

% Calculate replacement coordinates
if begOrEnd == 0 % Normal way
    [pos,placementFrame] = calcReplacementTrajectory(missingMarker,aRef,bRef,cRef,sFrame);
elseif begOrEnd == 1 % Beginning 
    [pos,placementFrame] = calcReplacementTrajectoryBeg(missingMarker,aRef,bRef,cRef,sFrame);
elseif begOrEnd == 2 % End
    [pos,placementFrame] = calcReplacementTrajectoryEnd(missingMarker,aRef,bRef,cRef,sFrame);
else
    error("Error in decision making in replacementFunc")
end
    
%% Write the new position data to the trial data file
exists = logical(missingMarker(:,4));
exists(placementFrame) = 1;

writeOut = missingMarker(:,[1:3])';
writeOut(:,placementFrame) = pos';

% vicon.CreateModelOutput(subName{1},'test','Modeled Markers',{'X','Y','Z'},...
%     {'Length','Length','Length'});
% vicon.SetModelOutput(subName{1},'test',writeOut,exists');



vicon.SetTrajectory(subName{1},markerName,writeOut(1,:),writeOut(2,:),writeOut(3,:),exists);

end