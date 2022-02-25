function [outTee, outBP, outCannon, outLive] = process_Signal(data, subjectNames, signalName, subjectData, signalType)
% Process a single signal - run this function with different signal names
% to process different signals

% Extract the event times from teeData, bpData, cannonData, Live Data
%eventNames = {'stance','load','footDown','impact','firstMove','followThrough'};
events = {'Stance','Foot Up','Load','First Hand Movement','Foot Down','Impact','Follow Through'};
trimmedEvents = {'Foot Up','Load','First Hand Movement','Foot Down','Impact'};
hz = 500; % hz
pitchInfo = [-1.97 -1.56 -1.18 -.73 -.54]; % s

% Create signals for each subject, each cell of avg, etc is a different
% subject
for i = 1:length(subjectNames)
    [avg{i,1}, stde{i,1}, normAvg{i,1}, normStde{i,1}, normLiveAvg{i,1}, normLiveStde{i,1}, avgPercent{i,1}, stdePercent{i,1}, percentEvents{i,1}, eventTimes{i,1}, trimmedGraphingIndices{i,1}, indScores{i,1}] = separate_PitchMode_Signals(data.(subjectNames{i}), signalName, subjectNames{i}, subjectData{i}{9}, signalType, pitchInfo);
end

% Compile the signals by pitch mode 
for i = 1:length(avg)
    % From each patricipant, put each pitch mode into a matrix
    % Raw
    % Avg
    teeMat(:,i) = avg{i}{1};
    bpMat(:,i) = avg{i}{2};
    cannonMat(:,i) = avg{i}{3};
    liveMat(:,i) = avg{i}{4};
    % Stde
    teeMatStde(:,i) = stde{i}{1};
    bpMatStde(:,i) = stde{i}{2};
    cannonMatStde(:,i) = stde{i}{3};
    liveMatStde(:,i) = stde{i}{4};
    % Normalized
    % Avg
    normTeeMat(:,i) = normAvg{i}{1};
    normBPMat(:,i) = normAvg{i}{2};
    normCannonMat(:,i) = normAvg{i}{3};
    normLiveMat(:,i) = normAvg{i}{4};
    %Stde
    normTeeMatStde(:,i) = normStde{i}{1};
    normBPMatStde(:,i) = normStde{i}{2};
    normCannonMatStde(:,i) = normStde{i}{3};
    normLiveMatStde(:,i) = normStde{i}{4};
    % Normalized to the live pitch mode
    % Avg
    normTeeLiveMat(:,i) = normLiveAvg{i}{1};
    normBPLiveMat(:,i) = normLiveAvg{i}{2};
    normCannonLiveMat(:,i) = normLiveAvg{i}{3};
    % Stde
    normTeeLiveMatStde(:,i) = normLiveStde{i}{1};
    normBPLiveMatStde(:,i) = normLiveStde{i}{2};
    normCannonLiveMatStde(:,i) = normLiveStde{i}{3};
    % Percent events
    %Avg
    percentTeeMat(:,i) = avgPercent{i}{1};
    percentBPMat(:,i) = avgPercent{i}{2};
    percentCannonMat(:,i) = avgPercent{i}{3};
    percentLiveMat(:,i) = avgPercent{i}{4};
    % Stde
    percentTeeMatStde(:,i) = stdePercent{i}{1};
    percentBPMatStde(:,i) = stdePercent{i}{2};
    percentCannonMatStde(:,i) = stdePercent{i}{3};
    percentLiveMatStde(:,i) = stdePercent{i}{4};
    
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
avgTee = mean(teeMat,2,'omitnan');
avgBP = mean(bpMat,2,'omitnan');
avgCannon = mean(cannonMat,2,'omitnan');
avgLive = mean(liveMat,2,'omitnan');

stdeTee = std(teeMat,1,2,'omitnan')./ sqrt(size(teeMat,2));
stdeBP = std(bpMat,1,2,'omitnan')./ sqrt(size(bpMat,2));
stdeCannon = std(cannonMat,1,2,'omitnan')./ sqrt(size(cannonMat,2));
stdeLive = std(liveMat,1,2,'omitnan')./ sqrt(size(liveMat,2));
% Normalized
normAvgTee = mean(normTeeMat,2,'omitnan');
normAvgBP = mean(normBPMat,2,'omitnan');
normAvgCannon = mean(normCannonMat,2,'omitnan');
normAvgLive = mean(normLiveMat,2,'omitnan');

