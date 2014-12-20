%% Average number of collision-free packets
clear; clc;

N = 5000;

%% Set required parameters

% Packet time
Tp = 0.200;	% seconds

% Frame time 3 hours
T = 3600*3; % seconds



p = 0:0.001:1;
n_iters = numel(p)

n_retry = 100

tic
for i = 1:n_iters


	q = p(i)*exp(-2*N*p(i)*Tp/(T-Tp)); % Probability of no collision

	k_model = N*q; % Mean of binomial distribution

	for j = 1:n_retry

		k_sim(j) = numel(TransmissionSimulation(N, p(i), Tp, T));

	end

	k_sim = mean(k_sim);

	i
	toc

end


figure(3)
clf(3)
plot(p,k_model,k_sim)
