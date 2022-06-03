clc
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

D = zeros(4,1);
K = [34.7778   11.0000  -13.5178   38.5000];
SYS = ss(A-B*K,B,C,D);


%% Control law distributed system
Q = diag([1 1 1 1]);
R = 1;
R_1 = inv(R);

P = are(A,B/R*B',Q);
K = (B/R)'*P;
d_in = sum(A_graph, 2);
% d_in = zeros(N,1);
% for i = 2:N
%     ret = sum(GM(i,1:end-1));
%     d_in(i-1) = ret;
% end
D_mtx = diag(d_in);
L = D_mtx - A_graph;
lambda = eig(L+G);
num = min(real(lambda));

c = 1 + (1/(2*num));
ctrl = c*K;
%% Local controller
local_ctrl = place(A,B,[-4,-3,-2,0]);
leader_sys = ss(A-B*local_ctrl, B, C, D);

%% Sim
simout = sim('hw3_sim.slx');