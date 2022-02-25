function [paddedSignal] = pad_Signals(signal, frameOffset, impactFrames)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
paddedSignal = nan(size(signal,1)+max(frameOffset), size(signal,2));

for i = 1:length(impactFrames)
    % For each trial, (frameOffest(i)) NaN's to the beggining of the trial
    if frameOffset(i) ~= 0
        paddedSignal(frameOffset(i)+1:size(signal,1)+frameOffset(i),i) = signal(:,i);
    elseif frameOffset(i) == 0
        paddedSignal(1:size(signal,1),i) = signal(:,i);
        % Test prints
        %disp(strcat("Trial: ", num2str(i)))
        %disp(strcat("Max Impact Frame =", num2str(impactFrames(i))))
    else
        error('Error in logic in pad_Signals')
    end
end

%% Check impact signal values to see if they are aligned
check = 0;
if check == 1
    adjustedImpactValues = paddedSignal(max(impactFrames),:);
    for i = 1:size(signal,2)
        originalImpactValues(i) = signal(impactFrames(i),i);
    end
    disp(strcat("Adjusted Imapact Values: ", num2str(adjustedImpactValues)))
    disp(strcat("Original Impact Values: ", num2str(originalImpactValues)))
end

end

