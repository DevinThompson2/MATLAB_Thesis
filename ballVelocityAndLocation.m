% Devin Thompson
% PitchLocationAndVelocity
% Date: 11/21/19
% This script uses ball trajectory information to compute the ball's
% velocity and location (x,z) when it crosses the plate (y = 0)

%% Clear and close all. Establish Nexus and MATLAB connection

clear 
close all
clc

vicon = ViconNexus();

% %Commands for displaying the Nexus Command List and Help with each command
% vicon.DisplayCommandList;
%vicon.DisplayCommandHelp('OpenTrial')

%% Load and Filter Data
% Establish constants
dt = 1/vicon.GetFrameRate;
fig = gcf
set(fig, 'Visible','off')

% %Open the correct trial in Nexus
[trial.pathName, trial.trialName] = vicon.GetTrialName;

% %Get the subject name from the current trial
[trial.subjectName] = vicon.GetSubjectNames();

% Get marker names from the trial
markerNames = vicon.GetMarkerNames(trial.subjectName{1});
position = load_MarkerPos_v2(trial.subjectName, markerNames);

% Filter the marker position data
position = filter_MarkerPosition_v2(position, trial.subjectName{1});

%% Calculate Ball Velocity

% Differentiate the raw and filtered ball data to get the ball's velocity
velocity.raw.Ball1 = centralDiff_v2(dt, position.raw.Ball1);
velocity.filt.Ball1 = centralDiff_v2(dt, position.filt.Ball1);

% Calculate the magnitude of the balls velocity
magVel.Ball1.mm = calculate_magnitude(velocity.filt.Ball1);
magVel.Ball1.mph = magVel.Ball1.mm .* 0.00223694; % Convert to mph

% Get the average velocity, in mph
magVel.Ball1.avgMPH = mean(magVel.Ball1.mph);

%% Calculate the Balls (x,z) position as it crosses the plate
% Use filtered position data
% Take the abs of position data
normPosition.Ball1 = abs(position.filt.Ball1);
% Get the index where it crosses the plate
[plateValue, plateIndex] = min(normPosition.Ball1(:,2));
% Get the x,z position data at that index
plateCross.mm = position.filt.Ball1(plateIndex,1:2:3);
plateCross.in = plateCross.mm .* 0.0393701; % Convert to mph

%% Write the Data to Excel

outputs = [magVel.Ball1.avgMPH plateCross.in];

% Define output file and location
 outputLoc = 'Z:\SSL\Research\Graduate Students\Thompson, Devin\Vicon\Reports\Pitch Location\';
 outputFile = strcat(char(trial.subjectName),'.xlsx');
 outputPath = sprintf('%s%s',outputLoc,outputFile);

% Load existing output file to determine the next open row
 [num,txt,raw] = xlsread(outputPath,'C1:C8000');
 writeRow = length(num)+3
 writeRange = sprintf('%s%i%s%i','A',writeRow,':C',writeRow);

% Write the data for the current batter into that row
 xlswrite(outputPath,outputs,writeRange)

%% Plots

% % Plot the balls velocity
% figure(get(gcf,'Number')+1)
% plot(magVel.Ball1.mph)
% title("Filtered Bat Velocity")
% xlabel("Frame")
% ylabel("Velocity (mph)")

% Plot the raw and filtered position data
plotPosFigs = 0;
if plotPosFigs == 1
   figure(get(gcf,'Number')+1)
   hold on
   plot(position.raw.Ball1(:,1))
   plot(position.filt.Ball1(:,1))
   title("Filtered/Raw X-Position Data")
   xlabel("Frame")
   ylabel("Position(mm)")
   legend('Raw','Filtered')
   
   figure(get(gcf,'Number')+1)
   hold on
   plot(position.raw.Ball1(:,2))
   plot(position.filt.Ball1(:,2))
   title("Filtered/Raw Y-Position Data")
   xlabel("Frame")
   ylabel("Position(mm)")
   legend('Raw','Filtered')
   
   figure(get(gcf,'Number')+1)
   hold on
   plot(position.raw.Ball1(:,3))
   plot(position.filt.Ball1(:,3))
   title("Filtered/Raw Z-Position Data")
   xlabel("Frame")
   ylabel("Position(mm)")
   legend('Raw','Filtered')
   
end

% Plot the raw and filtered position data
plotVelFigs = 0;
if plotVelFigs == 1
   figure(get(gcf,'Number')+1)
   hold on
   plot(velocity.raw.Ball1(:,1))
   plot(velocity.filt.Ball1(:,1))
   title("Filtered/Raw X-Velocity Data")
   xlabel("Frame")
   ylabel("Velocity (mm/s)")
   legend('Raw','Filtered')
   
   figure(get(gcf,'Number')+1)
   hold on
   plot(velocity.raw.Ball1(:,2))
   plot(velocity.filt.Ball1(:,2))
   title("Filtered/Raw Y-Velocity Data")
   xlabel("Frame")
   ylabel("Velocity (mm/s)")
   legend('Raw','Filtered')
   
   figure(get(gcf,'Number')+1)
   hold on
   plot(velocity.raw.Ball1(:,3))
   plot(velocity.filt.Ball1(:,3))
   title("Filtered/Raw Z-Velocity Data")
   xlabel("Frame")
   ylabel("Velcoity (mm/s)")
   legend('Raw','Filtered')
   
end




