% addLASIMarker
% Script to add a LASI marker at the beginning of the trial
% Devin Thompson 9/25/18

clear all
clc

% Establish link between Vicon Nexus 2 and Matlab
vicon = ViconNexus();

% Import Subject Name
subName = vicon.GetSubjectNames;

% Get Trial Region of Interest
[sFrame, eFrame] = vicon.GetTrialRegionOfInterest;

% Import Bat Markers
[LASI(:,1), LASI(:,2), LASI(:,3), LASI(:,4)] = vicon.GetTrajectory(subName{1},'LASI');
[RASI(:,1), RASI(:,2), RASI(:,3), RASI(:,4)] = vicon.GetTrajectory(subName{1},'RASI');
[LPSI(:,1), LPSI(:,2), LPSI(:,3), LPSI(:,4)] = vicon.GetTrajectory(subName{1},'LPSI');
[RPSI(:,1), RPSI(:,2), RPSI(:,3), RPSI(:,4)] = vicon.GetTrajectory(subName{1},'RPSI');

% Calculate a location for Bat1 marker at this frame
replacementFunc(LASI,RASI,LPSI,RPSI,sFrame,subName,'LASI')