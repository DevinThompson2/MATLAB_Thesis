function [outTee, outBP, outCannon, outLive] = stde_signal_matrices(tee, bp, cannon, live)
% Just computes standard error of signal matrices, just improves readability of
% process_Signal

outTee = (std(tee,0,2,'omitnan'))./ (sqrt(size(tee,2)));
outBP = (std(bp,0,2,'omitnan'))./ (sqrt(size(bp,2)));
outCannon = (std(cannon,0,2,'omitnan'))./ (sqrt(size(cannon,2)));
outLive = (std(live,0,2,'omitnan'))./ (sqrt(size(live,2)));

end