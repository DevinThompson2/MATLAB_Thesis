function [missing] = missingMarkersBeginning(position)
% Inputs: position: marker position struct
% Outputs: List of markers that are missing from the beginning of the trial

% Get all marker names
fields = fieldnames(position);
disp("Beginning")
% Loop through all of the fields
count = 1;
missing = {};
for i = 1:length(fields)
   % Check the 4th column, 1st row to see if data exists for the first frame
   if position.(fields{i})(1,4) == 0 % No data exists
       missing{count,1} = fields{i};
       count = count + 1;
       disp(strcat("No data for marker ",fields{i}))
   elseif position.(fields{i})(1,4) == 1
       disp(strcat("Good marker ",fields{i}))
   else
       error("Error in missingMarkersBeginning")
   end       
end

disp(' ')
disp(' ')
end

