classdef AbioticFilter
    %ABIOTICFILTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Access = public)
        
        function filtered = filter(this,unfiltered,type)
            rows = unfiltered.getMatrix();
            s = size(rows);
            
            for i=11:13
                
                tempSum = 0;
                for j=2:s(1)
                    tempSum = tempSum + rows{j,i};
                end
                rows{2,i} = tempSum/(s(1)-1);
                
            end
            filtered = rows([1 2],:);
        
        end
    end
    
end

