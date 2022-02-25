function [impact, BEV, launch, hitOrMiss] = determine_hitOrMiss(impact, marker, BEV, launch, trimOrAll,leftOrRight)
% Determine if the ball was hit or missed and sets values that are
% dependent on the ball being hit to zero
%   Inputs: impact: The impact struct from the main program
%           marker: A marker struct from the main script. Either trimmed or
%           raw data
%           BEV: Ball exit velocity struct. Should contain raw and
%           filtered fields
%           launch: struct containing the launch angle info. Should contain
%           raw and filtered fields
%           trimOrAll: Indicates whether input data is full or trimmed
%           leftOrRight: Left or right handed value, 0 or 1
%   Outputs:impact: sames truct as input
%           BEV: same struct as input
%           launch: same struct as input

% Use filtered data, not raw data

% Use input from leftOrRight to determine which marker to use to use as a
% reference marker (either right or left heel)
if leftOrRight == -1 % Left Handed batter
    % Determine if raw or trimmed data entered, used to calculate if it was a
    % hit or miss
    if trimOrAll == 0 % Trimmed data entered
        hitOrMiss = calc_hitOrMiss(impact.filt.frame, marker.pos.filt.batBall.LHEE, marker.pos.filt.batBall.Ball1); % Inputs are trimmed data
    elseif trimOrAll == 1 % All data entered
        hitOrMiss = calc_hitOrMiss(impact.filt.frame, marker.pos.filt.LHEE, marker.pos.filt.Ball1); % Inputs are untrimmed data
    else
        error('determine_hitOrMiss error: Last function parameter not a 0 or 1')
    end
elseif leftOrRight == 1 % Right Handed Batter
    % Determine if raw or trimmed data entered, used to calculate if it was a
    % hit or miss
    if trimOrAll == 0 % Trimmed data entered
        hitOrMiss = calc_hitOrMiss(impact.filt.frame, marker.pos.filt.batBall.RHEE, marker.pos.filt.batBall.Ball1); % Inputs are trimmed data
    elseif trimOrAll == 1 % All data entered
        hitOrMiss = calc_hitOrMiss(impact.filt.frame, marker.pos.filt.RHEE, marker.pos.filt.Ball1); % Inputs are untrimmed data
    else
        error('determine_hitOrMiss error: function parameter trimOrAll not a 0 or 1')
    end
else
   error('determine_hitOrMiss error: function parameter leftOrRight not a 0 or 1') 
end

% Logic for changing values if it was a miss
if hitOrMiss == 1 % Ball was hit
    % Do nothing, this is the way
elseif hitOrMiss == 0 % Ball was missed
    % Assign zero values to launch angle, impact location, ball exit
    % velocity - maybe change these to strings so they become nan
    BEV.filt = nan;
    BEV.raw = nan;
    launch.raw = nan;
    launch.filt =nan;
    % BallLauchAngle_SwingPlane =0;
    impact.raw.location_knob = nan;
    impact.raw.location_ecap = nan;
    impact.filt.location_knob = nan;
    impact.filt.location_ecap = nan;
    
%     fieldsImpact = fieldnames(impact);% Get the field names in impact
%     fieldsRF = fieldnames(impact.raw);% Get the field names in raw/filtered fields
%     for i = 1:numel(fieldsImpact)
%         for j = numel(fieldsRF)
%             
%             impactLoc_EndCap = 0;
%         end
%     end
else
   error('determine_hitOrMiss error: Output from calc_hitOrMiss not a 0 or 1') 
end

end

