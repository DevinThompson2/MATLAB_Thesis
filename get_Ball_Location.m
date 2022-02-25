function [xzByPlayer, xzRaw] = get_Ball_Location(data, tag)
% Go through each trial and get the pitch location

% Establish a y-position to take the data from (a certain distance in front
% of the plate)
% 2 ft in front of the front edge of the plate
y = 1.0414; % m

% Use the tag to determine whether it was a tee or pitched ball
if tag == "tee"
    count = 1;
    % Loop over each subject
    for i = 1:length(data)
        % Loop over each trial
       for j = 1:length(data{i})
           % Just average the first 10 positions
            pointData = mean(data{i}{j}(1:10,:));
            % Extract just the x,z positions and convert to in
            xzRaw(count,1) = pointData(1,1) * 39.3701; % x, in
            xzRaw(count,2) = pointData(1,3) * 39.3701; % z, in
            xzByPlayer{i,1}(j,1) = pointData(1,1) * 39.3701; % x, in
            xzByPlayer{i,1}(j,2) = pointData(1,3) * 39.3701; % z, in
            count = count + 1;
       end
    end
else
    count = 1;
    % Loop over each subject
    for i = 1:length(data)
        % Loop over each trial
       for j = 1:length(data{i})
            % First, need to get first data point where ball is inside 1 ft from plate, take the previous data point as location
            index = find(data{i}{j}(:,2) <= y,1) - 1;
            % Next, get the data from that index
            pointData = data{i}{j}(index,:);
            % Extract only the x,z positions and convert to in
            xzRaw(count,1) = pointData(1,1) * 39.3701; % x, in
            xzRaw(count,2) = pointData(1,3) * 39.3701; % z, in
            xzByPlayer{i,1}(j,1) = pointData(1,1) * 39.3701; % x, in
            xzByPlayer{i,1}(j,2) = pointData(1,3) * 39.3701; % z, in
            count = count + 1;
       end
    end
end
end

