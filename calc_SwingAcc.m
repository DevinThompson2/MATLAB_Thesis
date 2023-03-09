function [returnTable] = calc_SwingAcc(batTable, timeTable)
% Input: table: the table one condition and one participant, should only be
% trials from one participant and one condition with the bat and ball
% metrics needed to calculate the Swing Acc

% Output: output the table with swingAcc appended to it

% Get the required variables from the table (Need Vb, Vp, BEV)
% Names from table are: pitchVel, exitVel, maxBatSSVel

% Formula for Ea = (BEV - Vbat)/(Vp + Vbat)
batVel = batTable.maxBatSSVel; % m/s
swingTime = timeTable.swingTimeHand; % s
% filenames = inTable.FILE_NAME;
% 
% % If the trials are Tee, should make all of the Vp values zero to eliminate
% % noise
% if contains(filenames, "Tee") == 1
%     % It is Tee data, make Vp 0
%     Vp = zeros(size(Vp));
%     %disp("Tee table, changing Vp values to zero.")
% end

% Calculate the acceleration
swingAcc = batVel ./swingTime; % m/s^2
swingAccTable = table(swingAcc, 'VariableNames', "swingAcc");

% Add Ea to the end of the table
returnTable = [batTable swingAccTable];
end