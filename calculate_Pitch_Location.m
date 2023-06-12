function calculate_Pitch_Location(subjectData, subjects)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


% First, separate out the ball data
for i = 1:length(subjects)
    filenames{i,1} = subjectData.(subjects{i}).SignalData.FILE_NAME;
    signal{i,1} = subjectData.(subjects{i}).SignalData.ballPosition;
    [teeData{i,1}, bpData{i,1}, cannonData{i,1}, liveData{i,1}] = separate_Pitch_Location(signal{i,1}, filenames{i,1});
end

% For each data type, go through each trial and get the point (x,z) at a certain
% distance from home plate (y)
[teePlayer, teeRaw] = get_Ball_Location(teeData, "tee");
[bpPlayer, bpRaw] = get_Ball_Location(bpData, "bp");
[cannonPlayer, cannonRaw] = get_Ball_Location(cannonData, "bp");
[livePlayer, liveRaw] = get_Ball_Location(liveData, "bp");

% Calculate the distances from the center of the strike zone
[teeDistance, teeDistancePlayer] = calc_StrikeZone_Distance(teeRaw, teePlayer);
[bpDistance, bpDistancePlayer] = calc_StrikeZone_Distance(bpRaw, bpPlayer);
[cannonDistance, cannonDistancePlayer] =  calc_StrikeZone_Distance(cannonRaw, cannonPlayer);
[liveDistance, liveDistancePlayer] =  calc_StrikeZone_Distance(liveRaw, livePlayer);

% Plot the ball location data
plot_Pitch_Location(teeRaw, bpRaw, cannonRaw, liveRaw);
% Each subject
for i = 1:length(subjects)
    plot_Pitch_Location_Subject(teePlayer{i}, bpPlayer{i}, cannonPlayer{i}, livePlayer{i}, subjects{i});
end
% Each subject only RPM on one plot
numSubjects = length(subjects);
cmap = colormap(cool(numSubjects));
% Create the figure
f= gcf;
figure(f.Number+1)
for i = 1:length(subjects)
    plot_Pitch_Location_OnlyRPM(cannonPlayer{i}, subjects{i}, cmap(i,:))
end
% Save the figure
f = gcf;
%f.WindowState = 'maximized';
path = "Z:\SSL\Research\Graduate Students\Thompson, Devin\Thesis Docs\Pitch Modality (RIP)\Thesis\Pics and Videos\Results Figs\Pitch Location\";
fileName = strcat("PitchLocation","_OnlyRPM");
savefig(f, strcat(path, fileName));
saveas(f, strcat(path, fileName), 'png');


% Plot the distance data
plot_StrikeZone_Distance(teeDistance, bpDistance, cannonDistance, liveDistance)
for i = 1:length(subjects)
    plot_StrikeZone_Distance_Subject(teeDistancePlayer{i}, bpDistancePlayer{i}, cannonDistancePlayer{i}, liveDistancePlayer{i}, subjects{i});
end

end

