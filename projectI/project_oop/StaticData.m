classdef StaticData < handle
   properties
        tau = .7; % Gradient descent parameter
        lambda = 1e-4 % parameters
        A {mustBeNumeric} % Dictionary
        agents % agents list
        n {mustBeNonnegative} = 0 % number of agents
        l {mustBePositive} = 10 % lenght of the side of the square
        p = 100; 
        
        %% Signal parameters
        P_t = 25;
        mean = 0;
        sigma = .5;
   end
   methods
       function add_agent(obj, a)
           obj.agents = [obj.agents, a];
           obj.n = obj.n+1;
       end
       function clear_agents(obj)
           obj.agents = [];
           obj.n = 0;
       end
       function i = next_id(obj)
           i = obj.n+1;
       end
   end
end