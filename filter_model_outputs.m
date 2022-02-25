function [data] = filter_model_outputs(data,subjectName)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
% Filters model data from Nexus
% Inputs:   data: model data, as a structure with a field .raw
%           subjectName: name of the subject, as a char
vicon = ViconNexus();
frames = vicon.GetFrameCount();
% Filter Position Data For: All marker data the exists
[b,a] = butter(4,0.125);
fields = fieldnames(data.raw); % Get names of markers w/trajectories
% Re-write to determine if any markers dont have trajectories
% mrkrNames = vicon.GetMarkerNames(subjectName); % Get names of all markers on subject
% if numel(fields)~= numel(mrkrNames) % Determine if any markers are
% missing - not working, need to fix
%     disp('There is a marker missing')
% end

for i = 1:numel(fields) % Get the indexing of good frames for each model output
    index.(fields{i}) = find(data.raw.(fields{i})(:,4));
    % Also get the number of columns in each field, for future looping
    col(i) = size(data.raw.(fields{i}), 2);
end

count = 1; % Count variable to increment through col
for j = 1:numel(fields)% Filter all of the data in each model output
    for i = 1:col(count)-2
        data.filt.(fields{j})(frames,i) = 0; % Set initial values of all columns to zeros w/ same length as number of frames in trial
        data.filt.(fields{j})(index.(fields{j}),i) = filtfilt(b,a,data.raw.(fields{j})(index.(fields{j}),i));
        %data.filt.(fields{j})(:,i) = filtfilt(b,a,data.raw.(fields{j})(index.(fields{j}),i));
    end 
    count = count + 1;
    % Add condition to append data with zeros if 
end



count = 1;
for j = 1:numel(fields)% Add the 'exist' and 'Frame' column to the filtered data
    for i = col(count)-1:col(count) 
        data.filt.(fields{j})(:,i) = data.raw.(fields{j})(:,i);
    end
    count = count + 1;
end

end

