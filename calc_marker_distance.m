function [distanceVec, distanceAvg] = calc_marker_distance(marker1, marker2, calibration)
%   Inputs: marker1, marker2 - Position data in form of [x y z] column
%   vectors.
%           calibrated: If a 1, a calibration trial, if a 2, a normal trial
%   Output: The distance, in mm, between the markers

%   Uses the distance formula to find the distance between two markers.
%   Returns both a vector with the distance between each points for all
%   valid frames as well as the average distance

plotChecker = 0; % Use this to determine whether to plot distance graphs or not

% Determine the range of valid frames for each marker
[commonFrames,marker1Index,marker2Index] = intersect(marker1(:,5), marker2(:,5));

% Use the commonFrames value to trim the marker data
marker1Trimmed = marker1(marker1Index,:);
marker2Trimmed = marker2(marker2Index,:);

% Calculate the distance between the markers
distanceVec = sqrt((marker2Trimmed(:,1) - marker1Trimmed(:,1)).^2....
    + (marker2Trimmed(:,2) - marker1Trimmed(:,2)).^2....
    + (marker2Trimmed(:,3) - marker1Trimmed(:,3)).^2) - 14; % Subtract 14 mm to account for marker diameter of both markers
distanceAvg = mean(distanceVec);


if plotChecker == 1
   avg = distanceAvg * ones(length(distanceVec),1);
   negSTD = avg - std(distanceVec);
   posSTD = avg + std(distanceVec);
   hold on 
   plot(distanceVec)
   plot(avg)
   plot(negSTD)
   plot(posSTD)
   ylim([min(distanceVec)-5 max(distanceVec)+5])
   ylabel('Distance (mm)')
   xlabel('Frame Number')
   legend('Raw','Avg,','-1 STD','+1 STD')
end

end

