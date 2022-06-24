close all

%% Plant parameters
A_plant = [0 1; 880.87 0];
B_plant = [0; -9.9453];
C_plant = [708.27 0];
D_plant = 0;

%% Initial conditions
x0_agent = [0 0];
x0_leader= [100 0];

%% Modified plant
signal_reference = 1; % Might be 1, 2 or 3 for step, ramp and sinevawe
switch(signal_reference)
    case 1
        poles = [-1 0]; % step
    case 2
        poles = [0 0]; % ramp
    case 3
        w = 100;
        poles = [w*1i -w*1i]; % sinewave
end

K_plant = acker(A_plant, B_plant, poles);
A = A_plant - B_plant*K_plant;
B = B_plant;
C = C_plant; % for the agent's observers

%% Experiment begin

type = "dictator";
%figure 
n_experiments = generate_adj_mtx(type, -1);
results = cell.empty(4,0);
rng(0);

rc = factor(n_experiments);

for i = 1:n_experiments
    %% Graph definition
    N = 6;
    
    [png_vct, adj_mtx] = generate_adj_mtx(type, i); % equal weights at 1
    png_mtx = diag(png_vct); % pinning matrix

    %% Simulink variables
    standard_model_variables();

    %% Agents' Controller
    Q = diag([1 1]);
    R = 1;
    P = are(A,B/R*B',Q);
    K = B'/R*P;

    d_in = sum(adj_mtx,2);

    deg_mtx = diag(d_in); % degree matrix
    lpc_mtx = deg_mtx - adj_mtx; % laplacian matrix
    lambda = eig(lpc_mtx + png_mtx); 
    den = 2 * min(real(lambda));

    c = 10/den;

    %% Leader observer
    L = acker(A_plant', C_plant', [-1 -1]);
    L = L';

    %% Agents' Observer
    % Same Q and R
    P = are(A_plant, C'*C/R, Q); %% simone.pirrera@polito.it
    F = P * C' / R;

    %% Simulation
    time = 15;
    out = sim('stable_model_system');
    results{i} = out;
    
    subplot(n_experiments/rc(1), n_experiments/rc(2), i);
    hold on
    plot(out.y0, "k", "DisplayName", "leader");
    for j = 1:N
        name = strcat("y", int2str(j));
        plot(out.find(name), "DisplayName", strcat("s", int2str(j)));
    end
    title(strcat("Configuration ", int2str(i)));
    legend
end

%% Statistics and plots
for i = 1:n_experiments
    metric_ACO(results{i}, true, 1e3)
end

%%
figure
a = zeros(n_experiments, 1);
for i = 1:n_experiments
    a(i) = subplot(n_experiments/rc(1), n_experiments/rc(2), i);
    metric_GDE(results{i}, true);
    tit = get(gca, "title");
    title(strcat("GDE - Confguration ", int2str(i)));
end
linkaxes(a, 'y');

%% results 4
figure
ct = metric_ACO(results{5}, true, 1e3);
ct = ct(:,2);
weights = [1e5; 1e4; 1e3; 1e2; 1e1; 1];
semilogx(weights, ct, '-*');
% fitted = fit(weights, ct, "exp2")
% hold on
% plot(fitted);