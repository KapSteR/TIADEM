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

dateString = ncreadatt(dataPath,'/','start_date');
dateOfCollection = dateString(1:10);


% Index steps per degree
latStep = latDim/(northMax-southMax);
lonStep = lonDim/(eastMax-westMax);

% Positive north
upperBound = 56.5;
lowerBound = 56;

% Positive east
leftBound = 11;
rightBound = 12;

% Find index plus zero offset
northIndex = upperBound*latStep + (16000/2);
southIndex = lowerBound*latStep +(16000/2);
eastIndex  = rightBound*lonStep + (36000/2);
westIndex  = leftBound*lonStep + (36000/2);

sstData_raw = ncread(dataPath,'analysed_sst', ...       Set to pull data from.
    [westIndex, southIndex,1], ...                      Start of data grid.
    [northIndex-southIndex, eastIndex-westIndex,1] ...  Indexes to end.
    );

% Convert from Kelvin to centigrade
tempOffset = ncreadatt(dataPath,'analysed_sst','add_offset');
sstDataC = sstData_raw - tempOffset;


figure(2)
clf
contourf(...
    [leftBound:1/lonStep:rightBound-1/lonStep], ...     X-axis indexes
    [lowerBound:1/latStep:upperBound-1/latStep], ...    Y-axis indexes
    sstDataC, ...                                       Z-values
    100, ...                                            Number of levels
    'LineStyle','none' ...                              Hide lines
);

save('DATA\SST_data_subset.mat', 'sstDataC', 'latDim', 'lonDim')


%% Visualize

% colormap('parula')
colormap('jet')
colorbar
xlabel('Degrees East')
ylabel('Degrees North')
grid on
grid minor
title(['Sea Surface Temperature ' dateOfCollection])
    

