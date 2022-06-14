%% standard model variables
function standard_model_variables(options)
arguments
    options.output_state logical = 1; % binary variable indicating wheter the state is  directly measureble or not
    options.eps_on logical = 1; % 0 to use local controller, 1 for neighborhood controller
    options.zeta_on logical = 1; % 0 to use local observer, 1 for neighborhood observer
    options.measurement_noise_type uint8 = 1; % 1 for no noise.
    options.local_or_neighborhood_observer uint8 = 2; % 2 means local observer, 1 means neighborhood
end

assignin('base', 'output_state', options.output_state);
assignin('base', 'eps_on', options.eps_on);
assignin('base', 'zeta_on', options.zeta_on);
assignin('base', 'measurement_noise_type', options.measurement_noise_type);
assignin('base', 'local_or_neighborhood_observer', options.local_or_neighborhood_observer);



end