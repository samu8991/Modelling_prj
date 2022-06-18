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

acc_I = zeros(n_experiments, 1); % norm of the difference between target and estimate
acc_D = zeros(n_experiments, 1); 

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
        acc_I(i) = vecnorm(xBest_I-target_I, 2);

        [x_D(i,:), target_D, ~,  ~,  t_D(i), ~, ~] = DIST(T_max, stopThreshold, x0, target, k, showPlots, i); 
        [~, iBest_D] = max(x_D(i,:));
        xBest_D = cell2pos(iBest_D)';
        acc_D(i) = vecnorm(xBest_D-target_D, 2);
        
        fprintf(" target:    \t\t(%.2f, %.2f) \t\t(%.2f, %.2f)\n", target_I(1), target_I(2), target_D(1), target_D(2));
        fprintf(" estimate:  \t\t(%.2f, %.2f) \t\t(%.2f, %.2f)\n", xBest_I(1), xBest_I(2), xBest_D(1), xBest_D(2));
        fprintf(" accuracy:  \t\t%8.3f \t\t%8.3f\n", acc_I(i), acc_D(i));
        fprintf(" time conv: \t\t  %6d \t\t  %6d\n", t_I(i), t_D(i) );
    end
end
avg_acc_I = mean(acc_I);
avg_acc_D = mean(acc_D);
fprintf("The average accuracy of  IST is: %.3f\n", avg_acc_I);
fprintf("The average accuracy of DIST is: %.3f\n", avg_acc_D);


avg_t_I = mean(t_I);
avg_t_D = mean(t_D);
fprintf("The average convergence time of  IST is: %5d\n", avg_t_I);
fprintf("The average convergence time of DIST is: %5d\n", avg_t_D);

save("experiment_b", "-v7.3")


%% output

