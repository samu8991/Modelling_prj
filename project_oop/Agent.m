classdef Agent < handle
    properties (Constant)
        static = StaticData
    end
    properties 
        x, xold, xbar {mustBeFinite}
        id {mustBePositive}
        y(1,1) {mustBeFinite} %single measurement
        A(:,1) {mustBeNumeric} %single line dictionary
        position(2,1) double {mustBeFinite} %x,y position
        neighbors % Neighbor class array
    end
    
    methods(Static)
        function clear()
            Agent.static.clear_agents()
        end
    end
    
    methods
        function obj = Agent()
            obj = obj@handle();
            Agent.static.add_agent(obj);
            obj.id = obj.static.n;
            obj.position = rand(2,1) * Agent.static.l;
            obj.x = zeros(obj.static.p,1);
        end % Agent
        
        function setQ(obj, Q)
            obj.neighbors = [];
            for i = 1:length(Q)
                if Q(i) ~= 0
                    n = Neighbor(Agent.static.agents(i), Q(i));
                    obj.neighbors = [obj.neighbors, n];
                end
            end % for
        end % setQ
        
        function y = measure(obj, target, p)
            arguments
                obj
                target
                p = 0
            end
            s = obj.static;
            d = norm(obj.position-target);
            eta = randn * s.sigma + s.mean;
            if d > 8
                y = s.P_t - 58.5 - 33*log10(d)+ eta;
            else
                y = s.P_t - 40.2 - 20*log10(d)+ eta;
            end
            obj.y = y;
            if p ~= 0
                obj.A(p) = y;
            end
        end % measure
        
        function feng(obj, B,z)
            obj.y = z(obj.id);
            obj.A = B(obj.id,:);
            obj.A = obj.A';
        end %feng 
        
        function DIST_step(obj)
           s = obj.static;
           obj.xold = obj.x;
           % Compute xbar
           obj.xbar = zeros(s.p,1);
           for el = obj.neighbors
               obj.xbar = obj.xbar + el.weight * el.agent.x;
           end
           % Compute new state x
           obj.x = obj.xbar + s.tau * obj.A * (obj.y - obj.A' * obj.xold);
            for i = 1:length(obj.x)
                if(abs(obj.x(i)) <= s.lambda)
                    obj.x(i) = 0;
                else
                    obj.x(i) = obj.x(i) - sign(obj.x(i))*s.lambda; 
                end
            end
        end % DIST_step
        
    end % methods
end % classdef
    