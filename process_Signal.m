function [outTee, outBP, outCannon, outLive] = process_Signal(data, subjectNames, signalName, varGraphNames, subjectData, signalType)
% Process a single signal - run this function with different signal names
% to process different signals

% Extract the event times from teeData, bpData, cannonData, Live Data
%eventNames = {'stance','load','footDown','impact','firstMove','followThrough'};
events = {'Stance','Foot Up','Load','First Hand Movement','Foot Down','Impact','Follow Through'};
trimmedEvents = {'Foot Up','Load','First Hand Movement','Foot Down','Impact'};
hz = 500; % hz
pitchInfo = [-1.97 -1.56 -1.18 -.73 -.54]; % s

% Graphing variable names, find graphing names equivalent to variable name
graphIndex = find(varGraphNames == signalName);
graphName = varGraphNames(graphIndex,2);

% Combine all trials into one array for spm1d analysis
for i = 1:length(subjectNames)
    [rawMats{i,1}, percentMats{i,1}, subtractMats{i,1}, rawTimeMats{i,1}] = separate_PitchMode_Signals_All(data.(subjectNames{i}), signalName, graphName, subjectNames{i}, subjectData{i}{9}, signalType, pitchInfo);
end



% Create signals for each subject, each cell of avg, etc is a different
% subject
for i = 1:length(subjectNames)
    [avg{i,1}, stde{i,1}, normAvg{i,1}, normStde{i,1}, normLiveAvg{i,1}, normLiveStde{i,1}, avgPercent{i,1}, stdePercent{i,1}, avgSubtract{i,1}, stdeSubtract{i,1}, avgRaw{i,1}, stdeRaw{i,1}, percentEvents{i,1}, eventTimes{i,1}, trimmedGraphingIndices{i,1}, indScores{i,1}] = separate_PitchMode_Signals(data.(subjectNames{i}), signalName, graphName, subjectNames{i}, subjectData{i}{9}, signalType, pitchInfo);
end

% Compile all of the signals into matrices
[teeMat, bpMat, cannonMat, liveMat] = signal_cell_2_mat(avg);
[teeMatStde, bpMatStde, cannonMatStde, liveMatStde] = signal_cell_2_mat(stde);
[normTeeMat, normBPMat, normCannonMat, normLiveMat] = signal_cell_2_mat(normAvg);
[normTeeMatStde, normBPMatStde, normCannonMatStde, normLiveMatStde] = signal_cell_2_mat(normStde);
[normTeeLiveMat, normBPLiveMat, normCannonLiveMat, ~] = signal_cell_2_mat(normLiveAvg);
[normTeeLiveMatStde, normBPLiveMatStde, normCannonLiveMatStde, ~] = signal_cell_2_mat(normLiveStde);
[percentTeeMat, percentBPMat, percentCannonMat, percentLiveMat] = signal_cell_2_mat(avgPercent);
[percentTeeMatStde, percentBPMatStde, percentCannonMatStde, percentLiveMatStde] = signal_cell_2_mat(stdePercent);
[subtractTeeMat, subtractBPMat, subtractCannonMat, subtractLiveMat] = signal_cell_2_mat(avgSubtract);
[subtractTeeMatStde, subtractBPMatStde, subtractCannonMatStde, subtractLiveMatStde] = signal_cell_2_mat(stdeSubtract);
[rawTimeTeeMat, rawTimeBPMat, rawTimeCannonMat, rawTimeLiveMat] = signal_cell_2_mat(avgRaw);
[rawTimeTeeMatStde, rawTimeBPMatStde, rawTimeCannonMatStde, rawTimeLiveMatStde] = signal_cell_2_mat(stdeRaw);
% [percentEventTeeMat, percentEventBPMat, percentEventCannonMat, percentEventLiveMat] = signal_cell_2_mat(percentEvents);

% Put events into matrices as well, slightly different, cant use the
% function like above
for i = 1:length(subjectNames)
    % Events as percent of swing
    percentEventTeeMat(i,:) = percentEvents{i}{1};
    percentEventBPMat(i,:) = percentEvents{i}{2};
    percentEventCannonMat(i,:) = percentEvents{i}{3};
    percentEventLiveMat(i,:) = percentEvents{i}{4};
    
    % Event Times Matrix as well
    eventTeeMat(i,:) = eventTimes{i}(1,:);
    eventBPMat(i,:) = eventTimes{i}(2,:);
    eventCannonMat(i,:) = eventTimes{i}(3,:);
    eventLiveMat(i,:) = eventTimes{i}(4,:);
end

% Average the matrices
% Raw
[avgTee, avgBP, avgCannon, avgLive] = avg_signal_matrices(teeMat, bpMat, cannonMat, liveMat);
[stdeTee, stdeBP, stdeCannon, stdeLive] = stde_signal_matrices(teeMat, bpMat, cannonMat, liveMat);
% Min-Max normalized
[normAvgTee, normAvgBP, normAvgCannon, normAvgLive] = avg_signal_matrices(normTeeMat, normBPMat, normCannonMat, normLiveMat);
[normStdeTee, normStdeBP, normStdeCannon, normStdeLive] = stde_signal_matrices(normTeeMat, normBPMat, normCannonMat, normLiveMat);
% Normalized to live, subtraction, keep outside function for now
avgTeeLive = mean(normTeeLiveMat,2,'omitnan');
avgBPLive = mean(normBPLiveMat,2,'omitnan');
avgCannonLive = mean(normCannonLiveMat,2,'omitnan');
stdeTeeLive = std(normTeeLiveMat,1,2,'omitnan')./ sqrt(size(normTeeLiveMat,2));
stdeBPLive = std(normBPLiveMat,1,2,'omitnan')./ sqrt(size(normBPLiveMat,2));
stdeCannonLive = std(normCannonLiveMat,1,2,'omitnan')./ sqrt(size(normCannonLiveMat,2));
% Percent of Live
[avgPercentTee, avgPercentBP, avgPercentCannon, avgPercentLive] = avg_signal_matrices(percentTeeMat, percentBPMat, percentCannonMat, percentLiveMat);
[stdePercentTee, stdePercentBP, stdePercentCannon, stdePercentLive] = stde_signal_matrices(percentTeeMat, percentBPMat, percentCannonMat, percentLiveMat);
% Subtraction, time normalized
[avgSubtractTee, avgSubtractBP, avgSubtractCannon, avgSubtractLive] = avg_signal_matrices(subtractTeeMat, subtractBPMat, subtractCannonMat, subtractLiveMat);
[stdeSubtractTee, stdeSubtractBP, stdeSubtractCannon, stdeSubtractLive] = stde_signal_matrices(subtractTeeMat, subtractBPMat, subtractCannonMat, subtractLiveMat);
% Raw, normalized time
[avgRawTimeTee, avgRawTimeBP, avgRawTimeCannon, avgRawTimeLive] = avg_signal_matrices(rawTimeTeeMat, rawTimeBPMat, rawTimeCannonMat, rawTimeLiveMat);
[stdeRawTimeTee, stdeRawTimeBP, stdeRawTimeCannon, stdeRawTimeLive] = stde_signal_matrices(rawTimeTeeMat, rawTimeBPMat, rawTimeCannonMat, rawTimeLiveMat);

