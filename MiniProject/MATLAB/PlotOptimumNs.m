%% Find optimum number of samples
clc; clear;


%% Input SST data
NormError1 = load('DATA\OptimumNsMSElogSnakeOff.mat')
M = NormError1.M;
Error = NormError1.NormError;

NormError2 = load('DATA\OptimumNsMSElogSnakeOff2.mat')

M = [M(1:end-1) NormError2.M];
Error = [Error(1:end-1) ; NormError2.NormError];


figure(3)
semilogy(M,Error)
xlabel('Number of measurements (M)')
ylabel('Average normalized error')
title('Estimation of N_s')

N_s = 2500;

Error_Ns = (Error(13)+Error(14))/2

figure(3)
line([N_s, N_s], [10^-6, Error_Ns], 'color', 'k')




