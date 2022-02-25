function [outputAvg,outputStde, normOutputAvg, normOutputStde, normToLiveAvg, normToLiveStde, avgPercent, stdePercent, percentEvents, normEventTimes, trimmedGraphingIndices, scores] = separate_PitchMode_Signals(subjectData, signalName, subjectName, eventData, signalType, pitchInfo)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% Pull out the desired signal and filenames
filenames = subjectData.SignalData.FILE_NAME;
signal = subjectData.SignalData.(signalName);
hz = 500;
events = {'Stance','Foot Up','Load','First Hand Movement','Foot Down','Impact','Follow Through'};
eventVarNames = {'stance','footUp','load','firstMove','footDown','impact','followThrough'};

% Separate by Tee, BP, Cannon, Live
teeCount = 1;
bpCount = 1;
cannonCount = 1;
liveCount = 1;
for i = 1:length(signal)
   if contains(filenames{i}, 'Tee') == 1 % Tee
       teeData{teeCount,1} = signal{i};
       teeEvents(teeCount,:) = eventData(i,eventVarNames);
       teeCount = teeCount + 1;
   elseif contains(filenames{i}, 'BP') == 1% BP
       bpData{bpCount,1} = signal{i};
       bpEvents(bpCount,:) = eventData(i,eventVarNames);
       bpCount = bpCount + 1;
   elseif contains(filenames{i}, 'Cannon') == 1% Cannon
       cannonData{cannonCount,1} = signal{i};
       cannonEvents(cannonCount,:) = eventData(i,eventVarNames);
       cannonCount = cannonCount + 1;
   elseif contains(filenames{i}, 'Live') == 1% Live
       liveData{liveCount,1} = signal{i};
       liveEvents(liveCount,:) = eventData(i,eventVarNames);
       liveCount = liveCount + 1;
   else
       error('Logic error when figuring out what file each signal belongs to: separate_PitchMode')
   end     
end

% Get the indices of impact for each events
teeImpactIndices = round(teeEvents.impact * hz,0);
bpImpactIndices = round(bpEvents.impact * hz,0);
cannonImpactIndices = round(cannonEvents.impact * hz,0);
liveImpactIndices = round(liveEvents.impact * hz,0);

% Put each trial into a matrix to get an average signal
% Signal is always going to be either x-component or only component (always the first one) 
for i = 1:length(teeData)
    if isempty(teeData{i}(:,1)) == 0
        teeMat(:,i) = teeData{i}(:,1);
    end
end
for i = 1:length(bpData)
    if isempty(bpData{i}(:,1)) == 0
        bpMat(:,i) = bpData{i}(:,1);
    end
end
for i = 1:length(cannonData)
    if isempty(cannonData{i}(:,1)) == 0
        cannonMat(:,i) = cannonData{i}(:,1);
    end
end
for i = 1:length(liveData)
    if isempty(liveData{i}(:,1)) == 0
        liveMat(:,i) = liveData{i}(:,1);
    end
end

% Adjust the data so that values at impact are 'aligned'
dataMat = {teeMat; bpMat; cannonMat; liveMat};
impactIndices = {teeImpactIndices; bpImpactIndices; cannonImpactIndices; liveImpactIndices};
[trimmedData, trimmedGraphingIndices] = adjust_Signal_Times(dataMat,impactIndices);

% Separate data out into inidividual matrices - Overwrite the raw matrices
teeMat = trimmedData{1};
bpMat = trimmedData{2};
cannonMat = trimmedData{3};
liveMat = trimmedData{4};

% Create variables for graphing different signal types, and convert to MPH
% if necessary
if signalType == 1
    unit1 = " (deg)";
    unit2 = " Normalized (deg/deg)";
    unit3 = " Normalized to Live (deg)";
elseif signalType == 2
    unit1 = " deg/s";
    unit2 = " Normalized ((deg/s)/(deg/s))";
    unit3 = " Normalized to Live (deg/s)";
