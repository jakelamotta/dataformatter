classdef DataAdapter
    %The DATAADAPTER class is a general class to the different kinds of
    %dataadapters, one for each data type. Provides the subclasses with a
    %method for reading files. The adapters are an fits the input data into
    %the DataObject interface so that all data types can be represented
    %with the same type of object.
    
    properties
        dobj;
        genData;
    end
    
    methods (Abstract)
        obj = getDataObject(this,paths)
    end
    
    methods (Access = public)
        
        function this = DataAdapter()
            this.genData = {'Flower','DATE','Negative','Positive';};
        end
        
        function matrix = addValues(this,path,idx,matrix)
            [h,w] = size(matrix);
            g = [{'Flower','DATE','Negative','Positive'};cell(h-1,4)];
            
            matrix = [g,matrix];
            
            date_ = path(idx(end-5):idx(end-4));
            
            flower = path(idx(end-4):idx(end-3));
            negOrPos = path(idx(end-3):idx(end-2));
            
            for i=2:h
                matrix{i,1} = flower(2:end-1);
                matrix{i,2} = date_(2:end-1);
                matrix{i,3} = double(strcmp(negOrPos(2:end-1),'negative'));
                matrix{i,4} = double(~strcmp(negOrPos(2:end-1),'negative'));
            end
        end
        
        %%Generic filereader used to get rawdata from txt files, applicable
        %%for most of the different data types
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

