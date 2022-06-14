function [sr, d, cumd] = metric_success_rate(data, options)
% This function returns the percentage of cases in which the target is
% correctly localized over the total number of cases. This is useful with
% the ODIST algorithm.

% This function also returns the distance (computed in euclidean norm) of
% the error for each time instant (d) and the cumulative error for each 
% time instant (cumd) 
arguments
    options.display bool = false; % whether to display d and cumd or not
end


r = 0;
d = 0;
cumd = 0;
end