classdef AbstractDataAdapter
    %ABSTRACTDATAADAPTER Summary of this class goes here
    %   Detailed explanation goes here
    
    methods (Abstract)
        obj = getDataObject(this,paths)
    end
    
    methods (Access = public)
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

