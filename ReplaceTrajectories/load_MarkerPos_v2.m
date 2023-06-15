function [data] = load_MarkerPos_v2(subjectName,markerNames)
% Inputs:   subject name, as a cell array
%           marker names, as cell array
% Output: The marker position data

%%Establish Connection between Nexus and MATLAB
vicon = ViconNexus();

% Get the trajectories of each marker in [mm]
allNames = 1:length(markerNames);
%rfrmIndex = 20;
for i = 1:length(markerNames)
    badMrkrArray(i) = vicon.HasTrajectory(char(subjectName),markerNames{i});
end
badMrkr = allNames.*badMrkrArray;
badMrkrIndex = setdiff(allNames,badMrkr);
markerNameIndex = setdiff(allNames,badMrkrIndex);

for i = markerNameIndex
   
    [tempData1(:,1),tempData2(:,1),tempData3(:,1),tempData4(:,1)] = vicon.GetTrajectory(subjectName{1}, markerNames{i});
    tempData5(:,1) = 1:length(tempData1);
    % Only get data where there is a valid frame    
%     index = find(tempData1);
%     
%     tempData1 = tempData1(index);
%     tempData2 = tempData2(index);
%     tempData3 = tempData3(index);
%     tempData4 = tempData4(index);
%     tempData5 = tempData5(index);
        
    data.raw.(markerNames{i}) = [tempData1,tempData2,tempData3,tempData4,tempData5];    
    
    clear tempData1
    clear tempData2
    clear tempData3
    clear tempData4
    clear tempData5
        
end

