function [teeData, bpData, cannonData, liveData] = separate_Pitch_Location(signal, filenames)
% Separate the ball location data by the method of pitch delivery for each
% subject

% Separate by Tee, BP, Cannon, Live
teeCount = 1;
bpCount = 1;
cannonCount = 1;
liveCount = 1;
for i = 1:length(signal)
   if contains(filenames{i}, 'Tee') == 1 % Tee
       teeData{teeCount,1} = signal{i};
       %teeEvents(teeCount,:) = eventData(i,eventVarNames);
       teeCount = teeCount + 1;
   elseif contains(filenames{i}, 'BP') == 1% BP
       bpData{bpCount,1} = signal{i};
       %bpEvents(bpCount,:) = eventData(i,eventVarNames);
       bpCount = bpCount + 1;
   elseif contains(filenames{i}, 'Cannon') == 1% Cannon
       cannonData{cannonCount,1} = signal{i};
       %cannonEvents(cannonCount,:) = eventData(i,eventVarNames);
       cannonCount = cannonCount + 1;
   elseif contains(filenames{i}, 'Live') == 1% Live
       liveData{liveCount,1} = signal{i};
       %liveEvents(liveCount,:) = eventData(i,eventVarNames);
       liveCount = liveCount + 1;
   else
       error('Logic error when figuring out what file each signal belongs to: separate_PitchMode')
   end     
end

end

