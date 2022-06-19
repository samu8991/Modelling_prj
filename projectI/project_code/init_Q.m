function Q = init_Q(s, r, n, eps, wt)
arguments
   s % agents potisions
   r % radius for the agents to communicate
   n % number of agents
   eps % uniform weights value
   wt = 0 % Q type
end
    switch wt
        case 0
            d_in = get_in_degree(s, r);
            assert(eps < 1/max(d_in))
            assert(eps > 0)
            Q = eps * ones(n);
            for i = 1:n-1
                for j = i+1:n
                    if norm(s(i,:)-s(j,:)) > r
                        Q(i,j) = 0;
                        Q(j,i) = 0;
                    end
                end
            end

            for i = 1:n
                s = sum(Q(i,:)) - eps; % eps is subtracted because Q(i,i) = eps;
                Q(i,i) = 1 - s;
            end
        case 1
            % Metropolis-Hastings weights
            disp("Not implemented yet!");
            assert(1 == 0);
    end
    
    
end