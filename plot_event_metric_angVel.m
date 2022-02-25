function plot_event_metric_angVel(teeData, bpData, cannonData, liveData, metric)
% Input: teeData, bpData, cannonData, liveData; tables, with all data, n tables for each category

% This function plots any variable that is included in the stance, load,
% foot-down, or impact event tables

eventNames = {'Stance';'Load';'FirstMove';'FootDown';'Impact';'FollowThrough'};
pitchModes = {'Tee';'BP';'Cannon';'Live'};

% Create new variables that only have the event tables in them
% Tee
[tee, bp, cannon, live] = create_plotting_tables(eventNames, teeData, bpData, cannonData, liveData);

% Extract the metric at each event, for each method
for i = 1:length(fieldnames(tee))
    teeMat(:,i) = tee.(eventNames{i}).(metric);
end

for i = 1:length(fieldnames(tee))
    bpMat(:,i) = bp.(eventNames{i}).(metric);
end

for i = 1:length(fieldnames(tee))
    cannonMat(:,i) = cannon.(eventNames{i}).(metric);
end

for i = 1:length(fieldnames(tee))
    liveMat(:,i) = live.(eventNames{i}).(metric);
end

% Take the average, ste of each matrix
avgTee = mean(teeMat);
avgBP = mean(bpMat);
avgCannon = mean(cannonMat);
avgLive = mean(liveMat);
stdeTee = std(teeMat) ./ sqrt(length(teeMat));
stdeBP = std(bpMat) ./ sqrt(length(bpMat));
stdeCannon = std(cannonMat) ./ sqrt(length(cannonMat));
stdeLive = std(liveMat) ./ sqrt(length(liveMat));

% Compile the vectors together for graphing
avgMat = [avgTee', avgBP', avgCannon', avgLive'];
stdeMat = [stdeTee', stdeBP', stdeCannon', stdeLive'];

fig = gcf;
% plot
xCat = categorical(eventNames);
xCat = reordercats(xCat,eventNames);
fs = figure(fig.Number+1);
b = bar(avgMat, 'grouped');
hold on
% Setup for plotting error bars
[nEvents, nModes] = size(avgMat);
% Plot the error bars
x = nan(nEvents,nModes);
for i = 1:nModes
    x(:,i) = b(i).XEndPoints;
end
errorbar(x, avgMat, stdeMat, 'k','linestyle','none')
hold off
title(strcat(metric,' at each event of the swing for each pitch mode'))
set(gca,'xtickLabel',eventNames)
ylabel(strcat(metric, ' (deg/s)'))
legend(pitchModes, 'Location', 'bestoutside');
print(fs, strcat(metric,'Event.png'),'-dpng','-r300');
end