elseif signalType == 3
    unit1 = " MPH";
    unit2 = " Normalized (MPH/MPH)";
    unit3 = " Normalized to Live (MPH)";
    % Convert the data from m/s to MPH
    teeMat = teeMat * 2.23694; % MPH
    bpMat = bpMat * 2.23694; % MPH
    cannonMat = cannonMat * 2.23694; % MPH
    liveMat = liveMat * 2.23694; % MPH
elseif signalType == 4
    unit1 = " Miles/hr^2";
    unit2 = " Normalized (Miles/hr^2/Miles/hr^2)";
    unit3 = " Normalized to Live (Miles/hr^2)";
    % Convert the data from m/s^2 to miles/hr^2
    teeMat = teeMat * 8052.9706513958 ; % miles/hr^2
    bpMat = bpMat * 8052.9706513958 ; % miles/hr^2
    cannonMat = cannonMat * 8052.9706513958 ; % miles/hr^2
    liveMat = liveMat * 8052.9706513958 ; % miles/hr^2
else
    error('signalType input is not correct')
end

%Convert the table of teeEvents to an array
teeEventsArray = table2array(teeEvents);
bpEventsArray = table2array(bpEvents);
cannonEventsArray = table2array(cannonEvents);
liveEventsArray = table2array(liveEvents);

allEventsMat = {teeEventsArray; bpEventsArray; cannonEventsArray; liveEventsArray};
dataMat = {teeMat; bpMat; cannonMat; liveMat};

% NORMALIZE THE DATA AS DISCUSSED HERE
[avgPercent, stdePercent, percentEvents] = normalize_To_Live(dataMat,allEventsMat, trimmedGraphingIndices, pitchInfo, signalName, subjectName);

% Average the teeEvents for each trial, then subtract
avgTeeEvents = mean(teeEventsArray,'omitnan');
avgBPEvents = mean(bpEventsArray,'omitnan');
avgCannonEvents = mean(cannonEventsArray,'omitnan');
avgLiveEvents = mean(liveEventsArray,'omitnan');

