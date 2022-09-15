%% Figure generation and data organization script
% Author: Devin Thompson
% Name: Main_PostProcessing
% Date: 3/17/2021

% Script to load in saved matfiles, generate figures, and perform
% statistical analysis on the data - No statistical analysis as I don't
% have a large enough data set


%% Close clear workspace/command window
close all
clear all
clc

% Set the default figure font
% set(groot, 'defaultAxesFontName', 'Arial');
% set(groot,'defaultAxesFontSize',20)
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
% Calculate the collision efficiency (Ea) and add it to the tables
[pitchModeTables] = calculate_collisionEfficiency(pitchModeTables);

% Determine good pitches
% (Launch angle and spray angle)
[contactRateSubject, contactRateMethodAvg, contactRateMethodStde, pitchModeTables] = determine_Good_Hit(convPlayerData, subjects, pitchModeTables);
teeTables = pitchModeTables{1};
bpTables = pitchModeTables{2};
cannonTables = pitchModeTables{3};
liveTables = pitchModeTables{4};


% Need to add Ea to the metrics table
metrics{1}{end+1,1} = 'Ea';
metrics{1}{end+1,1} = 'goodHitIndex';

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
%calculate_Pitch_Location(signalData, subjects);

%% Process the signal data to create plots
% Get the names of the signals
signalNames = fieldnames(signalData.(subjects{1}).SignalData);
signalVariableNames = create_variable_names(3)
%set(groot,'defaultAxesFontSize',25)