% Event Times
normTeeEvents = mean(eventTeeMat,'omitnan');
normBPEvents = mean(eventBPMat,'omitnan');
normCannonEvents = mean(eventCannonMat,'omitnan');
normLiveEvents = mean(eventLiveMat,'omitnan');

% Events as percentage of the swing
percentTeeEvents = mean(percentEventTeeMat,'omitnan');
percentBPEvents = mean(percentEventBPMat,'omitnan');
percentCannonEvents = mean(percentEventCannonMat,'omitnan');
percentLiveEvents = mean(percentEventLiveMat,'omitnan');

% Plotting signals
% Raw
[upperTee, lowerTee, inBetweenTee] = plotting_signals(avgTee, stdeTee);
[upperBP, lowerBP, inBetweenBP] = plotting_signals(avgBP, stdeBP);
[upperCannon, lowerCannon, inBetweenCannon] = plotting_signals(avgCannon, stdeCannon);
[upperLive, lowerLive, inBetweenLive] = plotting_signals(avgLive, stdeLive);
% Normalized
[normUpperTee, normLowerTee, normInBetweenTee] = plotting_signals(normAvgTee, normStdeTee);
[normUpperBP, normLowerBP, normInBetweenBP] = plotting_signals(normAvgBP, normStdeBP);
[normUpperCannon, normLowerCannon, normInBetweenCannon] = plotting_signals(normAvgCannon, normStdeCannon);
[normUpperLive, normLowerLive, normInBetweenLive] = plotting_signals(normAvgLive, normStdeLive);
% Normalized to Live by subtraction
[upperTeeLive, lowerTeeLive, inBetweenTeeLive] = plotting_signals(avgTeeLive, stdeTeeLive);
[upperBPLive, lowerBPLive, inBetweenBPLive] = plotting_signals(avgBPLive, stdeBPLive);
[upperCannonLive, lowerCannonLive, inBetweenCannonLive] = plotting_signals(avgCannonLive, stdeCannonLive);
% Percent of Live
[upperTeePercent, lowerTeePercent, inBetweenTeePercent] = plotting_signals(avgPercentTee, stdePercentTee);
[upperBPPercent, lowerBPPercent, inBetweenBPPercent] = plotting_signals(avgPercentBP, stdePercentBP);
[upperCannonPercent, lowerCannonPercent, inBetweenCannonPercent] = plotting_signals(avgPercentCannon, stdePercentCannon);
[upperLivePercent, lowerLivePercent, inBetweenLivePercent] = plotting_signals(avgPercentLive, stdePercentLive);
% Normalized by subtraction and time normalized
[upperTeeSubtract, lowerTeeSubtract, inBetweenTeeSubtract] = plotting_signals(avgSubtractTee, stdeSubtractTee);
[upperBPSubtract, lowerBPSubtract, inBetweenBPSubtract] = plotting_signals(avgSubtractBP, stdeSubtractBP);
[upperCannonSubtract, lowerCannonSubtract, inBetweenCannonSubtract] = plotting_signals(avgSubtractCannon, stdeSubtractCannon);
[upperLiveSubtract, lowerLiveSubtract, inBetweenLiveSubtract] = plotting_signals(avgSubtractLive, stdeSubtractLive);
% Raw data, time normalized
[upperTeeRawTime, lowerTeeRawTime, inBetweenTeeRawTime] = plotting_signals(avgRawTimeTee, stdeRawTimeTee);
[upperBPRawTime, lowerBPRawTime, inBetweenBPRawTime] = plotting_signals(avgRawTimeBP, stdeRawTimeBP);
[upperCannonRawTime, lowerCannonRawTime, inBetweenCannonRawTime] = plotting_signals(avgRawTimeCannon, stdeRawTimeCannon);
[upperLiveRawTime, lowerLiveRawTime, inBetweenLiveRawTime] = plotting_signals(avgRawTimeLive, stdeRawTimeLive);

% Use trimmed Graphing indices for plotting
% All of the graphing indices are the same because the data was all trimmed
% in the same way
teeGraph = trimmedGraphingIndices{1}{1} / hz;
bpGraph = trimmedGraphingIndices{1}{1} / hz;
cannonGraph = trimmedGraphingIndices{1}{1} / hz;
liveGraph = trimmedGraphingIndices{1}{1} / hz;
percentSwing = [0:.1:100]';

% Create x array for plotting
% was fliplr
newTeeGraph = [teeGraph; flipud(teeGraph)];
newBPGraph = [bpGraph; flipud(bpGraph)];
newCannonGraph = [cannonGraph; flipud(cannonGraph)];
newLiveGraph = [liveGraph; flipud(liveGraph)];
newPercentSwing = [percentSwing; flipud(percentSwing)];

% Create variables for graphing different signal types
if signalType == 1
    unit1 = " (deg)";
    unit2 = " Normalized (deg/deg)";
    unit3 = " Normalized to Live (deg)";
elseif signalType == 2
    unit1 = " (deg/s)";
    unit2 = " Normalized ((deg/s)/(deg/s))";
    unit3 = " Normalized to Live (deg/s)";
elseif signalType == 3
    unit1 = " (MPH)";
    unit2 = " Normalized (MPH/MPH)";
    unit3 = " Normalized to Live (MPH)";
