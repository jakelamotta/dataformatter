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
                path = paths{1,i};
                rawData = this.fileReader(this,path);
                
                
                
                
            end
        end
        
        function temp = createDob(this, inRow)
            row = regexp(inRow,[char(9),';',char(9)],'split');
            temp = cellfun(@str2num,row,'UniformOutput',false);%[this.tempMatrix;cellfun(@str2num,row,'UniformOutput',false)];
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
    
end

