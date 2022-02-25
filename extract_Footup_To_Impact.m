function [swingData] = extract_Footup_To_Impact(indices, data)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

for i = 1:length(data)
    for j = 1:size(data{i},2)
        swingData{i,1}{j,1}(:,1) = data{i}(indices{i}(j,1):indices{i}(j,2),j);
    end
end

end

