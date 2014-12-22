%% Find optimum number of samples
clc; clear;


%% Input SST data
NormError1 = load('DATA\OptimumNsMSElogSnakeOff.mat')
figure(3)

M1 = NormError1.M;
Error1 = NormError1.NormError;



semilogy(M,MSE(1:end-1))


xlabel('Number of measurements (M)')
ylabel('Average mean square error (MSE)')
title('Estimation of N_s')

N_s = 2500;

MSE_Ns = (MSE(13)+MSE(14))/2

figure(3)
line([N_s, N_s], [10^-6, MSE_Ns], 'color', 'k')