% [leadElbowFlexTee, leadElbowFlexBP, leadElbowFlexCannon, leadElbowFlexLive] = process_Signal(signalData, subjects, 'leadElbowAngles',signalVariableNames, subjectTables, 1);
% close all
% [leadElbowFlexVelTee, leadElbowFlexVelBP, leadElbowFlexVelCannon, leadElbowFlexVelLive] = process_Signal(signalData, subjects, 'leadElbowVel', signalVariableNames, subjectTables, 2);
% close all
% [leadKneeFlexTee, leadKneeFlexBP, leadKneeFlexCannon, leadKneeFlexLive] = process_Signal(signalData, subjects, 'leadKneeAngles', signalVariableNames, subjectTables, 1);
% close all
% [leadKneeFlexVelTee, leadKneeFlexVelBP, leadKneeFlexVelCannon, leadKneeFlexVelLive] = process_Signal(signalData, subjects, 'leadKneeVel', signalVariableNames, subjectTables, 2);
% close all
% [rearElbowFlexTee, rearElbowFlexBP, rearElbowFlexCannon, rearElbowFlexLive] = process_Signal(signalData, subjects, 'rearElbowAngles', signalVariableNames, subjectTables, 1);
% close all
% [rearElbowFlexVelTee, rearElbowFlexVelBP, rearElbowFlexVelCannon, rearElbowFlexVelLive] = process_Signal(signalData, subjects, 'rearElbowVel', signalVariableNames, subjectTables, 2);
% close all
% [rearKneeFlexTee, rearKneeFlexBP, rearKneeFlexCannon, rearKneeFlexLive] = process_Signal(signalData, subjects, 'rearKneeAngles', signalVariableNames, subjectTables, 1);
% close all
% [rearKneeFlexVelTee, rearKneeFlexVelBP, rearKneeFlexVelCannon, rearKneeFlexVelLive] = process_Signal(signalData, subjects, 'rearKneeVel', signalVariableNames, subjectTables, 2);
% close all
% [batSSVelTee, batSSVelBP, batSSVelCannon, batSSVelLive] = process_Signal(signalData, subjects, 'batSSVel', signalVariableNames, subjectTables, 3);
% close all
% %[batSSAccTee, batSSAccBP, batSSAccCannon, batSSAccLive] = process_Signal(signalData, subjects, 'batSSAcc', signalVariableNames, subjectTables, 4);
% %close all
% [batECAPVelTee, batECAPVelBP, batECAPVelCannon, batECAPVelLive] = process_Signal(signalData, subjects, 'batECAPVel', signalVariableNames, subjectTables, 3);
% close all
% %[batECAPAccTee, batECAPAccBP, batECAPAccCannon, batECAPAccLive] = process_Signal(signalData, subjects, 'batECAPAcc', signalVariableNames, subjectTables, 4);
% %close all
% %[headFlexTee, headFlexBP, headFlexCannon, headFlexLive] = process_Signal(signalData, subjects, 'headFlexion', signalVariableNames, subjectTables, 1); % Ran into an error, sub 6
% %[headLatFlexTee, headLatFlexBP, headLatFlexCannon, headLatFlexLive] = process_Signal(signalData, subjects, 'headLateralFlexion', signalVariableNames, subjectTables, 1); % Ran into an error, sub 6
% %[headRotTee, headRotBP, headRotCannon, headRotLive] = process_Signal(signalData, subjects, 'headRotation', signalVariableNames, subjectTables, 1); % Ran into an error, sub 6
% [hipRotTee, hipRotBP, hipRotCannon, hipRotLive] = process_Signal(signalData, subjects, 'hipRotation', signalVariableNames, subjectTables, 1);
% close all
% [hipRotVelTee, hipRotVelBP, hipRotVelCannon, hipRotVelLive] = process_Signal(signalData, subjects, 'hipRotationVel', signalVariableNames, subjectTables, 2);
% close all
% [trunkRotTee, trunkRotBP, trunkRotCannon, trunkRotLive] = process_Signal(signalData, subjects, 'trunkRotation', signalVariableNames, subjectTables, 1);
% close all
% [trunkRotVelTee, trunkRotVellBP, trunkRotVelCannon, trunkRotVelLive] = process_Signal(signalData, subjects, 'trunkRotationVel', signalVariableNames, subjectTables, 2);
% close all
% [leadArmAngVelTee, leadArmAngVelBP, leadArmAngVelCannon, leadArmAngVelLive] = process_Signal(signalData, subjects, 'leadArmAngVel', signalVariableNames, subjectTables, 2);
% close all
% [leadHandAngVelTee, leadHandAngVelBP, leadHandAngVelCannon, leadHandAngVelLive] = process_Signal(signalData, subjects, 'leadHandAngVel', signalVariableNames, subjectTables, 2);
% close all
% %[avg2, stde2] = process_Signal(signalData, subjects, 'leadWristAcc', signalVariableNames, subjectTables, 4);
% %[avg2, stde2] = process_Signal(signalData, subjects, 'leadWristVel', signalVariableNames, subjectTables, 3);
% [batAngVelTee, batAngVelBP, batAngVelCannon, batAngVelLive] = process_Signal(signalData, subjects, 'batAngVel', signalVariableNames, subjectTables, 2);
% close all
% %[rearShouldAbdTee, rearShouldAbdBP, rearShouldAbdCannon, rearShouldAbdLive] = process_Signal(signalData, subjects, 'rearShoulderAbduction', signalVariableNames, subjectTables, 1); % Ran into error, sub 6
% %[trunkFlexTee, trunkFlexBP, trunkFlexCannon, trunkFlexLive] = process_Signal(signalData, subjects, 'trunkFlexion', signalVariableNames, subjectTables, 1); % Ran into error, sub 6
% %[trunkLatFlexTee, trunkLatFlexBP, trunkLatFlexCannon, trunkLatFlexLive] = process_Signal(signalData, subjects, 'trunkLateralFlexion', signalVariableNames, subjectTables, 1); % Ran into error, sub 6
%% Swing speed vs time from pitch release to impact (or swing time)

% plot_batSpeedvsPitchTime(playerData, subjects, 'maxBatSSVel','pitchVel','swingTimeFootUp');
 
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
set(groot,'defaultAxesFontSize',14)
eventVariableNames = create_variable_names(2);
[avgEA, stdeEa] = plot_collisionEfficiency(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables,'Ea',eventVariableNames);
[avgPV, stdePV] = plot_pitchVel(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables,'pitchVel',eventVariableNames);
[avgBEV, stdeBEV] = plot_BEV(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables,'exitVel',eventVariableNames);
plot_impactLocation(finalTeeTables, finalBPTables,finalCannonTables,finalLiveTables, 'impactLocECAP', eventVariableNames)
% plot_max_metric_linVel(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'maxBatSSVel', eventVariableNames)
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
% plot_max_metric_angVel(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'maxBatAngVel', eventVariableNames)
% plot_max_metric_angVel(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'maxLeadArmAngVel')
% plot_max_metric_angVel(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, 'maxLeadHandAngVel')


%% Plot times of events
%plot_event_times(finalTeeTables, finalBPTables, finalCannonTables, finalLiveTables, {'stance','footUp', 'load','firstMove','footDown','impact','followThrough'})

















