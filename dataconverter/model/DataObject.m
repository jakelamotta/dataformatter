classdef DataObject < handle
    %DATAOBJECT - This class encapsulates the information of an
    %observation, the xlsMatrix is implemented as an cell array as all
    %cells do not contain numbers. This matrix is what is going to be
    %written to the final excel-file. 
    
    properties (Access = private)
        xlsMatrix;
        spectroData;
        olfactoryData;
    end
    
    methods (Access = public)
        
        function this = DataObject()
            this.xlsMatrix = {'Flower','ID','Date','temperature(c)','Humidity','Pressure','weatherTime','wind speed (m/s)','direction(degrees)','Temperature(c)','lux1','lux2','Contrast','Correlation','Energy','homogenity','ent','alpha','Comment'};
            global matrixColumns;
            
            this.xlsMatrix = [this.xlsMatrix,matrixColumns];
            
            this.spectroData = struct;
            this.olfactoryData = struct;
        end
        
        function this = addSpectroData(this,inStruct,id_)
            if ~isfield(this.spectroData,strrep(id_,'.',''))
                id_ = strrep(id_,'.','');
                this.spectroData.(id_) = inStruct;     
            else
                id_ = strrep(id_,'.','');
                this.spectroData.(id_)(end+1) = inStruct;
            end
        end
        
        function this = appendObject(this,obj)
            spectro = obj.getSpectroData();
            olf = obj.getOlfactoryData();
            matrix = obj.getMatrix();
            
            [this.xlsMatrix,matrix] = Utilities.padMatrix(this.xlsMatrix,matrix);
            
            this.setMatrix([this.xlsMatrix;matrix(2:end,:)]);
            
            fnames = fieldnames(spectro);
            numFnames = length(fnames);
            
            for i=1:numFnames
                fname = fnames{i};
                this.addSpectroData(spectro,fname);
            end
            
            fnames = fieldnames(olf);
            numFnames = length(fnames);
            
            for i=1:numFnames
                fname = fnames{i};
                this.addOlfactoryData(olf.(fname),fname);
            end            
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
            
            if isempty(fieldnames(inObj.getOlfactoryData()))
                mergedObj.addOlfactoryData(inObj.getOlfactoryData());
            end
            
            if isempty(fieldnames(inObj.getOlfactoryData()))
                mergedObj.addSpectroData(inObj.getSpectrosData());
            end        
            
            this.appendObject(mergedObject);            
        end
                
        function this = addOlfactoryData(this,inStruct,id_)
            if isempty(this.olfactoryData)
                mex = MException('InvalidOlfactorydata:isempty','Olfactory data is empty');
                throw(mex);
            end
            
            if ~isfield(this.olfactoryData,id_)
                id_ = strrep(id_,'.','');
                this.olfactoryData.(id_) = inStruct;            
            end
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
                            appendCell{k,2} = id;
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
        
        function sout = getSpectroData(this)
            sout = this.spectroData;
        end
        
        function oout = getOlfactoryData(this)
            oout = this.olfactoryData;
        end
        
        function this = setOlfactory(this,inStruct)
            this.olfactoryData = inStruct;
        end
        
        function this = setID(this,id)
           height = this.getNumRows();
           this.xlsMatrix{height+1,2} = id;
        end
        
        function this = setSpectroData(this,inStruct)
            this.spectroData = inStruct;
        end
    end    
    
    methods (Access = private)                
        function this = initStructFields(this)
            this.spectroData = struct;
            this.olfactoryData = struct;
        end
    end    
end

