function [pitchSpeed, BEV, magBeforeBall, magAfterBall] = calc_PitchSpeedAndBEV(ballPos, impact, fs, wc, dt)
% Finds the pitch velocity and BEV. Load in position data, filter Ball data
% before and after impact frame to to remove effects of impact on filtering
%   Inputs: ballPos: The ball position data, as an n by 5 array
%           impact: The impact location struct
%   Outputs:    pitchSpeed: The speed of the ball
%               BEV: Ball exit velocity off of the bat

% Extablish fraction of nyquist frequency to use for filter parameters
wn = fs./2;
filtFrac = wc./wn;

% Establish filter parameters
[b,a] = butter(4,filtFrac); 

% Separate data into before and after impact
beforeIndex = impact.raw.frameIndex-1;
afterIndex = impact.raw.frameIndex+1;

beforeBallPos = ballPos(1:beforeIndex,:);
afterBallPos = ballPos(afterIndex:end,:);

% Filter the data
for i = 1:3 % x,y,z of ball 
    filtBallBefore(:,i) = filtfilt(b,a,beforeBallPos(:,i));
    filtBallAfter(:,i) = filtfilt(b,a,afterBallPos(:,i));
end
% Add goodIndex and frame data
filtBallBefore(:,4) = ballPos(1:beforeIndex,4); 
filtBallBefore(:,5) = ballPos(1:beforeIndex,5);
filtBallAfter(:,4) = ballPos(afterIndex:end,4); 
filtBallAfter(:,5) = ballPos(afterIndex:end,5);

% Differentiate the filterd data to get velocity
[compBeforeBall, magBeforeBall] = five_point_central_diff(dt, filtBallBefore);% [mm/s]
[compBeforeBall, magAfterBall] = five_point_central_diff(dt, filtBallAfter);% [mm/s]

% Convert magnitude data to mph
magBeforeBall(:,1) = magBeforeBall(:,1).*0.00223694; % [mph]
magAfterBall(:,1) = magAfterBall(:,1).*0.00223694; % [mph]

% Calculate the pitch speed as average of all frames
pitchSpeed = mean(magBeforeBall(:,1)); % [mph]
BEV = mean(magAfterBall(:,1)); % [mph]



end

