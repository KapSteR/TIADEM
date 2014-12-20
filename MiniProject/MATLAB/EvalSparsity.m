clc; clear;

dataPath = 'DATA\SST_data_subset.mat'
load(dataPath);

[I,J] = size(sstDataC);
N = I*J;

% Xi = kron(dftmtx(I),dftmtx(J)); % fft
Xi = dctmtx(N);                 % dct

u = reshape(sstDataC,[N,1]);	% Columns
u = reshape(sstDataC',[N,1]);	% Rows
% u = sstDataC(:);

v = Xi * u;

% k = size(find(abs(v)>10),1)		% fft
k = size(find(abs(v)>1*10^-1),1)	% dct
% k = 300; 							% test

figure(1)
clf(1)
subplot(221)
plot(u)
% X = fft(u);
% X = v; % fft with matrix multiplication
X = dct(u);
subplot(222)
semilogy(abs(Xi*u))

M = 6*k
M = 2500
%%
select = randperm(N,M);

R = eye(N);
R = R(select,:);

y = R*u;

v_h=SolveBP(R*Xi', y, N);

u_h=Xi'*v_h;

% sstDataR = reshape(u_h,[I,J])		% Columns
sstDataR = reshape(u_h,[J,I])';		% Rows

%% Visualize
figure(1)
subplot(221)
hold on
plot(real(u_h))
legend('original', 'recovered');

subplot(222)
hold on
semilogy(abs(v_h))
legend('original', 'recovered');


subplot(223)
contourf(...
    [leftBound:1/lonStep:rightBound-1/lonStep], ...     X-axis indexes
    [lowerBound:1/latStep:upperBound-1/latStep], ...    Y-axis indexes
    sstDataC, ...                                       Z-values
    100, ...                                            Number of levels
    'LineStyle','none' ...                              Hide lines
);



% colormap('parula')
colormap('jet')
colorbar
xlabel('Degrees East')
ylabel('Degrees North')
grid on
grid minor
title(['Original Sea Surface Temperature ' dateOfCollection])

subplot(224)
contourf(...
    [leftBound:1/lonStep:rightBound-1/lonStep], ...     X-axis indexes
    [lowerBound:1/latStep:upperBound-1/latStep], ...    Y-axis indexes
    sstDataR, ...                                       Z-values
    100, ...                                            Number of levels
    'LineStyle','none' ...                              Hide lines
);

%% Visualize

% colormap('parula')
colormap('jet')
colorbar
xlabel('Degrees East')
ylabel('Degrees North')
grid on
grid minor
title(['Recovered Sea Surface Temperature ' dateOfCollection])




