function [goodFolders] = create_List_Subject_Folders(dirStruct)
% Input : dirStruct, a structure created from the dir funtion

% Determine which folders to use to get the data from
[rows, cols] = size(dirStruct);
% Loop over all fields in the struck, only store folders that contain the
% name "Subject"
count = 1;
for i = 1:rows
    if contains(dirStruct(i).name,"Subject") == 1
        goodFolders{count,1} = dirStruct(i).name;
        count = count + 1;
    end
end

end

