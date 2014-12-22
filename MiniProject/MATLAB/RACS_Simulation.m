%% RACS simulatiom
clc; clear;
tic

%% Set required parameters
    disp('Set required parameters');
    

    % Probability of sufficient sensing
    Ps = 0.90

    % Packet time
    Tp = 0.200 % seconds

    % Frame time 3 hour(s)
    T = 3600*3 % seconds

    snake = true;

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
        for i = 2:2:I

            sstDataC(i,:) = fliplr(sstDataC(i,:));

        end
    end

    % u = reshape(sstDataC,[N,1]);	% Columns
    u = reshape(sstDataC',[N,1]);	% Rows

% DCT of uncompressed data
    disp('DCT of uncompressed data');
    
    v = Xi * u;

    figure(1)
    clf(1)
    subplot(221)
    plot(u)
    xlabel('Data point index')
    ylabel('Temperature [C]')
    title('Raw data')

    % X = fft(u);
    % X = v; % fft with matrix multiplication
    X = dct(u);
    subplot(222)
    semilogy(abs(Xi*u))
    xlabel('Coefficient index')
    ylabel('Magnitude [C]')
    title('DCT Transform')
    drawnow


%% Estimate probability of sensing
    disp('Estimate probability of sensing');
    toc

    % Ns = 2500                               % Fixed
    Ns = size(find(abs(v)>1*10^-1),1)*6     % DCT
    % k = size(find(abs(v)>10),1)*6           % FFT

    % Find q_s
        qs_test = 0:0.001:1;
        PK = binocdf(Ns,N,qs_test);
        QK = 1-PK;
        index = find(QK>= Ps,1);

        qs = qs_test(index)

    % Show how q_s is found
        figure(2)
        plot(qs_test,QK)

        xlim([round(qs-0.1,1), round(qs+0.1,1)])

        xlabel('q_s')
        ylabel('Q_K(Ns)')

        line([0 qs],[Ps Ps],'color','k')
        line([qs qs], [0 Ps], 'color', 'k')

        title('Required probability of collision-free packet (q_s)')
        drawnow

    % Find p_s
        ps_test = 0:0.001:1;
        Beta = 2*N*Tp/(T-Tp);

        qs_plot = zeros(size(ps_test));

        for i = 1:numel(ps_test);

            qs_plot(i) = ps_test(i) * exp(-Beta * ps_test(i));

        end

        index = find(qs_plot>=qs,1);

        ps = ps_test(index)



    % Show how p_s is found
        figure(3)
        plot(ps_test,qs_plot)

        xlabel('p_s')
        ylabel('q_s')

        line([0 ps],[qs qs],'color','k')
        line([ps ps], [0 qs], 'color', 'k')

        title('Required sensing probability (p_s)')
        drawnow

%% Determine received data
    disp('Determine received data');
    toc

    % Simulate transmission
    [receiveIndex, M, k] = TransmissionSimulation( N, ps, Tp, T );

    % Build R matrix
    R = zeros(M,N);

    for i = 1:k
        R(i,receiveIndex(i)) = 1;
    end

    % Construct received data
    y = R*u;

%% Recunstruct original signel

    v_h=SolveBP(R*Xi', y, N);

    u_h=Xi'*v_h;

    % sstDataR = reshape(u_h,[I,J])		% Columns
    sstDataR = reshape(u_h,[J,I])';		% Rows

    if snake
    % Undo snake pattern
        for i = 2:2:I

            sstDataR(i,:) = fliplr(sstDataR(i,:));
            sstDataC(i,:) = fliplr(sstDataC(i,:));

        end
    end

    % MSE = sum(sum((sstDataC - sstDataR).^2))/N
    normalizedError = norm(u_h-u)/norm(u)

%% Visualize
    disp('Visualize');
    toc
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

    % colormap('parula')
    colormap('jet')
    colorbar
    xlabel('Degrees East')
    ylabel('Degrees North')
    grid on
    grid minor
    title(['Recovered Sea Surface Temperature ' dateOfCollection])


disp('Done');
toc




