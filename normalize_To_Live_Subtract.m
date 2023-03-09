function [avgData, stdeData, percentEvents, normalizedData] = normalize_To_Live_Subtract(signalData, eventData, indices, pitchInfo, signalName, graphName, subjectName, unit, graph)
% Normalize the signal data to the live condition for each player - average
% of live condition

% (1) Map all trials to normalized time (i.e., horizontal axis  = % swing),
% also need to normalized the events to % of swing, average them
% For each participant:
% (2) Average live swing trials
% (3) Subtract all average live swing trial from each non-live trial

events = {'Stance','Foot Up','Load','First Hand Movement','Foot Down','Impact','Follow Through'};

% Comment and uncomment the trimmed events to change the range

trimmedEvents = {'Foot Up','Load','First Hand Movement','Foot Down','Impact'};
%trimmedEvents = {'First Hand Movement','Foot Down','Impact'};
eventVarNames = {'stance','footUp','load','firstMove','footDown','impact','followThrough'};
hz = 500; % Sampling frequency

%% (1)
[teeEvents, bpEvents, cannonEvents, liveEvents] = normalize_Events(eventData{1}, eventData{2}, eventData{3}, eventData{4}, eventVarNames);
normEventMats = {teeEvents; bpEvents; cannonEvents; liveEvents};

% Convert indices to times
rawTime = indices{1} / hz;

% Round the events so that an equality comparison can be performed
for i = 1:length(normEventMats)
    roundEventMats{i,1} = round(normEventMats{i},3);
end

% Get indices to extract data from for each trial
% Find indices of foot-up and impact
% Normalize the events from foot-up to impact as a percentage of the swing
% in this function as well 
[eventIndices, percentEvents] = get_Event_Indices(roundEventMats, eventVarNames, rawTime);

% Extract the data for each trial
footUpToImpactData = extract_Footup_To_Impact(eventIndices, signalData);

% Create vectors for each trial, all need to be the same size and not
% remove any data by "changing" the sampling frequency
percentSwing = [0:.1:100]';

% Interpolate the trimmed-to-swing data so that it has the same amount of
% data points as the x axis values for % of the swing (1001 data points)
interpolatedData = interpolate_Signal_Data(footUpToImpactData, percentSwing);


%% (2)
% Average the trials for the live swing
avgLive = mean(interpolatedData{4},2,'omitnan');

%% (3)
% Divide each trial by the average of the live trials
normalizedData = subtract_By_Live(interpolatedData, avgLive);
% Average the data - These values are being output
for i = 1:length(normalizedData)
    avgData{i,1} = mean(normalizedData{i}, 2, 'omitnan'); % In deg
    stdeData{i,1} = (std(normalizedData{i},0,2,'omitnan'))./ (sqrt(size(normalizedData{i},2))); % In deg
end

