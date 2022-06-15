function [x, x_diff, t, s] = DIST(T_max, stopThreshold, x0, target, deployment_type, showPlots, seed)
arguments
    T_max {mustBePositive} = 1e4; % Maximum time before the algorithm stops
    stopThreshold {mustBeNonnegative} = 1e-6; % early stopping threshold
    x0 = 0 % initial condition of the algorithm, vector of size nx1
    target = 0 % bidimentional array which represents target's coordinates (x,y)
    deployment_type {mustBeInRange(deployment_type, 1, 2)} = 1 % 1 means random deplyment, 2 grid deployment
    showPlots logical = true; % whether to show plots at the end
    seed {mustBeNonnegative} = 0; % for repeatability (affects the deployment 2 and automatic target positionining)
end
rng(seed);

%% Dati
n = 25;
l = 10;
p = l^2;
r = 3;
sigma = 0.5;
P_t = 25;

%% Deployment
s = deploy(n, l, r, deployment_type);

%% Training
A = init_A(s, n, p, P_t, sigma, [.5, .5]);
mu = mutual_coherence(A);
ret = 0.5*(1+1/mu); % sparsity of the solution
%fprintf("The sparsity K will be less than %f\n", ret);

%% Q computation
% Computation of d_in due to the fact that eps must be included between 0
% and 1/max(d_in). Done in this way there's duplicate code!
% Two sensors are connected if the distance between them is <= r
d_in = get_in_degree(s, r);
assert(ones(1,n) * d_in >= n); %% Parameters are wrong!!!
R = [0,1/max(d_in)]; % eps range
eps = rand(1,1)*range(R) + min(R);
Q = init_Q(s, r, n, eps); % stochastic graph matrix

%% Runtime DIST
x = zeros(n,p); 
if sum(size(target)) ~= 2
    x = x0' .* ones(n,p);
end
if sum(size(target)) == 2
    target = [l*unifrnd(), l*unifrnd()]; % target positioning
end

% metrics objects
x_diff = zeros(n, T_max-1);

% measurements
y = zeros(n,1);
for i = 1:n
    d = norm(target-s(i,:));
    y(i) = RSS(d, P_t, sigma);
end
[B, z] = feng(A,y); % Feng's theorem

for t = 2:T_max
    xold = x;
        
    % perform DIST step for each sensor
    for i = 1:n
        x_bar = zeros(1,p); % calculate xbar
        for j=1:n
           x_bar = x_bar + Q(i,j) * x(j,:); 
        end
        x(i,:) = DIST_step(i, x_bar, x(i,:), z, B); % defined later in this file
    end

    % early stopping
    if(norm(x - xold) <= stopThreshold)   
        break
    end
    
    % online metrics computation
    x_diff(:,t-1) = vecnorm(x-xold, 2, 2);
end

%% Results
x_diff; % has been calulated online
t; % has been calculated online
x = x(1,:); % Best estimate index array
s; % Sensor disposition

%% plots
if showPlots
    % x_diff plots
    figure
    hold on
    for i=1:n
        plot(x_diff(i,:));
    end
    m = min(x_diff, [], 'all');
    if m == 0
        m = 1e-6;
    end
    ylim([0 1e2*m]);

    % Room representation
    showRoom;
    [~, c] = max(x);
    cell2pos(c, 10, true, true); % best estimation
    pos2cell(target(1), target(2), true, l); % real target
    plotAgents(s, n, r, false, false); % sensors (or agents)
    generateLegend(3, ["db","sg","*r"], ["best estimation", "target", "sensors"]);


    % probability vector
    figure
    stem(x);
end

end

%% Helper function
function r = DIST_step(current, x_bar, x_0, y, A)
    lambda = 1e-4;
    tau = 0.7;
    r = x_bar' + tau*A(current,:)' * (y(current) - A(current,:) * x_0');
    for i = 1:length(r)
        if(abs(r(i)) <= lambda)
            r(i) = 0;
        else
            r(i) = r(i) - sign(r(i))*lambda; 
        end
    end
end