%% Full Body Processing Script 
% Author: Devin Thompson
% Name: FullBodyProcessing
% Date: 12/31/19
% This script calculates metrics for a full body swing. Outputs continuous
% timesteps to Excel for each metric. Can get desired time in Excel. Look
% at values from different events: Toe off, Toe Down, Swing Start,
% Contact. Average trials and compare between pitch delivery methods.

%% Metrics:
% Bat/Ball metrics
% 1) Bat Velocity (linear and angular)
% 2) Impact Location - Done
% 3) BEV - Done 
% 4) Pitch Speed - Done 
% 5) Launch Angle - Done 
% 6) Bat Kinetic Energy
% 7) Bat lag

% Body metrics
% 1) Kinetic/ Kinematic Sequence
% 2) Swing Time
% 3) Event timing (Toe-off, toe-down, swing start, bat-ball contact)
% 4) Shoulder Tilt
% 5) Trunk Flexion/Extension
% 6) Max Shoulder/ Hip Separation
% 7) Hand Position
% 8) Lead/ Back Elbow Angle
% 9) Lead/ Back Knee Angle
% 10) Lead/ Back Elbow Velocity
% 11) Lead/ Back Knee Velocity
% 12) Stride Length
% 13) Stance Offset
% 14) Swing Time
%  Other Joint angles/velocities?????

% Notes:
% USE CONSISTENT SYNTAX

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

% Filter the marker position data
mrkr.pos = filter_MarkerPosition_v2(mrkr.pos, trial.fs, trial.fc);

%% Load and Filter the Model Output Data
% Get raw model outputs
modelOutputs = load_model_outputs(trial.subjectName, trial.modelOutNames);

% Filter the model output data
modelOutputs= filter_model_outputs(modelOutputs, trial.subjectName{1});

%% Get indices where frame data exists for each marker
[goodIndices.all, goodIndices.batBall, goodIndices.body] = get_goodIndices(mrkr.pos.raw, trial.markerNames);

%% Trim all marker data to lengths specified by goodIndices
% Raw data
trimmedMrkr.pos.raw.all = trim_data(mrkr.pos.raw, goodIndices.all);
trimmedMrkr.pos.raw.batBall = trim_data(mrkr.pos.raw, goodIndices.batBall);
trimmedMrkr.pos.raw.body = trim_data(mrkr.pos.raw, goodIndices.body);
% Filtered data
trimmedMrkr.pos.filt.all = trim_data(mrkr.pos.filt, goodIndices.all);
trimmedMrkr.pos.filt.batBall = trim_data(mrkr.pos.filt, goodIndices.batBall);
trimmedMrkr.pos.filt.body = trim_data(mrkr.pos.filt, goodIndices.body);

%% Determine if batter is left or right handed
leftRightHanded = calc_RightieLeftiev2(mrkr.pos);

%% Calculate Linear Velocity and Acceleration of All Markers
% % Velocity
% Raw, trimmed and untrimmed
trimmedMrkr.vel.raw.all = differentiate_mrkrData(trimmedMrkr.pos.raw.all, dt); % [mm/s]
trimmedMrkr.vel.raw.batBall = differentiate_mrkrData(trimmedMrkr.pos.raw.batBall, dt); % [mm/s]
trimmedMrkr.vel.raw.body = differentiate_mrkrData(trimmedMrkr.pos.raw.body, dt); % [mm/s]
mrkr.vel.raw = differentiate_mrkrData(mrkr.pos.raw, dt); % [mm/s]
% Filtered, trimmed and untrimmed
trimmedMrkr.vel.filt.all = differentiate_mrkrData(trimmedMrkr.pos.filt.all, dt); % [mm/s]
trimmedMrkr.vel.filt.batBall = differentiate_mrkrData(trimmedMrkr.pos.filt.batBall, dt); % [mm/s]
trimmedMrkr.vel.filt.body = differentiate_mrkrData(trimmedMrkr.pos.filt.body, dt); % [mm/s]
mrkr.vel.filt = differentiate_mrkrData(mrkr.pos.filt, dt); % [mm/s]

% % Acceleration
% Raw, trimmed and untrimmed
trimmedMrkr.acc.raw.all = differentiate_mrkrData(trimmedMrkr.vel.raw.all.comp, dt); % [mm/s^2]
trimmedMrkr.acc.raw.batBall = differentiate_mrkrData(trimmedMrkr.vel.raw.batBall.comp, dt); % [mm/s^2]
trimmedMrkr.acc.raw.body = differentiate_mrkrData(trimmedMrkr.vel.raw.body.comp, dt); % [mm/s^2]
mrkr.acc.raw = differentiate_mrkrData(mrkr.vel.raw.comp, dt); % [mm/s^2]
% Filtered, trimmed and untrimmed
trimmedMrkr.acc.filt.all = differentiate_mrkrData(trimmedMrkr.vel.filt.all.comp, dt); % [mm/s^2]
trimmedMrkr.acc.filt.batBall = differentiate_mrkrData(trimmedMrkr.vel.filt.batBall.comp, dt); % [mm/s^2]
trimmedMrkr.acc.filt.body = differentiate_mrkrData(trimmedMrkr.vel.filt.body.comp, dt); % [mm/s^2]
mrkr.acc.filt = differentiate_mrkrData(mrkr.vel.filt.comp, dt); % [mm/s^2]


