RACS simulation

	- Initialization
		- Generate random number for all data points (nodes)
		- Choose for sensing based on p (Find(x>p))
	
	- Transmission:
		- Generate random number for all selected nodes
		- Multiply with frame time (mind the end of frame)
		- For each selected node:
			- search for for other nodes inside +- one transmission time
			- If collision is detected remove index from list of received data points

	- Output:
		- List of received data points
		- Percentage of packet reception
	
	- Next:
		- Make into a function or generic callable script
		- Reconstruct
		- Estimate error
		- 

