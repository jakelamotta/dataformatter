classdef WeatherFilter < Filter

    %WEATHERFILTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Access = public)
        
        function output = filter(this,unfiltered,type,varargin)
            this.filtered = unfiltered;
            
            switch type
                case 'average'
                    disp('hej');
                    this.filtered = filter@Filter(this,unfiltered,9,13);
            end        
            
            output = this.filtered;
                    
        end
    end
    
    methods (Access = private)
       
    end
    
end