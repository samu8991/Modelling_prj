function A = init_A(s, n, p, P_t, sigma, offset, m)
arguments
    s, % sensors arrangement as generated from deploy
    n, % number of sensors
    p, % number of cells
    P_t, % transmission power
    sigma, % noise variance for RSS
    offset = [0, 0] % ofsset for the cell to measure
    m {mustBePositive} = 1; % numbers of measurements per cell
end
    A = zeros(n*m,p);
    l = 10;
    size(A);
     for m_i = 1:m % faccio m misurazioni
        for pos_i = 1:p % Per ogni cella
            t = cell2pos(pos_i, l, false, offset); % posiziono il target
            for n_i = 1:n % per ogni sensore
                    d = norm(s(n_i,:)-t); % calcolo la distanza dal sensore del target
                    A( (n_i-1)*m  + m_i, pos_i) = RSS(d, P_t, sigma); % e la RSS di quel sensore per quella posizione del target
                    assert(A(n_i, pos_i) ~= inf)
            end
        end
    end
end