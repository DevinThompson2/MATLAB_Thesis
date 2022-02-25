function test_Plot(tee, bp, cannon, live, tableNames, metricNames)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% Add Fun_ to all variable names
for i = 1:length(metricNames)
    for j = 2:length(metricNames{i})
        if j == 2
           funMetricNames{i,1}{j-1,1} = metricNames{i,1}{j-1,1}; 
        end
        funMetricNames{i,1}{j,1} = strcat('Fun_',metricNames{i}{j});
    end
end


% Plot exitVelocity as a test

% exitVelocity is in BatBallData {1}
teeVec = tee.BatBallData.Fun_exitVel;
bpVec = bp.BatBallData.Fun_exitVel;
cannonVec = cannon.BatBallData.Fun_exitVel;
liveVec = live.BatBallData.Fun_exitVel;

statsMat = [teeVec bpVec cannonVec liveVec]

% First, average all of the variables
avg = mean(statsMat)
stde = std(statsMat) ./ sqrt(length(statsMat))

% plot
xPlot = categorical(["Tee", "BP", "Cannon", "Live"]);
figure(1)
boxplot(statsMat, xPlot)
figure(2)
errorbar(avg,stde,'o')
figure(3)
bar(xPlot,avg)
end

