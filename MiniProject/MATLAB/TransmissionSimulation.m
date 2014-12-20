function [ receiveIndex ] = transmissionSimulation( N, p, Tp, T )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

	%% 	- Initialization
	% 		- Generate random number for all data points (nodes)
	% 		- Choose for sensing based on p (Find(x>p))

	selectIndex = rand(N,1);
	selectIndex = find(selectIndex >= p);
		
	%% 	- Transmission:
	% 		- Generate random number for all selected nodes
	% 		- Multiply with frame time (mind the end of frame)
	% 		- For each selected node:
	% 			- search for other nodes inside +- one transmission time
	% 			- If collision is detected remove index from list of received data points

	M = numel(selectIndex);

	sendTime = rand(M,1) * T-Tp;

	receiveIndex = selectIndex;

	for i = 1:M

		% Search for transmission collisions
		colIndex = find((sendTime(i) - Tp) <= sendTime <= (sendTime(i) + Tp));

		% Exclude oneself
		colIndex = find(colIndex ~= i);

		% Remove from received set
		if not(isempty(colIndex))

			receiveIndex = find(receiveIndex ~= selectIndex(i));

		end
	end
end

