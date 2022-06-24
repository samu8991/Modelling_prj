function [png_vct, adj_mtx, Q] = generate_adj_mtx(type, n, show, N)
arguments
    type
    n = 1;
    show = false;
    N = 6;
end

png_vct = zeros(N,1);
adj_mtx = zeros(N);

if type == "chain"
    switch(n)
        case -1
            png_vct = 4;
        case 1
            png_vct=[1,0,0,0,0,0]';
            adj_mtx=diag([1,1,1,1,1],-1);
        case 2
            png_vct=[1,0,0,0,0,0]';
            adj_mtx=diag([2,3,4,5,6],-1);
        case 3
            png_vct=[6,0,0,0,0,0]';
            adj_mtx=diag([5,4,3,2,1],-1);
        case 4 
            q=rand(1,1)*10;
            png_vct=[q,0,0,0,0,0]';
            adj_mtx=diag(rand(1,5).*10,-1);
    end
elseif type == "doublechain"
    switch(n) 
        case -1
            png_vct = 2;
        case 1 % equal weights at 1
            png_vct(1) = 1;
            png_vct(2) = 1;
            adj_mtx(3,1) = 1; % From 1 to 3
            adj_mtx(5,3) = 1; % From 3 to 5
            adj_mtx(4,2) = 1; % From 2 to 4
            adj_mtx(6,4) = 1; % From 4 to 6
        case 2 % increasing weights going down
            png_vct(1) = 1;
            png_vct(2) = 1;
            adj_mtx(3,1) = 1e2; % From 1 to 3
            adj_mtx(5,3) = 1e4; % From 3 to 5
            adj_mtx(4,2) = 1e2; % From 2 to 4
            adj_mtx(6,4) = 1e3; % From 4 to 6
    end
elseif type == "looped_doublechain"
    switch (n)
        case -1 
            png_vct = 2;
        case 1
            png_vct(1) = 1;
            png_vct(2) = 1;
            adj_mtx(3,1) = 1; % From 1 to 3
            adj_mtx(5,3) = 1; % From 3 to 5
            adj_mtx(3,5) = 1; % loop
            adj_mtx(4,2) = 1; % From 2 to 4
            adj_mtx(6,4) = 1; % From 4 to 6
            adj_mtx(4,6) = 1; % loop
        case 2
            png_vct(1) = 100;
            png_vct(2) = 1;
            adj_mtx(3,1) = 1; % From 1 to 3
            adj_mtx(5,3) = 1; % From 3 to 5
            adj_mtx(3,5) = 1; % loop
            adj_mtx(4,2) = 1; % From 2 to 4
            adj_mtx(6,4) = 100; % From 4 to 6
            adj_mtx(4,6) = 1; % loop
    end
elseif type == "tree"
    switch(n) 
        case -1
            png_vct = 6;
        case 1 % equal weights at 1
            png_vct(1) = 1;
            png_vct(2) = 1;
            adj_mtx(3,1) = 1; % From 1 to 3
            adj_mtx(4,1) = 1; % From 1 to 4
            adj_mtx(5,2) = 1; % From 2 to 5
            adj_mtx(6,2) = 1;
        case 2 % increasing weights going down
            png_vct(1) = 1;
            png_vct(2) = 1;
            adj_mtx(3,1) = 10;
            adj_mtx(4,1) = 10;
            adj_mtx(5,2) = 10;
            adj_mtx(6,2) = 10;
        case 3 % decreasing weights going up
            png_vct(1) = 10;
            png_vct(2) = 10;
            adj_mtx(3,1) = 1;
            adj_mtx(4,1) = 1;
            adj_mtx(5,2) = 1;
            adj_mtx(6,2) = 1;
        case 4 % same convergence time
            png_vct(1) = 1;
            png_vct(2) = 1;
            b = 100;
            adj_mtx(3,1) = b;
            adj_mtx(4,1) = b;
            adj_mtx(5,2) = b;
            adj_mtx(6,2) = b;
        case 5 % big equal weights
            b = 1e10;
            png_vct(1) = b;
            png_vct(2) = b;
            adj_mtx(3,1) = b; % From 1 to 3
            adj_mtx(4,1) = b; % From 1 to 4
            adj_mtx(5,2) = b; % From 2 to 5
            adj_mtx(6,2) = b;
        case 6 % asimmetric weights
            png_vct(1) = 1;
            png_vct(2) = 10;
            adj_mtx(3,1) = 1; % From 1 to 3
            adj_mtx(4,1) = 10; % From 1 to 4
            adj_mtx(5,2) = 1; % From 2 to 5
            adj_mtx(6,2) = 10;
    end    
elseif type == "complete"
    switch(n)
        case -1 
            png_vct = 4;
        case 1 % equal weights at 1
            png_vct = ones(N,1);
            adj_mtx = ones(N) - eye(N);
        case 2 % equal weights at 100
            png_vct = 100 * ones(N,1);
            adj_mtx = 100 * (ones(N) - eye(N));
        case 3 % Random 1
            png_vct = 100 * rand * ones(N,1);
            adj_mtx = 100*rand(N);
            adj_mtx = adj_mtx - diag(diag(adj_mtx));
        case 4 % Random 2
            png_vct = 100 * rand * ones(N,1);
            adj_mtx = 100 * rand(N);
            adj_mtx = adj_mtx - diag(diag(adj_mtx));
    end
elseif type == "dictator"
    adj_mtx = zeros(N);
    switch(n)
        case -1
            png_vct = 6;
        case 1
            png_vct = ones(N,1);
        case 2
            png_vct = 1e3 * ones(N,1);
        case 3
            png_vct = 1e6 * ones(N,1);
        case 4
            png_vct = 1e9 * ones(N,1);
        case 5
            png_vct = ones(N,1);
            for i = 2:6
                png_vct(i) = power(10, i-1);
            end
        case 6
            png_vct = ones(N,1);
            for i = 2:6
                png_vct(i) = power(1e3, i-1);
            end
    end
end

if n ~= -1
    Q = [zeros(1,N+1); png_vct, adj_mtx];
end
if show % visualize the graph
    names = ["s0" "s1" "s2" "s3" "s4" "s5" "s6"];
    plot(digraph(Q', names));
end

end