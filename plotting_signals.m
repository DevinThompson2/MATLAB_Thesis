function [upper, lower, inBetween] = plotting_signals(avg, stde)
%Graphing variables based on avg and stde

upper = avg+stde;
lower = avg-stde;
inBetween = [upper; flipud(lower)]';

end