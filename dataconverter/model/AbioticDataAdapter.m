classdef AbioticDataAdapter < AbstractDataAdapter
    %ABIOTICDATAADAPTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dobj;
        tempMatrix;
    end
    
    methods (Access = public)
        
        function this = AbioticDataAdapter()
            this.dobj = DataObject();
            this.tempMatrix = {'Date','Pressure','temperature(c)','Humidity'};
        end
        
        function obj = getDataObject(this,paths)
            
            s = size(paths);
            for i=1:s(2)
                idx = strfind(paths{1,i},'\');
                id_ = paths{1,i}(idx(end-2)+1:idx(end-1)-1);
                
                path = paths{1,i};
                rawData = this.fileReader(path);
                
                temp = cellfun(@this.createDob,rawData,'UniformOutput',false);
                
                for k=1:length(temp)
                   
                   this.tempMatrix = [this.tempMatrix;temp{1,k}];
                   
                   this.dobj = this.dobj.setObservation(this.tempMatrix,id_);                    
                end
            end
            
            obj = this.dobj;
        end
        
        function temp = createDob(this, inRow)
            row = regexp(inRow,[char(9),';',char(9)],'split');
            
            temp = cellfun(@AbioticDataAdapter.handleRow,row,'UniformOutput',false);
            
            %temp = cellfun(@str2num,row,'UniformOutput',false);%[this.tempMatrix;cellfun(@str2num,row,'UniformOutput',false)];
        end
        
        function rawData = fileReader(this, path)
            
            fid = fopen(path,'r');
            
            line_ = fgets(fid);
            rawData = cell(1,1);
            index = 1;
            while line_ ~= -1
                rawData{1,index} = line_;
                line_ = fgets(fid);
                index = index+1;
            end
            
            fclose(fid);
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

