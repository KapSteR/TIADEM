%% RACS simulatiom
clc; clear;

%% Set required parameters

    % Probability of sufficient sensing
    Ps = 0.90;

    % Packet time
    Tp = 0.200; % seconds

    % Frame time 1 hour
    T = 3600; % seconds

%% Input data
    dataPath = 'DATA\SST_data_subset.mat'
    load(dataPath);

    [I,J] = size(sstDataC);
    N = I*J;

    % Xi = kron(dftmtx(I),dftmtx(J)); % fft
    Xi = dctmtx(N);                 % dct

    u = reshape(sstDataC,[N,1]);	% Columns
    u = reshape(sstDataC',[N,1]);	% Rows

% DCT of uncompressed data
    v = Xi * u;

    figure(1)
    clf(1)
    subplot(221)
    plot(u)
    % X = fft(u);
    % X = v; % fft with matrix multiplication
    X = dct(u);
    subplot(222)
    semilogy(abs(Xi*u))


%% Estimate probability of sensing

    Ns = 2500

    k = Ns;


    % Find q_s
        qs_test = 0:0.001:1;
        PK = binocdf(k,N,qs_test);
        QK = 1-PK;
        index = find(QK>= Ps,1);

        qs = qs_test(index)


        figure(1)
        plot(qs_test,QK)

        xlim([round(qs-0.1,1), round(qs+0.1,1)])

        xlabel('q_s')
        ylabel('Q_K(Ns)')

        line([0 qs],[Ps Ps],'color','k')
        line([qs qs], [0 Ps], 'color', 'k')

        title('Required probability of collision-free packet (q_s)')

    % Find p_s
        ps_test = 0:0.001:1;
        Bmin = 2*N*Tp/(Tcoh-Tp);

        qs_plot = zeros(size(ps_test));

        for i = 1:numel(ps_test);

            qs_plot(i) = ps_test(i) * exp(-Bmin * ps_test(i));

        end


        index = find(qs_plot>=qs,1);

        ps = ps_test(index)




        figure(2)
        plot(ps_test,qs_plot)

        xlabel('p_s')
        ylabel('q_s')

        line([0 ps],[qs qs],'color','k')
        line([ps ps], [0 qs], 'color', 'k')

        title('Required sensing probability (p_s)')

%% Determine selection matrix

TransmissionSimulation( N, p, Tp, T )


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




