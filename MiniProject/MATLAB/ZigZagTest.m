%% SnakeTest
clc; clear;


%% Input SST data
dataPath = 'DATA\SST_data_subset.mat'
load(dataPath);

[I,J] = size(sstDataC);
N = I*J;

% Xi = kron(dftmtx(I),dftmtx(J)); % fft
Xi = dctmtx(N);                 % dct

% u = reshape(sstDataC,[N,1]);	% Columns
u = reshape(sstDataC',[N,1]);	% Rows
% u = sstDataC(:);

v = Xi * u;

% k = size(find(abs(v)>10),1)		% fft
k = size(find(abs(v)>1*10^-1),1)	% dct
% k = 300; 							% test

figure(2)
clf(1)
subplot(221)
plot(u)
% X = fft(u);
% X = v; % fft with matrix multiplication
X = dct(u);
subplot(222)
semilogy(abs(Xi*u))

M = 6*k

sstDataCZZ = sstDataC;

u_snake = zigzag(sstDataC')';

v_snake = Xi * u_snake;

% k = size(find(abs(v)>10),1)		% fft
k = size(find(abs(v_snake)>1*10^-1),1)	% dct
% k = 300; 							% test

figure(2)
subplot(223)
plot(u_snake)
% X = fft(u);
% X = v; % fft with matrix multiplication
X = dct(u_snake);
subplot(224)
semilogy(abs(Xi*u_snake))

M = 6*k