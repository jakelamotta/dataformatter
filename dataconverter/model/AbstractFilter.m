classdef (Abstract) AbstractFilter
    %ABSTRACTFILTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Abstract)
    end
    
    methods (Abstract)
        function success = applyFilter(dataObject)
        end
    end
    
end

