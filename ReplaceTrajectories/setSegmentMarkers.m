function [segments] = setSegmentMarkers(markers)
% Input: Marker names
% Output: 
%   Detailed explanation goes here
% From trial markers. May need to make more robust in the future by naming
% each segment individually. Also it will need to change with each marker
% set that is used

segments.head = markers(1:4);
segments.trunk = markers(5:9);
segments.upperArmL = markers(10:14); %(10:14)
segments.lowerArmL = markers(14:17); 
segments.handL = markers(15:18);
segments.upperArmR = markers(19:23);
segments.lowerArmR = markers(23:26);
segments.handR = markers(24:27);
segments.hips = markers(28:31);
%segments.upperLegL = markers([28 30 32 33 48]); % Dont use upper leg
%markers to fill the knee
segments.lowerLegL = markers([33 34 35 48 50]);
segments.ankleL = markers([35 36 37 50]);
%segments.upperLegR = markers([29 31 38 39 49]);
segments.lowerLegR = markers([39 40 41 49 51]);
segments.ankleR = markers([41 42 43 51]);
segments.bat = markers(44:47);

% Adjust order of lower leg markers

end

