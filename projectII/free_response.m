%% Computation of free response for lti system

A = sym('A', [2,2]);
B = sym('B', [2,2]);
K = sym('K', [2,2]);
C = sym('C', [1,2]);

s = sym('s');
x0 = sym('x0', [2,1]);

M = A-B*K; % new poles matrix
X = (s*eye(2)-M)^-1 * x0;
Y = C * X;

Y = partfrac(Y, s);
[num, den] = numden(Y)

