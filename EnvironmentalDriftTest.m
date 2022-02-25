% Devin Thompson
% 3/7/2020

% Script to determine how much the bat length changed over time due to
% environmental factors in the cameras

%% Clear and close all. Establish Nexus and MATLAB connection

clear 
close all
clc

vicon = ViconNexus();

% % for Commands for displaying the Nexus Command List and Help with each command
% vicon.DisplayCommandList;
% vicon.DisplayCommandHelp('OpenTrial')

%% Load All Trial Info Needed
[trial.pathName, trial.trialName] = vicon.GetTrialName; % %Open the correct trial in Nexus
[startROI,endROI] = vicon.GetTrialRegionOfInterest; % Get Trial Region of Interest (in case the trial was cropped in Nexus)
trial.subjectName = vicon.GetSubjectNames(); % Get the subject name from the current trial
trial.markerNames = vicon.GetMarkerNames(trial.subjectName{1}); % Get marker names of the trial
trial.modelOutNames = vicon.GetModelOutputNames(trial.subjectName{1});
trial.frameCount = vicon.GetFrameCount; % Number of frames in the trial
trial.fs = vicon.GetFrameRate; % sampling frequency [frame/s]
dt = 1/trial.fs; % Discrete time-step [s]
trial.fc = 30; % cut-off frequency for marker position data filtering [Hz]
trial.fcBall = 60; % cut-off frequency for ball position data filtering [Hz]

%% Load and Filter Marker Data
% Get the raw marker position data
mrkr.pos = load_MarkerPos_v2(trial.subjectName, trial.markerNames);

% Calculate the length of the bat for each frame
batLength = mrkr.pos.raw.Bat1-mrkr.pos.raw.Bat2;
magBatLength = calculate_magnitude(batLength(:,1:3));

% Calculate the mean and std of the bat length
avgBatLength = mean(magBatLength);
stdBatLength = std(magBatLength);

%% Write the results to an Excel file
outputs = {trial.trialName avgBatLength stdBatLength};

% Define output file and location
 outputLoc = 'Z:\SSL\Research\Graduate Students\Thompson, Devin\Vicon\Reports\Camera Testing\';
 outputFile = 'BatLength.xlsx';
 outputPath = strcat(outputLoc,outputFile);

% Load existing output file to determine the next open row
 [num,txt,raw] = xlsread(outputPath,'C1:C8000');
 writeRow = length(num)+3;
 writeRange = sprintf('%s%i%s%i','A',writeRow,':C',writeRow);

% Write the data for the current batter into that row
 xlswrite(outputPath,outputs,writeRange)
 
 disp("End of script")


