%% Experiment a
% which is the rate of success? When the algorithm is not successful, how
% far is the estimated target?

T_max = 1e5;
stopThreshold = 1e-5;
x0 = 0; % always zero initial state 
target = 0; % Automatic target positioning
showPlots = false; % we don't need the plot for each iteration
seed = 0; % for repeatability of random deployment and target positioning
% NOTE: given the seed, the automatic positioning of the sensors and the
% target will result the same for both IST and DIST algorithms.
% The seed will change with the index of the experiment

n = 25;
p = 100;


%% DIST
% We are going to compute the success rate of the DIST algorithm
n_experiments = 10;

% DIST measures vectors
x = zeros(n_experiments, p);
target = zeros(n_experiments, 2);
successful = 0;
unsucc = 0;
unsucc_dist = zeros(n_experiments, 1);

for k=[2 1]
    if k == 2 % grid deployment, type A
        first = 1;
        last = n_experiments/2;
    else % random deployment, type B
        first = n_experiments/2 + 1 ;
        last = n_experiments;
    end
    for i = first:last
        fprintf("Cycle %d - ", i);
        [x(i,:), target(i,:), ~, ~, ~, ~, ~] = DIST(T_max, stopThreshold, x0, target, K, showPlots, seed);
        [~, xBest_index] = max(x(i,:));
        
        target_index = pos2cell(target(i,1), target(i,2));
        if target_index == xbest_index
            successful = successful + 1;
            fprintf("Successful reference point estimation!\n")
        else
           xpos = pos2cell(xBest_index);
           d = norm(xpos-target,2);
           unsucc = unsucc + 1;
           unsucc_dist(unsucc) = d;
           fprintf("Unsuccessful! The distance is: %f\n", d);
        end
    end
end

successful_rate = successful / n_experiments;
average_dist = mean(unsucc_dist);
variance_dist = var(unsucc_dist);
fprintf("The successfull rate is: %f\n", successful_rate);
fprintf("The average distance when failing is: %f with a variance of %f", average_dist, variance_dist);

%% ODIST
last_path = getPath(-1);

distances = {};
succ_rates = zeros(last_path,1);

for i = 1:last_path
    tp = getPath(i);
    
    [~, n_succ, dist] = ODIST(T_max, stopThreshold, tp, false);
    distances(i) = dist; % Controllare se questo funziona
    succ_rates(i) = succ; 
    
end

% calcolare distanza cumulativa
% mostrare grafici?





save experiment_a