close all 
clear all
clc

%% Plant parameters
A_plant = [0 1; 880.87 0];
B_plant = [0; -9.9453];
C_plant = [708.27 0];
D_plant = 0;

%% Using unstable matrix
K = acker(A_plant, B_plant, [0 0]);
A_plant = A_plant - B_plant * K;

%% Agents observer
Q = diag([1 1]);
R = 1;
P = are(A_plant, C_plant'*C_plant/R, Q);
F = P * C_plant' / R;


%% Compute convergence region
lReal = [-1 1];
lImag = [-1 1];
points = 100;
okPoints = zeros(points^2);
ok = 0;
for alpha = linspace(lReal(1), lReal(2), points)
    for beta = linspace(lImag(1), lImag(2), points)
        s = alpha + beta * 1i;
        M = A_plant - s * C_plant * F;
        lambdas = eig(M);
        if sum(lambdas < 0, 'all') == rank(M)
            ok = ok + 1;
            okPoints(ok) = s;
        end
    end
end

figure
hold on
axis('equal');
xlim(lReal)
ylim(lImag)
for p = 1:ok
    s = okPoints(p);
    plot(real(s), imag(s), 'b*');
end
    


%% Riccati equation
Z = [A_plant -B_plant*B_plant'/R;
       -Q       -A_plant'];
eig(Z)
A_c = A_plant - B_plant * (R + B_plant'*P*B_plant) ^ -1 * B_plant' * P * A_plant;
eig(A_c)


