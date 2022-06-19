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
n_experiments = 100;

T_max = 1e5;
stopThreshold = 1e-5; 
x0 = 0;
deployment = 1; % random
t = zeros(n_experiments, 1);
err = zeros(n_experiments, 1);
m = 0.2;
epsRange = linspace(m, 1-m, n_experiments);
esrQ = zeros(n_experiments, 1);
target = [5.5 5.5]; % Automatic target positioning for the first run
seed = 6; %In order to generate the same graph each time

for i = 1:n_experiments
    [x, target, ~, ~,  t(i), ~, Q] = DIST(T_max, stopThreshold, x0, target, deployment, showPlots, seed, "qEps", epsRange(i) );
    [~, bestI] = max(x);
    p = cell2pos(bestI);
    lambdas = sort(eig(Q));
    esrQ(i) = lambdas(2);
    
    err(i) = vecnorm(p-target, 2);
    %                   real target     best estimate   error                convergence time 
    fprintf("Cycle %3d (t:[%4.1f,%4.1f] e:[%4.1f,%4.1f] err:%3.1f) - esr: %8.3f time: %6d\n", i, target(1), target(2), p(1), p(2), err(i), lambdas(2), t(i));
end

%% Plots

figure
plot(esrQ, t);
xlabel("esr");
ylabel("convergence time");

save("experiment_c", "-v7.3");


%% Output
% comparison plot( ((log(esrQ(1:76))+4)/4), -esrQ(1:76))


