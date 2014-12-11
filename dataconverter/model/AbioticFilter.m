classdef AbioticFilter < Filter
    %ABIOTICFILTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Access = public)
        
        function output = filter(this,unfiltered,type,varargin)
            this.filtered = unfiltered;
            
            switch type
                case 'average'                    
                    this.filtered = filter@Filter(this,unfiltered,6,9);
            end
            
            output = this.filtered;
            
        end
    end
    
end

