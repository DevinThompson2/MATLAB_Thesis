function [tee, bp, cannon, live] = compile_Tables(tables, phases)
% Input: tables: cell array containing all of the tables. Has the form of
% pitchMode -> subject -> phases

% Concatonate all of the tables into 24 tables (4 pitch modes, 8 tables
% (different data in each)

% Order of tables cell is: Tee, BP, Cannon, Live

% Tee, all phases
rowCount = 1;
for i = 1:length(tables{1}) % subject
    for j = 1:length(tables{1}{i}) % phase
        addTable = tables{1}{i}{j};
        tee.(phases{j})(rowCount,:) = addTable;
    end
    rowCount = rowCount + 1;
end

% BP, all phases
rowCount = 1;
for i = 1:length(tables{2}) % subject
    for j = 1:length(tables{2}{i}) % phase
        addTable = tables{2}{i}{j};
        bp.(phases{j})(rowCount,:) = addTable;
    end
    rowCount = rowCount + 1;
end
% Cannon, all phases
rowCount = 1;
for i = 1:length(tables{3}) % subject
    for j = 1:length(tables{3}{i}) % phase
        addTable = tables{3}{i}{j};
        cannon.(phases{j})(rowCount,:) = addTable;
    end
    rowCount = rowCount + 1;
end
% Live, all phases
rowCount = 1;
for i = 1:length(tables{4}) % subject
    for j = 1:length(tables{4}{i}) % phase
        addTable = tables{4}{i}{j};
        live.(phases{j})(rowCount,:) = addTable;
    end
    rowCount = rowCount + 1;
end



end

