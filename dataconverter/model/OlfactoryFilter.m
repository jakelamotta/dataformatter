classdef OlfactoryFilter < Filter
    %OLFACTORYFILTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
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
            
            listOfStructs = this.filtered.getOlfactoryData();
            fnames = fieldnames(listOfStructs);
            numFnames = length(fnames);
            
            newListOfStructs = struct;
            
            for i=1:numFnames
            
            
                tempStruct = listOfStructs.(fnames{i});


                x = [tempStruct.x];
                y = [tempStruct.y];

                xnew = round(linspace(0,60,dsrate));
                
                y = interp1(x,y,xnew);
                
                tempStruct.x = xnew;
                tempStruct.y = y;
                
                newListOfStructs.(fnames{i}) = tempStruct;
            end
            
            this.filtered.setOlfactory(newListOfStructs);
            this.addOlfactoryPoints();
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

