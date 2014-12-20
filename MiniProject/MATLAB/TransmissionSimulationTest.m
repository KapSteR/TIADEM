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

k = numel(receiveIndex);

received = k/M


% 	- Output:
% 		- List of received data points
% 		- Percentage of packet reception
	
% 	- Next:
% 		- Make into a function or generic callable script
% 		- Reconstruct
% 		- Estimate error
% 		- 

