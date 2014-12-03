classdef OlfactoryFilter < Filter
    %OLFACTORYFILTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Access = public)
       
        function filtered = filter(this,unfiltered,type,varargin)
            dsrate = varargin{1};
            this.filtered = unfiltered;
            
            
            
            this.downSample(dsrate);
            this.expandSpectrumPoints();
            filtered = this.filtered;
        end        
    end
    
    methods (Access = private)
        
        function this = expandSpectrumPoints(this)
           matrix = this.filtered.getMatrix();
           height = this.filtered.getNumRows();
           
           
           y1 = matrix{2,uint32(Constants.SpectroXPos)};
           
           appendee = cell(height,length(y1));
           
           for j=2:height
               row = matrix(j,:);
               
               x1 = row{uint32(Constants.SpectroYPos)};               
               
               for k=1:length(x1)
                  if j==2
                    appendee{1,k-1} = y1(k);
                  end
                  appendee{j,k-1} = x1(k);
               end               
           end
           
           matrix = [matrix(:,1:21),matrix(:,28:end)];
           matrix = [matrix,appendee];
           this.filtered.setMatrix(matrix);           
        end
        
        function this = downSample(this,dsrate)
            
            y1pos = uint32(Constants.OlfYPos);
            x1newpos = uint32(Constants.OlfXPos);
            
            matrix = this.filtered.getMatrix();
            height = this.filtered.getNumRows();
            
            for i=2:height
                y1 = matrix{i,y1pos};
                y2 = matrix{i,y2pos};
                
                x1new = round(linspace(380,600,dsrate));
                
                y1 = interp1(x1,y1,x1new);
                
                matrix{i,y1pos} = y1;
                matrix{i,x1newpos} = x1new;
            end
            
            this.filtered.setMatrix(matrix);
%             
%             listOfStructs = this.filtered.getOlfactoryData();
%             fnames = fieldnames(listOfStructs);
%             numFnames = length(fnames);
%             
%             newListOfStructs = struct;
%             
%             for i=1:numFnames
%             
%             
%                 tempStruct = listOfStructs.(fnames{i});
% 
% 
%                 x = [tempStruct.x];
%                 y = [tempStruct.y];
% 
%                 xnew = round(linspace(0,60,dsrate));
%                 
%                 y = interp1(x,y,xnew);
%                 
%                 tempStruct.x = xnew;
%                 tempStruct.y = y;
%                 
%                 newListOfStructs.(fnames{i}) = tempStruct;
%             end
%             
%             this.filtered.setOlfactory(newListOfStructs);
%             this.addOlfactoryPoints();
        end
        
        function this = addOlfactoryPoints(this)
            
            listOfolfactory = this.filtered.getOlfactoryData();
            fnames = fieldnames(listOfolfactory);
            numOfFnames = length(fnames);
            newMatrix = {};
            
            for j=1:numOfFnames 
                
                olf = listOfolfactory.(fnames{j});
                
                x = [olf.x];
                y = [olf.y];

                width = size(x);

                tempMatrix = this.filtered.getRowFromID(fnames{j});
                this.filtered.deleteRowFromID(fnames{j});
                %tempMatrix = this.filtered.getMatrix();
                s = size(tempMatrix);

                height = s(1);

                olfMatrix = cell(height,width(2));

                for i=1:width(2)
                    olfMatrix{1,i} = x(i);
                    olfMatrix{2,i} = y(i);
                end

                tempMatrix = [tempMatrix,olfMatrix];
                newMatrix = [newMatrix;tempMatrix];
            end
            [newMatrix,oldMat] = Utilities.padMatrix(newMatrix,this.filtered.getMatrix());
            finalMatrix = [oldMat;newMatrix(2:end,:)];
            this.filtered = this.filtered.setMatrix(finalMatrix);            
        end
        
    end
    
end

