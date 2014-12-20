function [ receiveIndex, M ] = TransmissionSimulation( N, p, Tp, T )
%TransmissionSimulation Simulates transmission in RACS. 
% Based on Number of nodes, probability of sensing, frame time and transmission time 
% it returns a list of received data indexes


	%% Initialization
	% Generate random number for all data points (nodes)
	selectIndex = rand(N,1);
	
	% Choose for sensing based on p
	selectIndex = find(selectIndex >= p);
	M = numel(selectIndex);

	%% 	- Transmission:	
	% Generate random number for all selected nodes
	% Multiply with frame time
	sendTime = rand(M,1) * T-Tp;

	receiveIndex = selectIndex;


	% For each selected node:
	for i = 1:M

		% Search for other nodes inside +- one transmission time (Collisions)
		colIndex = find((sendTime(i) - Tp) <= sendTime <= (sendTime(i) + Tp));

		% Exclude oneself
		colIndex = find(colIndex ~= i);

		% If collision is detected remove index from list of received data points
		if not(isempty(colIndex))

			receiveIndex = find(receiveIndex ~= selectIndex(i));

		end
	end

	%% Return:
	% 	- receiveIndex
	% 	- M
end

