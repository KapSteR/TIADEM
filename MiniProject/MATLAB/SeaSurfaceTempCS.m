
clear all; clc;
load SeaSurfaceTemp10min.mat;

n=size(SST,1);
Psi_dct= dctmtx(n);

figure(1)
subplot(221)
plot(SST);
title('Sea Surface Temperature');

figure(1)
subplot(222)
plot(Psi_dct*SST);
title('DCT domain of Sea Surface Temperature');

k= size(find(abs(Psi_dct*SST)>0.1),1);

m=6*k;

A=randn(m,n);
y=A*SST;

d_h=SolveBP(A*Psi_dct', y, n);

SST_h=Psi_dct'*d_h;

figure(1)
subplot(2,2,[3 4])
plot(SST,'b.'); hold on;
plot(SST_h,'r-');
legend('original', 'recovered');
title('Sea Surface Temperature Recovery by CS, m=6k');
fprintf('Normalized MSE for CS is %f\n',mse(SST-SST_h)/mse(SST));

