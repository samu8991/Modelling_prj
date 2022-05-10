function b = calculateParameters(Gd, H, Ts, seed, noise)
arguments
    Gd
    H = 100
    Ts = 1
    seed = -1
    noise.eq = 0
    noise.out = 0
end

if seed >= 0
    rng(seed)
end

%time and random input
T = zeros(H,1);
T(1) = 0;
for i=2:H
    T(i) = T(i-1) + Ts;
end
u = rand(H,1);

w = lsim(Gd, u, T);
nn = randn(H, 1) * sqrt(noise.out);
w = w + nn;

A = zeros(H-2, 5);
for i=1:H-2
   A(i,:) = [w(i+1) w(i) u(i+2) u(i+1) u(i)];
end

b = A\w(3:end);
b = b'; %Per qualche motivo theta(1) e theta(2) hanno segno invertito!