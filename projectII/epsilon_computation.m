function eps = epsilon_computation(x0, x1, x2, x3, x4, x5, x6)

png_vct = evalin("base", "png_vct");
adj_mtx = evalin("base", "adj_mtx");

N = 6;

eps = zeros(N, 2);

for i = 1:N
    e = [0; 0]; %epsilon
    e = e + png_vct(i) .* (x0 - eval(strcat('x', int2str(i)))); % pinning gain
    for j = 1:N
       e = e + adj_mtx(i,j) .* ( eval(strcat('x', int2str(j))) - eval(strcat('x', int2str(i))) ); % edge gain
    end
    eps(i,:) = e;
end

eps = eps';