%%
clc; clear;

%% Input data
NormError1 = load('DATA\MVP_SnakeOn.mat')
p_on = NormError1.p_test;
Error_on = NormError1.AvNormalizedError;

%% Input SST data
NormError = load('DATA\MVP_SnakeOff.mat')
p_of = NormError.M;
Error_off = NormError.AvNormalizedError;

%% Visualize

    figure(1)
    clf(1)
    semilogy(p_off,Error_off)
    hold on
    semilogy(p_on,Error_on)
    hold off
    % line([M_off(1) M_off(end)], [10^-3 10^-3], 'color', 'k', 'LineStyle','--')
    xlabel('Probability of sensing (p_s)')
    ylabel('Average normalized error')
    title('Average normalized error vs. p_s')
    grid on
    grid minor