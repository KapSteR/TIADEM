%% Find optimum number of samples
clc; clear;


%% Input SST data
dataPath = 'DATA\SST_data_subset.mat'
load(dataPath);

[I,J] = size(sstDataC);
N = I*J;

% Xi = kron(dftmtx(I),dftmtx(J)); % fft
Xi = dctmtx(N);                 % dct

snake = true;

if snake
% Make snake pattern
    for i = 2:2:I

        sstDataC(i,:) = fliplr(sstDataC(i,:));

    end
end

u = reshape(sstDataC,[N,1]);	% Columns
u = reshape(sstDataC',[N,1]);	% Rows
% u = sstDataC(:);


%% Start iterating 

M = logspace(0,4,10)
n_iters = numel(M);
MSE = zeros(n_iters,1);
n_retry = 10;
mse = zeros(n_retry,1);

figure(1)
	clf(1)
	xlabel('Number of measurements (M)')
	ylabel('Mean Square Error')

for i = 1:n_iters

	tic
	M(i)

	for j = 1:n_retry

		select = randperm(N,M(i));
		R = eye(N);
		R = R(select,:);

		y = R*u;

		v_h=SolveBP(R*Xi', y, N);

		u_h=Xi'*v_h;

		mse(j) = sum((u-u_h).^2)/N;

	end

	MSE(i) = mean(mse);

	save('DATA\OptimumNsMSESnake', 'MSE', 'M')

	semilogy(M,MSE/max(MSE))
	drawnow

	toc

end