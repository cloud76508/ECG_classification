%cd C:\Users\User\Documents\MATLAB\mcode
[sig, Fs, tm] = rdsamp('mitdb/100', 1);
%[sig, Fs, tm] = rdsamp('afdb/00735', 1);
%rdsamp -r 00735
%rdann -r 00735 -a qrs