clear;clc

dataPath = 'DATA\20140915-JPL_OUROCEAN-L4UHfnd-GLOB-v01-fv01_0-G1SST.nc';


ncdisp(dataPath);
lat = ncread(dataPath,'lat');
lon = ncread(dataPath,'lon');

latDim =  size(lat,1);
lonDim =  size(lon,1);

northMax = ncreadatt(dataPath,'/','northernmost_latitude')
southMax = ncreadatt(dataPath,'/','southernmost_latitude')
westMax = ncreadatt(dataPath,'/','westernmost_longtitude')
eastMax = ncreadatt(dataPath,'/','easternmost_longtitude')


% Index steps per degree
latStep = (northMax-southMax)/latDim;
lonStep = (eastMax-westMax)/lonDim;

northBound = 60;
southBound = 40;

westbound = 0;
eastbound = 20;

northIndex = 

