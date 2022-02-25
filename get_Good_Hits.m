function [subjectPercentages, averages, stdeErrors] = get_Good_Hits(launchAngle, sprayAngle, filenames)
% Input all the launch angles and spray angles

% First, determine for each subject
% Use the appropriate ranges
[subjectPercentages, ~] = compute_Contact_Rate(launchAngle, sprayAngle);

% Next, determine contact rate for each participant for each mode for each
% subjects, then combine for total
% Separate by Tee, BP, Cannon, Live

for i = 1:length(filenames)
    teeCount = 1;
    bpCount = 1;
    cannonCount = 1;
    liveCount = 1;
    for j = 1:length(filenames{i})
       if contains(filenames{i}{j}, 'Tee') == 1 % Tee
           teeLaunch{i,1}(teeCount,1) = launchAngle{i}(j);
           teeSpray{i,1}(teeCount,1) = sprayAngle{i}(j);
           teeCount = teeCount + 1;
       elseif contains(filenames{i}{j}, 'BP') == 1% BP
           bpLaunch{i,1}(bpCount,1) = launchAngle{i}(j);
           bpSpray{i,1}(bpCount,1) = sprayAngle{i}(j);
           bpCount = bpCount + 1;
       elseif contains(filenames{i}{j}, 'Cannon') == 1% Cannon
           cannonLaunch{i,1}(cannonCount,1) = launchAngle{i}(j);
           cannonSpray{i,1}(cannonCount,1) = sprayAngle{i}(j);
           cannonCount = cannonCount + 1;
       elseif contains(filenames{i}{j}, 'Live') == 1% Live
           liveLaunch{i,1}(liveCount,1) = launchAngle{i}(j);
           liveSpray{i,1}(liveCount,1) = sprayAngle{i}(j);
           liveCount = liveCount + 1;
       else
           error('Logic error when figuring out what file each signal belongs to: separate_PitchMode')
       end 
    end    
end

% Compute contact rate for each method of each subject
[teeRateSubs, teeIndex] = compute_Contact_Rate(teeLaunch, teeSpray);
[bpRateSubs, bpIndex] = compute_Contact_Rate(bpLaunch, bpSpray);
[cannonRateSubs, cannonIndex] = compute_Contact_Rate(cannonLaunch, cannonSpray);
[liveRateSubs, liveIndex] = compute_Contact_Rate(liveLaunch, liveSpray);
% Compile all together
% [teeCompiled, teeRate] = compute_Contact_Rate_All(teeIndex);
% [bpCompiled, bpRate] = compute_Contact_Rate_All(bpIndex);
% [cannonCompiled, cannonRate] = compute_Contact_Rate_All(cannonIndex);
% [liveCompiled, liveRate] = compute_Contact_Rate_All(liveIndex);
% Taking the mean of ____RateSubs is the same as ___Compiled

% Compute the means and stdes
avgTee = mean(teeRateSubs);
stdeTee = std(teeRateSubs) ./ (sqrt(length(teeRateSubs)));
avgBP = mean(bpRateSubs);
stdeBP = std(bpRateSubs) ./ (sqrt(length(bpRateSubs)));
avgCannon = mean(cannonRateSubs);
stdeCannon = std(cannonRateSubs) ./ (sqrt(length(cannonRateSubs)));
avgLive = mean(liveRateSubs);
stdeLive  = std(liveRateSubs) ./ (sqrt(length(liveRateSubs)));

averages = [avgTee; avgBP; avgCannon; avgLive];
stdeErrors = [stdeTee; stdeBP; stdeCannon; stdeLive];

end

