function [combined, subNum, modeNum] = combine_Data(cellData)

% First, for RM anova, must use a balanced design. Find the lowest number
% of valid trials, remove any extra trials from this data set
for i = 1:length(cellData)
    for j = 1:length(cellData{i})
        tempData = cellData{i}{j}';
        numTrials(i,j) = size(tempData,1);
    end
end

minTrials = min(numTrials, [], 'all');

% Make sure all data are first minTrials valid trials
for i = 1:length(cellData)
    for j = 1:length(cellData{i})
        tempData = cellData{i}{j}';
        newCellData{i,1}{j,1} = tempData(1:minTrials,:);
    end
end

%Now put all of the data into a large array
combined = [];
subNum = [];
modeNum = [];

for i = 1:length(newCellData)
    for j = 1:length(newCellData{i})
       tempData = newCellData{i}{j};
       tempSub = (ones(size(tempData,1),1).*i) - 1;
       tempMode = (ones(size(tempData,1),1).*j) - 1;
       combined = vertcat(combined,tempData);
       subNum = vertcat(subNum, tempSub);
       modeNum = vertcat(modeNum,tempMode);
    end
end

% For all of the trials, not just the first n, leaving here in case I need
% it later
% Put all data into a large array
% combined = [];
% subNum = [];
% modeNum = [];
% 
% for i = 1:length(cellData)
%     for j = 1:length(cellData{i})
%        tempData = cellData{i}{j}';
%        tempSub = (ones(size(tempData,1),1).*i) - 1;
%        tempMode = (ones(size(tempData,1),1).*j) - 1;
%        combined = vertcat(combined,tempData);
%        subNum = vertcat(subNum, tempSub);
%        modeNum = vertcat(modeNum,tempMode);
%     end
% end

end