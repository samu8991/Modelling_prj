clc
clear
close all

%% Data
k1 = 1.5;
k2 = 1;
m1 = 1.1;
m2 = .9;
x0 = [0 0 0 0]';
N = 6;

% Extended graph definition
% NOTE: This is the adjacent matrix of this graph, but with a slight
% modification. It has the colum shifted by one, so the last column has the
% meaning of entering edges in the leading node.
GM = zeros(N+1,N+1);
GM(2,1) = 1;GM(5,4) = 1;
GM(3,2) = 2;GM(6,5) = 1;
GM(4,3) = 6;GM(7,6) = 3;
% adjacent matrix graph definition (NOT extended!)
A_graph = GM(2:end, 2:end);

G = diag(GM(2:end,1));% Pinning matrix

%% Model
A = [0 1 0 0
    -(k1/m1)-(k2/m1) 0 0 0
    0 0 0 1
    k2/m2 0 -k2/m2 0];

B = [0 1/m1 0 0]';

C = eye(4,4);

Ds = zeros(4,1);

A_graf = [0 0 0 0 0 0
          2 0 0 0 0 0
          0 6 0 0 0 0
          0 0 1 0 0 0
          0 0 0 1 0 0
          0 0 0 0 3 0];
A_graph = GM(2:end, 2:end);

%% Control law distributed system
Q = diag([1 1 1 1]);
R = 1;
R_1 = inv(R);

P = are(A,B/R*B',Q);
K = (B/R)'*P;
G = diag(GM(2:end,1));
%d_in = sum(GM(2:end,1:end-1),1)


d_in= sum(A_graph,2);

D = diag(d_in);
L = D - A_graph;
lambda = eig(L+G);
num = min(real(lambda));

c = 1 + (1/(2*num));
ctrl = c*K;
%% Local controller
local_ctrl = place(A,B,[-3,-2,-1,-4]);

%% Sim
simout = sim('hw3_sim.slx');