clc
clear
close all

%% Load

load("metrics_b.mat")

%% Plot first metric
figure(1)
fig = gcf;  
fig.Position(3:4)=[1000,600];
stem(metrics_b,'LineWidth',1.5)
grid on
title('$|\!|\boldmath{\bf{x}}(t)-\!\boldmath{\bf{x}}(t-1)|\!|_2 < 10^{-3}$', 'interpreter', 'latex')
ylabel('$\bf{no \hspace{0.20cm} iterations }$','Interpreter','latex')