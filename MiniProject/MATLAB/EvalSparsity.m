clc; clear;

dataPath = 'DATA\SST_data_subset.mat'
load(dataPath);

[I,J] = size(sstDataC);
N = I*J;

% Xi = kron(dftmtx(I),dftmtx(J)); % fft
Xi = dctmtx(N);                 % dct

snake = false;

if snake
% Make snake pattern
    for i = 2:2:(I - mod(I,2)) % Mod2 used to compensate in case of odd number of rows

        sstDataC(i,:) = fliplr(sstDataC(i,:));

    end
end

u = reshape(sstDataC,[N,1]);	% Columns
u = reshape(sstDataC',[N,1]);	% Rows
% u = sstDataC(:);

v = Xi * u;

% k = size(find(abs(v)>10),1)		% fft
k = size(find(abs(v)>1*10^-1),1)	% dct
% k = 300; 							% test

figure(1)
clf(1)
subplot(221)
plot(u)
% X = fft(u);
% X = v; % fft with matrix multiplication
X = dct(u);
subplot(222)
semilogy(abs(Xi*u))

M = 6*k
% M = 2500
%%
select = randperm(N,M);

R = eye(N);
R = R(select,:);

y = R*u;

v_h=SolveBP(R*Xi', y, N);

u_h=Xi'*v_h;

% sstDataR = reshape(u_h,[I,J])		% Columns
sstDataR = reshape(u_h,[J,I])';		% Rows

if snake
    % Undo snake pattern
    for i = 2:2:(I - mod(I,2)) % Mod2 used to compensate in case of odd number of rows

        sstDataR(i,:) = fliplr(sstDataR(i,:));
        sstDataC(i,:) = fliplr(sstDataC(i,:));

    end
end

normalizedError = norm(u_h-u)/norm(u)

%% Visualize
figure(1)
subplot(221)
hold on
plot(real(u_h))
legend('original', 'recovered');
title('Vectorized datamap')
xlabel('Data point index')
ylabel('Temperature [C]')

subplot(222)
hold on
semilogy(abs(v_h))
legend('original', 'recovered');
title(['DCT | k = ' num2str(k) ', M = ' num2str(M) ', Snake enabled = ' num2str(snake)])
xlabel('Coefficient index')
ylabel('Magnitude')


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
title(['Original Sea Surface Temperature'])

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
title(['Recovered SST | Norm error = ' num2str(normalizedError)])

hold off



