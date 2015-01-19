classdef AbioticDataAdapter < DataAdapter
    %ABIOTICDATAADAPTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        tempMatrix;
    end
    
    methods (Access = public)
        
        function this = AbioticDataAdapter()
            this.dobj = Observation();
            this.tempMatrix = {'/AbioTime','Ab_CO2','Ab_temp','Ab_humid'};
        end
        
        function this = addValues(this,idx,p)
            this.tempMatrix = addValues@DataAdapter(this,p,idx,this.tempMatrix);
        end
%         
        %%Function that takes a list of file paths and retrieve a data
        %%object with data from these files
        function obj = getDataObject(this,paths)
            
            s = size(paths);
            
            for i=1:s(2)
                idx = strfind(paths{1,i},'\');
                
                try
                    %%The observation id is found in the filepath one step
                    %%above the type folder
                    id_ = paths{1,i}(idx(end-2)+1:idx(end-1)-1);
                catch e
                    errordlg('Incorrect path was passed to the file reader');
                end
                
                path = paths{1,i};
                
                %%Retrieve data from the file
                rawData = this.fileReader(path);
                
                temp = cellfun(@this.createDob,rawData,'UniformOutput',false);
                
                for k=1:length(temp)
                   [h,w] = size(temp{1,k});
                   
                   if w == 4
                       row = temp{1,k};
                       row{1} = strrep(strrep(row{1},'-',''),'_','');
                       this.tempMatrix = [this.tempMatrix;row];
                   end
                end
                
                
                
                this = this.addValues(idx,path);
                this.dobj = this.dobj.setObservation(this.tempMatrix,id_);                    
                this.tempMatrix = {'/AbioTime','CO2','temperature(c)','Humidity'};
            end
            
            obj = this.dobj;
        end
        
        function temp = createDob(this, inRow)
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

