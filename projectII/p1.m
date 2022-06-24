close all

%% Plant parameters
A_plant = [0 1; 880.87 0];
B_plant = [0; -9.9453];
C_plant = [708.27 0];
D_plant = 0;

%% Initial conditions
x0_agent = [0 0];
x0_leader= [100 0];
SCT_vec = zeros(1,3);
CACT_vec = zeros(1,3);
ACO_vec = zeros(3,6);
GDE_vec = zeros(1,3);
%% Modified plant
for a=1:3
    signal_reference = a; % Might be 1, 2 or 3 for step, ramp and sinevawe
    
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
    
    type = "tree";
    
    %% Graph definition
    N = 6;
    
    [png_vct, adj_mtx] = generate_adj_mtx(type, 4); % equal weights at 1
    png_mtx = diag(png_vct); % pinning matrix
    
    %% Simulink variables
    
    standard_model_variables("local_or_neighborhood_observer",2,"eps_on",1,"zeta_on",1);
    
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
    
    subplot(3,1,a);

    %% Statistics and plots
    SCT_vec(a) = metric_SCT(out);
    metric_GDE(out,true)
    CACT_vec(a) =metric_CACT(out);
    ACO_vec(a,:) =metric_ACO(out);
    
    switch(a)
        case 1
            title("Global Disagreement Error[STEP]");

        case 2
            title("Global Disagreement Error[RAMP]");

        case 3
            title("Global Disagreement Error[SINE]");
    end
end