% 			    (IST)		   (DIST)
% Cycle   1 - 
%  target:    		(9.28, 7.90) 		(9.28, 7.90)
%  estimate:  		(5.50, 5.50) 		(5.50, 5.50)
%  accuracy:  		   4.479 		   4.479
%  time conv: 		   35218 		   29222
% Cycle   2 - 
%  target:    		(9.14, 5.05) 		(9.14, 5.05)
%  estimate:  		(8.50, 7.50) 		(8.50, 7.50)
%  accuracy:  		   2.532 		   2.532
%  time conv: 		    5570 		    5635
% Cycle   3 - 
%  target:    		(2.95, 8.46) 		(2.95, 8.46)
%  estimate:  		(9.50, 7.50) 		(8.50, 7.50)
%  accuracy:  		   6.616 		   5.628
%  time conv: 		   15164 		    8715
% Cycle   4 - 
%  target:    		(6.01, 9.94) 		(6.01, 9.94)
%  estimate:  		(5.50, 5.50) 		(5.50, 5.50)
%  accuracy:  		   4.468 		   4.468
%  time conv: 		   32286 		   29354
% Cycle   5 - 
%  target:    		(1.94, 9.99) 		(1.94, 9.99)
%  estimate:  		(4.50, 5.50) 		(4.50, 5.50)
%  accuracy:  		   5.169 		   5.169
%  time conv: 		   26760 		   31287
% Cycle   6 - 
%  target:    		(8.56, 8.20) 		(8.56, 8.20)
%  estimate:  		(5.50, 5.50) 		(5.50, 5.50)
%  accuracy:  		   4.081 		   4.081
%  time conv: 		   26712 		   18764
% Cycle   7 - 
%  target:    		(1.59, 3.66) 		(1.59, 3.66)
%  estimate:  		(1.50, 0.50) 		(1.50, 0.50)
%  accuracy:  		   3.165 		   3.165
%  time conv: 		   13708 		    9365
% Cycle   8 - 
%  target:    		(7.38, 7.95) 		(7.38, 7.95)
%  estimate:  		(8.50, 7.50) 		(8.50, 7.50)
%  accuracy:  		   1.206 		   1.206
%  time conv: 		   14113 		    9362
% Cycle   9 - 
%  target:    		(2.61, 8.25) 		(2.61, 8.25)
%  estimate:  		(4.50, 7.50) 		(4.50, 7.50)
%  accuracy:  		   2.033 		   2.033
%  time conv: 		   14975 		   12339
% Cycle  10 - 
%  target:    		(4.90, 1.86) 		(4.90, 1.86)
%  estimate:  		(1.50, 0.50) 		(1.50, 0.50)
%  accuracy:  		   3.660 		   3.660
%  time conv: 		   11467 		    8992
% Cycle  11 - 
%  target:    		(7.63, 1.53) 		(7.63, 1.53)
%  estimate:  		(7.50, 6.50) 		(7.50, 6.50)
%  accuracy:  		   4.967 		   4.967
%  time conv: 		    8730 		   10589
% Cycle  12 - 
%  target:    		(2.19, 8.72) 		(2.19, 8.72)
%  estimate:  		(2.50, 1.50) 		(2.50, 1.50)
%  accuracy:  		   7.227 		   7.227
%  time conv: 		   16483 		   13766
% Cycle  13 - 
%  target:    		(7.09, 5.58) 		(7.09, 5.58)
%  estimate:  		(8.50, 6.50) 		(5.50, 7.50)
%  accuracy:  		   1.681 		   2.494
%  time conv: 		   14859 		   12109
% Cycle  14 - 
%  target:    		(8.69, 7.67) 		(8.69, 7.67)
%  estimate:  		(9.50, 8.50) 		(9.50, 8.50)
%  accuracy:  		   1.161 		   1.161
%  time conv: 		   13275 		   13504
% Cycle  15 - 
%  target:    		(3.89, 5.83) 		(3.89, 5.83)
%  estimate:  		(4.50, 3.50) 		(4.50, 3.50)
%  accuracy:  		   2.411 		   2.411
%  time conv: 		    6584 		    6614
% Cycle  16 - 
%  target:    		(6.45, 4.10) 		(6.45, 4.10)
%  estimate:  		(5.50, 6.50) 		(5.50, 6.50)
%  accuracy:  		   2.576 		   2.576
%  time conv: 		   11487 		   10593
% Cycle  17 - 
%  target:    		(9.04, 2.60) 		(9.04, 2.60)
%  estimate:  		(2.50, 1.50) 		(2.50, 1.50)
%  accuracy:  		   6.629 		   6.629
%  time conv: 		   14656 		   15589
% Cycle  18 - 
%  target:    		(5.86, 3.90) 		(5.86, 3.90)
%  estimate:  		(7.50, 4.50) 		(7.50, 4.50)
%  accuracy:  		   1.743 		   1.743
%  time conv: 		   19023 		   14479
% Cycle  19 - 
%  target:    		(5.29, 5.90) 		(5.29, 5.90)
%  estimate:  		(4.50, 4.50) 		(4.50, 4.50)
%  accuracy:  		   1.607 		   1.607
%  time conv: 		   15223 		    8164
% Cycle  20 - 
%  target:    		(6.17, 8.65) 		(6.17, 8.65)
%  estimate:  		(8.50, 7.50) 		(8.50, 7.50)
%  accuracy:  		   2.595 		   2.595
%  time conv: 		   13354 		   10473
% Cycle  21 - 
%  target:    		(1.24, 8.95) 		(1.24, 8.95)
%  estimate:  		(8.50, 9.50) 		(8.50, 9.50)
%  accuracy:  		   7.285 		   7.285
%  time conv: 		   16844 		   14092
% Cycle  22 - 
%  target:    		(6.59, 7.42) 		(6.59, 7.42)
%  estimate:  		(8.50, 7.50) 		(8.50, 7.50)
%  accuracy:  		   1.911 		   1.911
%  time conv: 		   15733 		   12293
% Cycle  23 - 
%  target:    		(6.52, 9.11) 		(6.52, 9.11)
%  estimate:  		(9.50, 8.50) 		(9.50, 8.50)
%  accuracy:  		   3.037 		   3.037
%  time conv: 		   13764 		   11023
% Cycle  24 - 
%  target:    		(2.55, 9.59) 		(2.55, 9.59)
%  estimate:  		(2.50, 1.50) 		(2.50, 1.50)
%  accuracy:  		   8.091 		   8.091
%  time conv: 		   23586 		   21415
% Cycle  25 - 
%  target:    		(9.60, 5.21) 		(9.60, 5.21)
%  estimate:  		(9.50, 8.50) 		(9.50, 8.50)
%  accuracy:  		   3.294 		   3.294
%  time conv: 		   13165 		   15922
% Cycle  26 - 
%  target:    		(7.27, 5.07) 		(7.27, 5.07)
%  estimate:  		(6.50, 7.50) 		(6.50, 7.50)
%  accuracy:  		   2.549 		   2.549
%  time conv: 		    9446 		    8183
% Cycle  27 - 
%  target:    		(3.38, 0.11) 		(3.38, 0.11)
%  estimate:  		(3.50, 3.50) 		(3.50, 3.50)
%  accuracy:  		   3.392 		   3.392
%  time conv: 		   32679 		   29845
% Cycle  28 - 
%  target:    		(3.84, 8.47) 		(3.84, 8.47)
%  estimate:  		(8.50, 0.50) 		(8.50, 0.50)
%  accuracy:  		   9.237 		   9.237
%  time conv: 		   24236 		   15669
% Cycle  29 - 
%  target:    		(7.62, 1.44) 		(7.62, 1.44)
%  estimate:  		(1.50, 0.50) 		(1.50, 0.50)
%  accuracy:  		   6.196 		   6.196
%  time conv: 		   24962 		   23699
% Cycle  30 - 
%  target:    		(6.42, 8.08) 		(6.42, 8.08)
%  estimate:  		(8.50, 7.50) 		(8.50, 7.50)
%  accuracy:  		   2.164 		   2.164
%  time conv: 		   17111 		   15911
% Cycle  31 - 
%  target:    		(2.88, 8.06) 		(2.88, 8.06)
%  estimate:  		(1.50, 4.50) 		(8.50, 5.50)
%  accuracy:  		   3.818 		   6.180
%  time conv: 		   25650 		   17501
% Cycle  32 - 
%  target:    		(3.03, 6.07) 		(3.03, 6.07)
%  estimate:  		(7.50, 3.50) 		(2.50, 1.50)
%  accuracy:  		   5.159 		   4.602
%  time conv: 		   10901 		    8773
% Cycle  33 - 
%  target:    		(2.91, 5.24) 		(2.91, 5.24)
%  estimate:  		(1.50, 2.50) 		(1.50, 2.50)
%  accuracy:  		   3.088 		   3.088
%  time conv: 		   14946 		   17633
% Cycle  34 - 
%  target:    		(2.11, 1.36) 		(2.11, 1.36)
%  estimate:  		(3.50, 3.50) 		(3.50, 3.50)
%  accuracy:  		   2.552 		   2.552
%  time conv: 		   36436 		   27271
% Cycle  35 - 
%  target:    		(7.98, 3.01) 		(7.98, 3.01)
%  estimate:  		(1.50, 4.50) 		(1.50, 4.50)
%  accuracy:  		   6.652 		   6.652
%  time conv: 		   16019 		   12666
% Cycle  36 - 
%  target:    		(8.40, 4.00) 		(8.40, 4.00)
%  estimate:  		(8.50, 7.50) 		(8.50, 7.50)
%  accuracy:  		   3.504 		   3.504
%  time conv: 		   16312 		    9389
% Cycle  37 - 
%  target:    		(8.70, 7.09) 		(8.70, 7.09)
%  estimate:  		(9.50, 8.50) 		(9.50, 8.50)
%  accuracy:  		   1.617 		   1.617
%  time conv: 		   18155 		   14037
% Cycle  38 - 
%  target:    		(4.51, 7.89) 		(4.51, 7.89)
%  estimate:  		(5.50, 7.50) 		(5.50, 7.50)
%  accuracy:  		   1.065 		   1.065
%  time conv: 		   16756 		   15602
% Cycle  39 - 
%  target:    		(5.13, 2.27) 		(5.13, 2.27)
%  estimate:  		(2.50, 0.50) 		(2.50, 0.50)
%  accuracy:  		   3.170 		   3.170
%  time conv: 		   10426 		    7818
% Cycle  40 - 
%  target:    		(9.25, 5.97) 		(9.25, 5.97)
%  estimate:  		(9.50, 8.50) 		(9.50, 8.50)
%  accuracy:  		   2.544 		   2.544
%  time conv: 		    9043 		   10267
% Cycle  41 - 
%  target:    		(0.53, 2.10) 		(0.53, 2.10)
%  estimate:  		(4.50, 2.50) 		(4.50, 2.50)
%  accuracy:  		   3.995 		   3.995
%  time conv: 		   43720 		   34258
% Cycle  42 - 
%  target:    		(5.01, 7.95) 		(5.01, 7.95)
%  estimate:  		(8.50, 7.50) 		(8.50, 7.50)
%  accuracy:  		   3.522 		   3.522
%  time conv: 		   10239 		   10455
% Cycle  43 - 
%  target:    		(8.91, 7.84) 		(8.91, 7.84)
%  estimate:  		(5.50, 5.50) 		(5.50, 5.50)
%  accuracy:  		   4.133 		   4.133
%  time conv: 		   36560 		   30981
% Cycle  44 - 
%  target:    		(4.60, 5.14) 		(4.60, 5.14)
%  estimate:  		(4.50, 3.50) 		(4.50, 3.50)
%  accuracy:  		   1.640 		   1.640
%  time conv: 		   23095 		   12947
% Cycle  45 - 
%  target:    		(8.52, 1.92) 		(8.52, 1.92)
%  estimate:  		(8.50, 7.50) 		(8.50, 7.50)
%  accuracy:  		   5.585 		   5.585
%  time conv: 		   21261 		   17157
% Cycle  46 - 
%  target:    		(0.26, 7.44) 		(0.26, 7.44)
%  estimate:  		(4.50, 3.50) 		(4.50, 3.50)
%  accuracy:  		   5.783 		   5.783
%  time conv: 		   23040 		   18189
% Cycle  47 - 
%  target:    		(2.97, 7.78) 		(2.97, 7.78)
%  estimate:  		(7.50, 6.50) 		(7.50, 6.50)
%  accuracy:  		   4.706 		   4.706
%  time conv: 		   12420 		    9237
% Cycle  48 - 
%  target:    		(2.52, 4.18) 		(2.52, 4.18)
%  estimate:  		(3.50, 0.50) 		(3.50, 0.50)
%  accuracy:  		   3.810 		   3.810
%  time conv: 		   18671 		   14612
% Cycle  49 - 
%  target:    		(0.43, 7.68) 		(0.43, 7.68)
%  estimate:  		(4.50, 3.50) 		(4.50, 3.50)
%  accuracy:  		   5.835 		   5.835
%  time conv: 		   40474 		   33176
% Cycle  50 - 
%  target:    		(2.72, 2.38) 		(2.72, 2.38)
%  estimate:  		(1.50, 0.50) 		(1.50, 0.50)
%  accuracy:  		   2.240 		   2.240
%  time conv: 		   16798 		   12774
% Cycle  51 - 
%  target:    		(0.15, 0.85) 		(0.15, 0.85)
%  estimate:  		(3.50, 1.50) 		(3.50, 1.50)
%  accuracy:  		   3.412 		   3.412
%  time conv: 		   21903 		   17604
% Cycle  52 - 
%  target:    		(8.02, 9.02) 		(8.02, 9.02)
%  estimate:  		(6.50, 5.50) 		(6.50, 5.50)
%  accuracy:  		   3.831 		   3.831
%  time conv: 		   16879 		   12565
% Cycle  53 - 
%  target:    		(3.29, 6.48) 		(3.29, 6.48)
%  estimate:  		(7.50, 5.50) 		(7.50, 5.50)
%  accuracy:  		   4.320 		   4.320
%  time conv: 		    8286 		    6090
% Cycle  54 - 
%  target:    		(1.12, 4.07) 		(1.12, 4.07)
%  estimate:  		(0.50, 0.50) 		(0.50, 0.50)
%  accuracy:  		   3.621 		   3.621
%  time conv: 		   11097 		    9128
% Cycle  55 - 
%  target:    		(0.95, 7.61) 		(0.95, 7.61)
%  estimate:  		(6.50, 8.50) 		(6.50, 8.50)
%  accuracy:  		   5.616 		   5.616
%  time conv: 		   39716 		   32566
% Cycle  56 - 
%  target:    		(4.32, 8.98) 		(4.32, 8.98)
%  estimate:  		(5.50, 1.50) 		(5.50, 1.50)
%  accuracy:  		   7.570 		   7.570
%  time conv: 		    9049 		    6356
% Cycle  57 - 
%  target:    		(1.20, 6.92) 		(1.20, 6.92)
%  estimate:  		(6.50, 6.50) 		(6.50, 6.50)
%  accuracy:  		   5.317 		   5.317
%  time conv: 		   10197 		   11264
% Cycle  58 - 
%  target:    		(9.82, 0.16) 		(9.82, 0.16)
%  estimate:  		(9.50, 9.50) 		(9.50, 9.50)
%  accuracy:  		   9.350 		   9.350
%  time conv: 		   15171 		   12186
% Cycle  59 - 
%  target:    		(2.24, 3.51) 		(2.24, 3.51)
%  estimate:  		(2.50, 9.50) 		(2.50, 9.50)
%  accuracy:  		   5.994 		   5.994
%  time conv: 		   10231 		    7915
% Cycle  60 - 
%  target:    		(4.04, 8.17) 		(4.04, 8.17)
%  estimate:  		(3.50, 9.50) 		(3.50, 9.50)
%  accuracy:  		   1.434 		   1.434
%  time conv: 		   16881 		   15174
% Cycle  61 - 
%  target:    		(1.50, 9.42) 		(1.50, 9.42)
%  estimate:  		(4.50, 4.50) 		(4.50, 4.50)
%  accuracy:  		   5.764 		   5.764
%  time conv: 		   17164 		   15993
% Cycle  62 - 
%  target:    		(6.01, 6.74) 		(6.01, 6.74)
%  estimate:  		(8.50, 6.50) 		(8.50, 6.50)
%  accuracy:  		   2.501 		   2.501
%  time conv: 		    8468 		    6181
% Cycle  63 - 
%  target:    		(2.80, 2.35) 		(2.80, 2.35)
%  estimate:  		(0.50, 0.50) 		(0.50, 0.50)
%  accuracy:  		   2.949 		   2.949
%  time conv: 		    8229 		    6064
% Cycle  64 - 
%  target:    		(2.02, 4.26) 		(2.02, 4.26)
%  estimate:  		(1.50, 9.50) 		(1.50, 9.50)
%  accuracy:  		   5.263 		   5.263
%  time conv: 		   10777 		    4634
% Cycle  65 - 
%  target:    		(6.74, 0.46) 		(6.74, 0.46)
%  estimate:  		(0.50, 5.50) 		(0.50, 5.50)
%  accuracy:  		   8.027 		   8.027
%  time conv: 		    7590 		    5600
% Cycle  66 - 
%  target:    		(6.07, 0.71) 		(6.07, 0.71)
%  estimate:  		(0.50, 0.50) 		(0.50, 0.50)
%  accuracy:  		   5.576 		   5.576
%  time conv: 		    8219 		    6369
% Cycle  67 - 
%  target:    		(9.55, 0.64) 		(9.55, 0.64)
%  estimate:  		(5.50, 6.50) 		(5.50, 6.50)
%  accuracy:  		   7.121 		   7.121
%  time conv: 		   16139 		   18030
% Cycle  68 - 
%  target:    		(3.39, 4.54) 		(3.39, 4.54)
%  estimate:  		(2.50, 9.50) 		(2.50, 9.50)
%  accuracy:  		   5.041 		   5.041
%  time conv: 		   10486 		   11466
% Cycle  69 - 
%  target:    		(5.34, 2.87) 		(5.34, 2.87)
%  estimate:  		(3.50, 3.50) 		(7.50, 2.50)
%  accuracy:  		   1.944 		   2.192
%  time conv: 		    5565 		    3876
% Cycle  70 - 
%  target:    		(4.38, 7.97) 		(4.38, 7.97)
%  estimate:  		(6.50, 8.50) 		(6.50, 8.50)
%  accuracy:  		   2.185 		   2.185
%  time conv: 		   13634 		   13618
% Cycle  71 - 
%  target:    		(7.80, 9.31) 		(7.80, 9.31)
%  estimate:  		(8.50, 2.50) 		(8.50, 2.50)
%  accuracy:  		   6.843 		   6.843
%  time conv: 		   21659 		   14918
% Cycle  72 - 
%  target:    		(7.39, 7.33) 		(7.39, 7.33)
%  estimate:  		(9.50, 8.50) 		(9.50, 8.50)
%  accuracy:  		   2.413 		   2.413
%  time conv: 		    8424 		    5641
% Cycle  73 - 
%  target:    		(2.70, 5.84) 		(2.70, 5.84)
%  estimate:  		(1.50, 1.50) 		(1.50, 1.50)
%  accuracy:  		   4.504 		   4.504
%  time conv: 		   17310 		   10504
% Cycle  74 - 
%  target:    		(1.87, 4.60) 		(1.87, 4.60)
%  estimate:  		(0.50, 2.50) 		(0.50, 2.50)
%  accuracy:  		   2.507 		   2.507
%  time conv: 		   31819 		   21239
% Cycle  75 - 
%  target:    		(4.05, 2.18) 		(4.05, 2.18)
%  estimate:  		(0.50, 0.50) 		(0.50, 0.50)
%  accuracy:  		   3.924 		   3.924
%  time conv: 		    8475 		    4001
% Cycle  76 - 
%  target:    		(2.64, 4.67) 		(2.64, 4.67)
%  estimate:  		(1.50, 1.50) 		(1.50, 1.50)
%  accuracy:  		   3.373 		   3.373
%  time conv: 		   13118 		   14014
% Cycle  77 - 
%  target:    		(4.27, 3.89) 		(4.27, 3.89)
%  estimate:  		(2.50, 9.50) 		(2.50, 9.50)
%  accuracy:  		   5.877 		   5.877
%  time conv: 		   10833 		    7618
% Cycle  78 - 
%  target:    		(1.88, 7.02) 		(1.88, 7.02)
%  estimate:  		(3.50, 0.50) 		(3.50, 0.50)
%  accuracy:  		   6.718 		   6.718
%  time conv: 		    9023 		    7079
% Cycle  79 - 
%  target:    		(3.06, 3.49) 		(3.06, 3.49)
%  estimate:  		(9.50, 4.50) 		(9.50, 4.50)
%  accuracy:  		   6.521 		   6.521
%  time conv: 		   12549 		    9214
% Cycle  80 - 
%  target:    		(3.21, 5.85) 		(3.21, 5.85)
%  estimate:  		(7.50, 3.50) 		(7.50, 3.50)
%  accuracy:  		   4.897 		   4.897
%  time conv: 		    9866 		    7819
% Cycle  81 - 
%  target:    		(7.50, 7.75) 		(7.50, 7.75)
%  estimate:  		(9.50, 8.50) 		(9.50, 8.50)
%  accuracy:  		   2.133 		   2.133
%  time conv: 		    8230 		    6731
% Cycle  82 - 
%  target:    		(3.91, 7.73) 		(3.91, 7.73)
%  estimate:  		(6.50, 7.50) 		(6.50, 7.50)
%  accuracy:  		   2.601 		   2.601
%  time conv: 		   10622 		    9438
% Cycle  83 - 
%  target:    		(2.59, 9.45) 		(2.59, 9.45)
%  estimate:  		(9.50, 8.50) 		(9.50, 8.50)
%  accuracy:  		   6.973 		   6.973
%  time conv: 		   13342 		   12133
% Cycle  84 - 
%  target:    		(0.89, 9.59) 		(0.89, 9.59)
%  estimate:  		(9.50, 8.50) 		(9.50, 8.50)
%  accuracy:  		   8.682 		   8.682
%  time conv: 		   12246 		    7647
% Cycle  85 - 
%  target:    		(0.88, 7.16) 		(0.88, 7.16)
%  estimate:  		(0.50, 0.50) 		(0.50, 0.50)
%  accuracy:  		   6.669 		   6.669
%  time conv: 		   22718 		   13950
% Cycle  86 - 
%  target:    		(6.49, 5.37) 		(6.49, 5.37)
%  estimate:  		(9.50, 4.50) 		(9.50, 4.50)
%  accuracy:  		   3.137 		   3.137
%  time conv: 		   16217 		   11712
% Cycle  87 - 
%  target:    		(8.42, 1.02) 		(8.42, 1.02)
%  estimate:  		(8.50, 8.50) 		(8.50, 8.50)
%  accuracy:  		   7.479 		   7.479
%  time conv: 		   11357 		    9612
% Cycle  88 - 
%  target:    		(0.57, 5.93) 		(0.57, 5.93)
%  estimate:  		(2.50, 9.50) 		(2.50, 9.50)
%  accuracy:  		   4.055 		   4.055
%  time conv: 		    8101 		    5328
% Cycle  89 - 
%  target:    		(9.31, 2.58) 		(9.31, 2.58)
%  estimate:  		(9.50, 8.50) 		(4.50, 9.50)
%  accuracy:  		   5.919 		   8.422
%  time conv: 		   18388 		   13014
% Cycle  90 - 
%  target:    		(9.37, 3.68) 		(9.37, 3.68)
%  estimate:  		(9.50, 6.50) 		(9.50, 6.50)
%  accuracy:  		   2.820 		   2.820
%  time conv: 		   14187 		   11513
% Cycle  91 - 
%  target:    		(4.40, 1.83) 		(4.40, 1.83)
%  estimate:  		(1.50, 9.50) 		(1.50, 9.50)
%  accuracy:  		   8.197 		   8.197
%  time conv: 		    9369 		    7178
% Cycle  92 - 
%  target:    		(4.63, 6.31) 		(4.63, 6.31)
%  estimate:  		(5.50, 7.50) 		(1.50, 3.50)
%  accuracy:  		   1.471 		   4.209
%  time conv: 		   10137 		    6374
% Cycle  93 - 
%  target:    		(9.36, 5.99) 		(9.36, 5.99)
%  estimate:  		(4.50, 8.50) 		(4.50, 8.50)
%  accuracy:  		   5.469 		   5.469
%  time conv: 		   15358 		   14107
% Cycle  94 - 
%  target:    		(1.21, 7.86) 		(1.21, 7.86)
%  estimate:  		(0.50, 9.50) 		(0.50, 9.50)
%  accuracy:  		   1.790 		   1.790
%  time conv: 		   17581 		   13801
% Cycle  95 - 
%  target:    		(8.72, 6.20) 		(8.72, 6.20)
%  estimate:  		(8.50, 8.50) 		(8.50, 8.50)
%  accuracy:  		   2.312 		   2.312
%  time conv: 		   10671 		    7922
% Cycle  96 - 
%  target:    		(8.72, 9.11) 		(8.72, 9.11)
%  estimate:  		(6.50, 5.50) 		(6.50, 5.50)
%  accuracy:  		   4.237 		   4.237
%  time conv: 		   35416 		   32515
% Cycle  97 - 
%  target:    		(6.57, 6.06) 		(6.57, 6.06)
%  estimate:  		(5.50, 8.50) 		(5.50, 8.50)
%  accuracy:  		   2.667 		   2.667
%  time conv: 		    9674 		    7218
% Cycle  98 - 
%  target:    		(3.56, 1.03) 		(3.56, 1.03)
%  estimate:  		(0.50, 9.50) 		(0.50, 9.50)
%  accuracy:  		   9.008 		   9.008
%  time conv: 		   10159 		    6004
% Cycle  99 - 
%  target:    		(9.65, 6.43) 		(9.65, 6.43)
%  estimate:  		(9.50, 8.50) 		(9.50, 8.50)
%  accuracy:  		   2.074 		   2.074
%  time conv: 		   20796 		   13316
% Cycle 100 - 
%  target:    		(5.26, 0.64) 		(5.26, 0.64)
%  estimate:  		(3.50, 6.50) 		(3.50, 6.50)
%  accuracy:  		   6.116 		   6.116
%  time conv: 		   25412 		   18727
% The average accuracy of  IST is: 4.298
% The average accuracy of DIST is: 4.369
% The average convergence time of  IST is: 1.650833e+04
% The average convergence time of DIST is: 1.334676e+04