classdef WeatherFilter
    %WEATHERFILTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Access = public)
        
        function filtered = filter(this,unfiltered)
            rows = unfiltered.getMatrix();
            filtered = rows([1 2 ],:);
        end
    end
    
end