%% Get the impact location of the ball on the bat
% Raw
[impact.raw.location_knob, impact.raw.location_ecap, impact.raw.frame, impact.raw.frameIndex] = getImpactLoc(trimmedMrkr.pos.raw.batBall.KNOB, trimmedMrkr.pos.raw.batBall.ECAP,...
    trimmedMrkr.pos.raw.batBall.MIDK, trimmedMrkr.pos.raw.batBall.MIDE, trimmedMrkr.pos.raw.batBall.Ball1, goodIndices.batBall); % [in]
% Filtered
[impact.filt.location_knob, impact.filt.location_ecap, impact.filt.frame, impact.filt.frameIndex] = getImpactLoc(trimmedMrkr.pos.filt.batBall.KNOB, trimmedMrkr.pos.filt.batBall.ECAP,...
    trimmedMrkr.pos.filt.batBall.MIDK, trimmedMrkr.pos.filt.batBall.MIDE, trimmedMrkr.pos.filt.batBall.Ball1, goodIndices.batBall); % [in]

%% Calculate the BEV and Pitch Speed

% Take Pitch Velocity as average velocity from start of ball trajectory to
% impact
% before impact of filtered ball data
beforeIndex = impact.raw.frameIndex-2; % -2 because of 5-point central difference method to compute velocity
%pitchSpeed.filt = mean(trimmedMrkr.vel.filt.batBall.mag.Ball(1:beforeIndex,1)) .*0.00223694; % [mph]
pitchSpeed.raw = mean(trimmedMrkr.vel.raw.batBall.mag.Ball1(1:beforeIndex,1)) .*0.00223694; % [mph]
OGpitchSpeedRaw = mean(trimmedMrkr.vel.raw.batBall.mag.Ball1(impact.raw.frameIndex-11:impact.raw.frameIndex-1,1)) .*0.00223694; % [mph]

% Take BEV as average velocity from impact to end of ball trajectory
% tracking of filtered ball data
afterIndex = impact.raw.frameIndex+2; % +2 because of 5-point central difference method to compute velocity
%BEV.filt = mean(trimmedMrkr.vel.filt.batBall.mag.Ball(afterIndex:end,1)) .*0.00223694; % [mph]
BEV.raw = mean(trimmedMrkr.vel.raw.batBall.mag.Ball1(afterIndex:end,1)) .*0.00223694; % [mph]
OGBEVRaw = mean(trimmedMrkr.vel.raw.batBall.mag.Ball1(impact.raw.frameIndex+1:impact.raw.frameIndex+11,1)) .*0.00223694; % [mph]

% Calulate BEV in a new way
[pitchSpeed.filt, BEV.filt, filtBallBefore, filtBallAfter] =  calc_PitchSpeedAndBEV(trimmedMrkr.pos.raw.batBall.Ball1, impact, trial.fs, trial.fcBall, dt); % [mph]

% Plot ball velocity from trimmed data
plotBall = 1; % Adjust if want to see plot of raw/ filtered data
if plotBall == 1
    figure(1)
    hold on
    plot(trimmedMrkr.vel.raw.batBall.mag.Ball1(:,2), trimmedMrkr.vel.raw.batBall.mag.Ball1(:,1).*0.00223694,'b') % Convert to mph
    plot(trimmedMrkr.vel.filt.batBall.mag.Ball1(:,2), trimmedMrkr.vel.filt.batBall.mag.Ball1(:,1).*0.00223694,'r') % Convert to mph
    plot(impact.filt.frame, trimmedMrkr.vel.filt.batBall.mag.Ball1(impact.filt.frameIndex-2,1).*0.00223694,'ro') % Convert to mph
    plot(impact.raw.frame, trimmedMrkr.vel.raw.batBall.mag.Ball1(impact.raw.frameIndex-2,1).*0.00223694,'bo') % Convert to mph)
    plot(filtBallBefore(:,2), filtBallBefore(:,1),'g')
    plot(filtBallAfter(:,2), filtBallAfter(:,1),'g');
    xlabel('Frame Number')
    ylabel('Velocity (mph)')
    title('Ball Velocity vs Time')
end

%% Calculate the launch angle of the ball off of the bat
% Raw and filtered calculated with same method as calculating BEV and pitch
% velocity
launchAngle.raw = calc_BallLaunchAngle(trimmedMrkr.pos.raw.batBall.Ball1, trimmedMrkr.vel.raw.batBall.comp.Ball1, impact.raw.frameIndex, dt);
launchAngle.filt = calc_BallLaunchAngle(trimmedMrkr.pos.filt.batBall.Ball1, trimmedMrkr.vel.filt.batBall.comp.Ball1, impact.filt.frameIndex, dt);

%% Determine if the ball was hit or missed
trimOrAll = 0; % Edit for trimmed or all - 0=trimmed, 1=all
% Set BEV, impact location, launch angles to nan if ball was missed
[impact, BEV, launchAngle, hitOrMiss] = determine_hitOrMiss(impact,trimmedMrkr,BEV,launchAngle,trimOrAll,leftRightHanded); % Trimmed data entered

%% Calculate the bat linear and angular velocity
% Do fft on ball data to determine what frequnecy signals are in it, filter
% ball data differently
% BEV.raw
% BEV.new
% pitchSpeed.raw
% pitchSpeed.new

[angVel, angVelArray] = Calc_AngularVel(dt, trimmedMrkr.pos.filt.batBall.KNOB, trimmedMrkr.pos.filt.batBall.ECAP, impact.raw.frameIndex)








