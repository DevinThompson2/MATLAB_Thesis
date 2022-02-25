function [theta] = getAngle2(v1, v2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Get dot product of vectors
dp = dot(v1,v2);
% Find magnitude of the vectors
magV1 = sqrt(v1(1).^2 + v1(2).^2 + v1(3).^2);
magV2 = sqrt(v2(1).^2 + v2(2).^2 + v2(3).^2);

% Use arccos to find the angle between the vectors
theta = acos(dp./(magV1 * magV2));


end

