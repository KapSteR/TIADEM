function [ receiveIndex, M, k ] = TransmissionSimulation( N, p, Tp, T )
%TransmissionSimulation Simulates transmission in RACS. 
% Based on Number of nodes, probability of sensing, frame time and transmission time 
% it returns a list of received data indexes

	%% DEBUG

	% if p>= 0.7;
	% 	disp('Test');
	% end


	%% Initialization
	% Generate random number for all data points (nodes)
	selectIndex = rand(N,1);
	
	% Choose for sensing based on p
	selectIndex = find(selectIndex <= p);
	M = numel(selectIndex);

	%% 	- Transmission:	
	% Generate random number for all selected nodes
	% Multiply with frame time
	sendTime = rand(M,1) * (T-Tp);


	receiveIndex = selectIndex;

	% For each selected node:
	for i = 1:M


		beforeIndex = find(sendTime < sendTime(i)-Tp);
		afterIndex  = find(sendTime > sendTime(i)+Tp);

		% Remove all messages before
		colIndex = setdiff([1:M],beforeIndex);
		% Remove all messages after
		colIndex = setdiff(colIndex,afterIndex);
		% Exclude oneself
		colIndex = setdiff(colIndex, i);

		% If collision is detected remove index from list of received data points
		if not(isempty(colIndex))

            % receiveIndex = find(receiveIndex ~= selectIndex(i));
            receiveIndex = setdiff(receiveIndex, selectIndex(i));

		end
	end

	k = numel(receiveIndex);

	%% Return:
	% 	- receiveIndex
	% 	- M
	%	- k
end

