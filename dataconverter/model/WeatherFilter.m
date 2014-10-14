classdef WeatherFilter
    %WEATHERFILTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Access = public)
        
        function filtered = filter(this,unfiltered,type)
            filtered = unfiltered;
            switch type
                
                case 'random'
            
                    rows = unfiltered.getMatrix();
                    %filtered = rows;
                    filtered = rows([1 2 ],:);
                    
                case 'average'
                      
                    rows = unfiltered.getMatrix();
                    s = size(rows);
                    
                    %Observation name
                    tempObs = rows{2,2};
                    lenOfObs = [1];
                    inclrows = [1 2];
                    for k=3:s(1)
                        if ~strcmp(rows{k,2},tempObs)
                            lenOfObs(end) = k-1;
                            inclrows(end+1) = inclrows(end)+1; 
                            tempObs = rows{k,2};
                        end
                    end
                    
                    lenOfObs(end+1) = s(1);
                    numOfObs = length(lenOfObs);
                    
                    
                    for k=1:numOfObs
                        for i=9:10

                            tempSum = 0;
                            if k==1
                                start = 2;
                            else
                                start = lenOfObs(k-1)+1;
                            end
                            for j=start:lenOfObs(k)%s(1)
                                tempSum = tempSum + rows{j,i};
                            end
                            if k == 1
                                numRows = lenOfObs(k)-1;
                            else
                                numRows = lenOfObs(k)-lenOfObs(k-1);
                            end
                            rows{k+1,i} = tempSum/(numRows);%s(1)-1);

                        end                    
                        filtered = rows(inclrows,:);%[1 2],:);
                    end
                case 'specific'
                    
                    rows = unfiltered.getMatrix();
                    %filtered = rows;
                    filtered = rows([1 2 ],:);
                    
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

