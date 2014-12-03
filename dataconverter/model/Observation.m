classdef Observation < handle
    %Observation - This class encapsulates the information of an
    %observation, the xlsMatrix is implemented as an cell array as all
    %cells do not contain numbers. This matrix is what is going to be
    %written to the final excel-file. 
    
    properties (Access = private)
        xlsMatrix;
        spectroTime;
    end
    
    methods (Access = public)
        
        %%
        function this = Observation()
            this.xlsMatrix = {'Flower','ID','DATE','Negative','Positive','temperature(c)','Humidity','Pressure','weatherTime','wind speed (m/s)','direction(degrees)','Temperature(c)','Contrast','Correlation','Energy','homogenity','ent','alpha','Comment','lux1','lux2','SpectroX','SpectroY','SpectroXUp','SpectroYUp','OlfX','OlfY'};
            global matrixColumns;
            this.xlsMatrix = [this.xlsMatrix,matrixColumns];
            this.spectroTime = struct;
        end
        
        %%
        function this = appendObservation(this,obj)
            matrix = obj.getMatrix();
            
            [this.xlsMatrix,matrix] = Utilities.padMatrix(this.xlsMatrix,matrix);
            
            this.setMatrix([this.xlsMatrix;matrix(2:end,:)]);
        end
        
        %%Function for merging a row 
        function this = combine(this,inObj)
            inRow = inObj.getMatrix();
            
            id = inRow{2,2};
            
            mergedObj = DataObject();
            
            outRow = this.getRowFromID(id);
            this.deleteRowFromID(id);
            
            [outRow,inRow] = Utilities.padMatrix(outRow,inRow);
            
            nrOfCols = size(outRow);
            nrOfCols = nrOfCols(2);
            
            for i=1:nrOfCols
                if xor(isempty(outRow{2,i}),isempty(inRow{2,i}))
                    outRow{2,i} = [outRow{2,i},inRow{2,i}];
                end
            end
            
            mergedObj.setMatrix(outRow);
                        
            this.appendObject(mergedObject);            
        end
        
        function row = getRowFromID(this,id)
            
            height = this.getNumRows();
            width = this.getWidth();
            row = [];
            
            for i=2:height
               for j=1:width
                   if strcmp(this.xlsMatrix{1,j},'ID') 
                       if strcmp(strrep(this.xlsMatrix{i,j},'.',''),strrep(id,'.',''))
                           row = [this.xlsMatrix(1,:);this.xlsMatrix(i,:)];
                           break;
                       end
                   end
               end                
            end           
        end
        
        function this = deleteRowFromID(this,id)
            mat = this.getMatrix();
            height = this.getNumRows();
            rowNr = -1;
            for i=2:height
                if strcmp(strrep(id,'.',''),strrep(mat{i,2},'.',''))
                    rowNr = i;
                    break;
                end
            end
            
            if rowNr ~= -1
                mat = [mat(1:rowNr-1,:);mat(rowNr+1:end,:)];
            end
            this.setMatrix(mat);
        end
        
        %%
        function this = setObservation(this,matrix,id)
            s = size(matrix);
            
            appendCell = cell(s(1),this.getWidth());
            
            start = 1;
            
            counter = 0;
            
            for i=1:s(2)                
                for j=start:this.getWidth()
                    
                    if strcmp(this.xlsMatrix{1,j},matrix{1,i})
                        for k=2:s(1);
                            counter = counter +1;
                            appendCell{k,uint32(Constants.IdPos)} = id;
                            appendCell{k,j} = matrix{k,i};
                        end
                        break;
                    end
                    counter = counter+1;
                end
            end
            
            %disp(['Loop ran for ',num2str(counter),' times']);
            [this.xlsMatrix,appendCell] = Utilities.padMatrix(this.xlsMatrix,appendCell);
            this.xlsMatrix = [this.xlsMatrix;appendCell(2:end,:)];
        end
        
        %%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%GETTERS AND SETTERS%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function spectroTime = getSpectroTime(this)
            spectroTime = this.spectroTime;
        end
        
        function this = setSpectroTime(this,id,time_)
           this.spectroTime.(strrep(id,'.','')) = time_; 
        end
        
        function this = setSpectroStruct(this,inStruct)
           this.spectroTime = inStruct; 
        end
        
        function s = getWidth(this)
            size_ = size(this.xlsMatrix);
            s = size_(2);
        end
        
        function s = getNumRows(this)
            size_ = size(this.xlsMatrix);
            s = size_(1);
        end
        
        function id = getObjectID(this)
            id = cell(1,1);
            
            for i=1:this.getWidth()
                if strcmp('ID',this.xlsMatrix{1,i})
                    id{1,1} = this.xlsMatrix{2,i};                   
                end
            end
            
            for i=3:this.getNumRows()
                for j=1:this.getWidth()
                  if strcmp('ID',this.xlsMatrix{1,j})
                      id{1,i-1} = this.xlsMatrix{i,j};
                  end
                end
            end
        end
        
        function matrix = getMatrix(this)
            matrix = this.xlsMatrix;
        end
        
        function this = setMatrix(this,m)
            this.xlsMatrix = m;
        end
        
        function this = setID(this,id)
           height = this.getNumRows();
           this.xlsMatrix{height+1,2} = id;
        end
    end
end

