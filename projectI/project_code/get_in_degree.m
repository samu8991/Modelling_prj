function d_in = get_in_degree(s, r)
    % s is senors position in a matrix (nx2), where the first element is
        % the x and the second is the y
    % r is the radius
    n = length(s); % number of sensors
    d_in = zeros(n,1); 
    for i = 1:n-1
        for j = i+1:n
            if norm(s(i,:)-s(j,:)) <= r
                d_in(i) = d_in(i)+1;
                d_in(j) = d_in(j)+1;
            end
        end 
    end