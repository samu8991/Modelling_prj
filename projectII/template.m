%% Plant parameters
A_plant = [0 1; 880.87 0];
B_plant = [0; -9.9453];
C_plant = [708.27 0];
D_plant = 0;


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

%% Initial conditions
x0_agent = [0 0];
x0_leader= [0 0];

%% Graph definition
N = 6;
adj_mtx = [0 0 0 0 0 0
           2 0 0 0 0 0
           0 6 0 0 0 0
           0 0 1 0 0 0
           0 0 0 1 0 0
           0 0 0 0 3 0];
png_vct = zeros(N, 1); % pinning vector
png_mtx = diag(png_vct); % pinning matrix

%% Simulink variables
output_state = 1; % binary variable indicating wheter the state is  directly measureble or not
eps_on = 1; % 0 to use local controller, 1 for neighborhood controller
zeta_on = 1; % 0 to use local observer, 1 for neighborhood observer
measurement_noise_type = 1; % output

%% Simulation
time = 15;
sim('model')
