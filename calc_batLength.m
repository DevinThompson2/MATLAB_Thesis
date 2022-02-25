function [batLength]= calc_batLength(position)

KnobRAW = position.raw.Bat1;
EndcapRAW = position.raw.Bat2;

Knob = position.filt.Bat1;
Endcap = position.filt.Bat2;

% Find which frames positional data is available for both the endcap and
% knob markers
[commonFrames,indexKnob,indexEndcap] = intersect(Knob(:,5),Endcap(:,5));

% For those frames, subtract the knob position from the endcap position
batLength.diff = Endcap(indexEndcap,:) - Knob(indexKnob,:);
batLength.rawdiff = EndcapRAW(indexEndcap,:) - KnobRAW(indexKnob,:);

% Calculate the distance between the endcap and knob markers based on the
% resulting difference
batLength.dist(:,1) = sqrt(sum(batLength.diff(:,1:3).^2,2));
batLength.rawdist(:,1) = sqrt(sum(batLength.rawdiff(:,1:3).^2,2));

% Record the common frames for the bat markers to make plotting easier
% later
batLength.frames = commonFrames;
