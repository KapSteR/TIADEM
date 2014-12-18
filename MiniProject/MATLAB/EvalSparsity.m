clc; clear;

dataPath = 'DATA\SST_data_subset.mat'
load(dataPath);

[I,J] = size(sstDataC);
N = I*J;

% Xi = kron(dftmtx(I),dftmtx(J)); % fft
Xi = dctmtx(N);                 % dct

% u = reshape(sstDataC,[N,1]);
u = sstDataC(:);

v = Xi * u;

% k = size(find(abs(v)>10),1)     % fft
k = size(find(abs(v)>0.1),1)    % dct

figure(1)
clf(1)
subplot(211)
plot(u)
% X = fft(u);
% X = v; % fft with matrix multiplication
X = dct(u);
subplot(212)
semilogy(abs(Xi*u))

M = 6*k
%%
select = randperm(N,M);

R = eye(N);
R = R(select,:);

y = R*u;

v_h=SolveBP(R*Xi', y, N);

u_h=Xi'*v_h;

%%
figure(1)
subplot(211)
hold on
plot(real(u_h))
legend('original', 'recovered');

subplot(212)
hold on
semilogy(abs(v_h))
legend('original', 'recovered');
