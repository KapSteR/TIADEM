% Note: You need to download Sparselab MATLAB library first from http://sparselab.stanford.edu/
% When the signal is sparse in frequency domain, using CS to recover the
% original signal.
clear all;

n=512;

t = [0:n-1]';
x = cos(2*pi/256*t)+cos(2*pi/128*t);


%Psi=inv(fft(eye(n)));
Psi=fft(eye(n));

s=size(find(real(Psi)*x>0.001),1);
m=4*s;

A=randn(m,n);
y=A*x;
xp=SolveBP(A*real(Psi),y,n);

% cvx solver is an alternative solution

% cvx_begin
%     variable xp(n);
%     minimize(norm(xp,1));
%     subject to
%     A*Psi*xp==y;
% cvx_end

figure; plot(x,'b.');hold on; plot(real(Psi*xp),'r-');
legend('Original', 'Recovered');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%using DCT transform to get sparse representation of original signal in DCT domain.


n=512;

t = [0:n-1]';
x = cos(2*pi/256*t)+cos(2*pi/128*t);

Psi_dct=dctmtx(n);
s=size(find(Psi_dct*x>0.001),1);
m=4*s;

A=randn(m,n);
y=A*x;



xp=SolveBP(A*Psi_dct',y,n);


figure; plot(x,'b.');hold on; plot(real(Psi_dct'*xp),'r-');
legend('Original', 'Recovered');
title('Using DCT transform');