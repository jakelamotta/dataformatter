classdef Observation < handle
    %Observation - This class encapsulates the information of an
    %observation, the xlsMatrix is implemented as an cell array as all
    %cells do not contain numbers. This matrix is what is going to be
    %written to the final excel-file.
    
    properties (Access = private)
        xlsMatrix;
    end
    
    methods (Access = public)
        
        %%Constructor. 
        function this = Observation()
%             this.xlsMatrix = {'Flower','ID','DATE','/SpectroTime','/weatherTime','Negative','Positive','temperature(c)','Humidity','CO2','wind speed (m/s)','direction(degrees)','Temperature(c)','Contrast','Correlation','Energy','homogenity','ent','alpha','Comment'};
%             global matrixColumns;
%             this.xlsMatrix = [this.xlsMatrix,matrixColumns,{'lux_flower','lux_up','SpectroX','SpectroY','SpectroXUp','SpectroYUp','OlfX','OlfY'}];
            global matrixColumns;
            this.xlsMatrix = [matrixColumns,{'lux_flower','lux_up','SpectroX','SpectroY','SpectroXUp','SpectroYUp','OlfX','OlfY'}];
        end
        
        %%Adding an observation to another, it doesnt consider copies or
        %ids but simply appends the rows from the input observation to the
        %to the current
        function this = appendObservation(this,obj)
            matrix = obj.getMatrix();
            [this.xlsMatrix,matrix] = Utilities.padMatrix(this.xlsMatrix,matrix);
            this.setMatrix([this.xlsMatrix;matrix(2:end,:)]);
        end
        
        %%Adds zeroes to any empty cell in the Observation cell array
        function this = fillWithZeros(this)
            for i=4:this.getWidth()
                for j=2:this.getNumRows()
                    if isemtpy(this.xlsMatrix{j,i})
                        this.xlsMatrix{j,i} = 0;
                    end
                end
            end
        end
        
        %%
        function this = mergeObservations(this,rowNr1,rowNr2)
            this.getWidth();
            mergeable = true;
            
            for i=3:this.getWidth()
                mergeable = mergeable & (this.xlsMatrix{rowNr1,i} == this.xlsMatrix{rowNr2,i});
                if ~mergeable
                    break;
                end
            end
            
            if mergeable
                this.xlsMatrix{rowNr1,5} = [this.xlsMatrix{rowNr1,5},' ',this.xlsMatrix{rowNr2,5}];
            end
            
            this.deleteRowFromID(this.xlsMatrix(rowNr2,uint32(Constants.IdPos)));
        end
        
        %%Boolean function that checks if there are multiples of any id in
        %%the observation matrix
        function hasMultiples = hasMultiples(this)
            this.sortById();
            hasMultiples = false;
            
            for i=3:this.getNumRows()
                if strcmp(this.xlsMatrix{i,2},this.xlsMatrix{i-1,2})
                    hasMultiples = true;
                    break;
                end
            end
        end
        
        %%Sorts the observation matrix by ID
        function this = sortById(this)
            matrix = this.getMatrix();
            
            data = matrix(2:end,:);
            topRow = matrix(1,:);
            
            data = sortrows(data,2);
            
            matrix = [topRow;data];
            this.setMatrix(matrix);
        end
        
        %%Calculates average for each observation
        function this = doAverage(this,colStart)
            this.sortById();
            matrix = this.getMatrix();
            
            firstRow = matrix(1,:);
            matrix = matrix(2:end,:);
            
            height = this.getNumRows()-1;
            
            indices = [1,0];
            temp = matrix{1,2};
            
            for k=1:height
                if ~strcmp(temp,matrix{k,2})
                    indices(end) = k-1;
                    indices = [indices;[k,0]];
                    temp = matrix{k,2};
                end
            end
            
            indices(end) = height;
            
            [h,w] = size(indices);
            
            averaged = cell(h,this.getWidth());
            
            for i=1:h
                start = indices(i,1);
                end_ = indices(i,2);
                
                tempRows = matrix(start:end_,:);
                avgRow = this.average(colStart,tempRows);
                averaged(i,:) = avgRow;
            end
            
            averaged = [firstRow;averaged];
            
            this.setMatrix(averaged);
        end
        
        %%Initially the data for Olfactory and the spectrum points of Spectrophotometerdata
        %%are stored in arrays in the cell. These arrays need to be removed
        %%before the Observation can be displayed in a table
        function this = removeArrays(this)
            matrix = this.getMatrix();
            matrix = [matrix(:,1:uint32(Constants.SpectroXPos)-1),matrix(:,uint32(Constants.OlfYPos)+1:end)];
            this.setMatrix(matrix);
        end
        
        function row = average(this,colStart,rows)
            
            [h,w] = size(rows);
            row = cell(1,w);
            
            for i=1:7
                row{i} = rows{1,i};
            end
            
            for i=colStart:w
