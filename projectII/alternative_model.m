%% Plant parameters
A_plant = [0 1; 880.87 0];
B_plant = [0; -9.9453];
C_plant = [708.27 0];
D_plant = 0;

sys_plant = tf(ss(A_plant, B_plant, C_plant, D_plant));

%% Initial conditions
x0_agent = [0.1 2];
x0_leader= [1e-3 1e-3];

%% Modified plant
signal_reference = 3; % Might be 1, 2 or 3 for step, ramp and sinevawe
switch(signal_reference)
    case 1
        %p1 = A_plant(1,2)*x0_leader(2) - A_plant(1,1) * x0_leader(1);
        p1 = 1;
        poles = [-p1 0]; % step with amplitude 1
    case 2
        poles = [0 0]; % ramp
    case 3
        w = 100;
        poles = [w*1i -w*1i]; % sinewave
end

K_plant = acker(A_plant, B_plant, poles);
A = A_plant - B_plant*K_plant; % For controller design
B = B_plant; % For controller design
C = C_plant; % For observer design

sys = ss(A, B, eye(2), zeros(2,1));
% 
% X = (s*eye(2) - A_plant + B_plant * K_plant)^-1;
% bode(X)
% hold on

%% Graph definition
N = 6;
adj_mtx = [0 0 0 0 0 1
           1 0 0 0 0 0
           0 1 0 0 0 0
           0 0 1 0 0 0
           0 0 0 1 0 0
           0 0 0 0 0 0];
png_vct = zeros(N, 1); % pinning vector
png_vct(6) = 1;
png_mtx = diag(png_vct); % pinning matrix

%% Simulink configuration
standard_model_variables(...
    "output_state", false, ...
    "eps_on", true,...
    "zeta_on", true, ...
    "measurement_noise_type", 1, ...
    "local_or_neighborhood_observer", 2 ...
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

solution = 1;

if solution == 1 % This is the naive solution
    L = acker(A_plant', C_plant', [-1 -1]);
    L = L';
elseif solution == 2
    P = l
    L = -.5 * C'\P;
end
% x_hat transfer function
s = tf('s');
x_hat = inv(s*eye(2)+B_plant*K_plant) * inv(s*eye(2)-(A_plant+L*C_plant + B_plant*K_plant)) * L*C_plant * inv(s*eye(2)-A_plant) * x0_leader';
x_hat = zpk(minreal(x_hat, 1e-3));
x = (s*eye(2)-A)^-1 * (x0_leader' - B*K*x_hat);
x = zpk(minreal(x, 1e-3));

%% Agents observer
% Same Q and R
P = are(A_plant, C'*C/R, Q); %% simone.pirrera@polito.it
F = P * C' / R;

%% Simulation
time = 50;
out = sim('model');

%% Plots
close all;
% plot y0 in black (leader), y1 in green and y6 in red
figure
hold on
plot(out.y0, 'k');
plot(out.y1, 'g');
plot(out.y6, 'r');
legend("leader", "agent1", "agent6");