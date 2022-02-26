% addBat1Marker
% Script to add a Bat 1 marker at the beginning of the trial
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
[Bat1(:,1), Bat1(:,2), Bat1(:,3), Bat1(:,4)] = vicon.GetTrajectory(subName{1},'Bat1');
[Bat2(:,1), Bat2(:,2), Bat2(:,3), Bat2(:,4)] = vicon.GetTrajectory(subName{1},'Bat2');
[Bat3(:,1), Bat3(:,2), Bat3(:,3), Bat3(:,4)] = vicon.GetTrajectory(subName{1},'Bat3');
[Bat4(:,1), Bat4(:,2), Bat4(:,3), Bat4(:,4)] = vicon.GetTrajectory(subName{1},'Bat4');

% Calculate a location for Bat1 marker at this frame
replacementFunc(Bat1,Bat2,Bat3,Bat4,sFrame,subName,'Bat1')