% Cycle   1 (t:[ 2.3, 5.3] e:[ 9.5, 9.5] acc:8.3) - esr:    0.987 time:   1859
% Cycle   2 (t:[ 2.3, 5.3] e:[ 2.5, 0.5] acc:4.8) - esr:    0.974 time:   3505
% Cycle   3 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:    0.961 time:  16899
% Cycle   4 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:    0.948 time:  22814
% Cycle   5 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:    0.935 time:  27466
% Cycle   6 (t:[ 2.3, 5.3] e:[ 2.5, 0.5] acc:4.8) - esr:    0.922 time:  32683
% Cycle   7 (t:[ 2.3, 5.3] e:[ 2.5, 0.5] acc:4.8) - esr:    0.909 time:  36198
% Cycle   8 (t:[ 2.3, 5.3] e:[ 2.5, 0.5] acc:4.8) - esr:    0.896 time:  39383
% Cycle   9 (t:[ 2.3, 5.3] e:[ 2.5, 0.5] acc:4.8) - esr:    0.883 time:  43180
% Cycle  10 (t:[ 2.3, 5.3] e:[ 2.5, 0.5] acc:4.8) - esr:    0.870 time:  47821
% Cycle  11 (t:[ 2.3, 5.3] e:[ 2.5, 0.5] acc:4.8) - esr:    0.857 time:  52901
% Cycle  12 (t:[ 2.3, 5.3] e:[ 2.5, 0.5] acc:4.8) - esr:    0.844 time:  58045
% Cycle  13 (t:[ 2.3, 5.3] e:[ 2.5, 0.5] acc:4.8) - esr:    0.831 time:  54348
% Cycle  14 (t:[ 2.3, 5.3] e:[ 2.5, 0.5] acc:4.8) - esr:    0.818 time:  55357
% Cycle  15 (t:[ 2.3, 5.3] e:[ 2.5, 0.5] acc:4.8) - esr:    0.805 time:  54372
% Cycle  16 (t:[ 2.3, 5.3] e:[ 2.5, 0.5] acc:4.8) - esr:    0.792 time:  53326
% Cycle  17 (t:[ 2.3, 5.3] e:[ 2.5, 0.5] acc:4.8) - esr:    0.779 time:  54965
% Cycle  18 (t:[ 2.3, 5.3] e:[ 2.5, 0.5] acc:4.8) - esr:    0.766 time:  56631
% Cycle  19 (t:[ 2.3, 5.3] e:[ 2.5, 0.5] acc:4.8) - esr:    0.753 time:  58078
% Cycle  20 (t:[ 2.3, 5.3] e:[ 2.5, 0.5] acc:4.8) - esr:    0.740 time:  62291
% Cycle  21 (t:[ 2.3, 5.3] e:[ 2.5, 0.5] acc:4.8) - esr:    0.727 time:  71967
% Cycle  22 (t:[ 2.3, 5.3] e:[ 2.5, 0.5] acc:4.8) - esr:    0.714 time:  83970
% Cycle  23 (t:[ 2.3, 5.3] e:[ 2.5, 0.5] acc:4.8) - esr:    0.701 time:  95022
% Cycle  24 (t:[ 2.3, 5.3] e:[ 2.5, 0.5] acc:4.8) - esr:    0.688 time: 100000
% Cycle  25 (t:[ 2.3, 5.3] e:[ 2.5, 0.5] acc:4.8) - esr:    0.675 time:  98424
% Cycle  26 (t:[ 2.3, 5.3] e:[ 2.5, 0.5] acc:4.8) - esr:    0.662 time:  92497
% Cycle  27 (t:[ 2.3, 5.3] e:[ 2.5, 0.5] acc:4.8) - esr:    0.649 time:  87130
% Cycle  28 (t:[ 2.3, 5.3] e:[ 2.5, 0.5] acc:4.8) - esr:    0.636 time:  82411
% Cycle  29 (t:[ 2.3, 5.3] e:[ 2.5, 0.5] acc:4.8) - esr:    0.623 time:  78270
% Cycle  30 (t:[ 2.3, 5.3] e:[ 2.5, 0.5] acc:4.8) - esr:    0.610 time:  74873
% Cycle  31 (t:[ 2.3, 5.3] e:[ 2.5, 0.5] acc:4.8) - esr:    0.597 time:  73904
% Cycle  32 (t:[ 2.3, 5.3] e:[ 2.5, 0.5] acc:4.8) - esr:    0.584 time:  73666
% Cycle  33 (t:[ 2.3, 5.3] e:[ 2.5, 0.5] acc:4.8) - esr:    0.571 time:  73683
% Cycle  34 (t:[ 2.3, 5.3] e:[ 2.5, 0.5] acc:4.8) - esr:    0.558 time:  74517
% Cycle  35 (t:[ 2.3, 5.3] e:[ 2.5, 0.5] acc:4.8) - esr:    0.545 time:  73579
% Cycle  36 (t:[ 2.3, 5.3] e:[ 2.5, 0.5] acc:4.8) - esr:    0.532 time:  72741
% Cycle  37 (t:[ 2.3, 5.3] e:[ 2.5, 0.5] acc:4.8) - esr:    0.519 time:  71990
% Cycle  38 (t:[ 2.3, 5.3] e:[ 2.5, 0.5] acc:4.8) - esr:    0.506 time:  71314
% Cycle  39 (t:[ 2.3, 5.3] e:[ 2.5, 0.5] acc:4.8) - esr:    0.493 time:  70681
% Cycle  40 (t:[ 2.3, 5.3] e:[ 2.5, 0.5] acc:4.8) - esr:    0.480 time:  70080
% Cycle  41 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:    0.467 time:  69568
% Cycle  42 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:    0.454 time:  69205
% Cycle  43 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:    0.441 time:  68917
% Cycle  44 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:    0.428 time:  68494
% Cycle  45 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:    0.415 time:  68110
% Cycle  46 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:    0.402 time:  67764
% Cycle  47 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:    0.389 time:  67485
% Cycle  48 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:    0.376 time:  66749
% Cycle  49 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:    0.363 time:  65770
% Cycle  50 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:    0.350 time:  64804
% Cycle  51 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:    0.337 time:  63752
% Cycle  52 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:    0.324 time:  62777
% Cycle  53 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:    0.311 time:  61868
% Cycle  54 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:    0.298 time:  61018
% Cycle  55 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:    0.285 time:  60330
% Cycle  56 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:    0.272 time:  59763
% Cycle  57 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:    0.259 time:  59325
% Cycle  58 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:    0.246 time:  58929
% Cycle  59 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:    0.233 time:  58547
% Cycle  60 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:    0.220 time:  58180
% Cycle  61 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:    0.207 time:  57827
% Cycle  62 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:    0.194 time:  57494
% Cycle  63 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:    0.181 time:  57178
% Cycle  64 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:    0.168 time:  56889
% Cycle  65 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:    0.155 time:  56613
% Cycle  66 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:    0.142 time:  56346
% Cycle  67 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:    0.129 time:  56090
% Cycle  68 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:    0.116 time:  55840
% Cycle  69 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:    0.103 time:  55599
% Cycle  70 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:    0.090 time:  55365
% Cycle  71 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:    0.077 time:  55136
% Cycle  72 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:    0.064 time:  54911
% Cycle  73 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:    0.051 time:  54686
% Cycle  74 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:    0.038 time:  54468
% Cycle  75 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:    0.025 time:  54254
% Cycle  76 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:    0.012 time:  54046
% Cycle  77 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:   -0.001 time:  53839
% Cycle  78 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:   -0.014 time:  53634
% Cycle  79 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:   -0.027 time:  53433
% Cycle  80 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:   -0.040 time:  53241
% Cycle  81 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:   -0.053 time:  53036
% Cycle  82 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:   -0.066 time:  52838
% Cycle  83 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:   -0.079 time:  52667
% Cycle  84 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:   -0.092 time:  52525
% Cycle  85 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:   -0.105 time:  52446
% Cycle  86 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:   -0.118 time:  52429
% Cycle  87 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:   -0.131 time:  52600
% Cycle  88 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:   -0.144 time:  52808
% Cycle  89 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:   -0.157 time:  53116
% Cycle  90 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:   -0.170 time:  53614
% Cycle  91 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:   -0.183 time:  54462
% Cycle  92 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:   -0.196 time:  55340
% Cycle  93 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:   -0.209 time:  55525
% Cycle  94 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:   -0.222 time:  54831
% Cycle  95 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:   -0.235 time:  54507
% Cycle  96 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:   -0.248 time:  54462
% Cycle  97 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:   -0.261 time:  54628
% Cycle  98 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:   -0.274 time:  54937
% Cycle  99 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:   -0.287 time:  55327
% Cycle 100 (t:[ 2.3, 5.3] e:[ 5.5, 0.5] acc:5.7) - esr:   -0.300 time:  55756



