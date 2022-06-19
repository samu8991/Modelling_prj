function [x, target, x_diff, p_bar, t, s, Q] = DIST(T_max, stopThreshold, x0, target, deployment_type, showPlots, seed, options)
arguments
    T_max {mustBePositive} = 1e4; % Maximum time before the algorithm stops
    stopThreshold {mustBeNonnegative} = 1e-6; % early stopping threshold
    x0 = 0 % initial condition of the algorithm, vector of size nx1
    target = 0 % bidimentional array which represents target's coordinates (x,y)
    deployment_type {mustBeInRange(deployment_type, 1, 2)} = 1 % 1 means random deplyment, 2 grid deployment
    showPlots logical = true; % whether to show plots at the end
    seed {mustBeNonnegative} = 0; % for repeatability (affects the deployment 2 and automatic target positionining)
    options.qWeightsType = 0; % means we are going to get uniform weights
    options.qEps = .5; % percentage of the value for eps in the range [0 1/max(d_in)]
    options.m {mustBePositive} = 1; % measurements for each sensor
end
rng(seed); % For repeatability (target and sensor positioning)
m = options.m;

%% Dati
n = 25;
l = 10;
p = l^2;
r = 4;
sigma = 0.5;
P_t = 25;

%% Deployment
s = deploy(n, l, r, deployment_type);

%% Target positioning
if sum(size(target)) == 2
    target = unifrnd(0, l, 2, 1);
end

%% Training
A = init_A(s, n, p, P_t, sigma, [.5, .5], m);
muA = mutual_coherence(A);
kA = 0.5*(1+1/muA); % sparsity of the solution
if showPlots
    fprintf("The sparsity K will be less than %7.5f (coherence: %5.4f)\n", kA, muA);
end

%% Q computation
% Computation of d_in due to the fact that eps must be included between 0
% and 1/max(d_in). Done in this way there's duplicate code!
% Two sensors are connected if the distance between them is <= r
d_in = get_in_degree(s, r);
assert(ones(1,n) * d_in >= n); %% Parameters are wrong!!!
R = [0,1/max(d_in)]; % eps range
eps = options.qEps * range(R) + min(R);
Q = init_Q(s, r, n, eps); % stochastic graph matrix

%% Runtime DIST
x = zeros(n,p); 
if sum(size(x0)) ~= 2
    x = x0' .* ones(n,p);
end

% metrics objects
x_diff = zeros(p, T_max-1);

% measurements
y = zeros(n*m,1);
for i = 1:n % for each sensor
    for m_i = 1:m
        d = norm(target-s(i,:));
        y( (i-1)*m + m_i ) = RSS(d, P_t, sigma);
    end
end
%B=A; z=y;
[B, z] = feng(A,y); % Feng's theorem
muB = mutual_coherence(B);
kB = 0.5*(1+1/muB); % sparsity of the solution
if showPlots
    fprintf("The sparsity K will be less than %7.5f (coherence: %5.4f)\n", kB, muB);
end


for t = 2:T_max
    xold = x;
    
    if isnan(x(1))
        disp("Interrupting at cycle "+t);
        assert( ~isnan(x(1)));
    end
    
    % perform DIST step for each sensor
    for i = 1:n
        x_bar = zeros(1,p); % calculate xbar
        for j=1:n
           x_bar = x_bar + Q(i,j) * x(j,:); 
        end
        x(i,:) = DIST_step(i, x_bar, x(i,:), z, B, m); % defined later in this file
    end

    % early stopping
    x_d = mean(x-xold, 1)'; % mean of the estimates of the sensors
    if(vecnorm(x_d, 2, 1) <= stopThreshold)   
%    if sum(abs(x_d) <= stopThreshold, 'all') == p
        break
    end
    
    % online metrics computation
    x_diff(:,t-1) = x_d;
end

%% Results
x_diff; % norm difference for each sensor between each estimate -> size: [n, T_max-1]
t; % convergence time or T_max -> size: [1 1]
s; %  % sensors deployment positions -> size: [n, 2]
Q; % graph stocastich matrix -> size: [n, n]

p_bar = 0; % represent the average point, calculated as 1/n*sum(p_i), where
for i=1:n  %p_i is the pos2cell of the best component of the vector x_i
    [~, x_i_best] = max(x(i,:));
    p_i = cell2pos(x_i_best);
    p_bar = p_bar + p_i;
end
p_bar = p_bar / n;

x = x(1,:); % Best estimate index array - we assume convergence happened
            % -> size: [1, p]
            
target; % target position in (x,y) coordinates -> size: [2 1]
%% plots
if showPlots
    fprintf("Convergence time is %5d\n", t);
    
    % Room representation
    showRoom;
    [confidence, c] = max(x);
    cell2pos(c, 10, true); % best estimation
    pos2cell(target(1), target(2), true, l); % real target
    plotAgents(s, n, r, false, false); % sensors (or agents)
    %pos2cell(p_bar(1), p_bar(2), true, l);
    generateLegend(3, ["db","sg","*r"], ["best estimation", "target", "sensors"]);
    
    fprintf("Confidence: %.2f\n", confidence);
    
    % x_diff plots
    figure
    hold on
    for i=1:n
        plot(x_diff(i,:));
    end
    ylim([-stopThreshold stopThreshold]);
    xlim([t-t*.1, t]);

    % probability vector
    figure
    stem(x);
end

end

%% Helper function
function r = DIST_step(current, x_bar, x_0, y, A, m)
    lambda = 1e-4;
    tau = 0.7; % using Feng, 25 sensors, up to 4 measurements
    %tau = .377322e-6; % Not using Feng, 20 measurements, 25 (even 50) sensors
    %tau = 1e-7; % Not using Feng, 20 measurements, 100 sensors
    c = (current-1) * m + 1;
    f = c + m - 1;
    r = x_bar' + tau*A(c:f,:)' * (y(c:f) - A(c:f,:) * x_0');
    for i = 1:length(r)
        if(abs(r(i)) <= lambda)
            r(i) = 0;
        else
            r(i) = r(i) - sign(r(i))*lambda; 
        end
    end
end