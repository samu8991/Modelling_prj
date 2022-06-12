%% Plant parameters
A_plant = [0 1; 880.87 0];
B_plant = [0; -9.9453];
C_plant = [708.27 0];
D_plant = 0;

sys_plant = tf(ss(A_plant, B_plant, C_plant, D_plant));

%% Initial conditions
x0_agent = [0.1 2];
x0_leader= [10 0];

%% Modified plant
signal_reference = 3; % Might be 1, 2 or 3 for step, ramp and sinevawe
switch(signal_reference)
    case 1
        %p1 = A_plant(1,2)*x0_leader(2) - A_plant(1,1) * x0_leader(1);
        p1 = .1;
        poles = [-p1 0]; % step with amplitude 1
    case 2
        poles = [0 0]; % ramp
    case 3
        poles = [1i -1i]; % sinewave
end

K_plant = acker(A_plant, B_plant, poles);
A = A_plant - B_plant*K_plant; % For controller design
B = B_plant; % For controller design
C = C_plant; % For observer design

sys = tf(ss(A, B, C_plant, D_plant));

% Calculate final gain value
switch(signal_reference)
    case 1 % step gain
        step_gain = (A(1,1) * x0_leader(1) + A(1,2)*x0_leader(2)) /(A(1,1) + A(1,2));
    case 2
        poles = [0 0]; % ramp
    case 3
        poles = [1i -1i]; % sinewave
end


%% Graph definition
N = 6;
adj_mtx = [0 0 0 0 0 0
           1 0 0 0 0 0
           0 1 0 0 0 0
           0 0 1 0 0 0
           0 0 0 1 0 0
           0 0 0 0 1 0];
png_vct = zeros(N, 1); % pinning vector
png_vct(1) = 1;
png_mtx = diag(png_vct); % pinning matrix

%% Simulink configuration
standard_model_variables(...
    "output_state", false, ...
    "eps_on", true,...
    "zeta_on", true, ...
    "measurement_noise_type", 1 ...
    );

%% Controller
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
L = acker(A_plant', C_plant', [-1 -2]);
L = L';

%% Agents observer
% Same Q and R
P = are(A, C'/R*C, Q);
F = P * C' /R;

%% Simulation
time = 100;
out = sim('model');

%% Plots
plot(out.x0);