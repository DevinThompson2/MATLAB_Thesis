function [normData] = divide_By_Live(data, liveData)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

for i = 1:length(data)
    for j = 1:size(data{i},2)
        normData{i,1}(:,j) = data{i}(:,j) ./ liveData;
    end
end

end

