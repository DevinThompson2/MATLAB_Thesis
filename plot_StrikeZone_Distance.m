function plot_StrikeZone_Distance(tee, bp, cannon, live)
% Plot the disances of each method to the center of the strike zone
pitchModes = {'Tee';'BP';'Cannon';'Live'};
x = 1:length(pitchModes);

f = gcf;
figure(f.Number+1)
hold on
%errorbar(x, avgMat, stdeMat, 'k','linestyle','none')
errorbar(x(1), tee(1), tee(2), 'ko','MarkerFaceColor','k')
errorbar(x(2), bp(1), bp(2), 'ko','MarkerFaceColor','k')
errorbar(x(3), cannon(1), cannon(2), 'ko','MarkerFaceColor','k')
errorbar(x(4), live(1), live(2), 'ko','MarkerFaceColor','k')
hold off
title("Pitch Distance from Center of Strike Zone")
xlim([0 5])
set(gca,'xtickLabel',pitchModes)
xticks(1:4)
ylabel("Pitch Distance (in)")
ylim([0 16])
%legend(pitchModes, 'Location', 'bestoutside');

end

