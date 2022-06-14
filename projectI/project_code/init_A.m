function A = init_A(s,n,p,P_t,sigma)
    A = zeros(n,p);
    l = 10;

    for k = 1:p % Per ogni cella
        t = [ floor(k/l), mod(k,l) ]; % posiziono il target
        for kk = 1:n % per ogni sensore
            d = norm(s(kk,:)-t(1,:))+0.1; % calcolo la distanza dal sensore del target
            A(kk, k) = RSS(d, P_t, sigma); % e la RSS di quel sensore per quella posizione del target
            assert(A(kk,k) ~= inf)
        end
    end
end