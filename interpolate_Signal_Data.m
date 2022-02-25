function [outputData] = interpolate_Signal_Data(data, xq)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

for i = 1:length(data)
    for j = 1:length(data{i})
        xi = [1:length(data{i}{j})]';
        x = ((xi - min(xi)) / (max(xi) - min(xi))) * 100;
        outputData{i,1}(:,j) = interp1(x, data{i}{j},xq);
    end
end
   
end

