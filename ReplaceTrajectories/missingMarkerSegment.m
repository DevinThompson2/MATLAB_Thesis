function [mSeg] = missingMarkerSegment(missingM, segments)
% Inputs: Missing markers and the segments
% Outputs: The segments that the missing markers belong to

fields = fieldnames(segments);
pFound = 0;
found = 0;
mSeg.markers = {};
mSeg.segments = {};
% Loop over segments until each missing marker is found
for i = 1:length(missingM)
    for j = 1:length(fields)
        % disp(segments.(fields{j})) % For debugging
        for k = 1:length(segments.(fields{j}))
            % disp(segments.(fields{j}){k}) % For debugging
            if strcmp(segments.(fields{j}){k},missingM(i)) == 1
                % Missing marker segment has been found
                mSeg.markers{i} = segments.(fields{j});
                mSeg.segments{i} = fields{j};
                found = pFound + 1;
                break
            end   
        end
        if (found - 1) == pFound
            pFound = pFound+1;
            break
        end
    end
end

end

