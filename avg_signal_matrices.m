function [outTee, outBP, outCannon, outLive] = avg_signal_matrices(tee, bp, cannon, live)
% Just computes average of signal matrices, just improves readability of
% process_Signal

outTee = mean(tee,2,'omitnan');
outBP = mean(bp,2,'omitnan');
outCannon = mean(cannon,2,'omitnan');
outLive = mean(live,2,'omitnan');
end