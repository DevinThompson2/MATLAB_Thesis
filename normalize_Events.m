function [normTeeEvents, normBPEvents, normCannonEvents, normLiveEvents] = normalize_Events(teeEvents, bpEvents, cannonEvents, liveEvents, eventNames)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% Normalize the event times to Impact
% Adjust this so that impact is zero (index of avgTeeEvents subtracted from
% avgTeeEvents
impactIndex = find(strcmp(eventNames, "impact"));
normTeeEvents = teeEvents - teeEvents(:,impactIndex);
normBPEvents = bpEvents - bpEvents(:,impactIndex);
normCannonEvents = cannonEvents - cannonEvents(:,impactIndex);
normLiveEvents = liveEvents - liveEvents(:,impactIndex);

%outputMat = {normTeeEvents; normBPEvents; normCannonEvents; normLiveEvents};
end

