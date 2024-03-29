function plot_max_metric_angVel(teeData, bpData, cannonData, liveData, metric, names)
% Input: teeData, bpData, cannonData, liveData; tables, with all data, n tables for each category

pitchModes = {'Tee';'BP';'RPM';'Live'};

% Compare the metric name to the names and get the graphing name out
nameIndex = find(metric == names);
graphName = names(nameIndex,2);

% Figure out which table to get the data from and extract table that metric
% is in
if contains(metric, 'Bat') == 1 % It's a max bat metric, use BatBallData
    maxTee = teeData.BatBallData;
    maxBP = bpData.BatBallData;
    maxCannon = cannonData.BatBallData;
    maxLive = liveData.BatBallData;
else % It's not a max bat metric, use MaxData
    maxTee = teeData.MaxData;
    maxBP = bpData.MaxData;
    maxCannon = cannonData.MaxData;
    maxLive = liveData.MaxData;
end

% Once data has been extracted, get the individual metric
maxTeeMetric = maxTee.(metric);
maxBPMetric = maxBP.(metric);
maxCannonMetric = maxCannon.(metric);
maxLiveMetric = maxLive.(metric);

% Find mean and standard error for each
avgTee = mean(maxTeeMetric);
avgBP = mean(maxBPMetric);
avgCannon = mean(maxCannonMetric);
avgLive = mean(maxLiveMetric);
stdeTee = std(maxTeeMetric) ./ sqrt(length(maxTeeMetric));
stdeBP = std(maxBPMetric) ./ sqrt(length(maxBPMetric));
stdeCannon = std(maxCannonMetric) ./ sqrt(length(maxCannonMetric));
stdeLive = std(maxLiveMetric) ./ sqrt(length(maxLiveMetric));

% Compile the vectors together for graphing
avgMat = [avgTee', avgBP', avgCannon', avgLive'];
stdeMat = [stdeTee', stdeBP', stdeCannon', stdeLive'];

fig = gcf;
% plot the graph
xCat = categorical(pitchModes);
xCat = reordercats(xCat,pitchModes);

fs = figure(fig.Number+1);
%b = bar(avgMat, 'grouped');
hold on
% Setup for plotting error bars
%[nGroups, nBars] = size(avgMat);
% Plot the error bars
%x = nan(nBars,nGroups);
% for i = 1:nGroups
%     x(:,i) = b(i).XEndPoints;
% end
x = 1:length(pitchModes);
%errorbar(x, avgMat, stdeMat, 'k','linestyle','none')
errorbar(x, avgMat, stdeMat, 'ko','MarkerFaceColor','k')
hold off
% title(strcat(metric,' for each pitch mode'))
xlim([0 5])
set(gca,'xtickLabel',pitchModes)
xticks(1:4)
ylabel(strcat(graphName, " (deg/s)"))
%legend(pitchModes, 'Location', 'bestoutside');
print(fs, strcat(metric,'Max.png'),'-dpng','-r300');

% Save the figure
f = gcf;
%f.WindowState = 'maximized';
path = "Z:\SSL\Research\Graduate Students\Thompson, Devin\Thesis Docs\Pitch Modality (RIP)\Thesis\Pics and Videos\Results Figs\Max Metrics\";
fileName = strcat(metric,"_Max");
savefig(f, strcat(path, fileName));
saveas(f, strcat(path, fileName), 'png');
end

