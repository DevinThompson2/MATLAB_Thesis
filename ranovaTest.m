% data from question (1 within-subjects factor with 3 levels, 5 participants)
M = [1 101.05  39.99 1.10;
    2  216.14  70.14 1.25;
    3   26.53  81.12 1.54;
    4  231.18 135.89 0.89;
    5  140.40  37.21 0.01];

% organize the data in a table
T = array2table(M(:,2:end));
T.Properties.VariableNames = {'A' 'B' 'C'};

% create the within-subjects design
withinDesign = table([1 2 3]','VariableNames',{'Condition'});
withinDesign.Condition = categorical(withinDesign.Condition);

% create the repeated measures model and do the anova
rm = fitrm(T,'A-C ~ 1','WithinDesign',withinDesign);
AT = ranova(rm,'WithinModel','Condition'); % remove comma to see ranova's table

% output a conventional anova table
disp(anovaTable(AT, 'Measure (units)'));

% ---------------------------------------------------------------------
% Scott's function to create a conventional ANOVA table from the
% overly-complicated and confusing anova table created by the ranova
% function.

function [s] = anovaTable(AT, dvName)

c = table2cell(AT);

% remove erroneous entries in F and p columns 
for i=1:size(c,1)       
        if c{i,4} == 1
            c(i,4) = {''};
        end
        if c{i,5} == .5
            c(i,5) = {''};
        end
end

% use conventional labels in Effect column
effect = AT.Properties.RowNames;
for i=1:length(effect)
    tmp = effect{i};
    tmp = erase(tmp, '(Intercept):');
    tmp = strrep(tmp, 'Error', 'Participant');
    effect(i) = {tmp}; 
end

% determine the required width of the table
fieldWidth1 = max(cellfun('length', effect)); % width of Effect column
fieldWidth2 = 57; % field needed for df, SS, MS, F, and p columns

barDouble = sprintf('%s\n', repmat('=', 1, fieldWidth1 + fieldWidth2));
barSingle = sprintf('%s\n', repmat('-', 1, fieldWidth1 + fieldWidth2));

% re-organize the data 
c = c(2:end,[2 1 3 4 5]);
c = [num2cell(repmat(fieldWidth1, size(c,1), 1)), effect(2:end), c]';

% create the ANOVA table
s = sprintf('ANOVA table for %s\n', dvName);
s = [s barDouble];
s = [s sprintf('%-*s %4s %11s %14s %9s %9s\n', fieldWidth1, 'Effect', 'df', 'SS', 'MS', 'F', 'p')];
s = [s barSingle];
s = [s, sprintf('%-*s %4d %14.3f %14.3f %10.3f %10.4f\n', c{:})];
s = [s, barDouble];

end
