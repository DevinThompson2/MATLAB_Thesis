function [compiled,contactRate] = compute_Contact_Rate_All(indexCell)
% Input the index cell array to compute the contact rate for all trials of
% a certain method

compiled = [];
for i = 1:length(indexCell)
    compiled = cat(1,compiled,indexCell{i});
end

contactRate = nnz(compiled) ./ length(compiled);
end

