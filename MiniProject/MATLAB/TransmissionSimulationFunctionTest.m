% RACS simulation
clear; clc,

load('DATA\SST_data_subset')

[I,J] = size(sstDataC);

N = I*J;

%% Set required parameters

% Probability of sensing
p = 0.90;

% Packet time
Tp = 0.200;	% seconds

% Frame time 3 hours
T = 3600*3; % seconds


[receiveIndex, M] = TransmissionSimulation(N, p, Tp, T);

k = numel(receiveIndex)

received = k/M


