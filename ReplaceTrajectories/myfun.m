function F = myfun(guess,input)
x1 = input(1);
y1 = input(2);
z1 = input(3);

x2 = input(4);
y2 = input(5);
z2 = input(6);

x3 = input(7);
y3 = input(8);
z3 = input(9);

d1 = input(10);
d2 = input(11);
d3 = input(12);

x = guess(1);
y = guess(2);
z = guess(3);


F(1) = (x1-x)^2 + (y1-y)^2 + (z1-z)^2 - d1^2;
F(2) = (x2-x)^2 + (y2-y)^2 + (z2-z)^2 - d2^2;
F(3) = (x3-x)^2 + (y3-y)^2 + (z3-z)^2 - d3^2;

end