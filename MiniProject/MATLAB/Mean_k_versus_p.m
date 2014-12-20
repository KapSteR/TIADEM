%% Average number of collision-free packets
clear; clc;

N = 5000;

%% Set required parameters

% Packet time
Tp = 0.200;	% seconds

% Frame time 3 hours
T = 1000; % seconds



p = 0:0.1:1;
n_iters = numel(p)

n_retry = 1

tic
for i = 1:n_iters


	q = p(i)*exp(-2*N*p(i)*Tp/(T-Tp)); % Probability of no collision

	k_model(i) = N*q; % Mean of binomial distribution

	for j = 1:n_retry

		k_sim(j) = numel(TransmissionSimulation(N, p(i), Tp, T));

	end

	k_sim(i) = mean(k_sim);

	i
	toc

end


%% Plot

figure(3)
clf(3)
plot(p,k_model)
hold on
plot(p,k_sim)

xlabel('p')
ylabel('Average number of collision-free packets')
