classdef OlfactoryFilter < Filter
    %OLFACTORYFILTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        filtered;
    end
    
    methods (Access = public)
       
        function filtered = filter(this,unfiltered,type,varargin)
            dsrate = varargin{1};
            this.filtered = unfiltered;
            
            this = this.downSample(dsrate);
            
            filtered = this.filtered;
        end        
    end
    
    methods (Access = private)
        
        
        function this = downSample(this,dsrate)
            tempStruct = this.filtered.getOlfactoryData();
            
            x = [tempStruct.x];
            y = [tempStruct.y];

            xnew = round(linspace(380,600,dsrate));
            xnew = round(linspace(380,600,dsrate));
            
            y = interp1(x,y,xnew);
            
            tempStruct.x = xnew;
            tempStruct.y = y;
            
            this.filtered.setOlfactory(tempStruct);
        end
    end
    
end

