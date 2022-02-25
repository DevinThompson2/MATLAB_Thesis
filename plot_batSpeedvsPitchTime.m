function plot_batSpeedvsPitchTime(data,subjectNames, batSpeedName, pitchSpeedName, swingTimeName)
% Inputs: data: structure with all of the data that has the bat speed and pitch speed data
% batSpeedName: the name of the bat speed metric
% pitchSpeedName: the name of the pitch speed metric

%% Extract metrics from tables
% Extract only the bat and ball table from each subject (and swing time)
for i = 1:length(subjectNames)    
    batBallTables{i} = data.(subjectNames{i}).BatBallData;
    swingTimeTables{i} = data.(subjectNames{i}).TimingData;
end

% Extract the desired metrics into a matrix, one for pitchSpeed and one for
% batSpeed (and swing time)
for i = 1:length(batBallTables)
    batSpeed{i} = batBallTables{i}.(batSpeedName);
    pitchSpeed{i} = batBallTables{i}.(pitchSpeedName);
end
for i = 1:length(swingTimeTables)
    swingTime{i} = swingTimeTables{i}.(swingTimeName);
end

%% Replace any empty data with NaN
% Replace empty cells with nan
% For bat speed
for i = 1:length(batSpeed)
    for j = 1:length(batSpeed{i})
        if isempty(cell2mat(batSpeed{i}(j))) == 1
            batSpeed{i}(j) = {NaN};
        end
    end
end
% For pitch speed
for i = 1:length(pitchSpeed)
    for j = 1:length(pitchSpeed{i})
        if isempty(cell2mat(pitchSpeed{i}(j))) == 1
            pitchSpeed{i}(j) = {NaN};
        end
    end
end
% For swing time
for i = 1:length(swingTime)
    for j = 1:length(swingTime{i})
        if isempty(cell2mat(swingTime{i}(j))) == 1
            swingTime{i}(j) = {NaN};
        elseif cell2mat((swingTime{i}(j))) >= 2 % These swingtimes are from incorrect data, need to fix it in Visual3D
            swingTime{i}(j) = {NaN};
        end
    end
end


%% Data conversions and model building
% Put the cells into vectors
batSpeedVec = [{}];
for i = 1:length(batSpeed)
    batSpeedVec = cat(1,batSpeedVec, batSpeed{i});
end

pitchSpeedVec = [{}];
for i = 1:length(pitchSpeed)
    pitchSpeedVec = cat(1,pitchSpeedVec, pitchSpeed{i});
end

swingTimeVec = [{}];
for i = 1:length(swingTime)
    swingTimeVec = cat(1,swingTimeVec, swingTime{i});
end

% batSpeedVec = reshape(batSpeed,[],1);
% pitchSpeedVec = reshape(pitchSpeed,[],1);
% swingTimeVec = reshape(swingTime,[],1);

% Convert the cell arrays to matrices
batSpeedMat = cell2mat(batSpeedVec);
pitchSpeedMat = cell2mat(pitchSpeedVec);
swingTimeMat = cell2mat(swingTimeVec);

% Convert to mph
batSpeedMPH = batSpeedMat * 2.23694; % mph
pitchSpeedMPH = pitchSpeedMat * 2.23694; % mph

% Assign name of batSpeedVec to final variable for future use
batSpeedVec = batSpeedMPH;
pitchSpeedVec = pitchSpeedMPH;
swingTimeVec = swingTimeMat;

% Estimate time from release to home from measured pitch speed
liveD = 55; % ~55ft from release to home for live and machine
bpD = 35; % ~35ft from release to home for bp
teeD = 0; % Tee distance is 0ft
% To get time, 1/velocity * distance, first convert mph to ft/s
% Create array for distances
for i = 1:length(pitchSpeedVec)
    if pitchSpeedVec(i) <= 10 % 5 mph tee
        distance(i,1) = teeD;
    elseif pitchSpeedVec(i) > 10 && pitchSpeedVec(i) <= 55 % BP speeds
        distance(i,1) = bpD;
    elseif pitchSpeedVec(i) > 55 % Live and Machine speed
        distance(i,1) = liveD;
    else
        error('Issue with logic when determining pitch speeds')
    end
end

% Calculate the time vector
pitchSpeedFPS = pitchSpeedVec * 1.46667; % ft/s
timeVec = distance./pitchSpeedFPS;
% Comment out to remove tee from model
% Add 0.05s to maximum for tee because they really have an infinite amount of
% time, best way to plot?
% maxTime = max(timeVec);
% for i = 1:length(timeVec)
%     if timeVec(i) == 0
%         timeVec(i) = maxTime+0.05;
%     end
% end

% % Comment out here and not above to add tee to model 
% % Remove Tee from the model
timeVec(timeVec == 0) = NaN;

% Normalize bat speed to average of each player's swing speed
% Get max speed for each subject
for i = 1:length(batSpeed)
    batSpeedsMax(1,i) = max(cell2mat(batSpeed{i}));
    batSpeedsAvg(1,i) = mean(cell2mat(batSpeed{i}), 'omitnan');
end
batSpeedsMax = batSpeedsMax * 2.23694; % mph 
batSpeedsAvg = batSpeedsAvg * 2.23694; % mph

