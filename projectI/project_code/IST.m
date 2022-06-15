function [x, x_diff, t] = IST(seed, showPlots, stopThreshold, deployment_type, T_max)
arguments
   seed {mustBeNonnegative} = 0
   showPlots logical = true 
   stopThreshold {mustBeNonnegative} = 1e-6
   deployment_type {mustBeInRange(deployment_type, 1, 2)} = 1 % 1 means random deplyment, 2 grid deployment
   T_max {mustBePositive} = 1e7; % Maximum time before the algorithm stops
end
%% Settings
rng(seed); % For repeatability (target and sensor positioning)
% deployment_type = 2; % 1 for random, w for grid
% T_max = 1e7; % maximum time for the algorithm to ru

%% Dati
n = 25; % number of sensors
l = 10; % lenght of each side of the square room
p = l^2; % total number of cells (each 1m^2)
r = 4; % Radius for sensor communication
sigma = 0.5; % For RSS computation
P_t = 25; % For RSS computation

%% Deployment
s = deploy(n, l, r, deployment_type); %% Coordinate generation for the n sensors

%% Training
A = init_A(s, n, p, P_t, sigma); %% Training phase
mu = mutual_coherence(A);
ret = 0.5*(1+1/mu); % sparsity of the solution
fprintf("The sparsity K will be less than %f\n", ret);
 
%% Creazione di Q
% Computation of d_in due to the fact that eps must be included between 0
% and 1/max(d_in). Done in this way there's duplicate code!
% Two sensors are connected if the distance between them is <= r
d_in = get_in_degree(s, r);
R = [0,1/max(d_in)];
eps = rand(1,1)*range(R)+ min(R);
Q = init_Q(s,r,n,eps);
% G=digraph(Q);
% plot(G);

%% Runtime
x = zeros(p,T_max); % target estimation
target = [l*unifrnd(), l*unifrnd()]; % target positioning

% measurements
y = zeros(n,1);
for i = 1:n
    d = norm(target-s(i,:));
    y(i) = RSS(d, P_t, sigma);
end
[B, z] = feng(A, y); % Feng's theorem

% IST algorithm
x(:,1) = zeros(p,1);
for t = 2:T_max
    x(:,t) = IST_step(x(:,t-1),z,B); % defined later in this file
    
    % early stopping
    if norm(x(:,t) - x(:,t-1)) <= stopThreshold
        break
    end
    
    % online metrics computation
end


%% plots
if showPlots
    figure
    x_diff = x(:,2:t) - x(:,1:t-1);
    x_diff = vecnorm(x_diff, 2, 1);
    plot(x_diff);
    m = min(x_diff);
    if m == 0
        m = 1e-6;
    end
    ylim([0 1e2*m]);

    showRoom;
    plotAgents(s);
    x = x(:,t);

    [~, c] = max(x);
    cell2pos(c, 10, true, false);
    pos2cell(target(1), target(2), true, l);


    figure
    stem(x);
end


end

%% Helper function
function r = IST_step(x_0,y,A)
    lambda = 1e-4;
    tau = 0.7;
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