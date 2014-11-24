classdef ImageFilter < Filter
    %IMAGEFILTER Summary of this class goes here
    %Detailed explanation goes here
    properties
    
    end
    
    methods (Access = public)
        function filtered = filter(this,unfiltered,type,varargin)
            this.filtered = unfiltered;
            
            switch type                
                case 'nofilter'
                    
                case 'average'                    
                    this.filtered = filter@Filter(this,this.filtered,10,this.filtered.getWidth());
            end
            
            filtered = this.filtered;
        end
    end
end