%% Create graphing variables and graph the normalized data
% Plot the normalized
% First index is Tee, second is BP, third is Cannon, fourth is Live
if graph == 1
    upperTee = (avgData{1}+stdeData{1});
    lowerTee = (avgData{1}-stdeData{1});
    inBetweenTee = [upperTee; flipud(lowerTee)]';
    upperBP = (avgData{2}+stdeData{2});
    lowerBP = (avgData{2}-stdeData{2});
    inBetweenBP = [upperBP; flipud(lowerBP)]';
    upperCannon = (avgData{3}+stdeData{3});
    lowerCannon = (avgData{3}-stdeData{3});
    inBetweenCannon = [upperCannon; flipud(lowerCannon)]';
    upperLive = (avgData{4}+stdeData{4});
    lowerLive = (avgData{4}-stdeData{4});
    inBetweenLive = [upperLive; flipud(lowerLive)]';
    
    % Create x array for plotting
    % was fliplr
    newTeeGraph = [percentSwing; flipud(percentSwing)];
    newBPGraph = [percentSwing; flipud(percentSwing)];
    newCannonGraph = [percentSwing; flipud(percentSwing)];
    newLiveGraph = [percentSwing; flipud(percentSwing)];

    labelSize = 35;
    subLabelSize = 30;
    subNumSize = 25;
    xLineLabelSize = 25;
    boldLabel = 'bold';
    
    f = gcf;
    figure(f.Number+1)
    hold on
    fill(newTeeGraph, inBetweenTee,[.25 .25 .25],'facealpha',0.5,'EdgeColor',[.25 .25 .25],'EdgeAlpha', 0.25)
    fill(newBPGraph, inBetweenBP,[.25 .25 .25],'facealpha',0.5,'EdgeColor',[.25 .25 .25],'EdgeAlpha', 0.25)
    fill(newCannonGraph, inBetweenCannon,[.25 .25 .25],'facealpha',0.5,'EdgeColor',[.25 .25 .25],'EdgeAlpha', 0.25)
    fill(newLiveGraph, inBetweenLive,[.25 .25 .25],'facealpha',0.5,'EdgeColor',[.25 .25 .25],'EdgeAlpha', 0.25)
    p1 = plot(percentSwing, avgData{1}, 'r', 'LineWidth',2);
    p2 = plot(percentSwing, avgData{2}, 'g', 'LineWidth',2);
    p3 = plot(percentSwing, avgData{3}, 'b', 'LineWidth',2);
    p4 = plot(percentSwing, avgData{4}, 'k', 'LineWidth',2);
    plot(percentSwing, upperTee, 'r', 'LineWidth',.5)
    plot(percentSwing, upperBP, 'g', 'LineWidth',.5)
    plot(percentSwing, upperCannon, 'b', 'LineWidth',.5)
    plot(percentSwing, upperLive, 'k', 'LineWidth',.5)
    plot(percentSwing, lowerTee, 'r', 'LineWidth',.5)
    plot(percentSwing, lowerBP, 'g', 'LineWidth',.5)
    plot(percentSwing, lowerCannon, 'b', 'LineWidth',.5)
    plot(percentSwing, lowerLive, 'k', 'LineWidth',.5)
    xline(percentEvents{1},'r-', 'LineWidth',2, 'LabelHorizontalAlignment','center','FontSize',xLineLabelSize, 'FontWeight', boldLabel)
    xline(percentEvents{2},'g-', 'LineWidth',2, 'LabelHorizontalAlignment','center','FontSize',xLineLabelSize, 'FontWeight', boldLabel)
    xline(percentEvents{3},'b-', 'LineWidth',2, 'LabelHorizontalAlignment','center','FontSize',xLineLabelSize, 'FontWeight', boldLabel)
    xline(percentEvents{4},'k-',trimmedEvents, 'LineWidth',2, 'LabelHorizontalAlignment','center','FontSize',xLineLabelSize, 'FontWeight', boldLabel)
    %xline(pitchInfo(1),'c-','Pitcher Foot Up (est)','LineWidth',1)
    %xline(pitchInfo(2),'c-','Pitcher Knee Up (est)','LineWidth',1)
    %xline(pitchInfo(3),'c-','Pitcher Hand Separation (est)','LineWidth',1)
    %xline(pitchInfo(4),'c-','Pitcher Foot Down (est)','LineWidth',1)
    %xline(pitchInfo(5),'c-','Pitch Release (est)','LineWidth',1)
    xlim([0 100])
    %ylim([-3 3])
    ax= gca;
    ax.FontSize = subLabelSize;
    ax.FontWeight = 'bold';
    xLineFootUp = ax.Children(5);
    xLineFootUp.LabelHorizontalAlignment = "right";
    xLineImpact = ax.Children(1);
    xLineImpact.LabelHorizontalAlignment = "left";
    legend([p1 p2 p3 p4],{'Tee','BP','RPM','Live'},'Location','southwest', 'FontSize', subNumSize, 'FontWeight', boldLabel)
    %title(strcat(graphName, ", Normalized By Subtracting Live, For Each Pitch Mode- ", subjectName))
    xlabel("Percent of Swing",'FontSize', labelSize, 'FontWeight', boldLabel)
    ylabel(strcat(graphName, unit), 'FontSize', labelSize, 'FontWeight', boldLabel)
    
    % Save the figure as .png and mat
    f = gcf;
    f.WindowState = 'maximized';
    path = "Z:\SSL\Research\Graduate Students\Thompson, Devin\Thesis Docs\Pitch Modality (RIP)\Thesis\Pics and Videos\Results Figs\Signals\";
    fileName = strcat(signalName,"_SubtractNorm_", subjectName);
    savefig(f, strcat(path, fileName));
    saveas(f, strcat(path, fileName), 'png');
end

end