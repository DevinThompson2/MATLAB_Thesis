function plot_Pitch_Location_Subject(tee, bp, cannon, live, subject)
% Plot pitch location for a certain subject
set(groot,'defaultAxesFontSize',12)

%% All Data
% Create the figure
f= gcf;
figure(f.Number+1)
% Plot the lines representing the strike zone, using fixed values of 1.5ft,
% 3.5ft, respectively
upper = 12 * 3.5; % in
lower = 12 * 1.5; % in
right = 8.5; % in
left =  -8.5; % in
x = left;
y = lower;
w = right * 2;
h = upper - lower;
hold on
% Plot the strike zone
rectangle('Position',[x y w h])
% Plot all the data
scatter(tee(:,1), tee(:,2), 'ro', 'MarkerFaceColor', 'r', 'MarkerFaceAlpha', 0.1, 'MarkerEdgeAlpha', 0.25)
scatter(bp(:,1), bp(:,2), 'go', 'MarkerFaceColor', 'g', 'MarkerFaceAlpha', 0.1, 'MarkerEdgeAlpha', 0.25)
scatter(cannon(:,1), cannon(:,2), 'bo', 'MarkerFaceColor', 'b', 'MarkerFaceAlpha', 0.1, 'MarkerEdgeAlpha', 0.25)
scatter(live(:,1), live(:,2), 'ko', 'MarkerFaceColor', 'k', 'MarkerFaceAlpha', 0.1, 'MarkerEdgeAlpha', 0.25)
% Plot the mean values
scatter(mean(tee(:,1)), mean(tee(:,2)), 'ro', 'MarkerFaceColor', 'r', 'MarkerFaceAlpha', 1, 'MarkerEdgeAlpha', 1)
scatter(mean(bp(:,1)), mean(bp(:,2)), 'go', 'MarkerFaceColor', 'g', 'MarkerFaceAlpha', 1, 'MarkerEdgeAlpha', 1)
scatter(mean(cannon(:,1)), mean(cannon(:,2)), 'bo', 'MarkerFaceColor', 'b', 'MarkerFaceAlpha', 1, 'MarkerEdgeAlpha', 1)
scatter(mean(live(:,1)), mean(live(:,2)), 'ko', 'MarkerFaceColor', 'k', 'MarkerFaceAlpha', 1, 'MarkerEdgeAlpha', 1)
legend("Tee","BP","RPM","Live", "Avg Tee","Avg BP","Avg RPM", "Avg Live")
grid on
axis([-36 36 0 60])
xlabel("Horizontal Pitch Location (in)")
ylabel("Vertical Pitch Location (in)")
%title(strcat("Pitch Location For Each Method, ", subject, " (2ft in front of plate)"))

% Save the figure
f = gcf;
%f.WindowState = 'maximized';
path = "Z:\SSL\Research\Graduate Students\Thompson, Devin\Thesis Docs\Pitch Modality (RIP)\Thesis\Pics and Videos\Results Figs\Pitch Location\";
fileName = strcat("PitchLocation_", subject);
savefig(f, strcat(path, fileName));
saveas(f, strcat(path, fileName), 'png');

%% Error bars
% Create the figure
f= gcf;
figure(f.Number+1)
% Plot the lines representing the strike zone, using fixed values of 1.5ft,
% 3.5ft, respectively
upper = 12 * 3.5; % in
lower = 12 * 1.5; % in
right = 8.5; % in
left =  -8.5; % in
x = left;
y = lower;
w = right * 2;
h = upper - lower;
hold on
% Plot the strike zone
rectangle('Position',[x y w h])
% Plot the mean values
scatter(mean(tee(:,1)), mean(tee(:,2)), 'ro', 'MarkerFaceColor', 'r', 'MarkerFaceAlpha', 1, 'MarkerEdgeAlpha', 1)
scatter(mean(bp(:,1)), mean(bp(:,2)), 'go', 'MarkerFaceColor', 'g', 'MarkerFaceAlpha', 1, 'MarkerEdgeAlpha', 1)
scatter(mean(cannon(:,1)), mean(cannon(:,2)), 'bo', 'MarkerFaceColor', 'b', 'MarkerFaceAlpha', 1, 'MarkerEdgeAlpha', 1)
scatter(mean(live(:,1)), mean(live(:,2)), 'ko', 'MarkerFaceColor', 'k', 'MarkerFaceAlpha', 1, 'MarkerEdgeAlpha', 1)
% Plot the error bars
errorbar(mean(tee(:,1)), mean(tee(:,2)), std(tee(:,2)), std(tee(:,2)), std(tee(:,1)), std(tee(:,1)), 'r')
errorbar(mean(bp(:,1)), mean(bp(:,2)), std(bp(:,2)), std(bp(:,2)), std(bp(:,1)), std(bp(:,1)), 'g')
errorbar(mean(cannon(:,1)), mean(cannon(:,2)), std(cannon(:,2)), std(cannon(:,2)), std(cannon(:,1)), std(cannon(:,1)), 'b')
errorbar(mean(live(:,1)), mean(live(:,2)), std(live(:,2)), std(live(:,2)), std(live(:,1)), std(live(:,1)), 'k')
legend("Tee","BP","RPM","Live")
grid on
axis([-36 36 0 60])
xlabel("Horizontal Pitch Location (in)")
ylabel("Vertical Pitch Location (in)")
%title(strcat("Pitch Location For Each Method, ", subject, " (2ft in front of plate)"))

% Save the figure
f = gcf;
%f.WindowState = 'maximized';
path = "Z:\SSL\Research\Graduate Students\Thompson, Devin\Thesis Docs\Pitch Modality (RIP)\Thesis\Pics and Videos\Results Figs\Pitch Location\";
fileName = strcat("PitchLocation_", subject,"_ErrorBars");
savefig(f, strcat(path, fileName));
saveas(f, strcat(path, fileName), 'png');
end

