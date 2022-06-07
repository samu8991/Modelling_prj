function x_dot = leader_node(u,x)
k1 = 1.5;
k2 = 1;
m1 = 1.1;
m2 = .9;

A = [0 1 0 0
    -(k1/m1)-(k2/m1) 0 0 0
    0 0 0 1
    k2/m2 0 -k2/m2 0];

B = [0 1/m1 0 0]';

C = eye(4,4);

D = zeros(4,4);
%K = [24.8778    9.9000  -27.3778   13.8600];
K = place(A,B,[-4,-3,-2,0]);
x_dot = (A-B*K)*x + B* u;
