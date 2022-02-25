% Devin Thompson
% 3/9/2020

% Script to perform ANOVA calculations on each of the three days where data
% was collected

clear
close all
clc

%% Load the excel file
path = 'Z:\SSL\Research\Graduate Students\Thompson, Devin\Vicon\Reports\Camera Testing\';
file = 'BatLength.xlsx';
pathAndFile = strcat(path,file);

[num,text,raw] = xlsread(pathAndFile);

data(:,1) = num(1:5,1);
data(:,2) = num(6:10,1);
data(:,3) = num(11:15,1);

[p,tbl,stats] = anova1(data);
[c,m] = multcompare(stats)
