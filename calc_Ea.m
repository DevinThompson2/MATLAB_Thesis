function [returnTable] = calc_Ea(inTable)

% Input: table: the table one condition and one participant, should only be
% trials from one participant and one condition with the bat and ball
% metrics needed to calculate Ea

% Output: output the table with Ea appended to it

% Get the required variables from the table (Need Vb, Vp, BEV)
% Names from table are: pitchVel, exitVel, maxBatSSVel

% Formula for Ea = (BEV - Vbat)/(Vp + Vbat)
BEV = inTable.exitVel; % m/s
Vbat = inTable.maxBatSSVel; % m/s
Vp = inTable.pitchVel; % m/s
filenames = inTable.FILE_NAME;

% If the trials are Tee, should make all of the Vp values zero to eliminate
% noise
if contains(filenames, "Tee") == 1
    % It is Tee data, make Vp 0
    Vp = zeros(size(Vp));
    %disp("Tee table, changing Vp values to zero.")
end

% Calculate Ea
Ea = (BEV - Vbat) ./ (Vp + Vbat);
EaTable = table(Ea, 'VariableNames', "Ea");

% Add Ea to the end of the table
returnTable = [inTable EaTable];





end