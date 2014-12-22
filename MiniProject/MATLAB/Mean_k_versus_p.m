%% Average number of collision-free packets
clear; clc;

N = 5000;

%% Set required parameters

% Packet time
Tp = 0.200;	% seconds

% Frame time 3 hours
T = 1800; % seconds



p = 0:0.05:1;
n_iters = numel(p)

n_retry = 5;
j = 1;
tic
for i = 1:n_iters;


	q = p(i)*exp(-2*N*p(i)*Tp/(T-Tp)); % Probability of no collision

	k_model(i) = N*q; % Mean of binomial distribution

	k_sim_temp = zeros(n_retry,1);
	for j = 1:n_retry

		k_sim_temp(j) = numel(TransmissionSimulation(N, p(i), Tp, T));
		% k_sim(i,j) = numel(TransmissionSimulation(N, p(i), Tp, T));
		j

	end

	k_sim(i) = mean(k_sim_temp);

	p(i)
	toc

end
toc

%% Plot

figure(3)
clf(3)
plot(p,k_model)
hold on
plot(p,k_sim)
hold off

xlabel('p')
ylabel('Average number of collision-free packets')
legend('Binomial model', 'Simulated results', 'Location','southeast')
title(['Collision-free packets | T = ' num2str(T) ', T_p = ' num2str(Tp)])
grid on
grid minor
