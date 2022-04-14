classdef Neighbor < handle

    properties
        agent % object
        weight {mustBeNumeric} % weight for it
    end

    methods
        function obj = Neighbor(a, w)
            obj = obj@handle();
            
            obj.agent = a;
            obj.weight = w;
        end
    end
    
end