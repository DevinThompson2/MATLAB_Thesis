function plot_Pitch_Location_OnlyRPM(cannon, subject, color)
set(groot,'defaultAxesFontSize',20)

%% All Data

% Plot the lines representing the strike zone, using fixed values of 1.5ft,
% 3.5ft, respectively
upper = 12 * 3.5; % in
lower = 12 * 1.5; % in
right = 8.5; % inlive
left =  -8.5; % in
x = left;
y = lower;
w = right * 2;
h = upper - lower;
hold on
% Plot the strike zone
rectangle('Position',[x y w h])

% Plot all the data
scatter(cannon(:,1), cannon(:,2), 'o', 'MarkerFaceColor', color, 'MarkerEdgeColor', color, 'MarkerFaceAlpha', 0.1, 'MarkerEdgeAlpha', 0.25)

% Plot the mean values
scatter(mean(cannon(:,1)), mean(cannon(:,2)), 'o', 'MarkerFaceColor', color, 'MarkerEdgeColor', color, 'MarkerFaceAlpha', 1, 'MarkerEdgeAlpha', 1);

% Plot the error bars
errorbar(mean(cannon(:,1)), mean(cannon(:,2)), std(cannon(:,2)), std(cannon(:,2)), std(cannon(:,1)), std(cannon(:,1)), 'Color', color)

legend(["","Subject 1", "", "","Subject 2", "", "","Subject 3", "", "","Subject 4", "", "","Subject 5", "", "","Subject 6", ""], 'FontSize', 10)
%legend(["Tee","BP","RPM","Live"], 'FontSize', 14)
grid on
axis([-36 36 0 60])
xlabel("Horizontal Pitch Location (in)",'FontWeight','bold')
ylabel("Vertical Pitch Location (in)",'FontWeight','bold')
%title(strcat("Pitch Location For Each Method, ", subject, " (2ft in front of plate)"))


end