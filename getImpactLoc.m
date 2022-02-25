 function [impactLoc_wrtKnob,impactLoc_EndCap,impactFrame,impactFrameIndex] = getImpactLoc(Bat1,Bat2,Bat3,Bat4,Ball,goodIndex)

%% INPUTS
% Bat and Ball Marker positional data of the form
% Col 1 - X Position
% Col 2 - Y Position
% Col 3 - Z Position
% Col 4 - Good Data Exist?

%% OUTPUTS
% Impact Location (scalar)
% Impact Frame (scalar)

%% Method: 
% (1) Determine the frame of interest
% (2) Find the angle between the vectors:
%      (a) Bat Knob to End Cap [Bat Position]
%      (b) Bat Knob to Ball [Ball Position wrt End Cap]
% (3) Project ball position onto the bat vector.

%% (1)Determine the Frame of Interest

% Calculate total distance between ball and (1) knob and (2) endcap markers
distVect_K = Bat1(:,(1:3))-Ball(:,(1:3));
distVect_E = Bat2(:,(1:3))-Ball(:,(1:3));

distK = sqrt(sum(distVect_K.^2,2));
distE = sqrt(sum(distVect_E.^2,2));

distTotal = distK + distE;

% Get impact frame index
impactFrameIndex = find(distTotal == min(distTotal));
impactFrame = goodIndex(impactFrameIndex);

%% (2) Find Angle Between Vectors
% Calculate Vectors for Each Frame
vBat1Bat2 = Bat2(impactFrameIndex,[1:3]) - Bat1(impactFrameIndex,[1:3]);
vBat1Ball = Ball(impactFrameIndex,[1:3]) - Bat1(impactFrameIndex,[1:3]);
vBat2Ball = Ball(impactFrameIndex,1:3) - Bat2(impactFrameIndex,1:3);
vBat2Bat1 = Bat1(impactFrameIndex,1:3) - Bat2(impactFrameIndex,1:3);

% Calculate length of Knob-to-Ball Vector
magBatBall = sqrt(sum(vBat1Ball.^2,2));
magBat2Ball = sqrt(sum(vBat2Ball.^2,2));

% Get angle between vectors
[theta] = getAngle(vBat1Bat2,vBat1Ball);
theta2 = getAngle2(vBat2Bat1, vBat2Ball);

%% (3) Project Ball Location onto Bat Vector
impactLoc_wrtKnob = magBatBall*cos(theta) - 7; % [mm]; 7mm offset due to 14mm marker diameter
impactLoc_End = magBat2Ball*cos(theta2) - 7;

% Convert impact location to inches
impactLoc_wrtKnob = impactLoc_wrtKnob*(1/25.4); % [in]
impactLoc_End = impactLoc_End*(1/25.4);


 %% (4) Impact location from endcap
 distVect = Bat1(:,(1:3))-Bat2(:,(1:3));
 dist = sqrt(sum(distVect.^2,2))*(1/25.4);
 
 impactLoc_EndCap = dist(impactFrameIndex) - impactLoc_wrtKnob - 14*(1/25.4);


