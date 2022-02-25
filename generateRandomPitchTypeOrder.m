% Random Arrays
% Devin Thompson
% 11/6/2019
% Script to randomly create pitch type order to use for the study

clear
close all
clc

% Number of subjects
subjects = int32(input("How many subjects would you like to create random test orders for?\n"))

% Number of pitch types
pitches = int32(input("How many test configurations do you have?\n"))

% Calculate the order for each subject and pitch type
for i = 1:subjects
    order(i,:) = randperm(pitches);
end
disp(order)