classdef DataAdapter
    %The DATAADAPTER class is a superclass to the different kinds of 
    %dataadapters, one for each data type. Provides the subclasses with a
    %method for reading files. The adapters are an fits the input data into
    %the DataObject interface so that all data types can be represented
    %with the same type of object. 
    
    properties
       dobj; 
    end
    
    methods (Abstract)
        obj = getDataObject(this,paths)
    end
    
    methods (Access = public)
       function rawData = fileReader(this, path)
            
           try
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
            
           catch
              errordlg('Could not load source-file'); 
           end
        end 
    end
    
end

