function vector = metric_ACO(out, display_times, N, threshold)
arguments
    out
    display_times = false % whether to output also times
    N = 6 % Number of agents
    threshold = 1e-2 % one percent
end

times = zeros(N, 1);

for i = 1:N
    a = strcat('y', int2str(i));
    times(i) = metric_CtSi(out, a, threshold);
end

times_ordered = sort(times);

vector = zeros(N,1);
for i = 1:length(times_ordered)
    j = 1;
    while times(j) ~= times_ordered(i)
        j = j+1;
    end
    vector(i) = j;
end

if display_times
    vector = [vector, times_ordered];
end

end