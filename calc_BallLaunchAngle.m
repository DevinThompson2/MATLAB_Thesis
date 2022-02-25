function [launchAngle] = calc_BallLaunchAngle(ballPos, ballVel,impactIndex, dt)
%UNTITLED15 Summary of this function goes here
%   Inputs: ballPos: ball position data
%           ballVel: ball velcity data
%           dt: Time array for each frame
%   Output: launchAngle: Angle of the ball after impact w/ respect to the
%   x-y plane

% Compute angle
launchAngleArray = (atan(ballVel(impactIndex-2+15:end,3)./ballVel(impactIndex-2+15:end,2))) .* (180./pi);
launchAngle = mean(launchAngleArray);



end

