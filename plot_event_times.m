function plot_event_times(teeData, bpData, cannonData, liveData, metrics)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
set(groot, 'defaultAxesFontName', 'Arial');
set(groot,'defaultAxesFontSize',14)
pitchModes = {'Tee';'BP';'RPM';'Live'};
eventNames = {'Stance';'FootUp';'Load';'FirstMove';'FootDown';'Impact';'FollowThrough'};
graphNames = {"Stance";"Foot Up";"Load";"Hand Movement";"Foot Down";"Impact";"Follow Through"}

% Extract the desired metrics: stance, load, foot-down, impact
for i = 1:length(metrics)
    tee(:,i) = teeData.TimeMaxData.(metrics{i});
    bp(:,i) = bpData.TimeMaxData.(metrics{i});
    cannon(:,i) = cannonData.TimeMaxData.(metrics{i});
    live(:,i) = liveData.TimeMaxData.(metrics{i});
end

teeNorm = tee - tee(:,end-1);
bpNorm = bp - bp(:,end-1);
cannonNorm = cannon - cannon(:,end-1);
liveNorm = live - live(:,end-1);


% Average, standard error each event
avgTee = mean(teeNorm);
avgBP = mean(bpNorm);
avgCannon = mean(cannonNorm);
avgLive = mean(liveNorm);
stdeTee = std(teeNorm) ./ sqrt(length(teeNorm));
stdeBP = std(bpNorm) ./ sqrt(length(bpNorm));
stdeCannon = std(cannonNorm) ./ sqrt(length(cannonNorm));
stdeLive = std(liveNorm) ./ sqrt(length(liveNorm));

% Compile the vectors together for graphing
avgMat = [avgTee', avgBP', avgCannon', avgLive'];
stdeMat = [stdeTee', stdeBP', stdeCannon', stdeLive'];

% Path to save file to
path = "Z:\SSL\Research\Graduate Students\Thompson, Devin\Thesis Docs\Pitch Modality (RIP)\Thesis\Pics and Videos\Results Figs\Events\";

for i = 1:length(eventNames)
    fig = gcf;
    % plot the graph
    xCat = categorical(eventNames);
    xCat = reordercats(xCat,eventNames);

    fs = figure(fig.Number+1);
    % b = bar(avgMat, 'grouped');
    hold on
    % Setup for plotting error bars
    % [nGroups, nBars] = size(avgMat);
    % % Plot the error bars
    % x = nan(nBars,nGroups);
    % for i = 1:nGroups
    %     x(:,i) = b(i).XEndPoints;
    % end
    x = 1:length(pitchModes);
    % errorbar(x, avgMat(i,:), stdeMat(i,:), 'k','linestyle','none') % adjust to (:,i) to graph each event
    % errorbar(x, avgMat(i,:), stdeMat(i,:), 'ko','MarkerFaceColor','k')
    colors = ["r" "g" "b" "k"];
    for j = 1:length(x)
        errorbar(x(j), avgMat(i,j), stdeMat(i,j), 'o','MarkerFaceColor',colors(j), 'MarkerEdgeColor',colors(j), 'Color', colors(j),'LineWidth', 2, 'MarkerSize', 8,'CapSize', 10)
    end
    hold off
    %title(strcat(metrics{i},' times for each pitch mode'))
    xlim([0 5])
    set(gca,'xtickLabel',pitchModes,'FontSize', 20, 'FontWeight','bold')
    xticks(1:4)
    ylabel(strcat(graphNames{i}, " Times (s)"),'FontSize', 20, 'FontWeight','bold')
    %legend(pitchModes, 'Location', 'bestoutside');
    saveas(fs, strcat(path,metrics{i},"Times.png"));
    savefig(fs, strcat(path,metrics{i},"Times"))
end

end

