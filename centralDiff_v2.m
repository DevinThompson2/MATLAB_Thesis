function [centralDVel] = centralDiff_v2(deltax,y)
%Using the central difference method to compute the velocity of a set of
%data points
%   Detailed explanation goes here

%X-Velocity
for i = 2:length(y)-1
    centralDVelx(i-1,1) = (y(i+1,1)-y(i-1,1))/(2*deltax);
end

%Y-Velocity
for j = 2:length(y)-1
    centralDVely(j-1,1) = (y(j+1,2)-y(j-1,2))/(2*deltax);
end

%Z-Velocity
for k =2:length(y)-1
    centralDVelz(k-1,1) = (y(k+1,3)-y(k-1,3))/(2*deltax);
end

centralDVel = [centralDVelx centralDVely centralDVelz];
%Velocity Magnitude Calculation
%centralDVel = sqrt(centralDVelx.^2+centralDVely.^2+centralDVelz.^2);




end