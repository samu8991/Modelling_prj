function [x, target, x_diff, t, s, Q] = IST(T_max, stopThreshold, x0, target, deployment_type, showPlots, seed, options)
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
n = 25; % number of sensors
l = 10; % lenght of each side of the square room
p = l^2; % total number of cells (each 1m^2)
r = 4; % Radius for sensor communication
sigma = 0.5; % For RSS computation
P_t = 25; % For RSS computation

%% Deployment
s = deploy(n, l, r, deployment_type); %% Coordinate generation for the n sensors

%% Target positioning
if sum(size(target)) == 2
    target = unifrnd(0, l, 2, 1);
end

%% Training
A = init_A(s, n, p, P_t, sigma, [.5, .5], m); %% Training phase
muA = mutual_coherence(A);
kA = 0.5*(1+1/muA); % sparsity of the solution
if showPlots
    fprintf("The sparsity K will be less than %7.5f (coherence: %5.4f)\n", kA, muA);
end
 
%% Creazione di Q
% Computation of d_in due to the fact that eps must be included between 0
% and 1/max(d_in). Done in this way there's duplicate code!
% Two sensors are connected if the distance between them is <= r
d_in = get_in_degree(s, r);
assert(ones(1,n) * d_in >= n); %% Parameters are wrong!!!
R = [0,1/max(d_in)];
eps = options.qEps * range(R)+ min(R);
Q = init_Q(s,r,n,eps);

%% Runtime
x = zeros(p,T_max); % target estimation
if sum(size(x0)) ~= 2
    x(:,1) = x0; % Initial conditions
end

% measurements
y = zeros(n,1);
for i = 1:n
    d = norm(target-s(i,:));
    y(i) = RSS(d, P_t, sigma);
end
[B, z] = feng(A, y); % Feng's theorem
muB = mutual_coherence(B);
kB = 0.5*(1+1/muB); % sparsity of the solution
if showPlots
    fprintf("The sparsity K will be less than %7.5f (coherence: %5.4f)\n", kB, muB);
end

% IST algorithm
for t = 2:T_max
    x(:,t) = IST_step(x(:,t-1),z,B); % defined later in this file
    
    % early stopping
    if vecnorm(x(:,t)-x(:,t-1), 1, 1) <= stopThreshold
        break
    end
    
    % online metrics computation
end

%% Results
x_diff = x(:,2:end) - x(:,1:end-1); % x_diff -> size: (p, T_max-1)
%x_diff = vecnorm(x_diff, 2, 1); % best estimate difference between iterations

x; % x -> size: (p, T_max)
% best estimate afeter convergence or T_max

t; % convergence time -> size: [1 1]

s; % sensors deployment positions -> size: [n, 2]

Q; % graph stocastich matrix -> size: [n, n]

target; % target position in (x,y) coordinates -> size: [2 1]
%% plots
if showPlots
    showRoom;
    xLast = x(:,t);
    [~, c] = max(xLast);
    cell2pos(c, 10, true);
    pos2cell(target(1), target(2), true, l);
    plotAgents(s);
    generateLegend(3, ["db","sg","*r"], ["best estimate", "target", "sensors"]);

    
    figure
    plot(x_diff);
    m = min(x_diff);
    if m == 0
        m = 1e-6;
    end
    ylim([-stopThreshold stopThreshold]);

    figure
    stem(xLast);
end


end

%% Helper function
function r = IST_step(x_0,y,A)
    lambda = 1e-4;
    tau = .7;
    r = x_0 + tau*A'*(y-A*x_0);
    assert(length(r) == 100);
    for i = 1:length(r)
        if(abs(r(i)) <= lambda)
            r(i) = 0;
        else
            r(i) = r(i) - sign(r(i))*lambda; 
        end
    end
end