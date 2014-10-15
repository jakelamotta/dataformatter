classdef WeatherFilter < Filter
    %WEATHERFILTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Access = public)
        
        function filtered = filter(this,unfiltered,type)
            filtered = unfiltered;
            
            switch type
                case 'average'                      
                    filtered = filter@Filter(this,unfiltered,4,6);

            end                    
                    
        end
    end
    
    methods (Access = private)
    
    
    end
    
end



% classdef WeatherFilter
%     %WEATHERFILTER Summary of this class goes here
%     %   Detailed explanation goes here
%     
%     properties
%     end
%     
%     methods (Access = public)
%         
%         function filtered = filter(this,unfiltered,type)
%             filtered = unfiltered;
%             switch type
%                 
%                 case 'random'
%             
%                     rows = unfiltered.getMatrix();
%                     %filtered = rows;
%                     filtered = rows([1 2 ],:);
%                     
%                 case 'average'
%                       
%                     rows = unfiltered.getMatrix();
%                     s = size(rows);
%                     
%                     for i=9:10
%                         
%                         tempSum = 0;
%                         for j=2:s(1)
%                             tempSum = tempSum + rows{j,i};
%                         end
%                         rows{2,i} = tempSum/(s(1)-1);                       
%                         
%                     end                    
%                     filtered = rows([1 2],:);
%                     
%                 case 'specific'
%                     
%                     rows = unfiltered.getMatrix();
%                     %filtered = rows;
%                     filtered = rows([1 2 ],:);
%                     
%             end                    
%                     
%         end
%     end
%     
%     methods (Access = private)
%     
%     
%     end
%     
% end

