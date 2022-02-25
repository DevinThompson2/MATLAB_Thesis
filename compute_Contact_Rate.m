function [contactRate, goodIndex] = compute_Contact_Rate(launch, spray)
% Compute the contact rate for each subject and each method

for i = 1:length(launch)
    for j = 1:length(launch{i})
        if (launch{i}(j) >= -10 && launch{i}(j) <= 30) &&...
                    (spray{i}(j) >=-45 && spray{i}(j) <=45)
                goodIndex{i,1}(j,1) = 1;
        else
            goodIndex{i,1}(j,1) = 0;
        end
    end
end

% Get an overall percentage for each subject
for i =1:length(launch)
    contactRate(i,1) = nnz(goodIndex{i,1}) ./ length(goodIndex{i,1}); 
end

end

