function[AngularVel,AngularVelArray] = Calc_AngularVel(dt,Bat1,Bat2,impactFrameIndex)

BatVector = Bat2(:,1:3) - Bat1(:,1:3);

for i = impactFrameIndex-11 : impactFrameIndex-2
%     cosangle(i) = dot(BatVector(i-1,1:3),BatVector(i,1:3))/(sqrt(sum(BatVector(i-1,1:3).^2))*sqrt(sum(BatVector(i,1:3).^2)));
%     AngularVelArray(i) = acos(cosangle(i))/dt;
    
    AngularVelArray(i,1) = atan2(norm(cross(BatVector(i-1,1:3),BatVector(i,1:3))),dot(BatVector(i-1,1:3),BatVector(i,1:3)))/dt;
    AngularVelArray(i,2) = (i-impactFrameIndex)/500;
    
end

AngularVel = mean(AngularVelArray(impactFrameIndex-11 : impactFrameIndex-2));

AngularVelArray = AngularVelArray(impactFrameIndex-11 : impactFrameIndex-2,1:2);