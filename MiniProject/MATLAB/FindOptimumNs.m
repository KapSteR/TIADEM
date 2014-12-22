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

M = [4000:500:5000]/100
n_iters = numel(M);
n_retry = 12;
% MSE = zeros(n_iters,1);
% mse = zeros(n_retry,1);
NormError = zeros(n_iters,1);

figure(1)
	clf(1)
	xlabel('Number of measurements (M)')
	ylabel('Mean Square Error')

for i = 1:n_iters

	tic
	M(i)

	TempError = zeros(n_retry,1);

	for j = 1:n_retry

		select = randperm(N,M(i));
		R = eye(N);
		R = R(select,:);

		y = R*u;

		v_h=SolveBP(R*Xi', y, N);

		u_h=Xi'*v_h;

		% mse(j) = sum((u-u_h).^2)/N;
		TempError(j) = norm(u_h-u)/norm(u);

	end

	% MSE(i) = mean(mse);
	NormError(i) = mean(TempError)
	% NormError(i) = NormError/n_retry;

	

	semilogy(M,NormError)
	drawnow

	toc

end

NormError = cell2mat(NormError);

save('DATA\OptimumNsMSELogSnakeOff2', 'NormError', 'M')