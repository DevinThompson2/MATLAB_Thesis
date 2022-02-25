function write_Scores_xlsx(scores, name)
% Write the score data to the correct folder and spot
% Create the path and filename to read and write to
path = "Z:\SSL\Research\Graduate Students\Thompson, Devin\Thesis Docs\Pitch Modality (RIP)\Thesis\Data\";
filename = "ThesisOutputData.xlsx";
pathAndFile = strcat(path,filename);
sheet = 1;
% Read the table
inTable = readtable(pathAndFile);
% Find the first index in the table where there is no data
index = 1;

while ~isnan(inTable.Total(index))
   index = index + 1; 
end
dataIndex = index + 1; % Excel index always going to be one more than the table

outCellName = xlRC2A1(dataIndex,8);
outCellData = xlRC2A1(dataIndex,2);

% Write the name and data to the correct locations in Excel sheet
writematrix(scores, pathAndFile, 'Sheet',sheet,'Range',outCellData);
writematrix(name,pathAndFile,'Sheet',sheet,'Range',outCellName);


end

