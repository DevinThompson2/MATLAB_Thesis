function [tee, bp, cannon, live] = create_plotting_tables(eventNames, teeData, bpData, cannonData, liveData)
% Change this function if more events are added or if more pitch modes.
% This just separates that data and creates names that can easily be
% indexed through

% Create new variables that only have the event tables in them
% Tee
tee.(eventNames{1}) = teeData.StanceData;
tee.(eventNames{2}) = teeData.LoadData;
tee.(eventNames{3}) = teeData.FirstMoveData;
tee.(eventNames{4}) = teeData.FootDownData;
tee.(eventNames{5}) = teeData.ImpactData;
tee.(eventNames{6}) = teeData.FollowThroughData;
% BP
bp.(eventNames{1}) = bpData.StanceData;
bp.(eventNames{2}) = bpData.LoadData;
bp.(eventNames{3}) = bpData.FirstMoveData;
bp.(eventNames{4}) = bpData.FootDownData;
bp.(eventNames{5}) = bpData.ImpactData;
bp.(eventNames{6}) = bpData.FollowThroughData;
% Cannon
cannon.(eventNames{1}) = cannonData.StanceData;
cannon.(eventNames{2}) = cannonData.LoadData;
cannon.(eventNames{3}) = cannonData.FirstMoveData;
cannon.(eventNames{4}) = cannonData.FootDownData;
cannon.(eventNames{5}) = cannonData.ImpactData;
cannon.(eventNames{6}) = cannonData.FollowThroughData;
% Live
live.(eventNames{1}) = liveData.StanceData;
live.(eventNames{2}) = liveData.LoadData;
live.(eventNames{3}) = liveData.FirstMoveData;
live.(eventNames{4}) = liveData.FootDownData;
live.(eventNames{5}) = liveData.ImpactData;
live.(eventNames{6}) = liveData.FollowThroughData;
end

