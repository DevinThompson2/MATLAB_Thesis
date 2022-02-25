function [RLSF] = calc_RightieLeftiev2(position)
% Determines if the batter is right or left handed
% Inputs:   position: the struct containing untrimmed positional data
% Outputs:  RLSF: Either a -1 or 1; left or right


RASI = position.filt.RASI;
indRASI = find(RASI(:,5) == 100);
RASIy = RASI(indRASI,2);

LASI = position.filt.LASI;
indLASI = find(LASI(:,5) == 100);
LASIy = LASI(indLASI,2);

RPSI = position.filt.RPSI;
indRPSI = find(RPSI(:,5) == 100);
RPSIy = RPSI(indRPSI,2);

LPSI = position.filt.LPSI;
indLPSI = find(LPSI(:,5) == 100);
LPSIy = LPSI(indLPSI,2);

% If the right side of the hips have larger y location components 
if mean([RASIy,RPSIy]) > mean([LASIy,LPSIy])
    % The batter is left handed
    RLSF = -1;
else
    % The batter is right handed
    RLSF = 1;
end