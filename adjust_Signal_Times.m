function [trimmedData, trimmedGraphing] = adjust_Signal_Times(data, impactFrames)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Do it for each pitch mode
for j = 1:length(data)
    % Find the trial with the latest impact time
    latestImpact(j,1) = max(impactFrames{j});
    % Find the difference between the latest impact and the other trials
    diffImpact{j,1} = latestImpact(j) - impactFrames{j}; % Numbers to add to beginning
    % Pad the data with NaN's
    paddedData{j,1} = pad_Signals(data{j}, diffImpact{j}, impactFrames{j});
    % Trim the data to be a consistent length (1000 frames before impact,
    % 250 frames after)
    % Impact frames for the padded data are the ones given by the latest impact
    trimmedIndices{j,1}(:,1) = latestImpact(j)-1000:latestImpact(j)+250;
    trimmedGraphing{j,1}(:,1) = trimmedIndices{j,1} - latestImpact(j);
    trimmedData{j,:}(:,:) = paddedData{j,1}(trimmedIndices{j,1},:); 
    
end


end

