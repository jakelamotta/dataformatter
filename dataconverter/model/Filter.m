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
            firstRow = rows(1,:);
            rows = rows(2:end,:);
            %s = size(rows);
            height = unfiltered.getNumRows()-1;
            
            indices = [1,0];
            temp = rows{1,2};
            
            for k=1:height
                if ~strcmp(temp,rows{k,2})
                    indices(end) = k-1;
                    indices = [indices;[k,0]];
                    temp = rows{k,2};
                end
            end
            
            indices(end) = height;
            
            s = size(indices);
            
            averaged = cell(s(1),unfiltered.getWidth());
            
            for i=1:s(1)
                start = indices(i,1);
                end_ = indices(i,2);
                
                tempRows = rows(start:end_,:);
                avgRow = this.average(tempRows);
                averaged(i,:) = avgRow;
            end
            
            averaged = [firstRow;averaged];
            this.filtered.setMatrix(averaged);
            
            output = this.filtered;
        end
        
    end
    
    methods (Access = private)
        
        
        function row = average(this,rows)
           
            s = size(rows);
            row = cell(1,s(2));
            row{1} = rows{1,1};
            row{2} = rows{1,2};
            row{3} = rows{1,3};
            for i=6:s(2)
                temp = 0;
                
                for j=1:s(1)
                    temp = temp+rows{j,i};
                end
                avg = temp/s(1);
                row{i} = avg;
            end
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
