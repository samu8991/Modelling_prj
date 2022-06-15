function A = init_A(s, n, p, P_t, sigma, offset)
arguments
    s,
    n, 
    p, 
    P_t, 
    sigma, 
    offset = [0, 0]
end
    A = zeros(n,p);
    l = 10;

    for k = 1:p % Per ogni cella
        t = [ floor(k/l)+offset(1), mod(k,l)+offset(2)]; % posiziono il target
        for kk = 1:n % per ogni sensore
            d = norm(s(kk,:)-t(1,:)); % calcolo la distanza dal sensore del target
            A(kk, k) = RSS(d, P_t, sigma); % e la RSS di quel sensore per quella posizione del target
            assert(A(kk,k) ~= inf)
        end
    end
end