%% Experiment c
% DIST: which is the relationship between the convergence time and the
% essential spectral radius of the graph?

close all
clear all
clc

%% Parameters setup
showPlots = false; % we don't need the plot for each iteration

n = 25;
p = 100;

% The first thing we need to understand is the relationship between eps and
% esr(Q) with 
% Let's try to graph the two things:
s = deploy(n, 10, 4, 1);
max_eps = 1/max(get_in_degree(s,4));
epsRange = linspace(.0001, max_eps-.001, 30);
esrPoints = zeros(30, 1);
for i = 1:30
    Q = init_Q(s, 4, n, epsRange(i));
    lambda = sort(eig(Q), 'descend');
    assert(abs(1 - lambda(1)) < 1e-5);
    esrPoints(i) = lambda(2);
end

plot(epsRange, esrPoints);
ylabel("esr");
xlabel("\epsilon");

% We found that there is an inversely proportional relationship between eps
% and the esr(Q).

% Thus, increasing eps will result in a smaller esr.
% Let's now run 100 experiments with different epsilon. The deployment will
% be 
seeds = 0:69;
n_experiments = length(seeds);
n_points_per_seed = 30;

% experiment data
times = zeros(n_experiments, n_points_per_seed);
err = zeros(n_experiments, n_points_per_seed);
esrQ = zeros(n_experiments, n_points_per_seed);
success_rate = zeros(n_experiments,1);

m = 0.2;
epsRange = linspace(m, 1-m, n_points_per_seed);

T_max = 1e5;
stopThreshold = 1e-6; 
x0 = 0;
deployment = 1; % random, in general it's better
target = [5.5 5.5]; % Automatic target positioning for the first run
%seed = 6; %In order to generate the same graph each time

for s = seeds
    k = s - min(seeds) + 1;
    for i = 1:n_points_per_seed
        [x, ~, ~, ~,  times(k, i), ~, Q] = DIST(T_max, stopThreshold, x0, target, deployment, showPlots, s, "qEps", epsRange(i) );
        [~, bestI] = max(x);
        p = cell2pos(bestI);
        lambdas = sort(eig(Q));
        esrQ(k, i) = lambdas(2);

        err(k, i) = vecnorm(p-target, 2);
        %                   real target     best estimate   error                convergence time 
        fprintf("Seed: %d Cycle %3d (t:[%4.1f,%4.1f] e:[%4.1f,%4.1f] err:%3.1f) - esr: %8.3f time: %6d\n", s, i, target(1), target(2), p(1), p(2), err(k, i), lambdas(2), times(k, i));
    end
end

%% Plots

average_errors = zeros(length(seeds), 1);
for i = 1:length(seeds)
    figure
    plot(esrQ(i,:), times(i,:), '*');
    xlabel("esr");
    ylabel("convergence time");
    average_errors(i) = mean( err(i,:) );
    success_rate(i) = sum(err(i,:) == 0) / n_points_per_seed;
    fprintf("The average error is %5.2f, the success rate is %4.2f\n", average_errors(i), success_rate(i));
end



save("experiment_c", "-v7.3");


%% Complement
load("experiment_c_15_69.mat")
esrQ_15_69 = esrQ;
times_15_69 = times;
err_15_69 = err;

load("experiment_c_10_14.mat")
esrQ_10_14 = esrQ;
times_10_14 = times;
err_10_14 = err;

load("experiment_c_5_9.mat")
esrQ_5_9 = esrQ;
times_5_9 = times;
err_5_9 = err;

load("experiment_c_0_4.mat")
esrQ_0_4 = esrQ;
times_0_4 = times;
err_0_4 = err;

esrQ = [esrQ_0_4; esrQ_5_9; esrQ_10_14; esrQ_15_69];
times = [times_0_4; times_5_9; times_10_14; times_15_69];
err = [err_0_4; err_5_9; err_10_14; err_15_69];

% normalize times
for i = 1:length(times)
    times(i,:) = (times(i,:) - min(times(i,:))) / max(times(i,:));
end

%% Best method
esrQ_best = uniquetol(esrQ, 1e-2);
buckets = [esrQ_best; inf];
times_best = zeros(length(esrQ_best), 1);
tot_el = 0;
t = zeros(numel(esrQ), 1);
for i = 1:length(times_best)
   lastT = 0;
   for j = 1:numel(esrQ)
       if esrQ(j) < buckets(i+1) && esrQ(j) >= buckets(i) % as specified by uniquetol
            lastT = lastT+1;
            t(lastT) = times(j);
       end
   end
   tot_el = tot_el + lastT;
   times_best(i) = mean(t(1:lastT)); 
end
assert(tot_el == numel(times));

plot(esrQ_best, times_best);
legend("approximated best");
fitted = fit(esrQ_best, times_best, 'poly1');
hold on
plot(fitted);
xlabel("Essential spectral radius");
ylabel("Normalized time");


%% statistics
average_errors = zeros(length(seeds), 1);
for i = 1:length(err(:,1))
    average_errors(i) = mean( err(i,:) );
    success_rate(i) = sum(err(i,:) == 0) / n_points_per_seed;
    fprintf("sr %4.2f, err_avg: %5.2f\n", success_rate(i), average_errors(i));
end