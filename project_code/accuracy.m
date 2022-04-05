%% Calculate mean and variance

sim_n = 1

sim_error = zeros(1, sim_n);

for i = 1:sim_n
    project
    sim_error(i) = norm( target - [x_i y_i]);
end

sim_max = max(sim_error);
sim_min_in = .15;
sim_error_len = ceil(sim_max/sim_min_in);
sim_error_bars = zeros(1, sim_error_len);
for i = 1:sim_n
    for j =1:sim_error_len
        if sim_error(i) <= sim_min_in * (j-1) 
            sim_error_bars(j) = sim_error_bars(j)+1;
            break
        end
    end
end

sim_m = mean(sim_error);
%stem(sim_error, sim_error)
bar(sim_error_bars)