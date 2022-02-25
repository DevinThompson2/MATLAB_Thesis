function plot_Contact_Rates(average, stde)
% Plot the contact rates

pitchModes = {'Tee';'BP';'Cannon';'Live'};
x = 1:length(pitchModes);

f = gcf;
figure(f.Number+1)
hold on
errorbar(x(1), average(1), stde(1), 'ko','MarkerFaceColor','k')
errorbar(x(2), average(2), stde(2), 'ko','MarkerFaceColor','k')
errorbar(x(3), average(3), stde(3), 'ko','MarkerFaceColor','k')
errorbar(x(4), average(4), stde(4), 'ko','MarkerFaceColor','k')
hold off
title("Quality Contact Rate For Each Pitch Method")
xlim([0 5])
ylim([0 1])
set(gca,'xtickLabel',pitchModes)
xticks(1:4)
ylabel("Contact Rate (Fraction of Total)")

%legend(pitchModes, 'Location', 'bestoutside');


end

