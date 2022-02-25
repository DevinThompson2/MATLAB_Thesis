function [mag] = calculate_magnitude(data)
%UNTITLED3 Summary of this function goes here
%   Calculates the magnitude of the data, input should be in form of [x y
%   z] vector

mag = sqrt(data(:,1).^2 + data(:,2).^2 + data(:,3).^2);

end

