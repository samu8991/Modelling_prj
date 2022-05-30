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
GM = zeros(N+1,N+1);
GM(2,1) = 1;GM(5,4) = 1;
GM(3,2) = 2;GM(6,5) = 1;
GM(4,3) = 6;GM(7,6) = 3;

%% Model
A = [0 1 0 0
    -(k1/m1)-(k2/m1) 0 0 0
    0 0 0 1
    k2/m2 0 -k2/m2 0];

B = [0 1/m1 0 0]';

C = eye(4,4);

D = zeros(4,4);

%% Control law
Q = diag([1 1 1 1]);
R = 1;
R_1 = inv(R);

P = are(A,B/R*B',Q);
K = (B/R)'*P;
G = diag(GM(2:end,1));
%d_in = sum(GM(2:end,1:end-1),1)
d_in = zeros(N,1);
for i = 2:N
    ret = sum(GM(i,1:end-1));
    d_in(i) = ret;
end
D = diag(d_in);
L = D - GM(2:end,1:end-1);
lambda = eig(L+G)
num = min(real(lambda))

c = 1 + (1/(2*num))
ctrl = c*K;