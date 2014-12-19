RACS simulation

	- Generate random number for all datapoints (nodes)
	- Choose for sensing based on p (Find(x>p))
	
	- Transmission:
		- Generate randon number for all selected nodes
		- Multiply with frame time (mind the end of frame)
		- For each selectec node:
			- search for for other nodes inside +- one transmission time
			- If collision is detected remove index from list of recieved datapoints