elseif signalType == 4
    unit1 = " (Miles/hr^2)";
    unit2 = " Normalized (Miles/hr^2/Miles/hr^2)";
    unit3 = " Normalized to Live (Miles/hr^2)";
else
    error('signalType input is not correct')
end

%% Calculate 'scores' for differences between live and everything else
% Use the trapz function to calculate the area under each numerical curve
% Subtract 100 due to Live being at 1, 100*1 = 100, spacing of numbers is
% 0.1
spacing = 0.1;
teeScore = trapz(spacing,avgPercentTee)-100;
bpScore = trapz(spacing, avgPercentBP)-100;
cannonScore = trapz(spacing,avgPercentCannon)-100;
liveScore = trapz(spacing,avgPercentLive)-100;
scores = [teeScore; bpScore; cannonScore; liveScore];


%% Plotting
labelSize = 35;
subLabelSize = 30;
subNumSize = 25;
xLineLabelSize = 25;
xLineLabelSizeRaw = 25;
xLinePitcher = 25;
boldLabel = 'bold';
pitchColor = [0.8500 0.3250 0.0980]	;	

% I should put the plotting stuff into a function/functions
% Plot everything in one plot - The non-normalized raw data
% Only want the raw data now, none of the normalized data
f = gcf;
figure(f.Number+1)
%subplot(3,1,1)
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
xline(normTeeEvents,'r-', 'LineWidth',2, 'LabelHorizontalAlignment','center','FontSize',xLineLabelSizeRaw,'FontWeight', boldLabel)
xline(normBPEvents,'g-', 'LineWidth',2, 'LabelHorizontalAlignment','center','FontSize',xLineLabelSizeRaw,'FontWeight', boldLabel)
xline(normCannonEvents,'b-', 'LineWidth',2, 'LabelHorizontalAlignment','center','FontSize',xLineLabelSizeRaw,'FontWeight', boldLabel)
xline(normLiveEvents,'k-',events, 'LineWidth',2, 'LabelHorizontalAlignment','center','FontSize',xLineLabelSizeRaw,'FontWeight', boldLabel)
xline(pitchInfo(1),'-','Pitcher Foot Up (est)','LineWidth',1, 'LabelHorizontalAlignment','center','FontSize',xLinePitcher,'FontWeight', boldLabel,'Color',pitchColor)
xline(pitchInfo(2),'-','Pitcher Knee Up (est)','LineWidth',1, 'LabelHorizontalAlignment','center','FontSize',xLinePitcher,'FontWeight', boldLabel,'Color',pitchColor)
xline(pitchInfo(3),'-','Pitcher Hand Separation (est)','LineWidth',1, 'LabelHorizontalAlignment','center','FontSize',xLinePitcher,'FontWeight', boldLabel,'Color',pitchColor)
xline(pitchInfo(4),'-','Pitcher Foot Down (est)','LineWidth',1, 'LabelHorizontalAlignment','center','FontSize',xLinePitcher,'FontWeight', boldLabel,'Color',pitchColor)
xline(pitchInfo(5),'-','Pitch Release (est)','LineWidth',1, 'LabelHorizontalAlignment','center','FontSize',xLinePitcher,'FontWeight', boldLabel,'Color',pitchColor)
xlim([-2 0.5])
ax= gca;
ax.FontSize = subLabelSize;
ax.FontWeight = 'bold';
legend([p1 p2 p3 p4],{'Tee','BP','RPM','Live'},'Location','southwest','FontSize',xLineLabelSize, 'FontWeight','bold')
% title(strcat(graphName, ", Raw, All Participants "))
xlabel("Time (s)", 'FontSize',labelSize, 'FontWeight','bold')
ylabel(strcat(graphName, unit1),'FontSize',labelSize, 'FontWeight','bold')

% Save the figure
f = gcf;
f.WindowState = 'maximized';
path = "Z:\SSL\Research\Graduate Students\Thompson, Devin\Thesis Docs\Pitch Modality (RIP)\Thesis\Pics and Videos\Results Figs\Signals\";
fileName = strcat(signalName,"_Total");
savefig(f, strcat(path, fileName));
saveas(f, strcat(path, fileName), 'png');

