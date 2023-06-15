function plot_StrikeZone_Distance(tee, bp, cannon, live)
% Plot the disances of each method to the center of the strike zone
set(groot,'defaultAxesFontSize',20)
pitchModes = {'Tee';'BP';'RPM';'Live'};
x = 1:length(pitchModes);

f = gcf;
figure(f.Number+1)
hold on
%errorbar(x, avgMat, stdeMat, 'k','linestyle','none')
errorbar(x(1), tee(1), tee(2), 'ro','MarkerFaceColor','r','LineWidth', 2, 'MarkerSize', 8,'CapSize', 10)
errorbar(x(2), bp(1), bp(2), 'go','MarkerFaceColor','g','LineWidth', 2, 'MarkerSize', 8,'CapSize', 10)
errorbar(x(3), cannon(1), cannon(2), 'bo','MarkerFaceColor','b','LineWidth', 2, 'MarkerSize', 8,'CapSize', 10)
errorbar(x(4), live(1), live(2), 'ko','MarkerFaceColor','k','LineWidth', 2, 'MarkerSize', 8,'CapSize', 10)
hold off
%title("Pitch Distance from Center of Strike Zone")
xlim([0 5])
set(gca,'xtickLabel',pitchModes, 'FontWeight','bold')
xticks(1:4)
ylabel("Pitch Distance (in)", 'FontWeight','bold')
ylim([0 16])
%legend(pitchModes, 'Location', 'bestoutside');

% Save the figure
f = gcf;
%f.WindowState = 'maximized';
path = "Z:\SSL\Research\Graduate Students\Thompson, Devin\Thesis Docs\Pitch Modality (RIP)\Thesis\Pics and Videos\Results Figs\Pitch Location\";
fileName = "StrikeZoneDistance_Total";
savefig(f, strcat(path, fileName));
saveas(f, strcat(path, fileName), 'png');


end

