clear all
%% Plant parameters
A_plant = [0 1; 880.87 0];
B_plant = [0; -9.9453];
C_plant = [708.27 0];
D_plant = 0;

%% Initial conditions
x0_agent = [0 0];
x0_leader= [10 0];

%% Modified plant
signal_reference = 1; % Might be 1, 2 or 3 for step, ramp and sinevawe
switch(signal_reference)
    case 1
        poles = [-1 0]; % step
    case 2
        poles = [0 0]; % ramp
    case 3
        poles = [1i -1i]; % sinewave
end

K_plant = acker(A_plant, B_plant, poles);
A = A_plant - B_plant*K_plant;
B = B_plant;
C = C_plant; % for the agent's observers

n_experiment=5;
results=cell.empty(n_experiment,0);
figure
for i = 1:n_experiment
%% Graph definition
    N = 6;
    [png_vct,adj_mtx]=generate_adj_mtx('chain',i,N);
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

% Simulation
    time = 15;
    out = sim('stable_model_system');

    results{i} = out;
    subplot(n_experiment/2,n_experiment/2,i);
    hold on, grid on
     plot(out.y0, "k", "DisplayName", "leader");
     for j = 1:N
          name = strcat("y", int2str(j));
          plot(out.find(name), "DisplayName", strcat("s", int2str(j)));
          legend
          title(sprintf("Configuration %d",i));
     end
end
  

%%

figure
for i =1:n_experiment
    subplot(n_experiment/2, n_experiment/2, i);
    metric_GDE(results{i},true,N);
    subtitle(sprintf("Configuration %d",a))
end

