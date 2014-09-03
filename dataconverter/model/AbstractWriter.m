classdef (Abstract) AbstractWriter
    %ABSTRACTWRITER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Abstract)
        fileName;
    end
    
    methods (Abstract)
        function success = setFileName(name)
        end
    end
    
end

