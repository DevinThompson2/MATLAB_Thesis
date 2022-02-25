function [contactRateSubject, contactRateMethodAvg, contactRateMethodStde] = determine_Good_Hit(data, subjects)
% Input the data and subject names


% Extract the data for each subject, spray angle and launch angle
for i =1:length(subjects)
    launchAngle{i,1} = data.(subjects{i}).BatBallData.launchAng;
    sprayAngle{i,1} = data.(subjects{i}).BatBallData.sprayAng;
    filenames{i,1} = data.(subjects{i}).BatBallData.FILE_NAME;
end

% Put each subject data into an array
% for i = 1:length(subjects)
%    combinedData{i,1}(:,1) = filenames{i,1};
%    combinedData{i,1}(:,2) = launchAngle{i,1};
%    combinedData{i,1}(:,3) = sprayAngle{i,1};
% end


% Calculate the percentage of swings that result in a "good" hit ball +-45
% deg LA, fair ball (+-45 deg)
[contactRateSubject, contactRateMethodAvg, contactRateMethodStde] = get_Good_Hits(launchAngle, sprayAngle, filenames);

% Plot the contact rates
plot_Contact_Rates(contactRateMethodAvg, contactRateMethodStde)

end

