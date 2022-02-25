% Devin Thompson
% plotPitchLocation
% Date: 11/22/19
% This script uses the results in the excel sheet to plot the pitch
% distribution with a strike zone

clear 
close all
clc

%% Load data from excel
% Define the subject names
% 1 = Kevin
% 2 = Cannon
name1 = 'Kevin';
name2 = 'Cannon';

% Define file and location
 Loc = 'Z:\SSL\Research\Graduate Students\Thompson, Devin\Vicon\Reports\Pitch Location\';
 File1 = strcat(name1,'.xlsx');
 File2 = strcat(name2,'.xlsx');
 Path1 = sprintf('%s%s',Loc,File1);
 Path2 = sprintf('%s%s',Loc,File2);

% Load existing output file to determine the next open row
 [num1,txt1,raw1] = xlsread(Path1,'A1:G8000');
 [num2,txt2,raw2] = xlsread(Path2,'A1:G8000');
 
 % Create a box for the strike zone
 width = 17; % in
 x = 40;
 y = 60;
 knee = 19.5;
 chest = 42.5;
 % Calculate zone width lines
 zoneWidth = -width/2:.1:width/2;
 kneeWidth = knee*ones(length(zoneWidth),1);
 chestWidth = chest*ones(length(zoneWidth),1);
 % Calculate zone height lines
 zoneHeight = knee:.01:chest;
 leftHeight = -(width./2)*ones(length(zoneHeight),1);
 rightHeight = (width./2)*ones(length(zoneHeight),1);
 
 %% Calculate standard error of x and y
 % As standard error
%  xError1 = num1(end,2)./sqrt(length(num1(1:end-2,2)));
%  yError1 = num1(end,3)./sqrt(length(num1(1:end-2,3)));
 % As one standard deviation
 xError1 = num1(end,2);
 yError1 = num1(end,3);
 
 xError2 = num2(end,2);
 yError2 = num2(end,3);
 
 %% Plotting stuff
 % Plot the pitches across the plate
figure(1)
hold on
grid on
axis([-x x 0 y])
% Plot strike zone data
plot(zoneWidth, kneeWidth, 'k')
plot(zoneWidth, chestWidth, 'k')
plot(leftHeight, zoneHeight, 'k')
plot(rightHeight, zoneHeight, 'k')
% Plot Kevin's data
k = scatter(num1(1:end-2,2), num1(1:end-2,3), 'ro', 'MarkerFaceColor','r', 'MarkerFaceAlpha', 0.2, 'MarkerEdgeAlpha', 0.2)
scatter(num1(end-1,2), num1(end-1,3),'ro','MarkerFaceColor','r')
errorbar(num1(end-1,2), num1(end-1,3), xError1, 'r')
errorbar(num1(end-1,2), num1(end-1,3), yError1, 'r', 'horizontal')
% Plot the Cannon's data
c = scatter(num2(1:end-2,2), num2(1:end-2,3), 'bo', 'MarkerFaceColor','b', 'MarkerFaceAlpha', 0.2, 'MarkerEdgeAlpha', 0.2)
scatter(num2(end-1,2), num2(end-1,3),'bo','MarkerFaceColor','b')
errorbar(num2(end-1,2), num2(end-1,3), xError2, 'b')
errorbar(num2(end-1,2), num2(end-1,3), yError2, 'b', 'horizontal')

legend([k c],'Kevin','Cannon')
title('Kevins Pitch Location')
ylabel('Height (in)')
xlabel('Width (Zero is Center of Plate (in)')

figure(2)
plot(num1(1:end-2,4),'o')
title('Distance From Mean')
xlabel('Trial Number')
ylabel('Distance (in)')





