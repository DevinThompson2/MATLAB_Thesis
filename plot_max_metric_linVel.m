function plot_max_metric_linVel(teeData, bpData, cannonData, liveData, metric)
% Input: teeData, bpData, cannonData, liveData; tables, with all data, n tables for each category

pitchModes = {'Tee';'BP';'Cannon';'Live'};

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

% Convert lin vel's to mph
maxTeeMPH = maxTeeMetric * 2.23694; % mph
maxBPMPH = maxBPMetric * 2.23694; % mph
maxCannonMPH = maxCannonMetric * 2.23694; % mph
maxLiveMPH = maxLiveMetric * 2.23694; % mph

% Find mean and standard error for each
avgTee = mean(maxTeeMPH);
avgBP = mean(maxBPMPH);
avgCannon = mean(maxCannonMPH);
avgLive = mean(maxLiveMPH);
stdeTee = std(maxTeeMPH) ./ sqrt(length(maxTeeMPH));
stdeBP = std(maxBPMPH) ./ sqrt(length(maxBPMPH));
stdeCannon = std(maxCannonMPH) ./ sqrt(length(maxCannonMPH));
stdeLive = std(maxLiveMPH) ./ sqrt(length(maxLiveMPH));

% Compile the vectors together for graphing
avgMat = [avgTee', avgBP', avgCannon', avgLive'];
stdeMat = [stdeTee', stdeBP', stdeCannon', stdeLive'];

fig = gcf;
% plot the graph
xCat = categorical(pitchModes);
xCat = reordercats(xCat,pitchModes);

fs = figure(fig.Number+1)
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
title(strcat(metric,' for each pitch mode'))
xlim([0 5])
set(gca,'xtickLabel',pitchModes)
xticks(1:4)
ylabel(strcat(metric, ' (mph)'))
%legend(pitchModes, 'Location', 'bestoutside');
print(fs, strcat(metric,'Max.png'),'-dpng','-r300');
end

