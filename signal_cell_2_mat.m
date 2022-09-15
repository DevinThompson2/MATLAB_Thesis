function [teeMat, bpMat, cannonMat, liveMat] = signal_cell_2_mat(cell)
% Input a nx1 cell and output 4 matrices, one for each pitch mode
% Each cell entry is 4x1 or 3x1, only one is 3x1 need too account for that 
if length(cell{1}) == 3
    for i = 1:length(cell)
        teeMat(:,i) = cell{i}{1};
        bpMat(:,i) = cell{i}{2};
        cannonMat(:,i) = cell{i}{3};
    end
    liveMat = [];
else
    for i = 1:length(cell)
        teeMat(:,i) = cell{i}{1};
        bpMat(:,i) = cell{i}{2};
        cannonMat(:,i) = cell{i}{3};
        liveMat(:,i) = cell{i}{4};
    end
end
end