% % Plot all of the normalized data, min-max
% %f = gcf;
% %figure(f.Number+1)
% subplot(3,1,2)
% hold on
% fill(newTeeGraph, normInBetweenTee,[.25 .25 .25],'facealpha',0.5,'EdgeColor',[.25 .25 .25],'EdgeAlpha', 0.25)
% fill(newBPGraph, normInBetweenBP,[.25 .25 .25],'facealpha',0.5,'EdgeColor',[.25 .25 .25],'EdgeAlpha', 0.25)
% fill(newCannonGraph, normInBetweenCannon,[.25 .25 .25],'facealpha',0.5,'EdgeColor',[.25 .25 .25],'EdgeAlpha', 0.25)
% fill(newLiveGraph, normInBetweenLive,[.25 .25 .25],'facealpha',0.5,'EdgeColor',[.25 .25 .25],'EdgeAlpha', 0.25)
% p1 = plot(teeGraph, normAvgTee, 'r', 'LineWidth',2);
% p2 = plot(bpGraph, normAvgBP, 'g', 'LineWidth',2);
% p3 = plot(cannonGraph, normAvgCannon, 'b', 'LineWidth',2);
% p4 = plot(liveGraph, normAvgLive, 'k', 'LineWidth',2);
% plot(teeGraph, normUpperTee, 'r', 'LineWidth',.5)
% plot(bpGraph, normUpperBP, 'g', 'LineWidth',.5)
% plot(cannonGraph, normUpperCannon, 'b', 'LineWidth',.5)
% plot(liveGraph, normUpperLive, 'k', 'LineWidth',.5)
% plot(teeGraph, normLowerTee, 'r', 'LineWidth',.5)
% plot(bpGraph, normLowerBP, 'g', 'LineWidth',.5)
% plot(cannonGraph, normLowerCannon, 'b', 'LineWidth',.5)
% plot(liveGraph, normLowerLive, 'k', 'LineWidth',.5)
% xline(normTeeEvents,'r-', 'LineWidth',2)
% xline(normBPEvents,'g-', 'LineWidth',2)
% xline(normCannonEvents,'b-', 'LineWidth',2)
% xline(normLiveEvents,'k-',events, 'LineWidth',2)
% xline(pitchInfo(1),'c-','Pitcher Foot Up (est)','LineWidth',1)
% xline(pitchInfo(2),'c-','Pitcher Knee Up (est)','LineWidth',1)
% xline(pitchInfo(3),'c-','Pitcher Hand Separation (est)','LineWidth',1)
% xline(pitchInfo(4),'c-','Pitcher Foot Down (est)','LineWidth',1)
% xline(pitchInfo(5),'c-','Pitch Release (est)','LineWidth',1)
% xlim([-2 0.5])
% legend([p1 p2 p3 p4],{'Tee','BP','RPM','Live'},'Location','bestoutside')
% title(strcat(signalName, "For All Participants: Min-Max Normalized"))
% xlabel('Time (s)')
% ylabel(strcat(signalName, unit2))
% 
% % Plot all of the data normalized to the Live condition
% %f = gcf;
% %figure(f.Number+1)
% subplot(3,1,3)
% hold on
% fill(newTeeGraph, inBetweenTeeLive,[.25 .25 .25],'facealpha',0.5,'EdgeColor',[.25 .25 .25],'EdgeAlpha', 0.25)
% fill(newBPGraph, inBetweenBPLive,[.25 .25 .25],'facealpha',0.5,'EdgeColor',[.25 .25 .25],'EdgeAlpha', 0.25)
% fill(newCannonGraph, inBetweenCannonLive,[.25 .25 .25],'facealpha',0.5,'EdgeColor',[.25 .25 .25],'EdgeAlpha', 0.25)
% %fill(newLiveGraph, normInBetweenLive,[.25 .25 .25],'facealpha',0.5,'EdgeColor',[.25 .25 .25],'EdgeAlpha', 0.25)
% p1 = plot(teeGraph, avgTeeLive, 'r', 'LineWidth',2);
% p2 = plot(bpGraph, avgBPLive, 'g', 'LineWidth',2);
% p3 = plot(cannonGraph, avgCannonLive, 'b', 'LineWidth',2);
% %p4 = plot(liveGraph, normAvgLive, 'k', 'LineWidth',2);
% plot(teeGraph, upperTeeLive, 'r', 'LineWidth',.5)
% plot(bpGraph, upperBPLive, 'g', 'LineWidth',.5)
% plot(cannonGraph, upperCannonLive, 'b', 'LineWidth',.5)
% %plot(liveGraph, normUpperLive, 'k', 'LineWidth',.5)
% plot(teeGraph, lowerTeeLive, 'r', 'LineWidth',.5)
% plot(bpGraph, lowerBPLive, 'g', 'LineWidth',.5)
% plot(cannonGraph, lowerCannonLive, 'b', 'LineWidth',.5)
% %plot(liveGraph, normLowerLive, 'k', 'LineWidth',.5)
% xline(normTeeEvents,'r-', 'LineWidth',2)
% xline(normBPEvents,'g-', 'LineWidth',2)
% xline(normCannonEvents,'b-', 'LineWidth',2)Cannon
% xline(normLiveEvents,'k-',events, 'LineWidth',2)
% yline(0,'k-','LineWidth',2)
% xline(pitchInfo(1),'c-','Pitcher Foot Up (est)','LineWidth',1)
% xline(pitchInfo(2),'c-','Pitcher Knee Up (est)','LineWidth',1)
% xline(pitchInfo(3),'c-','Pitcher Hand Separation (est)','LineWidth',1)
% xline(pitchInfo(4),'c-','Pitcher Foot Down (est)','LineWidth',1)
% xline(pitchInfo(5),'c-','Pitch Release (est)','LineWidth',1)
% xlim([-2 0.5])
% legend([p1 p2 p3],{'Tee','BP','RPM'},'Location','bestoutside')
% title(strcat(signalName, " For All Participants: Normalized to Live"))
% xlabel('Time (s)')
% ylabel(strcat(signalName, unit3))

% Plot the combined data as a percentage (fraction) of the live condition
f = gcf;
figure(f.Number+1)
hold on
fill(newPercentSwing, inBetweenTeePercent,[.25 .25 .25],'facealpha',0.5,'EdgeColor',[.25 .25 .25],'EdgeAlpha', 0.25)
fill(newPercentSwing, inBetweenBPPercent,[.25 .25 .25],'facealpha',0.5,'EdgeColor',[.25 .25 .25],'EdgeAlpha', 0.25)
fill(newPercentSwing, inBetweenCannonPercent,[.25 .25 .25],'facealpha',0.5,'EdgeColor',[.25 .25 .25],'EdgeAlpha', 0.25)
fill(newPercentSwing, inBetweenLivePercent,[.25 .25 .25],'facealpha',0.5,'EdgeColor',[.25 .25 .25],'EdgeAlpha', 0.25)
p1 = plot(percentSwing, avgPercentTee, 'r', 'LineWidth',3);
p2 = plot(percentSwing, avgPercentBP, 'g', 'LineWidth',3);
p3 = plot(percentSwing, avgPercentCannon, 'b', 'LineWidth',3);
p4 = plot(percentSwing, avgPercentLive, 'k', 'LineWidth',3);
plot(percentSwing, upperTeePercent, 'r', 'LineWidth',.5)
plot(percentSwing, upperBPPercent, 'g', 'LineWidth',.5)
plot(percentSwing, upperCannonPercent, 'b', 'LineWidth',.5)
plot(percentSwing, upperLivePercent, 'k', 'LineWidth',.5)
plot(percentSwing, lowerTeePercent, 'r', 'LineWidth',.5)
plot(percentSwing, lowerBPPercent, 'g', 'LineWidth',.5)
plot(percentSwing, lowerCannonPercent, 'b', 'LineWidth',.5)
plot(percentSwing, lowerLivePercent, 'k', 'LineWidth',.5)
xline(percentTeeEvents,'r-', 'LineWidth',2, 'LabelHorizontalAlignment','center','FontSize',xLineLabelSize,'FontWeight', boldLabel)
xline(percentBPEvents,'g-', 'LineWidth',2, 'LabelHorizontalAlignment','center','FontSize',xLineLabelSize,'FontWeight', boldLabel)
xline(percentCannonEvents,'b-', 'LineWidth',2, 'LabelHorizontalAlignment','center','FontSize',xLineLabelSize,'FontWeight', boldLabel)
xline(percentLiveEvents,'k-',trimmedEvents, 'LineWidth',2, 'LabelHorizontalAlignment','center','FontSize',xLineLabelSize,'FontWeight', boldLabel)
%xline(pitchInfo(1),'c-','Pitcher Foot Up (est)','LineWidth',1)
%xline(pitchInfo(2),'c-','Pitcher Knee Up (est)','LineWidth',1)
%xline(pitchInfo(3),'c-','Pitcher Hand Separation (est)','LineWidth',1)
%xline(pitchInfo(4),'c-','Pitcher Foot Down (est)','LineWidth',1)
%xline(pitchInfo(5),'c-','Pitch Release (est)','LineWidth',1)
xlim([0 100])
%ylim([-3 3])
ax= gca;
ax.FontSize = subLabelSize;
ax.FontWeight = 'bold';
xLineFootUp = ax.Children(5);
xLineFootUp.LabelHorizontalAlignment = "right";
xLineImpact = ax.Children(1);
xLineImpact.LabelHorizontalAlignment = "left";
legend([p1 p2 p3 p4],{'Tee','BP','RPM','Live'},'Location','southwest','FontSize',xLineLabelSize, 'FontWeight','bold')
%title(strcat(graphName, ", Normalized to Live, All Participants"))
xlabel("Percent of Swing", 'FontSize',labelSize, 'FontWeight','bold')
ylabel(strcat(graphName, " (Percent of Live)"), 'FontSize',labelSize, 'FontWeight','bold')

