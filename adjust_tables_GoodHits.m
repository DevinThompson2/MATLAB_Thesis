function [outTable] = adjust_tables_GoodHits(inTable)
% Function to adjust Ea, exitVel, impactLocECAP, impactLocKNOB

launchAngle = inTable.launchAng;
sprayAngle = inTable.sprayAng;

% Get indices where hits are good or bad (spray angle of -45 to 45 and
% launch angle of -15 to 35
for i = 1:length(launchAngle)
    if (launchAngle(i) >= -15 && launchAngle(i) <= 35) &&...
            (sprayAngle(i) >= -45 && sprayAngle(i) <= 45)
        % It's a good hit
        goodHitIndex(i,1) = true;    
    else
        % The hit was not good
        goodHitIndex(i,1) = false;
    end
end

% Add the index to the tables
ghiTable = table(goodHitIndex,'VariableNames', "goodHitIndex");
outTable = [inTable ghiTable];

% Edit the tables to replace bad values with Nan
outTable.Ea(goodHitIndex == 0) = NaN;
outTable.exitVel(goodHitIndex == 0) = NaN;
outTable.impactLocECAP(goodHitIndex == 0) = NaN;
outTable.impactLocKNOB(goodHitIndex == 0) = NaN;

end