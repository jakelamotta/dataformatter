classdef Filter < handle
    %FILTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        filtered;
    end
    
    methods (Access = public)
        
        function output = filter(this,unfiltered,colStart,colEnd)
            this.filtered = unfiltered;
            
            
            rows = unfiltered.getMatrix();
            newrows = rows;
            s = size(rows);
            
            %Observation name
            tempObs = rows{2,2};
            %lenOfObs = [s(1)];
            lenOfObs = [];
            inclrows = [1 2];
            oneObs = true;
            
            for k=2:s(1)
                if ~strcmp(rows{k,2},tempObs)
                    lenOfObs(end+1) = k;%-1;
                    
                    inclrows(end+1) = inclrows(end)+1;
                    tempObs = rows{k,2};
                    oneObs = false;
                end
            end
            
            if ~oneObs
                lenOfObs(end+1) = s(1);
            end
            
            numOfObs = length(lenOfObs);
            
            disp(numOfObs);
            for k=1:numOfObs
                for i=colStart:colEnd
                    
                    tempSum = 0;
                    if k==1
                        start = 2;
                    else
                        start = lenOfObs(k-1);
                    end
                    
                    for j=start:lenOfObs(k)
                        tempSum = tempSum + rows{j,i};                        
                    end
                    
                    if k == 1
                        numRows = lenOfObs(k)-1;
                    else
                        numRows = lenOfObs(k)-lenOfObs(k-1);
                    end
                    
                    newrows{k+1,i} = tempSum/(numRows);
                    %rows{k+1,1} = rows{start,1};
                    newrows{k+1,2} = rows{start,2};
                end
                
                this.filtered = this.filtered.setMatrix(newrows(inclrows,:));
            end
            
            output = this.filtered;
        end
        
    end
    
end
% 
% classdef Filter < handle
%     %FILTER Summary of this class goes here
%     %   Detailed explanation goes here
%     
%     properties
%         filtered;
%     end
%     
%     methods (Access = public)
%         
%         function output = filter(this,unfiltered,colStart,colEnd)
%             this.filtered = unfiltered;
%             
%             
%             rows = unfiltered.getMatrix();
%             s = size(rows);
%             
%             %Observation name
%             tempObs = rows{2,2};
%             %lenOfObs = [s(1)];
%             lenOfObs = [];
%             inclrows = [1 2];
%             oneObs = true;
%             
%             for k=2:s(1)
%                 if ~strcmp(rows{k,2},tempObs)
%                     lenOfObs(end+1) = k;%-1;
%                     
%                     inclrows(end+1) = inclrows(end)+1;
%                     tempObs = rows{k,2};
%                     oneObs = false;
%                 end
%             end
%             
%             if ~oneObs
%                 lenOfObs(end+1) = s(1);
%             end
%             
%             numOfObs = length(lenOfObs);
%             
%             disp(numOfObs);
%             for k=1:numOfObs
%                 for i=colStart:colEnd
%                     
%                     tempSum = 0;
%                     if k==1
%                         start = 2;
%                     else
%                         start = lenOfObs(k-1)+1;
%                     end
%                     
%                     for j=start:lenOfObs(k)
%                         tempSum = tempSum + rows{j,i};
%                         
%                     end
%                     
%                     if k == 1
%                         numRows = lenOfObs(k)-1;
%                     else
%                         numRows = lenOfObs(k)-lenOfObs(k-1);
%                     end
%                     
%                     rows{k+1,i} = tempSum/(numRows);
%                     rows{k+1,1} = rows{start,1};
%                     rows{k+1,2} = rows{start,2};
%                 end
%                 
%                 this.filtered = this.filtered.setMatrix(rows(inclrows,:));
%             end
%             
%             output = this.filtered;
%         end
%         
%     end
%     
% end
% 
