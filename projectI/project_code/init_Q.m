function Q = init_Q(s, r, n, eps)
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
end