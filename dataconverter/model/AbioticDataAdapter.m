classdef AbioticDataAdapter < DataAdapter
    %ABIOTICDATAADAPTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        initMatrix
    end
    
    methods (Access = public)
        
        function this = AbioticDataAdapter()
            this.dobj = Observation();
            this.initMatrix = {'/AbioTime','Ab_CO2','Ab_temp','Ab_humid'};
            this.tempMatrix = this.initMatrix;
        end
        
        function this = addValues(this,p)
            this.tempMatrix = addValues@DataAdapter(this,p,this.tempMatrix);
        end
%         
        %%Function that takes a list of file paths and retrieve a data
        %%object with data from these files
        function obj = getDataObject(this,paths)
            len = length(paths);
            
            this.nrOfPaths = len;
            
            for i=1:len
                this.updateProgress(i); %Updates the waitbar
                
                path = paths{1,i};
                
                
                id_ = DataAdapter.getIdFromPath(path);%Retrieves observation id from path         
                
                rawData = this.fileReader(path); %Retrieve raw data from the file
                
                temp = cellfun(@this.createObs,rawData,'UniformOutput',false);
                
                for k=1:length(temp)
                   [h,w] = size(temp{1,k});
                   
                   if w == 4
                       row = temp{1,k};
                       row{1} = strrep(strrep(row{1},'-',''),'_','');
                       this.tempMatrix = [this.tempMatrix;row];
                   end
                end
                
                this = this.addValues(path);
                this.dobj = this.dobj.setObservation(this.tempMatrix,id_);                    
                this.tempMatrix = this.initMatrix;
            end
            close(this.mWaitbar);
            obj = this.dobj;
        end
        
        function temp = createObs(this, inRow)
            %Split around " ; ".
            row = regexp(inRow,[char(9),';',char(9)],'split');
            
            temp = cellfun(@AbioticDataAdapter.handleRow,row,'UniformOutput',false);
            %temp = cellfun(@str2num,row,'UniformOutput',false);%[this.tempMatrix;cellfun(@str2num,row,'UniformOutput',false)];
        end
        
        %%Filereader that uses the parent class filereader, for debugging
        %%this look in DataAdapter class
        function rawData = fileReader(this, path)
            rawData = fileReader@DataAdapter(this,path);
        end
        
    end
    
    methods (Static)
        
        function elem = handleRow(elem)
            
            idx = strfind(elem,';');
            
            if ~isempty(idx)
                temp = elem(1:idx-1);
                temp = strrep(temp,',','.');
                elem = str2double(temp);
            end
        end
    end
end

