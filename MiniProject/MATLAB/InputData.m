clear;clc

dataPath = 'DATA\20140915-JPL_OUROCEAN-L4UHfnd-GLOB-v01-fv01_0-G1SST.nc';


ncdisp(dataPath);
lat = ncread(dataPath,'lat');
lon = ncread(dataPath,'lon');

latDim =  size(lat,1);
lonDim =  size(lon,1);

northMax = ncreadatt(dataPath,'/','northernmost_latitude');
southMax = ncreadatt(dataPath,'/','southernmost_latitude');
westMax = ncreadatt(dataPath,'/','westernmost_longitude');
eastMax = ncreadatt(dataPath,'/','easternmost_longitude');


% Index steps per degree
latStep = latDim/(northMax-southMax);
lonStep = lonDim/(eastMax-westMax);

northBound = 60;
southBound = 40;

westBound = 0;
eastBound = 20;

% Find index plus zero offset
northIndex = northBound*latStep + (16000/2);
southIndex = -southBound*latStep +(16000/2);
eastIndex  = eastBound*lonStep + (36000/2);
westIndex  = -westBound*lonStep + (36000/2);