% Divide bat speeds by avg bat speeds to normalize them
for i = 1:length(batSpeed)
    batSpeedsNormAvg{i} = (cell2mat(batSpeed{i}) * 2.23694)./batSpeedsAvg(i);
    batSpeedsNormMax{i} = (cell2mat(batSpeed{i}) * 2.23694)./batSpeedsMax(i);
end
%batSpeedsNormAvg = batSpeedMPH./batSpeedsAvg;
%batSpeedsNormMax = batSpeedMPH./batSpeedsMax;
% Put into vector form
batSpeedsNormAvgVec = [];
batSpeedsNormMaxVec = [];
for i = 1:length(batSpeedsNormAvg)
    batSpeedsNormAvgVec = cat(1,batSpeedsNormAvgVec, batSpeedsNormAvg{i});
    batSpeedsNormMaxVec = cat(1,batSpeedsNormMaxVec, batSpeedsNormMax{i});
end
%batSpeedsNormAvgVec = reshape(batSpeedsNormAvg,[],1); % Use this to create new models
%batSpeedsNormMaxVec = reshape(batSpeedsNormMax,[],1);


% Create linear models to plot from bat speeds
pitchSpeedModel = fitlm(pitchSpeedVec, batSpeedVec,'linear');
estimatePitchTimeModel = fitlm(timeVec, batSpeedVec,'linear');
swingTimeModel = fitlm(swingTimeVec, batSpeedVec,'linear');

% Create linear models to plot from normalized bat speeds
pitchSpeedNormModel = fitlm(pitchSpeedVec, batSpeedsNormAvgVec,'linear');
estimatePitchTimeNormModel = fitlm(timeVec, batSpeedsNormAvgVec,'linear');
swingTimeNormModel = fitlm(swingTimeVec, batSpeedsNormAvgVec,'linear');

%% Plotting
% Plot the measured bat speed for the model
% First, plot the bat speed vs pitch speed
f = gcf;
fs = figure(f.Number+1);
hold on
%scatter(pitchSpeedVec, batSpeedVec, '.')
plot(pitchSpeedModel)
xlabel('Pitch Speed (mph)')
ylabel('Bat Sweet Spot Speed (mph)')
title('Bat Speed vs Pitch Speed')
text(20,66,sprintf('R^2: %.3f', pitchSpeedModel.Rsquared.Adjusted))
print(fs,'batSpeedvsPitchSpeed.png','-dpng','-r300');

% Plot the Swing speed vs estimated time
f = gcf;
fs = figure(f.Number+1);
hold on
%scatter(timeVec, batSpeedVec,'.')
plot(estimatePitchTimeModel)
xlabel('Estimated Time to Swing (s)')
ylabel('Bat Speed (mph)')
title('Bat Speed vs Estimated Time to Swing')
text(0.53,63,sprintf('R^2: %.3f', estimatePitchTimeModel.Rsquared.Adjusted))
print(fs,'batSpeedvsEstTime.png','-dpng','-r300');

% Plot the swing speed vs swing time
f = gcf;
fs = figure(f.Number+1);
hold on
%scatter(swingTimeVec,batSpeedVec,'.')
plot(swingTimeModel);
xlabel('Swing Time (s)')
ylabel('Bat Speed (mph)')
title('Bat Speed vs Swing Time')
text(.15,64,sprintf('R^2: %.3f', swingTimeModel.Rsquared.Adjusted))
print(fs,'batSpeedvsSwingTime.png','-dpng','-r300');

% Plot the normalized bat speed in the model
% First, plot the bat speed vs pitch speed
f = gcf;
fs = figure(f.Number+1);
hold on
%scatter(pitchSpeedVec, batSpeedVec, '.')
plot(pitchSpeedNormModel)
xlabel('Pitch Speed (mph)')
ylabel('Normalized Bat Speed (mph/subjectAvgMPH)')
title('Bat Speed vs Pitch Speed')
text(20,0.925,sprintf('R^2: %.3f', pitchSpeedNormModel.Rsquared.Adjusted))
print(fs,'batSpeedvsPitchSpeedNorm.png','-dpng','-r300');

% Plot the Swing speed vs estimated time
f = gcf;
fs = figure(f.Number+1);
hold on
%scatter(timeVec, batSpeedVec,'.')
plot(estimatePitchTimeNormModel)
xlabel('Estimated Time to Swing (s)')
ylabel('Normalized Bat Speed (mph/subjectAvgMPH)')
title('Bat Speed vs Estimated Time to Swing')
text(0.6,0.9,sprintf('R^2: %.3f', estimatePitchTimeNormModel.Rsquared.Adjusted))
print(fs,'batSpeedvsEstTimeNorm.png','-dpng','-r300');

% Plot the swing speed vs swing time
f = gcf;
fs = figure(f.Number+1);
hold on
%scatter(swingTimeVec,batSpeedVec,'.')
plot(swingTimeNormModel)
xlabel('Swing Time (s)')
ylabel('Normalized Bat Speed (mph/subjectAvgMPH)')
title('Bat Speed vs Swing Time')
text(.15,0.9,sprintf('R^2: %.3f', swingTimeNormModel.Rsquared.Adjusted))
print(fs,'batSpeedvsSwingTimeNorm.png','-dpng','-r300');

end

