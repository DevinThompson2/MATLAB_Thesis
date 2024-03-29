function [indices, normEvents] = get_Event_Indices(events, eventNames, timeData)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

impactIndex = find(strcmp(eventNames, "impact")); % Change these values to change the normalization range
footUpIndex = find(strcmp(eventNames, "footUp")); % foot up
%footUpIndex = find(strcmp(eventNames, "firstMove")); % first hand movement

% Get the footUp and Impact times (all impact should be zero)
for i = 1:length(events)
    footUpTimes{i,1} = events{i}(:,footUpIndex);
    impactTimes{i,1} = events{i}(:,impactIndex);
end

% Trim the events data so that only data from foot-up to impact is included
for i = 1:length(events)
    trimmedEvents{i,1} = events{i,1}(:,footUpIndex:impactIndex);
end

% Compute the average for each event in each pitch mode
for i = 1:length(trimmedEvents)
    avgEvents{i,1} = mean(trimmedEvents{i,1}, 'omitnan');
end

% Normalize the averaged events for each pitch mode, from foot-up to impact
% (0 to 100)
for i = 1:length(avgEvents)
    normEvents{i,1} = ((avgEvents{i,1} - avgEvents{i,1}(1,1)) ./ -avgEvents{i,1}(1,1)) * 100;
end
% for i = 1:length(avgEvents)
%     normEvents{i,1} = ((avgEvents{i,1} - min(avgEvents{i,1})) ./ -min(avgEvents{i,1})) * 100;
% end

% Get the indices of foot up to impact for all trials
for i = 1:length(footUpTimes)
    for j = 1:length(footUpTimes{i})
        %i
        %j
        indices{i,1}(j,1) = find(timeData == footUpTimes{i}(j,1));
        indices{i,1}(j,2) = find(timeData == impactTimes{i}(j,1));
    end
end

end

