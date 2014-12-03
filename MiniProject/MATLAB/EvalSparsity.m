clear; clc

dataPath = 'DATA\SST_data_subset.mat'
load(dataPath);

[I,J] = size(sstDataC);

sample = sstDataC(:,37:100)

figure(1)
subplot(211)
% plot(sample)
plot(sstDataC)

% X = fft(sample);
X = fft(sstDataC);
subplot(212)
plot(abs(X))
