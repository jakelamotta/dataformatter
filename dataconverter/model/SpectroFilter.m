classdef SpectroFilter < Filter
    %SPECTROFILTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Access = public)
        
        function filtered = filter(this,unfiltered,type)
            filtered = unfiltered;
            
            switch type
                case 'average'                    
                    filtered = filter@Filter(this,unfiltered,7,9);
            end
            
        end
    end
    
end

