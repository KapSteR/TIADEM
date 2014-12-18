%% Input data
clear; clc;

load('DATA\SST_data_subset')

[I,J] = size(sstDataC)

N = I*J;

%% Set required parameters

% Probability of sufficient sensing
Ps = 0.90;

% Packet time
Tp = 0.200 	% seconds

% Frame time
T = 1000 	% seconds

% Coherence time (assumed to be large ie. 1 hour)
Tcoh = 3600; % seconds 

C = 4;

S = 500;




%% Calculate sensing probability

% Ns = C*S*log(N);

% k = Ns;

k = 3200;

%% Cumulative probability of receiving K=k packets

qs_test = 0:0.001:1;

PK = binocdf(k,N,qs_test);

QK = 1-PK;



index = find(QK>= Ps,1)
qs = qs_test(index)

figure(1)
plot(qs_test,QK)

xlim([floor(10*qs-0.1)/10 , ceil(10*qs+0.1)/10])

xlabel('q_s')
ylabel('Q_K(Ns)')

line([0 qs],[Ps Ps],'color','k')
line([qs qs], [0 Ps], 'color', 'k')


