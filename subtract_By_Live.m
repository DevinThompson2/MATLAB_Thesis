function [normData] = subtract_By_Live(data, liveData)
% Subtract instead of divide to normalize

for i = 1:length(data)
    for j = 1:size(data{i},2)
        normData{i,1}(:,j) = data{i}(:,j) - liveData;
    end
end

end

