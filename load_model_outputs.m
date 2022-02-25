function [data] = load_model_outputs(subjectName, modelNames)
% Load the model outputs from Nexus
% Inputs:   subject name, as a cell array
%           marker names, as cell array
% Output: The model outputs from Nexus

%%Establish Connection between Nexus and MATLAB
vicon = ViconNexus();

% % Get the modeled output information, units vary 

for i = 1:length(modelNames)
   
    [tempData1, tempDataE] = vicon.GetModelOutput(subjectName{1}, modelNames{i});
    tempData1 = tempData1'; % Transpose model output data
    tempDataE = tempDataE'; % Transpose exist data
    tempData2(:,1) = 1:length(tempData1); % Frame number array
        
    data.raw.(modelNames{i}) = [tempData1,tempDataE,tempData2];    
    
    clear tempData1
    clear tempData2
    clear tempDataE
        
end
end

