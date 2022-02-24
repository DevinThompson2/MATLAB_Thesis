%% Figure generation and data organization script
% Author: Devin Thompson
% Name: Main_PostProcessing
% Date: 3/17/2021

% Script to load in saved matfiles, generate figures, and perform
% statistical analysis on the data


%% Close clear workspace/command window
close all
clear all
clc
%% Load the files and put them into structures for each subject
% Set the name of the folder where output data is stored
outputPathName = "Z:/SSL/Research/Graduate Students/Thompson, Devin/C-Motion/PitchModality/OutputData/";
% Get the structure of the files/folder in that directory
folderDir = dir(outputPathName);
% Create a list of path names to each folder that contains the subject data
subjectFolders = create_List_Subject_Folders(folderDir);
% Create a directory for each folder and open the files in each folder,
% assign them to a struck
playerData = open_Mat_Files(outputPathName,subjectFolders);

% Load the raw signal data
signalData = open_SignalData(outputPathName,subjectFolders);

%% Rearrange data so that it is easier to work with
% Create lists for each layer of data
subjects = fieldnames(playerData);
phases = fieldnames(playerData.(subjects{1}));

% In alphabetical order, if anything changes, will need to change this
% (order of the phases)
for i =1:length(phases)
    metrics{i,1} = fieldnames(playerData.(subjects{1}).(phases{i}));
end
tableTypes = {'Tee';'BP';'Cannon';'Live'};

% Remove signal data from phases and metrics
[playerData, phases, metrics] = remove_Signal(playerData, subjects, phases, metrics);

% Convert all of the cells to matrices
convPlayerData = convert_Data(playerData, subjects, phases, metrics);

% Create tables for each player
for i = 1:length(subjects)
    %i
    subjectTables{i,1} = create_Tables_Player(convPlayerData.(subjects{i}), phases, metrics);
end

% Separate the tables into the pitch mode for each player, then combine all
% of the pitch modes into a single table (Calculate the averages first
% before combining into a table with one metric per player?)
for i = 1:length(subjects)
    [teeTables{i,1}, bpTables{i,1},cannonTables{i,1},liveTables{i,1}] = separate_All_Tables(subjectTables{i});
end

pitchModeTables = {teeTables; bpTables; cannonTables; liveTables};

% Compute averages for each each participant for each table
averageTables = average_All_Tables(pitchModeTables, tableTypes, length(subjects), length(phases)); 

% Compile the averaged tables into a single table
[finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables] = compile_Tables(averageTables, phases);
% Fun_ has been added to the beginning of the variable names, should remove
% Fun_from variable names
% Remove Fun_ from the variable names in the tables
[finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables] = remove_Fun_All_Tables(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, phases, metrics);
% % Add Fun_ to all variable names - Dont need to do this, I think
% for i = 1:length(metrics)
%     for j = 2:length(metrics{i})
%         if j == 2
%            funMetrics{i,1}{j-1,1} = metrics{i,1}{j-1,1}; 
%         end
%         funMetrics{i,1}{j,1} = strcat('Fun_',metrics{i}{j});
%     end
% end

%% Compute the pitch location
%pitchLocation = calculate_Pitch_Location(signalData, subjects);

%% Determine good pitches
% (Launch angle and spray angle)
% out = determine_Good_Hit(convPlayerData, subjects);

%% Process the signal data to create plots
% Get the names of the signals
signalNames = fieldnames(signalData.(subjects{1}).SignalData);
signalVariableNames = create_variable_names(3)

