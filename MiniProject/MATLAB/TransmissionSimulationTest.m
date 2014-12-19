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

select = rand(N,1);
select = find(select >= p);
	
%% 	- Transmission:
% 		- Generate random number for all selected nodes
% 		- Multiply with frame time (mind the end of frame)
% 		- For each selected node:
% 			- search for other nodes inside +- one transmission time
% 			- If collision is detected remove index from list of received data points

k = numel(select);

sendTime = rand(k,1) * T;

for i = 1:k

	index = find(sendTime >= (sendTime(i) - Tp) && sendTime <= (sendTime(i) + Tp))

end


% 	- Output:
% 		- List of received data points
% 		- Percentage of packet reception
	
% 	- Next:
% 		- Make into a function or generic callable script
% 		- Reconstruct
% 		- Estimate error
% 		- 

