function [out] = calc_hitOrMiss(impactFrame,referenceMarker,Ball)
%Determines in the ball was sucessfully contacted, and if it wasn't, then
%it assigns a zero value to impact location, launch angle, and exit
%velocity
%   Detailed explanation goes here

% Determine impact index of ball
ballInd = find(Ball(:,5)==impactFrame);
refInd = find(referenceMarker(:,5)==impactFrame);

if referenceMarker(refInd+15,2) > Ball(ballInd+15,2)
    out = 0; % Miss
elseif referenceMarker(refInd+15,2) < Ball(ballInd+15,2)
    out = 1; % Hit
else
    error('Fix the hit or miss function')
end
end

