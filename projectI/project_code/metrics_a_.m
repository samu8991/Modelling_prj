clc
clear
close all

%% Load

load("metrics_a_1.mat")
load("metrics_a_2.mat")

%% Plot first metric
figure(1)
fig = gcf;  
fig.Position(3:4)=[1000,600];
hold on
for k = 1:length(metrics_a_1(:,1))
    plot(metrics_a_1(k,:),'LineWidth',1.5)
end
grid on
title('$|\!|\boldmath{\bf{\bar{x}}}(t)-\!\boldmath{\bf{\tilde{x}}}(t)|\!|_2,\forall t = 1,...,T$', 'interpreter', 'latex')
xlabel('$\bf{time}$','Interpreter','latex')
ylabel('$\bf{instant\hspace{0.20cm}euclidean\hspace{0.20cm}error\hspace{0.20cm}target-estimate}$','Interpreter','latex')
%% Plot second metric
figure(2)
fig = gcf;  
fig.Position(3:4)=[1000,600];
stem(metrics_a_2,'LineWidth',1.5)
grid on
title('$\sum\limits_{h = 1}^{t}{|\!|\boldmath{\bf{\bar{x}}}(t)-\!\boldmath{\bf{\tilde{x}}}(t)}|\!|_2,\forall t = 1,...,T$', 'interpreter', 'latex')
