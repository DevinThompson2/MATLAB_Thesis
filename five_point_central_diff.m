function [compVel, magVel] = five_point_central_diff(dt, data)
%UNTITLED12 Summary of this function goes here
%   Inputs: data: Data to differentiate, as an N x 3 array. If more columns
%   are entered, the rest will be ignored
%   Outputs:    magVel: Magnitude of the velocity
%               compVel: Components of the velocity, as an N x 3 array

% Differentiate x- column
for i = 3:length(data)-2
    fivePointX(i-2,1) = ( -data(i+2,1) + 8*data(i+1,1) - 8*data(i-1,1) + data(i-2,1) ) / (12 * dt);
end

% Differentiate y- column
for i = 3:length(data)-2
    fivePointY(i-2,1) = ( -data(i+2,2) + 8*data(i+1,2) - 8*data(i-1,2) + data(i-2,2) ) / (12 * dt);
end

% Differentiate z- column
for i = 3:length(data)-2
    fivePointZ(i-2,1) = ( -data(i+2,3) + 8*data(i+1,3) - 8*data(i-1,3) + data(i-2,3) ) / (12 * dt);
end

% Combine into [x y z]
compVel = [fivePointX fivePointY fivePointZ];

% Compute the magnitude of the velocity
magVel = calc_magnitude(compVel);

% Add index data to magVel and compVel, 5-point central difference
% removes 4 data points, two at beginning, two at end
newFrames = data(3:end-2,5);

magVel(:,2) = newFrames;
compVel(:,4) = data(3:end-2,4);
compVel(:,5) = newFrames;



end

