%% Find optimum number of samples
clc; clear;


%% Input SST data
NormError1 = load('DATA\OptimumNsMSElogSnakeOff.mat')
M_on = NormError1.M;
Error_on = NormError1.NormError;

NormError2 = load('DATA\OptimumNsMSElogSnakeOff2.mat')

M_on = [M_on(1:end-1) NormError2.M];
Error_on = [Error_on(1:end-1) ; NormError2.NormError];

%% Input SST data
NormError = load('DATA\OptimumNsMSElogSnakeOffReally.mat')
M_off = NormError.M;
Error_off = NormError.NormError;

figure(3)
clf(3)
semilogy(M_off,Error_off)
hold on
semilogy(M_on,Error_on)
hold off
xlabel('Number of measurements (M)')
ylabel('Average normalized error')
title('Estimation of N_s')
grid on
grid minor

% N_s = 2500;

% Error_Ns = (Error(13)+Error(14))/2

% figure(3)
% line([N_s, N_s], [10^-6, Error_Ns], 'color', 'k')




