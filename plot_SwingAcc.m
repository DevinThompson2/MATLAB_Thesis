function [avgMat, stdeMat] = plot_SwingAcc(teeData, bpData, cannonData, liveData, metric, names)
% Input: teeData, bpData, cannonData, liveData; tables, with all data, n tables for each category

pitchModes = {'Tee';'BP';'RPM';'Live'};

% Compare the metric name to the names and get the graphing name out
nameIndex = find(metric == names);
graphName = names(nameIndex,2);

% max in names doesn't mean anything, adapted from other plotting function
% Impact location is in BatBallData table
maxTee = teeData.BatBallData;
maxBP = bpData.BatBallData;
maxCannon = cannonData.BatBallData;
maxLive = liveData.BatBallData;

% Once data has been extracted, get the individual metric
maxTeeMetric = maxTee.(metric);
maxBPMetric = maxBP.(metric);
maxCannonMetric = maxCannon.(metric);
maxLiveMetric = maxLive.(metric);

% Find mean and standard error for each
avgTee = mean(maxTeeMetric, 'omitnan');
avgBP = mean(maxBPMetric, 'omitnan');
avgCannon = mean(maxCannonMetric, 'omitnan');
avgLive = mean(maxLiveMetric, 'omitnan');
stdeTee = std(maxTeeMetric, 'omitnan') ./ sqrt(length(maxTeeMetric));
stdeBP = std(maxBPMetric, 'omitnan') ./ sqrt(length(maxBPMetric));
stdeCannon = std(maxCannonMetric, 'omitnan') ./ sqrt(length(maxCannonMetric));
stdeLive = std(maxLiveMetric, 'omitnan') ./ sqrt(length(maxLiveMetric));

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
colors = ["r" "g" "b" "k"];
for i = 1:length(x)
    errorbar(x(i), avgMat(i), stdeMat(i), 'o','MarkerFaceColor',colors(i), 'MarkerEdgeColor',colors(i), 'Color', colors(i),'LineWidth', 2, 'MarkerSize', 8,'CapSize', 10)
end
hold off
%title(strcat(metric,' for each pitch mode'))
xlim([0 5])
set(gca,'xtickLabel',pitchModes, 'FontWeight','bold')
xticks(1:4)
ylabel(strcat(graphName, " (m/s^2)"), 'FontWeight','bold')
%legend(pitchModes, 'Location', 'bestoutside');
%print(fs, strcat(metric,'Max.png'),'-dpng','-r300');

% Save the figure
f = gcf;
%f.WindowState = 'maximized';
path = "Z:\SSL\Research\Graduate Students\Thompson, Devin\Thesis Docs\Pitch Modality (RIP)\Thesis\Pics and Videos\Results Figs\Max Metrics\";
fileName = strcat(metric,"FootUp");
savefig(f, strcat(path, fileName));
saveas(f, strcat(path, fileName), 'png');
end