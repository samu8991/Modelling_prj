% "Static" localzation (IST-DIST): how many iterations are necessary on
% average? Set a stop criterion of t he kind: if ||x(t) - x(t-1)||_2 < 1e-3,
% then exit

close all
clear all
clc
 
%% Parameters setup
T_max = 5e4;
stopThreshold = 1e-4;
x0 = 0; % always zero initial state 
target = 0; % Automatic target positioning
showPlots = false; % we don't need the plot for each iteration
seed = 0; % for repeatability of random deployment and target positioning
% NOTE: given the seed, the automatic positioning of the sensors and the
% target will result the same for both IST and DIST algorithms.
% The seed will change with the index of the experiment

n = 25;
p = 100;

%% First experiment
% We want to calculate how many iterations are necessary on average for the
% algorithm to converge. The first thing is to ensure that the norm
% ||x(t)-x(t-1)||_2<threshold has the same order of magnitude for both the
% algorithms

% To ensure that, we'll analyze the x_diff component
n_experiments = 1;

% IST measures vectors
x_I = zeros(n_experiments, p, T_max);
x_diff_I = zeros(n_experiments, p, T_max-1);
t_I = zeros(n_experiments, 1);
% discards s
% discard Q

% DIST measures vectors
x_D = zeros(n_experiments, p);
x_diff_D = zeros(n_experiments, p, T_max-1);
t_D = zeros(n_experiments, 1);
% discard s
% discard Q


for i = 1:n_experiments
    [x_I(i,:,:), ~, x_diff_I(i,:,:), t_I(i), ~, ~] = IST(T_max, stopThreshold, x0, target, 1, showPlots, i); 
    [x_D(i,:), ~, x_diff_D(i,:,:), ~,  t_D(i), ~, ~] = DIST(T_max, stopThreshold, x0, target, 1, showPlots, i); 
end

x_diff_D_tmp = squeeze(x_diff_D(1,:,:));
x_diff_I_tmp = squeeze(x_diff_I(1,:,:));


%% Plots
close all

figure
hold on
plot(vecnorm(x_diff_D_tmp, 1, 1),'r');
plot(vecnorm(x_diff_D_tmp, 2, 1),'r--');
plot(sum(x_diff_D_tmp, 1),'r-.');
plot(vecnorm(x_diff_I_tmp, 1, 1),'b');
plot(vecnorm(x_diff_I_tmp, 2, 1),'b--');
plot(sum(x_diff_I_tmp, 1),'b-.');
legend("norm1", "norm2", "sum", "norm1", "norm2", "sum")
xlim([0 3e4]);
ylim([-9e-5 13e-5])

figure
hold on

t_I = t_I - 1;

v1_D = vecnorm(x_diff_D_tmp, 1, 1);
v1_I = vecnorm(x_diff_I_tmp, 1, 1); 
plot(v1_D(1:t_I)-v1_I(1:t_I),'r');

v2_D = vecnorm(x_diff_D_tmp, 2, 1);
v2_I = vecnorm(x_diff_I_tmp, 2, 1); 
plot(v2_D(1:t_I)-v2_I(1:t_I),'b');

s_D = sum(x_diff_D_tmp, 1);
s_I = sum(x_diff_I_tmp, 1); 
plot(s_D(1:t_I)-s_I(1:t_I),'k');

plot(zeros(1,t_I), 'g'); % reference

legend("norm1", "norm2", "sum")
ylim([-6e-5, 3.5e-5]);
title("comparison between metrics for determining early stopping")

% As notable from this second figure, the most similar metrics we can use
% is the sum, but there is a problem. Looking at the first figure, it's
% notable that this metrics go under 0. That's a great indication of
% "overshoot", meaning "we want past the minimum of the function and we're
% tring to get back" which, for this specific instance, indicates a wrong
% setting of lambda and tau. We'll try to adjust them later. 
% For now, we are makein the assumption to use the norm1 as our
% early_stopping indicator.

%% Data gathering 1
% In this section we are going to investigate the difference between the
% centralized algorithm and the decentrilized algorithm evaluating the
% average time to converge (with early stopping)
% We are going to play 100 rounds of localization with random target and
% evaluate the accuracy of the localization using the
% euclidean norm of the distance between the predicted position and the
% actual position and the average convergence time.
% 50 of the 100 round will be performed using a grid deployment, while the
% other 50 will be performed deploying the sensors at random. In both cases
% the sensors will have radius of 4m.
% The target will be generated at random based on the seed of the
% experiment

n_experiments = 100;

% IST measures vectors
x_I = zeros(n_experiments, p, T_max);
x_diff_I = zeros(n_experiments, p, T_max-1);
t_I = zeros(n_experiments, 1);
% discard s
% discard Q

% DIST measures vectors
x_D = zeros(n_experiments, p);
x_diff_D = zeros(n_experiments, p, T_max-1);
t_D = zeros(n_experiments, 1);
% discard s
% discard Q

err_I = zeros(n_experiments, 1); % norm of the difference between target and estimate
err_D = zeros(n_experiments, 1); 

ref_err_I = zeros(n_experiments, 1); % logic array which says if we predicted the right cell
ref_err_D = zeros(n_experiments, 1); 


