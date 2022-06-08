function t = metric_CACT(out, N, threshold)
arguments
    out
    N = 6 % Number of agents
    threshold = 1e-2 % one percent
end

t = 0;

for i = 1:N
    a = strcat('y', int2str(i));
    T = metric_CtSi(out, a, threshold);
    t = t+T;
end

end