normStdeTee = std(normTeeMat,1,2,'omitnan')./ sqrt(size(normTeeMat,2));
normStdeBP = std(normBPMat,1,2,'omitnan')./ sqrt(size(normBPMat,2));
normStdeCannon = std(normCannonMat,1,2,'omitnan')./ sqrt(size(normCannonMat,2));
normStdeLive = std(normLiveMat,1,2,'omitnan')./ sqrt(size(normLiveMat,2));
% Normalized to live
avgTeeLive = mean(normTeeLiveMat,2,'omitnan');
avgBPLive = mean(normBPLiveMat,2,'omitnan');
avgCannonLive = mean(normCannonLiveMat,2,'omitnan');

stdeTeeLive = std(normTeeLiveMat,1,2,'omitnan')./ sqrt(size(normTeeLiveMat,2));
stdeBPLive = std(normBPLiveMat,1,2,'omitnan')./ sqrt(size(normBPLiveMat,2));
stdeCannonLive = std(normCannonLiveMat,1,2,'omitnan')./ sqrt(size(normCannonLiveMat,2));

% Percent of Live
avgPercentTee = mean(percentTeeMat,2,'omitnan');
avgPercentBP = mean(percentBPMat,2,'omitnan');
avgPercentCannon = mean(percentCannonMat,2,'omitnan');
avgPercentLive = mean(percentLiveMat,2,'omitnan');

stdePercentTee = std(percentTeeMat,1,2,'omitnan')./ sqrt(size(percentTeeMat,2));
stdePercentBP = std(percentBPMat,1,2,'omitnan')./ sqrt(size(percentBPMat,2));
stdePercentCannon = std(percentCannonMat,1,2,'omitnan')./ sqrt(size(percentCannonMat,2));
stdePercentLive = std(percentLiveMat,1,2,'omitnan')./ sqrt(size(percentLiveMat,2));

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
% Normalized
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
% Percent of Swing
upperTeePercent = avgPercentTee+stdePercentTee;
lowerTeePercent = avgPercentTee-stdePercentTee;
inBetweenTeePercent = [upperTeePercent; flipud(lowerTeePercent)]';
upperBPPercent = avgPercentBP+stdePercentBP;
lowerBPPercent = avgPercentBP-stdePercentBP;
inBetweenBPPercent = [upperBPPercent; flipud(lowerBPPercent)]';
upperCannonPercent = avgPercentCannon+stdePercentCannon;
lowerCannonPercent = avgPercentCannon-stdePercentCannon;
inBetweenCannonPercent = [upperCannonPercent; flipud(lowerCannonPercent)]';
upperLivePercent = avgPercentLive+stdePercentLive;
lowerLivePercent = avgPercentLive-stdePercentLive;
inBetweenLivePercent = [upperLivePercent; flipud(lowerLivePercent)]';

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
    unit1 = " deg/s";
    unit2 = " Normalized ((deg/s)/(deg/s))";
    unit3 = " Normalized to Live (deg/s)";
elseif signalType == 3
    unit1 = " MPH";
    unit2 = " Normalized (MPH/MPH)";
    unit3 = " Normalized to Live (MPH)";
elseif signalType == 4
    unit1 = " Miles/hr^2";
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
teeScore = trapz(spacing,avgPercentTee) - 100;
bpScore = trapz(spacing, avgPercentBP) - 100;
cannonScore = trapz(spacing,avgPercentCannon) - 100;
liveScore = trapz(spacing,avgPercentLive) - 100;
scores = [teeScore; bpScore; cannonScore; liveScore];


%% Plotting
% Plot everything in one plot - The non-normalized raw data
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
title(strcat(signalName, " For All Participants: Raw Data"))
xlabel('Time (s)')
ylabel(strcat(signalName, unit1))

% Plot all of the normalized data, min-max
%f = gcf;
%figure(f.Number+1)
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
title(strcat(signalName, "For All Participants: Min-Max Normalized"))
xlabel('Time (s)')
ylabel(strcat(signalName, unit2))

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
yline(0,'k-','LineWidth',2)
xline(pitchInfo(1),'c-','Pitcher Foot Up (est)','LineWidth',1)
xline(pitchInfo(2),'c-','Pitcher Knee Up (est)','LineWidth',1)
xline(pitchInfo(3),'c-','Pitcher Hand Separation (est)','LineWidth',1)
xline(pitchInfo(4),'c-','Pitcher Foot Down (est)','LineWidth',1)
xline(pitchInfo(5),'c-','Pitch Release (est)','LineWidth',1)
xlim([-2 0.5])
legend([p1 p2 p3],{'Tee','BP','Cannon'},'Location','bestoutside')
title(strcat(signalName, " For All Participants: Normalized to Live"))
xlabel('Time (s)')
ylabel(strcat(signalName, unit3))