%                row{i} = sum(cell2mat(rows(:,8)))/(this.getNumRows()-1);
                temp = 0;
                counter = 0;
                
                for j=1:h
                    
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
        
        
        function this = downSample(this,dsrate,type)
            y1pos = uint32(Constants.SpectroYPos);
            y2pos = uint32(Constants.SpectroYUpPos);
            x1newpos = uint32(Constants.SpectroXPos);
            x2newpos = uint32(Constants.SpectroXUpPos);
            
            matrix = this.getMatrix();
            height = this.getNumRows();
            
            if strcmp(type,'Spectro')
                for i=2:height
                    y1 = matrix{i,y1pos};
                    x1 = matrix{i,x1newpos};
                    y2 = matrix{i,y2pos};
                    x2 = matrix{i,x2newpos};
                    
                    x1new = round(linspace(380,600,dsrate));
                    x2new = round(linspace(380,600,dsrate));
                    
                    y1 = interp1(x1,y1,x1new);
                    y2 = interp1(x2,y2,x2new);
                    
                    matrix{i,y1pos} = y1;
                    matrix{i,y2pos} = y2;
                    matrix{i,x1newpos} = x1new;
                    matrix{i,x2newpos} = x2new;1
                end
            else
                y1pos = uint32(Constants.OlfYPos);
                x1newpos = uint32(Constants.OlfXPos);
                
                for i=2:height
                    
                    
                    y1 = matrix{i,y1pos};
                    x1 = matrix{i,x1newpos};
                    
                    x1new = linspace(min(x1),max(x1),dsrate);
                    
                    y1 = interp1(x1,y1,x1new);
                    
                    matrix{i,y1pos} = y1;
                    matrix{i,x1newpos} = x1new;
                end
            end
            this.setMatrix(matrix);
        end
        
        function this = expandSpectrumPoints(this,type)
            matrix = this.getMatrix();
            height = this.getNumRows();
            
            if strcmp(type,'Spectro')
                spectroXpos = uint32(Constants.SpectroXPos);
                spectroXuppos = uint32(Constants.SpectroXUpPos);
                
                y1 = matrix{2,spectroXpos};
                y2 = matrix{2,spectroXuppos};
                
                appendee = cell(height,2*length(y1));
                
                for j=2:height
                    row = matrix(j,:);
                    
                    x1 = row{uint32(Constants.SpectroYPos)};
                    x2 = row{uint32(Constants.SpectroYUpPos)};
                    
                    for k=1:length(x1)
                        
                        if j==2
                            appendee{1,k} = [num2str(y1(k)),'_f'];
                            appendee{1,k+length(x1)} = [num2str(y2(k)),'_u'];
                        end
                        
                        appendee{j,k} = x1(k);
                        appendee{j,k+length(x1)} = x2(k);
                    end
                end
                
            else
                
                y1 = matrix{2,uint32(Constants.OlfXPos)};
                
                appendee = cell(height,length(y1));
                
                for j=2:height
                    row = matrix(j,:);
                    
                    x1 = row{uint32(Constants.OlfYPos)};
                    
                    for k=1:length(x1)
                        if j==2
                            appendee{1,k} = y1(k);
                        end
                        appendee{j,k} = x1(k);
                    end
                end
            end
            matrix = [matrix,appendee];
            this.setMatrix(matrix);
        end
        
        %%Sorts the observations by date
        function this = sortByDate(this)
            matrix = this.getMatrix();
            
            data = matrix(2:end,:);
            topRow = matrix(1,:);
            
            data = sortrows(data,3);
            
            matrix = [topRow;data];
            
            this.setMatrix(matrix);
        end
                
        %%Function for merging a row
        function this = combine(this,id)
            mergeObj = Observation();
            matrix = this.getMatrix();
            
            row = [matrix(1,:);cell(1,this.getWidth())];
            
            for j=2:this.getNumRows()
                if strcmp(id,matrix{j,2})
                    for i=1:this.getWidth()
                        if isempty(row{2,i})
                            row{2,i} = matrix{j,i};
                        end
                    end
                end
            end
            
            while (this.isObservation(id))
                this.deleteRowFromID(id);
            end
            
            mergeObj.setMatrix(row);
            this.appendObservation(mergeObj);
        end
        
        %%Boolean function that checks if the input ID already exists as an
        %%observation
        function isObs = isObservation(this,id)
            isObs = false;
            for i=2:this.getNumRows()
                isObs = strcmp(id,this.xlsMatrix{i,2});
                if isObs
                    break;
                end
            end
        end
        
        %%Function that returns a single row corresponding to the input ID
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
        
        %%Function that deletes a single row corresponding to the input ID
        function this = deleteRowFromID(this,id)
            mat = this.getMatrix();
            height = this.getNumRows();
            rowNr = -1;
            for i=2:height
                if strcmp(strrep(id,'.',''),strrep(mat{i,2},'.',''))
                    rowNr = i;
                end
            end
            
            if rowNr ~= -1
                mat = [mat(1:rowNr-1,:);mat(rowNr+1:end,:)];
            end
            this.setMatrix(mat);
        end
        
        %%Function that takes a cell array and an ID as input, the elements
        %%of the cell array are indvidually mapped to columns in the
        %%observation matrix. All are set to the same row with ID id.
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
            
            [this.xlsMatrix,appendCell] = Utilities.padMatrix(this.xlsMatrix,appendCell);
            this.xlsMatrix = [this.xlsMatrix;appendCell(2:end,:)];
        end
        
        
        %%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%GETTERS AND SETTERS%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function spectroTime = getSpectroTime(this,id)
            spectroTime = '';
            for i=4:this.getWidth()
                if strcmp(this.xlsMatrix{1,i},'/SpectroTime')
                    for j=2:this.getNumRows()
                        if strcmp(id,this.xlsMatrix{j,2})
                            spectroTime = this.xlsMatrix{j,i};
                        end
                    end
                end
            end
        end
        
        function abioticTime = getAbioticTime(this,id)
            abioticTime = '';
            for i=4:this.getWidth()
                if strcmp(this.xlsMatrix{1,i},'/AbioTime')
                    for j=2:this.getNumRows()
                        if strcmp(id,this.xlsMatrix{j,2})
                            abioticTime = this.xlsMatrix{j,i};
                        end
                    end
                end
            end
        end
        
        function width = getWidth(this)
            [h,width] = size(this.xlsMatrix);
        end
        
        function height = getNumRows(this)
            [height,w] = size(this.xlsMatrix);
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