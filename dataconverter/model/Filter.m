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
                avgRow = this.average(colStart,tempRows);
                averaged(i,:) = avgRow;
            end
            
            averaged = [firstRow;averaged];
            
            averaged = [averaged(:,1:uint32(Constants.SpectroXPos)-1),averaged(:,uint32(Constants.OlfYPos)+1:end)];
            
            this.filtered.setMatrix(averaged);
                        
            
            output = this.filtered;
        end
        
    end
    
    methods (Access = private)        
        
        function row = average(this,colStart,rows)
           
            s = size(rows);
            row = cell(1,s(2));
            
%             row{1} = rows{1,1};
%             row{2} = rows{1,2};
%             row{3} = rows{1,3};
            
            for i=1:7
                row{i} = rows{1,i};
            end

            for i=colStart:s(2)
                temp = 0;
                counter = 0;
                
                for j=1:s(1)
                    
                    if isnumeric(rows{j,i})
                        if ~isempty(rows{j,i})
                            if rows{j,i} ~= 0
                                temp = temp+rows{j,i};
                                counter = counter+1;
                            end
                        end
                      
                    else
                        if ~isnan(str2double(rows{j,i}))
                            v = str2double(rows{j,i});
                            if v ~= 0 && ~isempty(v)
                                temp = temp+v;
                                counter = counter+1;
                            end
%                         elseif ~isempty(rows{j,i})
%                             temp = rows{j,i};
                        end
                    end
                end
                if isnumeric(temp)
                    if ~isempty(temp)
                        if temp ~= 0
                            avg = temp/counter;
                            row{i} = avg;
                        end
                    else
                        row{i} = temp;
                    end
                else
                    row{i} = temp;
                end
            end
            
        end        
    end
    
end
