%% Find optimum number of samples
clc; clear;


%% Input SST data
NormError1 = load('DATA\OptimumNsMSElogSnakeOff.mat')
figure(3)

M = NormError1.M;
Error = NormError1.NormError;

NormError2 = load('DATA\OptimumNsMSElogSnakeOff.mat')
figure(3)

M = [M NormError2.M];
Error = [Error NormError1.NormError];



semilogy(M,Error)


xlabel('Number of measurements (M)')
ylabel('Average normalized error')
title('Estimation of N_s')

N_s = 2500;

Error_Ns = (Error(13)+Error(14))/2

figure(3)
line([N_s, N_s], [10^-6, Error_Ns], 'color', 'k')




