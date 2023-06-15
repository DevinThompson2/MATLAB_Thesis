function [swingTime, batVelPlot] = create_PitchMode_Vectors(inData)

% Variables of interest
% Add all of the variables of interest into new vector variables
batVel = [];
for i = 1:length(inData) % Each pitch condition
    for j = 1:length(inData{i}) % Each Subject
        batVel{i}{:,j} = inData{i}{j}{1}.maxBatSSVel;
        swingTime{i}{:,j} = inData{i}{j}{10}.swingTimeHand;
    end
end

for i = 1:length(batVel)
    batVel{i} = cat(1,batVel{i}{:});
    swingTime{i} = cat(1,swingTime{i}{:});
end
for i = 1:length(batVel)
    batVelPlot{i} = batVel{i} *2.23694;
end

% Plot all of the data
f = gcf;
fs = figure(f.Number+1);
hold on
scatter(swingTime{1}, batVelPlot{1}, 'ro')
scatter(swingTime{2}, batVelPlot{2}, 'go')
scatter(swingTime{3}, batVelPlot{3}, 'bo')
scatter(swingTime{4}, batVelPlot{4}, 'ko')
%scatter(pitchSpeedVec, batSpeedVec, '.')
%plot(pitchSpeedModel)
xlabel('Pitch Speed (mph)')
ylabel('Swing Time (s)')
%title('Bat Speed vs Swing Time')

% Save the figure
f = gcf;
%f.WindowState = 'maximized';
path = "Z:\SSL\Research\Graduate Students\Thompson, Devin\Thesis Docs\Pitch Modality (RIP)\Thesis\Pics and Videos\Results Figs\SwingSpeedvs\";
fileName = "BatVelvsSwingTime";
savefig(f, strcat(path, fileName));
saveas(f, strcat(path, fileName), 'png');


end