% Adjust this so that impact is zero (index of avgTeeEvents subtracted from
% avgTeeEvents
[normTeeEvents, normBPEvents, normCannonEvents, normLiveEvents] = normalize_Events(avgTeeEvents, avgBPEvents, avgCannonEvents, avgLiveEvents,eventVarNames);

% Shouldn't need this anymore
% impactIndex = find(strcmp(eventVarNames, "impact"));
% normTeeEvents = avgTeeEvents - avgTeeEvents(impactIndex);
% normBPEvents = avgBPEvents - avgBPEvents(impactIndex);
% normCannonEvents = avgCannonEvents - avgCannonEvents(impactIndex);
% normLiveEvents = avgLiveEvents - avgLiveEvents(impactIndex);

normEventTimes = [normTeeEvents; normBPEvents; normCannonEvents; normLiveEvents];

% Compute the average and std for each one (just for one player) - Both the
% raw and normalized to min-max data
% Raw
avgTee = mean(teeMat,2,'omitnan');
avgBP = mean(bpMat,2,'omitnan');
avgCannon = mean(cannonMat,2,'omitnan');
avgLive = mean(liveMat,2,'omitnan');

stdeTee = std(teeMat,0,2,'omitnan')./ sqrt(size(teeMat,2));
stdeBP = std(bpMat,0,2,'omitnan')./ sqrt(size(bpMat,2));
stdeCannon = std(cannonMat,0,2,'omitnan')./ sqrt(size(cannonMat,2));
stdeLive = std(liveMat,0,2,'omitnan')./ sqrt(size(liveMat,2));

% Normalize the averages and standard deviations for each participant -
% Min-max normalized,
for i = 1:size(teeMat,2)
    normTeeMat(:,i) = (teeMat(:,i) - min(teeMat(:,i))) ./ (max(teeMat(:,i)) - min(teeMat(:,i)));
end

for i = 1:size(bpMat,2)
    normBPMat(:,i) = (bpMat(:,i) - min(bpMat(:,i))) ./ (max(bpMat(:,i)) - min(bpMat(:,i)));
end

for i = 1:size(cannonMat,2)
    normCannonMat(:,i) = (cannonMat(:,i) - min(cannonMat(:,i))) ./ (max(cannonMat(:,i)) - min(cannonMat(:,i)));
end

for i = 1:size(liveMat,2)
    normLiveMat(:,i) = (liveMat(:,i) - min(liveMat(:,i))) ./ (max(liveMat(:,i)) - min(liveMat(:,i)));
end

% Normalized
normAvgTee = mean(normTeeMat,2,'omitnan');
normAvgBP = mean(normBPMat,2,'omitnan');
normAvgCannon = mean(normCannonMat,2,'omitnan');
normAvgLive = mean(normLiveMat,2,'omitnan');

normStdeTee = std(normTeeMat,0,2,'omitnan')./ sqrt(size(normTeeMat,2));
normStdeBP = std(normBPMat,0,2,'omitnan')./ sqrt(size(normBPMat,2));
normStdeCannon = std(normCannonMat,0,2,'omitnan')./ sqrt(size(normCannonMat,2));
normStdeLive = std(normLiveMat,0,2,'omitnan')./ sqrt(size(normLiveMat,2));
% Normalized to live
% Finally, I want to compare the rest of the data to Live (or Tee) -
% Normalize the data to Live to see how different each one is from Live
avgTeeLive = avgTee - avgLive;
avgBPLive = avgBP - avgLive;
avgCannonLive = avgCannon - avgLive;

stdeTeeLive = abs(stdeTee - stdeLive);
stdeBPLive = abs(stdeBP - stdeLive);
stdeCannonLive = abs(stdeCannon - stdeLive);

% % Normalized by dividing by live
% for i = 1:length(normDivideByLive)
%     avgDivideByLive{i,1} = mean(normDivideByLive{i}, 2, 'omitnan');
%     stdeDivideByLive{i,1} = std(normDivideByLive,0,2,'omitnan')./ sqrt(size(normDivideByLive,2));
% end

% Outputs assembled for norms and averages
normOutputAvg = {normAvgTee; normAvgBP; normAvgCannon; normAvgLive};
normOutputStde = {normStdeTee; normStdeBP; normStdeCannon; normStdeLive};

outputAvg = {avgTee; avgBP; avgCannon; avgLive};
outputStde = {stdeTee; stdeBP; stdeCannon; stdeLive};

normToLiveAvg = {avgTeeLive; avgBPLive; avgCannonLive};
normToLiveStde = {stdeTeeLive; stdeBPLive; stdeCannonLive};

%% Calculate 'scores' for differences between live and everything else
% Use the trapz function to calculate the area under each numerical curve
% Subtract 100 due to Live being at 1, 100*1 = 100, spacing of numbers is
% 0.1
spacing = 0.1;
teeScore = trapz(spacing,avgPercent{1}) - 100;
bpScore = trapz(spacing, avgPercent{2}) - 100;
cannonScore = trapz(spacing,avgPercent{3}) - 100;
liveScore = trapz(spacing,avgPercent{4}) - 100;
scores = [teeScore; bpScore; cannonScore; liveScore];

% normDivideByLiveAvg = avgDivideByLive;
% normDivideByLiveStde = stdeDivideByLive;

%% Plots for each subject - may or may not use these
% Plot the timeseries data for each method for each subject
usePlot = 1;
if usePlot == 1
    % Path for plots
    path = "Z:\SSL\Research\Graduate Students\Thompson, Devin\Thesis Docs\Pitch Modality (RIP)\Thesis\Pics and Videos\Results Figs\Signals\";
    x = 1:2000;
    newX = [x, fliplr(x)];
    % Raw
    upperTee = avgTee+stdeTee;
    lowerTee = avgTee-stdeTee;
    inBetweenTee = [upperTee; flipud(lowerTee)]';
    upperBP = avgBP+stdeBP;
    lowerBP = avgBP-stdeBP;
    inBetweenBP = [upperBP; flipud(lowerBP)]';
    upperCannon = avgCannon+stdeCannon;
    lowerCannon = avgCannon-stdeCannon;
    inBetweenCannon = [upperCannon; flipud(lowerCannon)]';
    upperLive = avgLive+stdeLive;
    lowerLive = avgLive-stdeLive;
    inBetweenLive = [upperLive; flipud(lowerLive)]';
    % Min-Max  Normalized
    normUpperTee = normAvgTee+normStdeTee;
    normLowerTee = normAvgTee-normStdeTee;
    normInBetweenTee = [normUpperTee; flipud(normLowerTee)]';
    normUpperBP = normAvgBP+normStdeBP;
    normLowerBP = normAvgBP-normStdeBP;
    normInBetweenBP = [normUpperBP; flipud(normLowerBP)]';
    normUpperCannon = normAvgCannon+normStdeCannon;
    normLowerCannon = normAvgCannon-normStdeCannon;
    normInBetweenCannon = [normUpperCannon; flipud(normLowerCannon)]';
    normUpperLive = normAvgLive+normStdeLive;
    normLowerLive = normAvgLive-normStdeLive;
    normInBetweenLive = [normUpperLive; flipud(normLowerLive)]';
    % Normalized to Live
    upperTeeLive = avgTeeLive+stdeTeeLive;
    lowerTeeLive = avgTeeLive-stdeTeeLive;
    inBetweenTeeLive = [upperTeeLive; flipud(lowerTeeLive)]';
    upperBPLive = avgBPLive+stdeBPLive;
    lowerBPLive = avgBPLive-stdeBPLive;
    inBetweenBPLive = [upperBPLive; flipud(lowerBPLive)]';
    upperCannonLive = avgCannonLive+stdeCannonLive;
    lowerCannonLive = avgCannonLive-stdeCannonLive;
    inBetweenCannonLive = [upperCannonLive; flipud(lowerCannonLive)]';
    
%     % Normalized by dividing by live
%     upperTeeLive = avgTeeLive+stdeTeeLive;
%     lowerTeeLive = avgTeeLive-stdeTeeLive;
%     inBetweenTeeLive = [upperTeeLive; flipud(lowerTeeLive)]';
%     upperBPLive = avgBPLive+stdeBPLive;
%     lowerBPLive = avgBPLive-stdeBPLive;
%     inBetweenBPLive = [upperBPLive; flipud(lowerBPLive)]';
%     upperCannonLive = avgCannonLive+stdeCannonLive;
%     lowerCannonLive = avgCannonLive-stdeCannonLive;
%     inBetweenCannonLive = [upperCannonLive; flipud(lowerCannonLive)]';
    
    % Use trimmed Graphing indices for plotting
    teeGraph = trimmedGraphingIndices{1} / hz;
    bpGraph = trimmedGraphingIndices{2} / hz;
    cannonGraph = trimmedGraphingIndices{3} / hz;
    liveGraph = trimmedGraphingIndices{4} / hz;
    
    % Create x array for plotting
    % was fliplr
    newTeeGraph = [teeGraph; flipud(teeGraph)];
    newBPGraph = [bpGraph; flipud(bpGraph)];
    newCannonGraph = [cannonGraph; flipud(cannonGraph)];
    newLiveGraph = [liveGraph; flipud(liveGraph)];

    % Plot everything in one plot - The non-normalized data
    f = gcf;
    figure(f.Number+1)
    subplot(3,1,1)
    hold on
    fill(newTeeGraph, inBetweenTee,[.25 .25 .25],'facealpha',0.5,'EdgeColor',[.25 .25 .25],'EdgeAlpha', 0.25)
    fill(newBPGraph, inBetweenBP,[.25 .25 .25],'facealpha',0.5,'EdgeColor',[.25 .25 .25],'EdgeAlpha', 0.25)
    fill(newCannonGraph, inBetweenCannon,[.25 .25 .25],'facealpha',0.5,'EdgeColor',[.25 .25 .25],'EdgeAlpha', 0.25)
    fill(newLiveGraph, inBetweenLive,[.25 .25 .25],'facealpha',0.5,'EdgeColor',[.25 .25 .25],'EdgeAlpha', 0.25)
    p1 = plot(teeGraph, avgTee, 'r', 'LineWidth',2);
    p2 = plot(bpGraph, avgBP, 'g', 'LineWidth',2);
    p3 = plot(cannonGraph, avgCannon, 'b', 'LineWidth',2);
    p4 = plot(liveGraph, avgLive, 'k', 'LineWidth',2);
    plot(teeGraph, upperTee, 'r', 'LineWidth',.5)
    plot(bpGraph, upperBP, 'g', 'LineWidth',.5)
    plot(cannonGraph, upperCannon, 'b', 'LineWidth',.5)
    plot(liveGraph, upperLive, 'k', 'LineWidth',.5)
    plot(teeGraph, lowerTee, 'r', 'LineWidth',.5)
    plot(bpGraph, lowerBP, 'g', 'LineWidth',.5)
    plot(cannonGraph, lowerCannon, 'b', 'LineWidth',.5)
    plot(liveGraph, lowerLive, 'k', 'LineWidth',.5)
    xline(normTeeEvents,'r-', 'LineWidth',2)
    xline(normBPEvents,'g-', 'LineWidth',2)
    xline(normCannonEvents,'b-', 'LineWidth',2)
    xline(normLiveEvents,'k-',events, 'LineWidth',2)
    xline(pitchInfo(1),'c-','Pitcher Foot Up (est)','LineWidth',1)
    xline(pitchInfo(2),'c-','Pitcher Knee Up (est)','LineWidth',1)
    xline(pitchInfo(3),'c-','Pitcher Hand Separation (est)','LineWidth',1)
    xline(pitchInfo(4),'c-','Pitcher Foot Down (est)','LineWidth',1)
    xline(pitchInfo(5),'c-','Pitch Release (est)','LineWidth',1)
    xlim([-2 0.5])
    legend([p1 p2 p3 p4],{'Tee','BP','Cannon','Live'},'Location','bestoutside')
    title(strcat(signalName, ' For Each Pitch Mode: ', subjectName))
    %xlabel('Time (s)')
    ylabel(strcat(signalName, unit1))
    
    % Plot all of the normalized data
    %f = gcf;
    %figure(f.Number+1)\
    subplot(3,1,2)
    hold on
    fill(newTeeGraph, normInBetweenTee,[.25 .25 .25],'facealpha',0.5,'EdgeColor',[.25 .25 .25],'EdgeAlpha', 0.25)
    fill(newBPGraph, normInBetweenBP,[.25 .25 .25],'facealpha',0.5,'EdgeColor',[.25 .25 .25],'EdgeAlpha', 0.25)
    fill(newCannonGraph, normInBetweenCannon,[.25 .25 .25],'facealpha',0.5,'EdgeColor',[.25 .25 .25],'EdgeAlpha', 0.25)
    fill(newLiveGraph, normInBetweenLive,[.25 .25 .25],'facealpha',0.5,'EdgeColor',[.25 .25 .25],'EdgeAlpha', 0.25)
    p1 = plot(teeGraph, normAvgTee, 'r', 'LineWidth',2);
    p2 = plot(bpGraph, normAvgBP, 'g', 'LineWidth',2);
    p3 = plot(cannonGraph, normAvgCannon, 'b', 'LineWidth',2);
    p4 = plot(liveGraph, normAvgLive, 'k', 'LineWidth',2);
    plot(teeGraph, normUpperTee, 'r', 'LineWidth',.5)
    plot(bpGraph, normUpperBP, 'g', 'LineWidth',.5)
    plot(cannonGraph, normUpperCannon, 'b', 'LineWidth',.5)
    plot(liveGraph, normUpperLive, 'k', 'LineWidth',.5)
    plot(teeGraph, normLowerTee, 'r', 'LineWidth',.5)
    plot(bpGraph, normLowerBP, 'g', 'LineWidth',.5)
    plot(cannonGraph, normLowerCannon, 'b', 'LineWidth',.5)
    plot(liveGraph, normLowerLive, 'k', 'LineWidth',.5)
    xline(normTeeEvents,'r-', 'LineWidth',2)
    xline(normBPEvents,'g-', 'LineWidth',2)
    xline(normCannonEvents,'b-', 'LineWidth',2)
    xline(normLiveEvents,'k-',events, 'LineWidth',2)
    xline(pitchInfo(1),'c-','Pitcher Foot Up (est)','LineWidth',1)
    xline(pitchInfo(2),'c-','Pitcher Knee Up (est)','LineWidth',1)
    xline(pitchInfo(3),'c-','Pitcher Hand Separation (est)','LineWidth',1)
    xline(pitchInfo(4),'c-','Pitcher Foot Down (est)','LineWidth',1)
    xline(pitchInfo(5),'c-','Pitch Release (est)','LineWidth',1)
    xlim([-2 0.5])
    legend([p1 p2 p3 p4],{'Tee','BP','Cannon','Live'},'Location','bestoutside')
    title(strcat(signalName, ' Normalized For Each Pitch Mode: ', subjectName))
    %xlabel('Time (s)')
    ylabel(strcat(signalName, unit2'))
    
    % Plot all of the data normalized to the Live condition
    %f = gcf;
    %figure(f.Number+1)
    subplot(3,1,3)
    hold on
    fill(newTeeGraph, inBetweenTeeLive,[.25 .25 .25],'facealpha',0.5,'EdgeColor',[.25 .25 .25],'EdgeAlpha', 0.25)
    fill(newBPGraph, inBetweenBPLive,[.25 .25 .25],'facealpha',0.5,'EdgeColor',[.25 .25 .25],'EdgeAlpha', 0.25)
    fill(newCannonGraph, inBetweenCannonLive,[.25 .25 .25],'facealpha',0.5,'EdgeColor',[.25 .25 .25],'EdgeAlpha', 0.25)
    %fill(newLiveGraph, normInBetweenLive,[.25 .25 .25],'facealpha',0.5,'EdgeColor',[.25 .25 .25],'EdgeAlpha', 0.25)
    p1 = plot(teeGraph, avgTeeLive, 'r', 'LineWidth',2);
    p2 = plot(bpGraph, avgBPLive, 'g', 'LineWidth',2);
    p3 = plot(cannonGraph, avgCannonLive, 'b', 'LineWidth',2);
    %p4 = plot(liveGraph, normAvgLive, 'k', 'LineWidth',2);
    plot(teeGraph, upperTeeLive, 'r', 'LineWidth',.5)
    plot(bpGraph, upperBPLive, 'g', 'LineWidth',.5)
    plot(cannonGraph, upperCannonLive, 'b', 'LineWidth',.5)
    %plot(liveGraph, normUpperLive, 'k', 'LineWidth',.5)
    plot(teeGraph, lowerTeeLive, 'r', 'LineWidth',.5)
    plot(bpGraph, lowerBPLive, 'g', 'LineWidth',.5)
    plot(cannonGraph, lowerCannonLive, 'b', 'LineWidth',.5)
    %plot(liveGraph, normLowerLive, 'k', 'LineWidth',.5)
    xline(normTeeEvents,'r-', 'LineWidth',2)
    xline(normBPEvents,'g-', 'LineWidth',2)
    xline(normCannonEvents,'b-', 'LineWidth',2)
    xline(normLiveEvents,'k-',events, 'LineWidth',2)
    xline(pitchInfo(1),'c-','Pitcher Foot Up (est)','LineWidth',1)
    xline(pitchInfo(2),'c-','Pitcher Knee Up (est)','LineWidth',1)
    xline(pitchInfo(3),'c-','Pitcher Hand Separation (est)','LineWidth',1)
    xline(pitchInfo(4),'c-','Pitcher Foot Down (est)','LineWidth',1)
    xline(pitchInfo(5),'c-','Pitch Release (est)','LineWidth',1)
    yline(0,'k-','LineWidth',2)
    xlim([-2 0.5])
    legend([p1 p2 p3],{'Tee','BP','Cannon'},'Location','bestoutside')
    title(strcat(signalName, ' Normalized to the Live Condition: ', subjectName))
    xlabel('Time (s)')
    ylabel(strcat(signalName, unit3))
    
    % Save the figure (MATLAB and .png), for each subject
    f = gcf;
    f.WindowState = 'maximized';
    fileName = strcat(signalName,"_", subjectName);
    savefig(f, strcat(path, fileName));
    saveas(f, strcat(path, fileName, '.png'));
end

end

