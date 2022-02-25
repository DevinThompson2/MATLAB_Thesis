function [theta] = calc_getAngle(V2,V1)

% vDot = dot(V1,V2);
% mag1 = sqrt(sum(V1.^2,2));
% mag2 = sqrt(sum(V2.^2,2));
% rhs = vDot/(mag1*mag2);
% theta = acos(rhs);
% theta = min(theta,pi-theta);

if length(V2) == 3
    theta = atan2(norm(cross(V1,V2)),dot(V1,V2));    
elseif length(V2) == 2
    theta = atan2(norm(cross([V1,0],[V2,0])),dot([V1,0],[V2,0]));
end