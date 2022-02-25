function [theta] = calc_getAngle(V2,V1)

% vDot = dot(V1,V2);
% mag1 = sqrt(sum(V1.^2,2));
% mag2 = sqrt(sum(V2.^2,2));
% rhs = vDot/(mag1*mag2);
% theta = acos(rhs);
% theta = min(theta,pi-theta);

for i = 1:length(V2(:,1))
    crossvalue = cross(V1(i,(1:3)),V2(i,(1:3)));
    dotvalue = dot(V1(i,(1:3)),V2(i,(1:3)));
    normvalue = norm(crossvalue);
    
    theta(i) = atan2(normvalue,dotvalue);    
end

