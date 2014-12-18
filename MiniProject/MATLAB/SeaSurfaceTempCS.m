
clear all; clc;
load SeaSurfaceTemp10min.mat;

% ymd = num2str(YYYYMMDD);
% hms = num2str(HHMMSS);
% 
% YYYY = str2num(ymd(:,1:4));
% MM = str2num(ymd(:,5:6));
% DD = str2num(ymd(:,7:8));
% 
% hh = str2num(hms(:,1:2));
% mm = str2num(hms(:,3:4));
% ss = str2num(hms(:,5:6));

YYYY = floor(YYYYMMDD/10^4);
MM = floor(mod(YYYYMMDD,10^4)/10^2);
DD = mod(YYYYMMDD,10^2);

hh = floor(HHMMSS/10^4);
mm = floor(mod(HHMMSS,10^2)/10^2);
ss = mod(HHMMSS,10^2);

time = datetime(YYYY,MM,DD,hh,mm,ss);

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

k = size(find(abs(Psi_dct*SST)>0.1),1)

m=6*k

A=randn(m,n);
y=A*SST;

d_h=SolveBP(A*Psi_dct', y, n);

SST_h=Psi_dct'*d_h;
%%
figure(1)
subplot(2,2,[3 4])
plot(time,SST,'b.'); hold on;
% plotyy(time,SST_h,time,((SST_h-SST)/SST).^2);
plot(time,SST_h,'r-');
legend('original', 'recovered');
title('Sea Surface Temperature Recovery by CS, m=6k');
fprintf('Normalized MSE for CS is %f\n',mse(SST-SST_h)/mse(SST));
