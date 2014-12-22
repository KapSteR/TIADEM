%% Reconstruction error vs. p
clear; clc;

%% Set required parameters
    disp('Set required parameters');

    % Packet time
    Tp = 0.200 % seconds

    % Frame time: 1/2 hour(s)
    T = 1800 % seconds

    % Enable/Disable snake pattern (true = enable / false = disable)
    snake = false;

%% Input data
    disp('Input data');
    
    dataPath = 'DATA\SST_data_subset.mat';
    load(dataPath);

    [I,J] = size(sstDataC);
    N = I*J;

    % Xi = kron(dftmtx(I),dftmtx(J)); % fft
    Xi = dctmtx(N);                 % dct

    if snake
    % Make snake pattern
        for i = 2:2:(I - mod(I,2)) % Mod2 used to compensate in case of odd number of rows

            sstDataC(i,:) = fliplr(sstDataC(i,:));

        end
    end

    % u = reshape(sstDataC,[N,1]);  % Columns
    u = reshape(sstDataC',[N,1]);   % Rows

%% Setup test
    p_test = [0:0.1:1];
    n_iters = numel(p_test);
    n_retry = 1;

    normalizedError = zeros(n_retry,1);
    AvNormalizedError = zeros(n_iters,1);

%% Start test
    tic
    for i = 1:n_iters

        for j = 1:n_retry

        %% Determine received data
            disp('Determine received data');
            

            % Simulate transmission
            [receiveIndex, M, k] = TransmissionSimulation( N, p_test(i), Tp, T );

            % Build R matrix
            R = zeros(M,N);

            for k = 1:k
                R(k,receiveIndex(k)) = 1;
            end

            % Construct received data
            y = R*u;

        %% Recunstruct original signel

            v_h=SolveBP(R*Xi', y, N);

            u_h=real(Xi'*v_h);

            % % sstDataR = reshape(u_h,[I,J])		% Columns
            % sstDataR = reshape(u_h,[J,I])';		% Rows

            % if snake
            % % Undo snake pattern
            %     for i = 2:2:(I - mod(I,2)) % Mod2 used to compensate in case of odd number of rows

            %         sstDataR(i,:) = fliplr(sstDataR(i,:));
            %         sstDataC(i,:) = fliplr(sstDataC(i,:));

            %     end
            % end

            % MSE = sum(sum((sstDataC - sstDataR).^2))/N
            normalizedError(j) = norm(u_h-u)/norm(u);
            j

        end

        AvNormalizedError(i) = mean(normalizedError);

        p_test(i)
        toc
    end

save('DATA\MVP_SnakeOff', 'p_test', 'AvNormalizedError', 'snake');