function [diffData] = differentiate_mrkrData(data, dt)
%Differentiate marker data to get either velocity or acceleration
%   Input:  data: marker data, as a struct
%           dt: Time between frames, in seconds
%   Output: diffData: the differentiated marker data

fields = fieldnames(data);

for i = 1:numel(fields)
    [compVel.(fields{i}), magVel.(fields{i})] = five_point_central_diff(dt, data.(fields{i})); 
end

diffData.comp = compVel;
diffData.mag = magVel;


end

