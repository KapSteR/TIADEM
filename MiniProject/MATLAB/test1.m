% Note: You need to download Sparselab MATLAB library first from http://sparselab.stanford.edu/
clear all;

n=512; % number of samples
k=25;  % sparsity
m=6*k; % number of measurement


x=zeros(n,1);
q=randperm(n);
x(q(1:k))=randn(k,1); % generate a sparse signal f with sparsity k and the total number of entries equal to n;
A=randn(m,n); % measurement matrix
%A=orth(A')';  % return the orthonormal basis of matrix A
y=A*x;        % encoding process



xp=SolveBP(A,y,n); % using Basis Pursuit solver to find the estimation of x

% You can also use cvx to solve the l1 minimiation problem. However,
% SolveBP is probably faster.

% cvx_begin
%     variable xp(n);
%     minimize(norm(xp,1));
%     subject to
%     A*xp == y;
% cvx_end


figure;
plot(x);
hold on;
plot(xp, 'r.');
legend('original', 'recovered');