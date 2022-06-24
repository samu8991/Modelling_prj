function t = metric_SCT(out, N, threshold)
arguments
    out
    N = 6 % Number of agents
    threshold = 1e2 % one percent
end

t = 0;

for i = 1:N
    a = strcat('y', int2str(i));
    T = metric_CtSi(out, a, threshold);
    if T > t
        t = T;
    end
end

end