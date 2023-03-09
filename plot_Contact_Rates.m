function plot_Contact_Rates(average, stde)
% Plot the contact rates
set(groot,'defaultAxesFontSize',14)
pitchModes = {'Tee';'BP';'RPM';'Live'};
x = 1:length(pitchModes);

f = gcf;
figure(f.Number+1)
hold on
errorbar(x(1), average(1), stde(1), 'ro','MarkerFaceColor','r','LineWidth', 2, 'MarkerSize', 8,'CapSize', 10)
errorbar(x(2), average(2), stde(2), 'go','MarkerFaceColor','g','LineWidth', 2, 'MarkerSize', 8,'CapSize', 10)
errorbar(x(3), average(3), stde(3), 'bo','MarkerFaceColor','b','LineWidth', 2, 'MarkerSize', 8,'CapSize', 10)
errorbar(x(4), average(4), stde(4), 'ko','MarkerFaceColor','k','LineWidth', 2, 'MarkerSize', 8,'CapSize', 10)
hold off
%title("Quality Contact Rate For Each Pitch Method","FontSize", 16)
xlim([0 5])
ylim([0 1])
set(gca,'xtickLabel',pitchModes, 'FontWeight', 'bold', "FontSize", 20)
xticks(1:4)
ylabel("Line Drive Rate (Fraction)", "FontSize", 20, 'FontWeight', 'bold')

%legend(pitchModes, 'Location', 'bestoutside');
% Save the figure
f = gcf;
%f.WindowState = 'maximized';
path = "Z:\SSL\Research\Graduate Students\Thompson, Devin\Thesis Docs\Pitch Modality (RIP)\Thesis\Pics and Videos\Results Figs\Contact Rates\";
fileName = "ContactRates";
savefig(f, strcat(path, fileName));
saveas(f, strcat(path, fileName), 'png');

end