fprintf("\t\t\t    (IST)\t\t   (DIST)\n");
for k=2:-1:1
    if k == 2 % grid deployment, type A
        first = 1;
        last = n_experiments/2;
    else % random deployment, type B
        first = n_experiments/2 + 1 ;
        last = n_experiments;
    end
    for i = first : last
        fprintf("Cycle %3d - \n", i);

        [x_I(i,:,:), target_I, ~, t_I(i), ~, ~] = IST(T_max, stopThreshold, x0, target, k, showPlots, i); 
        [~, iBest_I] = max(x_I(i,:,t_I(i)));
        xBest_I = cell2pos(iBest_I)';
        err_I(i) = vecnorm(xBest_I-target_I, 2);
        ref_target_I = floor(target_I)+.5;
        if(ref_target_I(1) == xBest_I(1) && ref_target_I(2) == xBest_I(2) )
            ref_err_I(i) = 1;
        end

        [x_D(i,:), target_D, ~,  ~,  t_D(i), ~, ~] = DIST(T_max, stopThreshold, x0, target, k, showPlots, i); 
        [~, iBest_D] = max(x_D(i,:));
        xBest_D = cell2pos(iBest_D)';
        err_D(i) = vecnorm(xBest_D-target_D, 2);
        ref_target_D = floor(target_D)+.5;
        if(ref_target_D(1) == xBest_D(1) && ref_target_D(2) == xBest_D(2))
            ref_err_D(i) = 1;
        end

        fprintf(" target:    \t\t(%.2f, %.2f) \t\t(%.2f, %.2f)\n", target_I(1), target_I(2), target_D(1), target_D(2));
        fprintf(" estimate:  \t\t(%.2f, %.2f) \t\t(%.2f, %.2f)\n", xBest_I(1), xBest_I(2), xBest_D(1), xBest_D(2));
        fprintf(" error:        \t\t%8.3f \t\t%8.3f\n", err_I(i), err_D(i));
        fprintf(" time conv: \t\t  %6d \t\t  %6d\n", t_I(i), t_D(i) );
    end
end
th = 3.5;
avg_err_I = mean(err_I);
avg_err_D = mean(err_D);
fprintf("The average error of  IST is: %.3f\n", avg_err_I);
fprintf("The average error of DIST is: %.3f\n", avg_err_D);

var_err_I = var(err_I);
var_err_D = var(err_D);
fprintf("The error variance of  IST is: %.3f\n", var_err_I);
fprintf("The error variance of DIST is: %.3f\n", var_err_D);

success_rate_I = sum(ref_err_I == 1)/n_experiments;
success_rate_D = sum(ref_err_D == 1)/n_experiments;
fprintf("The success rate of I is: %.3f\n", success_rate_I);
fprintf("The success rate of D is: %.3f\n", success_rate_D);

acc_I = size(find(err_I < th));
acc_I = acc_I(1)/n_experiments;
acc_D = size(find(err_D < th));
acc_D = acc_D(1)/n_experiments;
fprintf("The accuracy of  IST is: %.3f\n", acc_I);
fprintf("The accuracy of DIST is: %.3f\n", acc_D);

avg_t_I = mean(t_I);
avg_t_D = mean(t_D);
fprintf("The average convergence time of  IST is: %5d\n", avg_t_I);
fprintf("The average convergence time of DIST is: %5d\n", avg_t_D);

%% Plot distribution
inter = linspace(0.5,8,11);
vec_I = zeros(1,10);
vec_D = zeros(1,10);
for k=1:length(vec_I)
    v_I = size(find(err_I < inter(k+1) & err_I > inter(k)));
    vec_I(k) = v_I(1)/n_experiments;

    v_D = size(find(err_D < inter(k+1) & err_D > inter(k)));
    vec_D(k) = v_D(1)/n_experiments;
end
figure
% bar(vec_I);
% hold on
% bar(vec_D);
% title('$Probability\hspace{0.2cm}Mass\hspace{0.2cm}distribution $','Interpreter','latex')
% legend('Ist','Dist')
bbb = [vec_I',vec_D']
bar(bbb)
% %% Prova
% % Create data
% close all
% bins = [inter(1) inter(2); 
%     inter(2) inter(3);
%     inter(4) inter(5);
%     inter(6) inter(7);
%     inter(8) inter(9);
%     inter(9) inter(10);
%     inter(10) inter(11)];
% y = vec_I;
% % Create bar plot
% % The .5 specifies bin width, making room for labels
% h = bar(y+.5); 
% 
% % Get bar centers and bar widths
% xCnt = h.XData + h.XOffset; % XOffset is undocumented!
% width =  h.BarWidth; 
% % Get x-val of bar-edges
% barEdgesX = xCnt + width.*[-.5;.5];
% % Set new xtick and xticklabels, rotate by 90deg.
% ax = h.Parent; % axis handle, if you don't have it already
% ax.XTick = barEdgesX(:); 
% ax.XTickLabel = string(reshape(bins',[],1)); 
% ax.XTickLabelRotation = 90;

%% save
save("experiment_b", "-v7.3")
