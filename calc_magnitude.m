function [magnitude] = calc_magnitude(array)
%UNTITLED13 Summary of this function goes here
%   Input:  array: array in the form of [x y z] w/ n number of rows
%   Output: magnitude: the magnitude of the array, as a column vector

% Calculate the magnitude for a 3D array
magnitude = sqrt(array(:,1).^2 + array(:,2).^2 + array(:,3).^2);

end

