function [png_vct, adj_mtx] = generate_adj_mtx(type, n, show, N)
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
elseif type == "tree"
    switch(n) 
        case -1
            png_vct = 4;
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
        case 4
            png_vct(1) = rand * 10;
            png_vct(2) = rand * 10;
            adj_mtx(3,1) = rand * 10;
            adj_mtx(4,1) = rand * 10;
            adj_mtx(5,2) = rand * 10;
            adj_mtx(6,2) = rand * 10;
    end    
elseif type == "complete"
    switch(n)
        case 1 % equal weights at 1
            png_vct = ones(N,1);
            adj_mtx = ones(N) - eye(N);
        case 2 % equal weights at 100
            png_vct = 100 * ones(N,1);
            adj_mtx = 100 * (ones(N) - eye(N));
    end
elseif type == "dictator"
	png_vct = ones(N,1);
    adj_mtx = zeros(N);
end

if show % visualize the graph
    mtx_complete = [zeros(1,N+1); png_vct, adj_mtx]';
    plot(digraph(mtx_complete));
end

end