% Save the figure
f = gcf;
f.WindowState = 'maximized';
path = "Z:\SSL\Research\Graduate Students\Thompson, Devin\Thesis Docs\Pitch Modality (RIP)\Thesis\Pics and Videos\Results Figs\Signals\";
fileName = strcat(signalName,"_PercentNorm_Total");
savefig(f, strcat(path, fileName));
saveas(f, strcat(path, fileName), 'png');

% Plot the normalized by subtraction data with normalized time
f = gcf;
figure(f.Number+1)
hold on
fill(newPercentSwing, inBetweenTeeSubtract,[.25 .25 .25],'facealpha',0.5,'EdgeColor',[.25 .25 .25],'EdgeAlpha', 0.25)
fill(newPercentSwing, inBetweenBPSubtract,[.25 .25 .25],'facealpha',0.5,'EdgeColor',[.25 .25 .25],'EdgeAlpha', 0.25)
fill(newPercentSwing, inBetweenCannonSubtract,[.25 .25 .25],'facealpha',0.5,'EdgeColor',[.25 .25 .25],'EdgeAlpha', 0.25)
fill(newPercentSwing, inBetweenLiveSubtract,[.25 .25 .25],'facealpha',0.5,'EdgeColor',[.25 .25 .25],'EdgeAlpha', 0.25)
p1 = plot(percentSwing, avgSubtractTee, 'r', 'LineWidth',3);
p2 = plot(percentSwing, avgSubtractBP, 'g', 'LineWidth',3);
p3 = plot(percentSwing, avgSubtractCannon, 'b', 'LineWidth',3);
p4 = plot(percentSwing, avgSubtractLive, 'k', 'LineWidth',3);
plot(percentSwing, upperTeeSubtract, 'r', 'LineWidth',.5)
plot(percentSwing, upperBPSubtract, 'g', 'LineWidth',.5)
plot(percentSwing, upperCannonSubtract, 'b', 'LineWidth',.5)
plot(percentSwing, upperLiveSubtract, 'k', 'LineWidth',.5)
plot(percentSwing, lowerTeeSubtract, 'r', 'LineWidth',.5)
plot(percentSwing, lowerBPSubtract, 'g', 'LineWidth',.5)
plot(percentSwing, lowerCannonSubtract, 'b', 'LineWidth',.5)
plot(percentSwing, lowerLiveSubtract, 'k', 'LineWidth',.5)
xline(percentTeeEvents,'r-', 'LineWidth',2, 'LabelHorizontalAlignment','center','FontSize',xLineLabelSize,'FontWeight', boldLabel)
xline(percentBPEvents,'g-', 'LineWidth',2, 'LabelHorizontalAlignment','center','FontSize',xLineLabelSize,'FontWeight', boldLabel)
xline(percentCannonEvents,'b-', 'LineWidth',2, 'LabelHorizontalAlignment','center','FontSize',xLineLabelSize,'FontWeight', boldLabel)
xline(percentLiveEvents,'k-',trimmedEvents, 'LineWidth',2, 'LabelHorizontalAlignment','center','FontSize',xLineLabelSize,'FontWeight', boldLabel)
%xline(pitchInfo(1),'c-','Pitcher Foot Up (est)','LineWidth',1)
%xline(pitchInfo(2),'c-','Pitcher Knee Up (est)','LineWidth',1)
%xline(pitchInfo(3),'c-','Pitcher Hand Separation (est)','LineWidth',1)
%xline(pitchInfo(4),'c-','Pitcher Foot Down (est)','LineWidth',1)
%xline(pitchInfo(5),'c-','Pitch Release (est)','LineWidth',1)
xlim([0 100])
%ylim([-3 3])
ax= gca;
ax.FontSize = subLabelSize;
ax.FontWeight = 'bold';
xLineFootUp = ax.Children(5);
xLineFootUp.LabelHorizontalAlignment = "right";
xLineImpact = ax.Children(1);
xLineImpact.LabelHorizontalAlignment = "left";
legend([p1 p2 p3 p4],{'Tee','BP','RPM','Live'},'Location','southwest','FontSize',xLineLabelSize, 'FontWeight','bold')
% title(strcat(graphName, ", Normalized By Subtracting Live, All Participants"))
xlabel("Percent of Swing",'FontSize',labelSize, 'FontWeight','bold')
ylabel(strcat(graphName, unit1),'FontSize',labelSize, 'FontWeight','bold')

