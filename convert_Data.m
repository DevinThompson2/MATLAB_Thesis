function [outData] = convert_Data(data, subNames, phaseNames, metricNames)
% Input: data, the data structure
% Converts input data from cells to matrices (for numeric data)

% Number of subjects
numSubs = length(subNames);
% Number of phases
numPhase = length(phaseNames);

newData = data;

% First, replace all blank cells with NaN's
for i = 1:numSubs
    for j = 1:numPhase
        for k = 2:length(metricNames{j})+1 % don't need to go through file names
            for m = 1:length(data.(subNames{i}).(phaseNames{j}).(metricNames{j}{k-1}))
%                 disp(i)
%                 disp(j)
%                 disp(k)
%                 disp(m)
                if isempty(data.(subNames{i}).(phaseNames{j}).(metricNames{j}{k-1}){m}) == 1
                    newData.(subNames{i}).(phaseNames{j}).(metricNames{j}{k-1}){m} = NaN; % Assign NaN to all values that are bad
                    % Debugging
%                     disp('value replaced')
%                     disp(i)
%                     disp(j)
%                     disp(k)
%                     disp(m)
                end
            end
        end
    end
end

%Convert all of the cells to matrices
for i = 1:numSubs
    for j = 1:numPhase
        for k = 2:length(metricNames{j})
            if k == 2 % first time through, add file name 
                outData.(subNames{i}).(phaseNames{j}).(metricNames{j}{k-1}) = newData.(subNames{i}).(phaseNames{j}).(metricNames{j}{k-1});
            end
            % debugging
%             disp(i)
%             disp(j)
%             disp(k)
% Convert all non string data to doubles
            outData.(subNames{i}).(phaseNames{j}).(metricNames{j}{k}) = cell2mat(newData.(subNames{i}).(phaseNames{j}).(metricNames{j}{k}));
          
        end
    end
end



end


