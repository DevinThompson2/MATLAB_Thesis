%% Marker replacement script 
% Author: Devin Thompson
% Name: MarkerReplacement
% Date: 5/19/2020

% Script will not replace markers if there are less than 3 markers on the
% segment

% First, use the transformation method on all trials. Then, check them to
% see if they worked properly. If it didn't work, then try the distance
% method and check the trials

%% Clear and close all. Establish Nexus and MATLAB connection

clear 
close all
clc

vicon = ViconNexus();

% 0 is distance method
% 1 is transformation method
useDistOrTran = 1; % Make sure this is the value that you want to use

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
trial.fc = 30; % cut-off frequency for marker position data filtering [Hz]

%% Load Marker Data
% Get the raw marker position data
mrkr.pos = load_MarkerPos_v2(trial.subjectName, trial.markerNames);

% Filter the marker position data
mrkr.pos = filter_MarkerPosition_v2(mrkr.pos, trial.fs, trial.fc);

%% Set markers in each segment
segments = setSegmentMarkers(trial.markerNames);

%% Determine Missing Markers at beginning and end
missingBeginning = missingMarkersBeginning(mrkr.pos.raw);
missingEnd = missingMarkersEnd(mrkr.pos.raw);

%% Get data for missing markers
missingBegData = getMissingMarkerData(mrkr.pos.raw, missingBeginning);
missingEndData = getMissingMarkerData(mrkr.pos.raw, missingEnd);

%% Determine which segments the missing markers belong to, which markers are in that segment
mSegBeg = missingMarkerSegment(missingBeginning, segments);
mSegEnd = missingMarkerSegment(missingEnd, segments);

%% Get markers in missing segment that aren't the missing markers
goodBeginning = getGoodMarkers(missingBeginning,mSegBeg);
goodEnd = getGoodMarkers(missingEnd, mSegEnd);

%% Get markers from missing segment that have data at beginning or end
goodBeginningWData = getGoodMarkersAtFrame(mrkr.pos.raw, goodBeginning, 1);
goodEndWData = getGoodMarkersAtFrame(mrkr.pos.raw, goodEnd, 2);

%% Pull marker data from segments into a struct
goodBegData = getSegmentMarkerData(mrkr.pos.raw, goodBeginningWData);
goodEndData = getSegmentMarkerData(mrkr.pos.raw, goodEndWData);
goodCloseBegData = getSegmentMarkerData(mrkr.pos.raw, goodBeginning);
goodCloseEndData = getSegmentMarkerData(mrkr.pos.raw, goodEnd);

%% Predict new marker position based on a transformation matrix
if useDistOrTran == 1
    % For the beginning data
    nRowsBeg = size(goodBeginning,1);
    nColsGoodBeg = sum(~cellfun(@isempty,goodBeginningWData),2);
    % Only replace if there is missing marker data
    if isempty(missingBeginning) == 0
        for i = 1:nRowsBeg
            if nColsGoodBeg(i) >= 3
                calcNewMarkerPosTrans(missingBegData{i,1}, goodBegData{i,1}, goodBegData{i,2}, goodBegData{i,3}, startROI, trial.subjectName, missingBeginning{i,1}, 1)
            else
                disp(strcat("Not enough markers on segment ", mSegBeg.segments{i}, " at the beginning of the trial to fill marker ", missingBeginning{i}))
                disp("Filling data as close to beginning as possible")
                calcNewMarkerPosTrans(missingBegData{i,1}, goodCloseBegData{i,1}, goodCloseBegData{i,2}, goodCloseBegData{i,3}, startROI, trial.subjectName, missingBeginning{i,1}, 1)
            end
            
        end
    end
    % For the end data
    nRowsEnd = size(goodEnd,1);
    nColsGoodEnd = sum(~cellfun(@isempty,goodEndWData),2);
    % Only replace if there is missing marker data
    if isempty(missingEnd) == 0
        for i = 1:nRowsEnd
            if nColsGoodEnd(i) >= 3
                calcNewMarkerPosTrans(missingEndData{i,1}, goodEndData{i,1}, goodEndData{i,2}, goodEndData{i,3}, endROI, trial.subjectName, missingEnd{i,1}, 2)
            else
               disp(strcat("Not enough markers on segment ", mSegEnd.segments{i}, " at the end of the trial to fill marker ", missingEnd{i}))
               disp("Filling data as close to end as possible")
               calcNewMarkerPosTrans(missingEndData{i,1}, goodCloseEndData{i,1}, goodCloseEndData{i,2}, goodCloseEndData{i,3}, endROI, trial.subjectName, missingEnd{i,1}, 2)
            end
        end
    end
    
%% Predict missing marker location and add it to trial - With Triangulation method, only use if transformation method is not working 
elseif useDistOrTran == 0
    % For the beginning data
    nRowsBeg = size(goodBeginning,1);
    nColsGoodBeg = sum(~cellfun(@isempty,goodBeginningWData),2);
    % Only replace if there is missing marker data
    if isempty(missingBeginning) == 0
        for i = 1:nRowsBeg
            if nColsGoodBeg(i) >= 3
                replacementFunc(missingBegData{i,1}, goodBegData{i,1}, goodBegData{i,2}, goodBegData{i,3}, startROI, trial.subjectName, missingBeginning{i,1}, 1)
            else
                disp(strcat("Not enough markers on segment ", mSegBeg.segments{i}, " at the beginning of the trial to fill marker ", missingBeginning{i}))
                disp("Filling data as close to beginning as possible")
                replacementFunc(missingBegData{i,1}, goodCloseBegData{i,1}, goodCloseBegData{i,2}, goodCloseBegData{i,3}, startROI, trial.subjectName, missingBeginning{i,1}, 1)
            end
            
        end
    end
    % For the end data
    nRowsEnd = size(goodEnd,1);
    nColsGoodEnd = sum(~cellfun(@isempty,goodEndWData),2);
    % Only replace if there is missing marker data
    if isempty(missingEnd) == 0
        for i = 1:nRowsEnd
            if nColsGoodEnd(i) >= 3
                replacementFunc(missingEndData{i,1}, goodEndData{i,1}, goodEndData{i,2}, goodEndData{i,3}, endROI, trial.subjectName, missingEnd{i,1}, 2)
            else
               disp(strcat("Not enough markers on segment ", mSegEnd.segments{i}, " at the end of the trial to fill marker ", missingEnd{i}))
               disp("Filling data as close to end as possible")
               replacementFunc(missingEndData{i,1}, goodCloseEndData{i,1}, goodCloseEndData{i,2}, goodCloseEndData{i,3}, endROI, trial.subjectName, missingEnd{i,1}, 2)
            end
        end
    end

else
    error("Logic for determining method to use not working properly")
end

%vicon.SaveTrial

disp("The Marker Replacement script has executed properly")