% Save the figure
f = gcf;
f.WindowState = 'maximized';
path = "Z:\SSL\Research\Graduate Students\Thompson, Devin\Thesis Docs\Pitch Modality (RIP)\Thesis\Pics and Videos\Results Figs\Signals\";
fileName = strcat(signalName,"_Total");
savefig(f, strcat(path, fileName));
saveas(f, strcat(path, fileName, '.png'));

% Plot the combined data as a percentage (fraction) of the live condition
f = gcf;
figure(f.Number+1)
hold on
fill(newPercentSwing, inBetweenTeePercent,[.25 .25 .25],'facealpha',0.5,'EdgeColor',[.25 .25 .25],'EdgeAlpha', 0.25)
fill(newPercentSwing, inBetweenBPPercent,[.25 .25 .25],'facealpha',0.5,'EdgeColor',[.25 .25 .25],'EdgeAlpha', 0.25)
fill(newPercentSwing, inBetweenCannonPercent,[.25 .25 .25],'facealpha',0.5,'EdgeColor',[.25 .25 .25],'EdgeAlpha', 0.25)
fill(newPercentSwing, inBetweenLivePercent,[.25 .25 .25],'facealpha',0.5,'EdgeColor',[.25 .25 .25],'EdgeAlpha', 0.25)
p1 = plot(percentSwing, avgPercentTee, 'r', 'LineWidth',2);
p2 = plot(percentSwing, avgPercentBP, 'g', 'LineWidth',2);
p3 = plot(percentSwing, avgPercentCannon, 'b', 'LineWidth',2);
p4 = plot(percentSwing, avgPercentLive, 'k', 'LineWidth',2);
plot(percentSwing, upperTeePercent, 'r', 'LineWidth',.5)
plot(percentSwing, upperBPPercent, 'g', 'LineWidth',.5)
plot(percentSwing, upperCannonPercent, 'b', 'LineWidth',.5)
plot(percentSwing, upperLivePercent, 'k', 'LineWidth',.5)
plot(percentSwing, lowerTeePercent, 'r', 'LineWidth',.5)
plot(percentSwing, lowerBPPercent, 'g', 'LineWidth',.5)
plot(percentSwing, lowerCannonPercent, 'b', 'LineWidth',.5)
plot(percentSwing, lowerLivePercent, 'k', 'LineWidth',.5)
xline(percentTeeEvents,'r-', 'LineWidth',2)
xline(percentBPEvents,'g-', 'LineWidth',2)
xline(percentCannonEvents,'b-', 'LineWidth',2)
xline(percentLiveEvents,'k-',trimmedEvents, 'LineWidth',2)
%xline(pitchInfo(1),'c-','Pitcher Foot Up (est)','LineWidth',1)
%xline(pitchInfo(2),'c-','Pitcher Knee Up (est)','LineWidth',1)
%xline(pitchInfo(3),'c-','Pitcher Hand Separation (est)','LineWidth',1)
%xline(pitchInfo(4),'c-','Pitcher Foot Down (est)','LineWidth',1)
%xline(pitchInfo(5),'c-','Pitch Release (est)','LineWidth',1)
xlim([0 100])
%ylim([-3 3])
legend([p1 p2 p3 p4],{'Tee','BP','Cannon','Live'},'Location','bestoutside')
title(strcat(signalName, ' For Each Pitch Mode - All Participants'))
xlabel('Percent of Swing')
ylabel(strcat(signalName, " (Fraction of Live)"))

% Save the figure
f = gcf;
f.WindowState = 'maximized';
path = "Z:\SSL\Research\Graduate Students\Thompson, Devin\Thesis Docs\Pitch Modality (RIP)\Thesis\Pics and Videos\Results Figs\Signals\";
fileName = strcat(signalName,"_PercentNormTotal");
savefig(f, strcat(path, fileName));
saveas(f, strcat(path, fileName, '.png'));

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

% Compile the avg and stde values (order is raw, MM, Live, percent live)
outTee = {outRawTee outRawTeeStde outMMTee outMMTeeStde outLiveTee outLiveTeeStde outPercentTee outPercentTeeStde};
outBP = {outRawBP outRawBPStde outMMBP outMMBPStde outLiveBP outLiveBPStde outPercentBP outPercentBPStde};
outCannon = {outRawCannon outRawCannonStde outMMCannon outMMCannonStde outLiveCannon outLiveCannonStde outPercentCannon outPercentCannonStde};
outLive = {outRawLive outRawLiveStde outMMLive outMMLiveStde outPercentLive outPercentLiveStde};

% Get the first value where the name (first column) is open
writeScore = 0;
if writeScore == 1
    write_Scores_xlsx(outScores,signalName)
end 

% Write the signal data
writeSignal = 1;
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

