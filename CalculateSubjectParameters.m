% Devin Thompson
% CalculateSubjectParameters
% Date: 10/24/19
% This script uses the calibration markers from the calibrations trial to
% calculate the subject parameters L and R (Elbow Width, Knee Width, Ankle
% Width, and Leg Length). It then writes these subject parameters back to
% Nexus and assigns these values to the subject

%% Clear and close all. Establish Nexus and MATLAB connection

clear 
close all
clc

vicon = ViconNexus();

% %Commands for displaying the Nexus Command List and Help with each command
% vicon.DisplayCommandList;
%vicon.DisplayCommandHelp('OpenTrial')

%% Load Data
% %Open the correct trial in Nexus
[trial.pathName, trial.trialName] = vicon.GetTrialName;

% %Get the subject name from the current trial
[trial.subjectName] = vicon.GetSubjectNames();

% Get marker names from the trial
markerNames = vicon.GetMarkerNames(trial.subjectName{1});
data = load_MarkerPos_v2(trial.subjectName, markerNames);

% Get subject parameters
subjectParamNames = vicon.GetSubjectParamNames(trial.subjectName{1});

% Calculate the distance between markers, accounting for the marker radius
% for each subject parameter
[~,distance.LELB] = calc_marker_distance(data.raw.LELB, data.raw.LMEP);
[~,distance.RELB] = calc_marker_distance(data.raw.RELB, data.raw.RMEP);
[~,distance.LKNE] = calc_marker_distance(data.raw.LKNE, data.raw.LMKN);
[~,distance.RKNE] = calc_marker_distance(data.raw.RKNE, data.raw.RMKN);
[~,distance.LANK] = calc_marker_distance(data.raw.LANK, data.raw.LMAN);
[~,distance.RANK] = calc_marker_distance(data.raw.RANK, data.raw.RMAN);
[~,distance.LLeg] = calc_marker_distance(data.raw.LASI, data.raw.LMAN);
[~,distance.RLeg] = calc_marker_distance(data.raw.RASI, data.raw.RMAN);
[~,distance.LWRT] = calc_marker_distance(data.raw.LWRA, data.raw.LWRB);
[~,distance.RWRT] = calc_marker_distance(data.raw.RWRA, data.raw.RWRB);

% Write the distances calculated to be subject parameters
% SubjectParamNames{x} is the name of the desired subject parameter
% Left side
vicon.SetSubjectParam(trial.subjectName{1}, subjectParamNames{16}, distance.LELB); % Elbow Width
vicon.SetSubjectParam(trial.subjectName{1}, subjectParamNames{6}, distance.LKNE); % Knee Width
vicon.SetSubjectParam(trial.subjectName{1}, subjectParamNames{7}, distance.LANK); % Ankle Width
vicon.SetSubjectParam(trial.subjectName{1}, subjectParamNames{4}, distance.LLeg); % Leg Length
% vicon.SetSubjectParam(trial.subjectName{1}, subjectParamNames{17}, distance.LWRT); % Wrist Width
% Right side
vicon.SetSubjectParam(trial.subjectName{1}, subjectParamNames{31}, distance.RELB); % Elbow Width
vicon.SetSubjectParam(trial.subjectName{1}, subjectParamNames{21}, distance.RKNE); % Knee Width
vicon.SetSubjectParam(trial.subjectName{1}, subjectParamNames{22}, distance.RANK); % Angle Width
vicon.SetSubjectParam(trial.subjectName{1}, subjectParamNames{19}, distance.RLeg); % Leg Length
% vicon.SetSubjectParam(trial.subjectName{1}, subjectParamNames{32}, distance.RWRT); % Wrist Width

% Save the trial and display to command window that script was successfully
% completed - can't get SaveTrial to work
% vicon.SaveTrial();
disp(strcat("Subject Parameters Successfully written to: ", trial.trialName));

