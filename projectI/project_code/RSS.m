function ret = RSS(d, P_t, sigma)
% d is the distance between the source and th sensor
% P_t is the transmision power
% sigma is the variance of the noise

    eta = randn(1)*sigma;
    if d > 8
        ret = P_t - 58.5 - 33 *log10(d)+ eta;
    elseif d > 0
        ret = P_t - 40.2 - 20*log10(d) + eta;
    else
        ret = P_t; % if the objects are really close, we assume no loss in the power
    end
 
        
end