% [avg1, stde1] = process_Signal(signalData, subjects, 'leadElbowAngles', subjectTables, 1);
% [avg1, stde1] = process_Signal(signalData, subjects, 'leadElbowVel', subjectTables, 2);
% [avg1, stde1] = process_Signal(signalData, subjects, 'leadKneeAngles', subjectTables, 1);
% [avg1, stde1] = process_Signal(signalData, subjects, 'leadKneeVel', subjectTables, 2);
% [avg1, stde1] = process_Signal(signalData, subjects, 'rearElbowAngles', subjectTables, 1);
% [avg1, stde1] = process_Signal(signalData, subjects, 'rearElbowVel', subjectTables, 2);
% [avg1, stde1] = process_Signal(signalData, subjects, 'rearKneeAngles', subjectTables, 1);
% [avg1, stde1] = process_Signal(signalData, subjects, 'rearKneeVel', subjectTables, 2);
% [avg1, stde1] = process_Signal(signalData, subjects, 'batSSVel', subjectTables, 3);
% [avg1, stde1] = process_Signal(signalData, subjects, 'batSSAcc', subjectTables, 4);
% [avg2, stde2] = process_Signal(signalData, subjects, 'batECAPVel', subjectTables, 3);
% [avg2, stde2] = process_Signal(signalData, subjects, 'batECAPAcc', subjectTables, 4);
% [avg1, stde1] = process_Signal(signalData, subjects, 'headFlexion', subjectTables, 1);
% [avg1, stde1] = process_Signal(signalData, subjects, 'headLateralFlexion', subjectTables, 1);
% [avg1, stde1] = process_Signal(signalData, subjects, 'headRotation', subjectTables, 1);
% [hipRotTee, hipRotBP, hipRotCannon, hipRotLive] = process_Signal(signalData, subjects, 'hipRotation', subjectTables, 1);
% [hipRotVelTee, hipRotVelBP, hipRotVelCannon, hipRotVelLive] = process_Signal(signalData, subjects, 'hipRotationVel', subjectTables, 2);
[trunkRotTee, trunkRotBP, trunkRotCannon, trunkRotLive] = process_Signal(signalData, subjects, 'trunkRotation', subjectTables, 1);
% [trunkRotVelTee, trunkRotVellBP, trunkRotVelCannon, trunkRotVelLive] = process_Signal(signalData, subjects, 'trunkRotationVel', subjectTables, 2);
% [avg2, stde2] = process_Signal(signalData, subjects, 'leadArmAngVel', subjectTables, 2);
% [avg2, stde2] = process_Signal(signalData, subjects, 'leadHandAngVel', subjectTables, 2);
% [avg2, stde2] = process_Signal(signalData, subjects, 'leadWristAcc', subjectTables, 4);
% [avg2, stde2] = process_Signal(signalData, subjects, 'leadWristVel', subjectTables, 3);
% [avg2, stde2] = process_Signal(signalData, subjects, 'batAngVel', subjectTables, 2);
% [avg2, stde2] = process_Signal(signalData, subjects, 'rearShoulderAbduction', subjectTables, 1);
% [avg2, stde2] = process_Signal(signalData, subjects, 'trunkFlexion', subjectTables, 1);
% [avg2, stde2] = process_Signal(signalData, subjects, 'trunkLateralFlexion', subjectTables, 1);
%% Swing speed vs time from pitch release to impact (or swing time)

% plot_batSpeedvsPitchTime(playerData, subjects, 'maxBatSSVel','pitchVel','SwingTime');
% 
% %% Create figures
% %test_Plot(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, phases, metrics);
% % Create list of event variable names - Not using this either
% % Print out variable names for events
% eventVariableNames = create_variable_names(1)
% % Plot event metrics
% plot_event_metric_angle(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'HipRot');
% plot_event_metric_angle(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'TrunkRot');
% plot_event_metric_angle(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'TrunkFlex');
% plot_event_metric_angle(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'TrunkLatFlex');
% plot_event_metric_angle(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'ShouldAbd');
% plot_event_metric_angVel(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'HipRotVel');
% plot_event_metric_angVel(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'TrunkVel');
% plot_event_metric_linVel(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'BatECAPVel');
% plot_event_metric_linVel(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'BatSSVel');
% plot_event_metric_angVel(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'BatAngVel');
% plot_event_metric_angle(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'LeadElbowFlex');
% plot_event_metric_angle(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'LeadKneeFlex');
% plot_event_metric_angVel(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'LeadElbowVel');
% plot_event_metric_angVel(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'LeadKneeVel');
% plot_event_metric_angle(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'RearElbowFlex');
% plot_event_metric_angle(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'RearKneeFlex');
% plot_event_metric_angVel(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'RearElbowVel');
% plot_event_metric_angVel(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'RearKneeVel');
% plot_event_metric_angVel(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'LeadArmAngVel');
% plot_event_metric_angVel(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'LeadHandAngVel');
% plot_event_metric_angVel(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'HeadRot');
% plot_event_metric_angVel(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'HeadLatFlex');
% plot_event_metric_angVel(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'HeadFlex');
% 
% 
% 
% %% Plot max metrics
% eventVariableNames = create_variable_names(2)
% plot_max_metric_linVel(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'maxBatSSVel')
% plot_max_metric_linVel(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'maxBatECAPVel')
% plot_max_metric_angle(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'maxHipRotation')
% plot_max_metric_angle(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'maxTrunkRotation')
% plot_max_metric_angle(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'maxTrunkFlexion')
% plot_max_metric_angle(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'maxTrunkLateralFlexion')
% plot_max_metric_angle(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'maxShoulderAbd')
% plot_max_metric_angle(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'maxLeadKneeFlexion')
% plot_max_metric_angle(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'maxLeadElbowFlexion')
% plot_max_metric_angle(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'maxRearKneeFlexion')
% plot_max_metric_angle(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'maxRearElbowFlexion')
% plot_max_metric_angVel(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'maxHipRotVel')
% plot_max_metric_angVel(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'maxTrunkRotVel')
% plot_max_metric_angVel(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'maxLeadElbowVel')
% plot_max_metric_angVel(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'maxRearElbowVel')
% plot_max_metric_angVel(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'maxLeadKneeVel')
% plot_max_metric_angVel(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'maxRearKneeVel')
% plot_max_metric_angVel(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'maxBatAngVel')
% plot_max_metric_angVel(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'maxLeadArmAngVel')
% plot_max_metric_angVel(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'maxLeadHandAngVel')


%% Plot times of events
% plot_event_times(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, {'stance','footUp', 'load','firstMove','footDown','impact','followThrough'})

















