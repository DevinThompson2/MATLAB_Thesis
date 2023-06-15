function [data] = filter_MarkerPosition_v2(data, fs, wc)
% Filters marker position data from Nexus
% Inputs:   data: marker data, as a structure with a field .raw
%           subjectName: name of the subject, as a char
vicon = ViconNexus();
frames = vicon.GetFrameCount();


% Filter Position Data For: All marker data the exists
% Establish filter parameters
wn = fs./2;
filtFrac = wc./wn;
[b,a] = butter(4,filtFrac);
fields = fieldnames(data.raw); % Get names of markers w/trajectories
% Re-write to determine if any markers dont have trajectories
% mrkrNames = vicon.GetMarkerNames(subjectName); % Get names of all markers on subject
% if numel(fields)~= numel(mrkrNames) % Determine if any markers are
% missing - not working, need to fix
%     disp('There is a marker missing')
% end

for i = 1:numel(fields) % Get the indexing of good frames for each marker
    index.(fields{i}) = find(data.raw.(fields{i})(:,4));
end

for i = 1:3 % Filter all of the marker data
    for j = 1:numel(fields)
        data.filt.(fields{j})(frames,i) = 0; % Set initial values of all columns to zeros w/ same length as number of frames in trial
        data.filt.(fields{j})(index.(fields{j}),i) = filtfilt(b,a,data.raw.(fields{j})(index.(fields{j}),i));
    end
end
  
for i = 4:5 % Add the 'exist' and 'Frame' column to the filtered data
    for j = 1:numel(fields)
        data.filt.(fields{j})(:,i) = data.raw.(fields{j})(:,i);
    end
end

end

