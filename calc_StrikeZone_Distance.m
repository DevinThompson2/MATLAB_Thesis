function [out, outSubject] = calc_StrikeZone_Distance(data, subjectData)
% Calculate the distance from each pitch to the center of the strike zone
% (in) for each trial, then calculate mean and stde

% Establish the center to the strike zone
center = [0 30];
% Calculate the distances for all trials
distance = sqrt((data(:,1) - center(1,1)).^2 + (data(:,2) - center(1,2)).^2);
avgDistance = mean(distance);
stdeDistance = std(distance)./ sqrt(length(distance));

out = [avgDistance stdeDistance];

% Calculate the distances for each subject
for i =1:length(subjectData)
    distanceSubject = sqrt((subjectData{i}(:,1) - center(1,1)).^2 + (subjectData{i}(:,2) - center(1,2)).^2);
    avgDistanceSubject = mean(distanceSubject);
    stdeDistanceSubject = std(distanceSubject)./ sqrt(length(distanceSubject));
    outSubject{i,1} = [avgDistanceSubject stdeDistanceSubject];
end

end

