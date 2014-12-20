%% Find optimum number of samples
clc; clear;


%% Input SST data

load('DATA\SST_data_subset.mat');
load('DATA\OptimumNsMSEVeryLarge.mat')

[I,J] = size(sstDataC);
N = I*J;


figure(1)
semilogy(M(1:end-1),MSE(1:end-1))
