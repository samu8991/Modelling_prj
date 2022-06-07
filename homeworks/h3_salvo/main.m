%clc
clear 
close all

%% Data
k1 = 1.5;
k2 = 1;
m1 = 1.1;
m2 = .9;
x10 = [0 0]';
x20 = [0 0]';
x0 = [10 0 10 0]';
N = 6;

% agents initial conditions
x0_1 = [0; 0; 0; 0];
x0_2 = [0; 0; 0; 0];
x0_3 = [0; 0; 0; 0];
x0_4 = [0; 0; 0; 0];
x0_5 = [0; 0; 0; 0];
x0_6 = [0; 0; 0; 0];

% graph's Adjacent matrix
adj_mtx = zeros(N,N);
adj_mtx(2,1) = 2;
adj_mtx(3,2) = 6;
adj_mtx(4,3) = 1;
adj_mtx(5,4) = 1;
adj_mtx(6,5) = 3;

% pinning matrix
png_vector = [1 0 0 0 0 0];
png_mtx = diag(png_vector);

%% Generic system definition
A = [0 1 0 0
    -(k1/m1)-(k2/m1) 0 0 0
    0 0 0 1
    k2/m2 0 -k2/m2 0];
B = [0 1/m1 0 0]';
C = eye(4,4);
D = zeros(4,1);

%% Pole placement and command leader settings
wrong_version = false;
selected_signal=2; % change this between 1,2,3 to select the corresponding input (step, ramp, sinewave)

if wrong_version
    poles = [-4 -3 -2 -1];
    leader_controller = place(A,B,poles);
    sys = ss(A, B,C,D);
    leader_sys = ss(A,B,C,D);
else
    switch(selected_signal)
        case 1
            poles = [-3 -2 -1 0]; % step
        case 2
            poles = [-3 -2 0 0]; % ramp
        case 3
            poles = [-3 -2 1i -1j]; % sinwave
    end

    leader_controller = acker(A,B,poles);
    newA = A-B*leader_controller;
    sys = ss(newA, B, C, D);
    leader_sys = ss(newA, zeros(4,1), C, D);
end

%% Leader node definition and control
leader_x0 = [0.01, 0.3, 0.3, 0.4];

rho = 40;
w = pi/3;
%poles = [-3 j*w -j*w -5]

%% Agent controller
Q = diag([1 1 1 1]);
R = 1;
P = are(A, B*B'/R, Q); % Algebraic Riccati Equation
K = B' * P / R; % Controller

% decoupling gains
deg_mtx = diag(sum(adj_mtx, 2));
lpc_mtx = deg_mtx - adj_mtx; %laplacian matrix
lambdas = eig(lpc_mtx + png_mtx);

denominator = 2 * min(real(lambdas));
c = 1/denominator; % c has to be >= of 1/denominator;
clear denominator;

%% simulation
time = 250;
sim('model_2020b')


