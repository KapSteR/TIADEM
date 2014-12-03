% Note: You need to download Sparselab MATLAB library first from http://sparselab.stanford.edu/
% When the signal is sparse in frequency domain, using CS to recover the
% original signal.

clear all;
n=512;
s=6;
m=6*s;
amp = rand(s, 1);
periods= [16, 32, 64, 128, 256, 512];
tmp=randperm(length(periods));
freq = (2*pi./round(periods(tmp(1:s))));
phase = 2*pi*rand(s,1);
x = zeros(n,1);
t = [0: n-1]';
for k= 1:s
    x=x+amp(k)*cos(freq(k)*t)+phase(k);
end

A=randn(m,n);
y=A*x;

Psi=inv(fft(eye(n)));
%Psi=fft(eye(n));
xp=SolveBP(A*real(Psi),y,n);
% cvx_begin
%     variable xp(n);
%     minimize(norm(xp,1));
%     subject to
%     A*Psi*xp==y;
% cvx_end

figure; plot(x,'b.');hold on; plot(real(Psi*xp),'r-');
legend('Original', 'Recovered');
title('m=6*s');
fprintf('Normalized MSE for CS (m=6s) is %f\n',mse(x-real(Psi*xp))/mse(x));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



m=4*s;

AA=randn(m,n);
yy=AA*x;

%Psi=inv(fft(eye(n)));

xp=SolveBP(AA*real(Psi),yy,n);

% cvx_begin
%     variable xp(n);
%     minimize(norm(xp,1));
%     subject to
%     A*Psi*xp==y;
% cvx_end

figure; plot(x,'b.');hold on; plot(real(Psi*xp),'r-');
legend('Original', 'Recovered');
title('m=4*s');
fprintf('Normalized MSE for CS (m=4s) is %f\n',mse(x-real(Psi*xp))/mse(x));
