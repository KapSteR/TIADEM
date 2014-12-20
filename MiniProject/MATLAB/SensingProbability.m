%% Input data
clear; clc;

load('DATA\SST_data_subset')

[I,J] = size(sstDataC);

N = I*J;

%% Set required parameters

% Probability of sufficient sensing
Ps = 0.90;

% Packet time
Tp = 0.200;	% seconds

% Frame time 3 hours
T = 3600; % seconds

% Coherence time (assumed to be large ie. 1 hour)
Tcoh = T; 	% seconds 

C = 2;

S = 500;
% S = 200;




%% Calculate sensing probability

% Ns = C*S*log10(N);
Ns = 2500;

k = Ns;


% Find q_s
qs_test = 0:0.001:1;
PK = binocdf(k,N,qs_test);
QK = 1-PK;
index = find(QK>= Ps,1);

qs = qs_test(index)


figure(1)
plot(qs_test,QK)

xlim([round(qs-0.1,1), round(qs+0.1,1)])

xlabel('q_s')
ylabel('Q_K(Ns)')

line([0 qs],[Ps Ps],'color','k')
line([qs qs], [0 Ps], 'color', 'k')

title('Required probability of collision-free packet (q_s)')

% Find p_s
ps_test = 0:0.001:1;
Bmin = 2*N*Tp/(Tcoh-Tp);

qs_plot = zeros(size(ps_test));

for i = 1:numel(ps_test);

	qs_plot(i) = ps_test(i) * exp(-Bmin * ps_test(i));

end


index = find(qs_plot>=qs,1);

ps = ps_test(index)




figure(2)
plot(ps_test,qs_plot)

xlabel('p_s')
ylabel('q_s')

line([0 ps],[qs qs],'color','k')
line([ps ps], [0 qs], 'color', 'k')

title('Required sensing probability (p_s)')