% Save the figure
f = gcf;
f.WindowState = 'maximized';
path = "Z:\SSL\Research\Graduate Students\Thompson, Devin\Thesis Docs\Pitch Modality (RIP)\Thesis\Pics and Videos\Results Figs\Signals\";
fileName = strcat(signalName,"_SubtractTimeNorm_Total");
savefig(f, strcat(path, fileName));
saveas(f, strcat(path, fileName), 'png');

% Plot the combined raw data
f = gcf;
figure(f.Number+1)
hold on
fill(newPercentSwing, inBetweenTeeRawTime,[.25 .25 .25],'facealpha',0.5,'EdgeColor',[.25 .25 .25],'EdgeAlpha', 0.25)
fill(newPercentSwing, inBetweenBPRawTime,[.25 .25 .25],'facealpha',0.5,'EdgeColor',[.25 .25 .25],'EdgeAlpha', 0.25)
fill(newPercentSwing, inBetweenCannonRawTime,[.25 .25 .25],'facealpha',0.5,'EdgeColor',[.25 .25 .25],'EdgeAlpha', 0.25)
fill(newPercentSwing, inBetweenLiveRawTime,[.25 .25 .25],'facealpha',0.5,'EdgeColor',[.25 .25 .25],'EdgeAlpha', 0.25)
p1 = plot(percentSwing, avgRawTimeTee, 'r', 'LineWidth',3);
p2 = plot(percentSwing, avgRawTimeBP, 'g', 'LineWidth',3);
p3 = plot(percentSwing, avgRawTimeCannon, 'b', 'LineWidth',3);
p4 = plot(percentSwing, avgRawTimeLive, 'k', 'LineWidth',3);
plot(percentSwing, upperTeeRawTime, 'r', 'LineWidth',.5)
plot(percentSwing, upperBPRawTime, 'g', 'LineWidth',.5)
plot(percentSwing, upperCannonRawTime, 'b', 'LineWidth',.5)
plot(percentSwing, upperLiveRawTime, 'k', 'LineWidth',.5)
plot(percentSwing, lowerTeeRawTime, 'r', 'LineWidth',.5)
plot(percentSwing, lowerBPRawTime, 'g', 'LineWidth',.5)
plot(percentSwing, lowerCannonRawTime, 'b', 'LineWidth',.5)
plot(percentSwing, lowerLiveRawTime, 'k', 'LineWidth',.5)
xline(percentTeeEvents,'r-', 'LineWidth',2, 'LabelHorizontalAlignment','center','FontSize',xLineLabelSize,'FontWeight', boldLabel)
xline(percentBPEvents,'g-', 'LineWidth',2, 'LabelHorizontalAlignment','center','FontSize',xLineLabelSize,'FontWeight', boldLabel)
xline(percentCannonEvents,'b-', 'LineWidth',2, 'LabelHorizontalAlignment','center','FontSize',xLineLabelSize,'FontWeight', boldLabel)
xline(percentLiveEvents,'k-',trimmedEvents, 'LineWidth',2, 'LabelHorizontalAlignment','center','FontSize',xLineLabelSize,'FontWeight', boldLabel)
%xline(pitchInfo(1),'c-','Pitcher Foot Up (est)','LineWidth',1)
%xline(pitchInfo(2),'c-','Pitcher Knee Up (est)','LineWidth',1)
%xline(pitchInfo(3),'c-','Pitcher Hand Separation (est)','LineWidth',1)
%xline(pitchInfo(4),'c-','Pitcher Foot Down (est)','LineWidth',1)
%xline(pitchInfo(5),'c-','Pitch Release (est)','LineWidth',1)
xlim([0 100])
%ylim([-3 3])
ax= gca;
ax.FontSize = subLabelSize;
ax.FontWeight = 'bold';
xLineFootUp = ax.Children(5);
xLineFootUp.LabelHorizontalAlignment = "right";
xLineImpact = ax.Children(1);
xLineImpact.LabelHorizontalAlignment = "left";
legend([p1 p2 p3 p4],{'Tee','BP','RPM','Live'},'Location','southwest','FontSize',xLineLabelSize, 'FontWeight','bold')
% title(strcat(graphName, ", Raw Data, Time Normalized, All Participants"))
xlabel("Percent of Swing",'FontSize',labelSize, 'FontWeight','bold')
ylabel(strcat(graphName, unit1),'FontSize',labelSize, 'FontWeight','bold')

% Save the figure
f = gcf;
f.WindowState = 'maximized';
path = "Z:\SSL\Research\Graduate Students\Thompson, Devin\Thesis Docs\Pitch Modality (RIP)\Thesis\Pics and Videos\Results Figs\Signals\";
fileName = strcat(signalName,"_RawNormTime_Total");
savefig(f, strcat(path, fileName));
saveas(f, strcat(path, fileName), 'png');

%% Statistical results using spm1d

% Compile all trial data into once large array, create vectors
% corresponding to subject and pitch method type
% [rawMats, subVec, modeVec] = combine_Data(rawTimeMats);
% [percentMats, subVec, modeVec] = combine_Data(rawTimeMats);
% [subtractMats, subVec, modeVec] = combine_Data(rawTimeMats);
%[rawTimeCombined, subVec, modeVec] = combine_Data(rawTimeMats);
%Y = [percentTeeMat';percentBPMat';percentCannonMat';percentLiveMat']; %array of data to test, 
%Y = [teeMat';bpMat';cannonMat';liveMat']; % array of data to test
%Y0 = rawTimeTeeMat';
%Y1 = rawTimeLiveMat';
% This is the data I should be using
rawTimeCombined = [rawTimeTeeMat';rawTimeBPMat';rawTimeCannonMat';rawTimeLiveMat']; % array of data to test, (p*c)*1001
modeVec = [zeros(numel(subjectNames),1); ones(numel(subjectNames),1); ones(numel(subjectNames),1)*2; ones(numel(subjectNames),1)*3]; % Label each group (p*c)*1
subVec = [[1:numel(subjectNames)]'; [1:numel(subjectNames)]'; [1:numel(subjectNames)]'; [1:numel(subjectNames)]']; % Label by subjec (p*c)*1

% Conduct normality test:
alpha = 0.05;
spm = spm1d.stats.normality.anova1rm(rawTimeCombined, subVec, modeVec);
spmi = spm.inference(alpha);
disp(spmi)

