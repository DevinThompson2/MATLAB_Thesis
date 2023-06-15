%% Script to add a ball marker to all frames 
% Author: Devin Thompson
% Name: AddBallToCal
% Date: 12/29/2020

% This script will add a ball marker to the calibration trial at [0 1 0]
% (m) for each frame of the trial

%% Clear and close all. Establish Nexus and MATLAB connection

clear 
close all
clc

vicon = ViconNexus();

% % for Commands for displaying the Nexus Command List and Help with each command
%vicon.DisplayCommandList;
%vicon.DisplayCommandHelp('SetTrajectory')

%% Load All Trial Info Needed
[trial.pathName, trial.trialName] = vicon.GetTrialName; % %Open the correct trial in Nexus
[startROI,endROI] = vicon.GetTrialRegionOfInterest; % Get Trial Region of Interest (in case the trial was cropped in Nexus)
trial.subjectName = vicon.GetSubjectNames(); % Get the subject name from the current trial
trial.markerNames = vicon.GetMarkerNames(trial.subjectName{1}); % Get marker names of the trial
trial.modelOutNames = vicon.GetModelOutputNames(trial.subjectName{1});
trial.frameCount = vicon.GetFrameCount; % Number of frames in the trial
trial.fs = vicon.GetFrameRate; % sampling frequency [frame/s]

%% Add a marker at position [0 1 0] on the ground that represents the ball for all frames
% Set arrays for ball data
X = zeros(1,trial.frameCount);
Y = ones(1,trial.frameCount)*1000;
Z = zeros(1,trial.frameCount);
E = zeros(1,trial.frameCount);
E(startROI:endROI) = 1;
exists = logical(E);
% Set the trajectory
vicon.SetTrajectory(trial.subjectName{1},trial.markerNames{54}, X, Y, Z, exists);
disp('Done')
