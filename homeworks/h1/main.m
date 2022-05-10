%% Data
clear all
s = tf('s');

Ts = 1;
Gp = 100 / (s^2 + 1.2*s + 1);
Gd = c2d(Gp, Ts, 'zoh');
[nGd, dGd] = tfdata(Gd, 'v');
    theta = [dGd(2:3) nGd] % parameters of Gd

% part 1
%b = calculateParameters(Gd, 100, Ts)
%b = calculateParameters(Gd, 7, Ts)

% part 3 
b = calculateParameters(Gd, 100, Ts, -1, "out", 5)
%b = calculateParameters(Gd, 7, Ts, -1, "out", 5)

%% Manca da fare
% implementazione del rumore d'equazione (Dy = Nq + e)
