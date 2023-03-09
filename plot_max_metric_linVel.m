function plot_max_metric_linVel(teeData, bpData, cannonData, liveData, metric, names)
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

% Convert lin vel's to mph
maxTeeMPH = maxTeeMetric * 2.23694; % mph
maxBPMPH = maxBPMetric * 2.23694; % mph
maxCannonMPH = maxCannonMetric * 2.23694; % mph
maxLiveMPH = maxLiveMetric * 2.23694; % mph

% Perform statistical test
% Create tables needed for fitrm function
resultsVec = [maxTeeMPH; maxBPMPH; maxCannonMPH; maxLiveMPH];
results = [maxTeeMPH maxBPMPH maxCannonMPH maxLiveMPH];
t = array2table(results, 'VariableNames',{'Tee', 'BP','RPM','Live'});
within = table(["Tee" "BP" "RPM" "Live"]','VariableNames',{'PitchCondition'});
within.PitchCondition = categorical(within.PitchCondition);

% Test normality of residuals
f = gcf;
figure(f.Number+1)
normplot(resultsVec)
%[hAD,pAD] = adtest(resultsVec)
%[hL, pL] = lillietest(resultsVec)
[hSW, pSW, wSW] = swtest(resultsVec, 0.05)
% using SW test, h = 1, p<0.05, reject null hypothesis, so there is
% evidence that the data is not normally distributed. Need to use different
% variance and ANOVA tests (kruskal-wallis)

% Test homogeneity of variance
% Since not normally distributed, need to do another test for variance
% using correction factor - Use Brown-Forsythe
[pV, statsBF] = vartestn(results,'TestType','BrownForsythe')
% Do not reject null hypothesis that variances are equal

%%%%%%%%%%%%%%%%% Overall: Not normally distrubuted, Variances are equal

% Perform the ANOVA test
rm = fitrm(t, 'Tee-Live ~ 1', 'WithinDesign', within);
ranovatb1 = ranova(rm, 'WithinModel','PitchCondition')
disp(anovaTable(ranovatb1, 'Max Bat Sweet Spot Velocity (mph)'));
% Need to use Friedman test
[pF, FriedmanTable] = friedman(results,1)
% Perform Mauchly test for sphericity
mTestTable = mauchly(rm)

% Perform MC tests
mcTable = multcompare(rm,'PitchCondition')

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
%errorbar(x, avgMat, stdeMat, 'ko','MarkerFaceColor','k','LineWidth', 2, 'MarkerSize', 8)
hold off
% title(strcat(metric,' for each pitch mode'))
xlim([0 5])
set(gca,'xtickLabel',pitchModes,'FontWeight','bold')
xticks(1:4)
ylabel(strcat(graphName, " (mph)"),'FontWeight','bold')
%legend(pitchModes, 'Location', 'bestoutside');
%print(fs, strcat(metric,'Max.png'),'-dpng','-r300');

% Save the figure
f = gcf;
%f.WindowState = 'maximized';
path = "Z:\SSL\Research\Graduate Students\Thompson, Devin\Thesis Docs\Pitch Modality (RIP)\Thesis\Pics and Videos\Results Figs\Max Metrics\";
fileName = strcat(metric,"_Max");
savefig(f, strcat(path, fileName));
saveas(f, strcat(path, fileName), 'png');

end