% Plot:
f = gcf;
f = figure((f.Number)+1)
xGraph = [0:.1:100]';
sgt = sgtitle(strcat("Normality: ", graphName));
sgt.FontSize = 35;
sgt.FontWeight = 'bold';
bp1 = subplot(131);  plot(xGraph,rawTimeCombined', 'k');  hold on;  title('Data', FontSize=subLabelSize, FontWeight='bold')
bp2 = subplot(132);  plot(xGraph,spm.residuals', 'k');  title('Residuals', FontSize=subLabelSize, FontWeight='bold'); xlabel("Percent of Swing", FontSize=labelSize, FontWeight='bold')
bp3 = subplot(133);  bp4 = spmi.plot(); title('Normality test', FontSize=subLabelSize, FontWeight='bold')

bp1.FontSize = subNumSize; bp2.FontSize = subNumSize; bp3.FontSize = subNumSize;

bp4(1).XData =  xGraph;
bp4(2).XData =  [0 100];
bp4(3).XData =  [0 100];
if length(bp4) > 3
    for i = 4:length(bp4)
        bp4(i).XData = bp4(i).XData ./10;
    end
end

% Save the normality test results
f = gcf;
f.WindowState = 'maximized';
path = "Z:\SSL\Research\Graduate Students\Thompson, Devin\Thesis Docs\Pitch Modality (RIP)\Thesis\Pics and Videos\Results Figs\Stats\";
fileName = strcat(signalName,"_RawNormTime_Normality");
savefig(f, strcat(path, fileName));
saveas(f, strcat(path, fileName), 'png');

% Equal variance test - Not going to test for equal variance, just use the
% non-parametric test, seems like it's not normal as lest for part of the
% trial
% [f,fcrit] = spm1d.stats.eqvartest(y0,y1, 'alt', 'unequal', 'alpha', 0.05);

% Parametric
F1 = spm1d.stats.anova1rm(rawTimeCombined, modeVec, subVec) % repeated measures, 7 trials
spmi1 = F1.inference(0.05)
disp(spmi1)

% Non-Parametric
% iterations = 1000;
% F2 = spm1d.stats.nonparam.anova1rm(rawTimeCombined, modeVec, subVec);
% snpmi2 = F2.inference(0.05, 'iterations', iterations);
% disp(snpmi2)

%Plot:
f = gcf;
figure((f.Number)+1)
xticks([0:10:100]);
xticklabels({'0', '10', '20', '30', '40', '50', '60', '70', '80', '90', '100'});

p = spmi1.plot(); % Parametric
pt = spmi1.plot_threshold_label();
spmi1.plot_p_values();
% p = snpmi2.plot(); % non-parametric
% pt = snpmi2.plot_threshold_label();
% snpmi2.plot_p_values();

p(1).XData =  xGraph;
p(2).XData =  [0 100];
p(3).XData =  [0 100];
if length(p) > 3
    for i = 4:length(p)
        p(i).XData = p(i).XData ./10;
    end
end

pt.FontSize = subNumSize;
ax = gca;
ax.FontSize = subLabelSize;
ax.FontWeight = 'bold';
xlabel("Percent of Swing",FontSize=labelSize, FontWeight='bold')
title(strcat("SPM: ", graphName),FontSize=labelSize, FontWeight='bold')

% Save the figure
f = gcf;
f.WindowState = 'maximized';
path = "Z:\SSL\Research\Graduate Students\Thompson, Devin\Thesis Docs\Pitch Modality (RIP)\Thesis\Pics and Videos\Results Figs\Stats\";
fileName = strcat(signalName,"_RawNormTime_Stats");
savefig(f, strcat(path, fileName));
saveas(f, strcat(path, fileName), 'png');

% If there are significant differences, need to do post-hoc comparisons,
% can do it on all, only report results from ones with differences
% separate into groups:
Y1 = rawTimeCombined(modeVec==0,:);
Y2 = rawTimeCombined(modeVec==1,:);
Y3 = rawTimeCombined(modeVec==2,:);
Y4 = rawTimeCombined(modeVec==3,:);

% Conduct SPM post hoc analysis:
t12 = spm1d.stats.ttest_paired(Y1, Y2);
t13 = spm1d.stats.ttest_paired(Y1, Y3);
t14 = spm1d.stats.ttest_paired(Y1, Y4);
t23 = spm1d.stats.ttest_paired(Y2, Y3);
t24 = spm1d.stats.ttest_paired(Y2, Y4);
t34 = spm1d.stats.ttest_paired(Y3, Y4);
% inference:
nTests = 6;
p_critical = spm1d.util.p_critical_bonf(alpha, nTests);
%p_critical = 0.05;
t12i = t12.inference(p_critical, 'two_tailed',true);
t13i = t13.inference(p_critical, 'two_tailed',true);
t14i = t14.inference(p_critical, 'two_tailed',true);
t23i = t23.inference(p_critical, 'two_tailed',true);
t24i = t24.inference(p_critical, 'two_tailed',true);
t34i = t34.inference(p_critical, 'two_tailed',true);

% Plot comparisons
f = gcf;
figure((f.Number)+1)
sgt = sgtitle(strcat("MC: ", graphName));
sgt.FontSize = subLabelSize;
sgt.FontWeight = 'bold';
mcpl = 20;
sp1 = subplot(321);  s1 = t12i.plot(); title('Tee - BP', 'FontSize', subLabelSize, 'FontWeight','bold'); ylim([-mcpl mcpl]); 
sp2 = subplot(322);  s2 = t13i.plot(); title('Tee - RPM', 'FontSize', subLabelSize, 'FontWeight','bold'); ylim([-mcpl mcpl]); 
sp3 = subplot(323);  s3 = t14i.plot(); title('Tee - Live', 'FontSize', subLabelSize, 'FontWeight','bold'); ylim([-mcpl mcpl]); 
sp4 = subplot(324);  s4 = t23i.plot(); title('BP - RPM', 'FontSize', subLabelSize, 'FontWeight','bold'); ylim([-mcpl mcpl]); 
sp5 = subplot(325);  s5 = t24i.plot(); title('BP - Live', 'FontSize', subLabelSize, 'FontWeight','bold'); ylim([-mcpl mcpl]); 
sp6 = subplot(326);  s6 = t34i.plot(); title('RPM - Live', 'FontSize', subLabelSize, 'FontWeight','bold'); ylim([-mcpl mcpl]);  

s5(1).XData = xGraph;
s5(2).XData = [0 100];
s5(3).XData = [0 100];
s5(4).XData = [0 100];
s6(1).XData = xGraph;
s6(2).XData = [0 100];
s6(3).XData = [0 100];
s6(4).XData = [0 100];
if length(s5) > 4
    for i = 5:length(s5)
        s5(i).XData = s5(i).XData ./10;
    end
end
if length(s6) > 4
    for i = 5:length(s6)
        s6(i).XData = s6(i).XData ./10;
    end
end

xTickLabels = {'0', '10', '20', '30', '40', '50', '60', '70', '80', '90', '100'};
xTicks = [0:10:100];
sp1.FontSize = subNumSize; sp2.FontSize = subNumSize; sp3.FontSize = subNumSize; sp4.FontSize = subNumSize; sp5.FontSize = subNumSize; sp6.FontSize = subNumSize;
sp5.XTick = xTicks; sp6.XTick = xTicks;
sp1.XTickLabel = []; sp2.XTickLabel = []; sp3.XTickLabel = []; sp4.XTickLabel = []; %sp5.XTickLabel = xTickLabels; sp6.XTickLabel = xTickLabels;

% Save the figure
f = gcf;
f.WindowState = 'maximized';
path = "Z:\SSL\Research\Graduate Students\Thompson, Devin\Thesis Docs\Pitch Modality (RIP)\Thesis\Pics and Videos\Results Figs\Stats\";
fileName = strcat(signalName,"_RawNormTime_MC");
savefig(f, strcat(path, fileName));
saveas(f, strcat(path, fileName), 'png');

% f = gcf;
% figure((f.Number)+1)
% spm1d.plot.plot_mean_sd(Y0, linecolor='b', facecolor=(0.7,0.7,1), edgecolor='b', label='Slow')
% spm1d.plot.plot_mean_sd(Y1, label='Normal')
% spm1d.plot.plot_mean_sd(Y2, linecolor='r', facecolor=(1,0.7,0.7), edgecolor='r', label='Fast')

%% Output necessary data to Excel and diplay the data here
% Put index scores into a single
for i = 1:length(indScores)
    outScores(:,i) = indScores{i};
end
outScores(:,i+1) = scores;


% Create matrices to output as well from the graphs
% For each calulate signal (currently 4) and each pitch method, avg and
% stde (4*3*2 + 3*2 = 30 signals)
% Raw
outRawTee = [teeMat teeGraph avgTee];
outRawBP = [bpMat bpGraph avgBP];
outRawCannon = [cannonMat cannonGraph avgCannon];
outRawLive = [liveMat liveGraph avgLive];

outRawTeeStde = [teeMatStde teeGraph stdeTee];
outRawBPStde = [bpMatStde bpGraph stdeBP];
outRawCannonStde = [cannonMatStde cannonGraph stdeCannon];
outRawLiveStde = [liveMatStde liveGraph stdeLive];
% Min-Max
outMMTee = [normTeeMat teeGraph normAvgTee];
outMMBP = [normBPMat bpGraph normAvgBP];
outMMCannon = [normCannonMat cannonGraph normAvgCannon];
outMMLive = [normLiveMat liveGraph normAvgLive];

outMMTeeStde = [normTeeMatStde teeGraph normStdeTee];
outMMBPStde = [normBPMatStde bpGraph normStdeBP];
outMMCannonStde = [normCannonMatStde cannonGraph normStdeCannon];
outMMLiveStde = [normLiveMatStde liveGraph normStdeLive];
% To live by subtraction, no live output
outLiveTee = [normTeeLiveMat teeGraph avgTeeLive];
outLiveBP = [normBPLiveMat bpGraph avgBPLive];
outLiveCannon = [normCannonLiveMat cannonGraph avgCannonLive];

outLiveTeeStde = [normTeeLiveMatStde teeGraph stdeTeeLive];
outLiveBPStde = [normBPLiveMatStde bpGraph stdeBPLive];
outLiveCannonStde = [normCannonLiveMatStde cannonGraph stdeCannonLive];

% Normalized to live condition as percentage
outPercentTee = [percentTeeMat percentSwing avgPercentTee];
outPercentBP = [percentBPMat percentSwing avgPercentBP];
outPercentCannon = [percentCannonMat percentSwing avgPercentCannon];
outPercentLive = [percentLiveMat percentSwing avgPercentLive];

outPercentTeeStde = [percentTeeMatStde percentSwing stdePercentTee];
outPercentBPStde = [percentBPMatStde percentSwing stdePercentBP];
outPercentCannonStde = [percentCannonMatStde percentSwing stdePercentCannon];
outPercentLiveStde = [percentLiveMatStde percentSwing stdePercentLive];

% Normalized by subtraction and normalized time

% Raw and normalized time

% Compile the avg and stde values (order is raw, MM, Live, percent live)
outTee = {outRawTee outRawTeeStde outMMTee outMMTeeStde outLiveTee outLiveTeeStde outPercentTee outPercentTeeStde};
outBP = {outRawBP outRawBPStde outMMBP outMMBPStde outLiveBP outLiveBPStde outPercentBP outPercentBPStde};
outCannon = {outRawCannon outRawCannonStde outMMCannon outMMCannonStde outLiveCannon outLiveCannonStde outPercentCannon outPercentCannonStde};
outLive = {outRawLive outRawLiveStde outMMLive outMMLiveStde outPercentLive outPercentLiveStde};

%% Get the first value where the name (first column) is open
writeScore = 0;
if writeScore == 1
    write_Scores_xlsx(outScores,signalName)
end 

%% Write the signal data
writeSignal = 0;
if writeSignal == 1
    write_Signal_Data_xlsx(outTee, signalName, 1); % Tee = 1
    write_Signal_Data_xlsx(outBP, signalName, 2); % BP = 2
    write_Signal_Data_xlsx(outCannon, signalName, 3); % Cannon = 3
    write_Signal_Data_xlsx(outLive, signalName, 4); % Live = 4
end

disp(indScores{1})
disp(indScores{2})
disp(indScores{3})
disp(indScores{4})
disp(indScores{5})
disp(scores)



end

