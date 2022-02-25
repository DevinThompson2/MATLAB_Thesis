function[Batsa] = GetProjectivePoint(Bat1,Bat2,Bats)

vBat2 = Bat2(:,(1:3))-Bat1(:,(1:3));
vBats = Bats(:,(1:3))-Bat1(:,(1:3));

[theta] = getAngle_allframes(vBat2,vBats);
LengthBats = sqrt(sum(vBats.^2,2));
LengthBat2 = sqrt(sum(vBat2.^2,2));

LocationBats = LengthBats.*(cos(theta))';

Batsa(:,1) = (Bat2(:,1)-Bat1(:,1)).*LocationBats./LengthBat2+Bat1(:,1);
Batsa(:,2) = (Bat2(:,2)-Bat1(:,2)).*LocationBats./LengthBat2+Bat1(:,2);
Batsa(:,3) = (Bat2(:,3)-Bat1(:,3)).*LocationBats./LengthBat2+Bat1(:,3);
Batsa(:,4) =  Bats(:,4);