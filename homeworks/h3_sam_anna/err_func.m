function [eps1,eps2,eps3,eps4,eps5,eps6]= err_func(x1, x2, x3, x4, x5, x6, x0)

N = 6;
GM = zeros(N+1,N+1);
GM(2,1) = 1;GM(5,4) = 1;
GM(3,2) = 2;GM(6,5) = 1;
GM(4,3) = 6;GM(7,6) = 3;
g = GM(:,1);
A_graph = GM(2:end,2:end);

eps = zeros(N,4);
for i = 1:N
    for j = 1:N
        eps(i,:) = eps(i,:) + A_graph(i,j)*( eval("x"+j)' - eval("x"+i)') ;
    end
    eps(i,:) = eps(i,:) + GM(i,1)*(x0'-x(i,:));
end

eps1 = eps(1,:)';
eps2 = eps(2,:)';
eps3 = eps(3,:)';
eps4 = eps(4,:)';
eps5 = eps(5,:)';
eps6 = eps(6,:)';