function vector = metric_ACO(out, display_times, N, threshold)
arguments
    out
    display_times = false % whether to output also times
    N = 6 % Number of agents
    threshold = 1e-2 % one percent
end

vector = zeros(N,2);

for i = 1:N
    a = strcat('y', int2str(i));
    vector(i,2) = metric_CtSi(out, a, threshold);
    vector(i,1) = i;
end

vector = sortrows(vector, 'descend');

if ~display_times
    vector = vector(:,1);
end

end