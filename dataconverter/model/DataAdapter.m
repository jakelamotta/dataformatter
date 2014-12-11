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
        
        function g = addValues(this,path,idx,matrix)
            
            [h,w] = size(matrix);
            
            g = {'Flower','DATE','Negative','Positive';};
            
            toPad = cell(h-1,length(g));
            
            g = [g,matrix];
            
            date_ = path(idx(end-5):idx(end-4));
            
            g{2,2} = date_;
            g{1,2} = paths{1,i}(idx(end-4):idx(end-3));
%             date_ = paths{1,i}(idx(end-5):idx(end-4));
%             flower = paths{1,i}(idx(end-4):idx(end-3));
%             negOrPos = paths{1,i}(idx(end-3):idx(end-2));
%             this.tempMatrix{i+1,1} = flower;
%             this.tempMatrix{i+1,3} = date_;
%             
            if strcmp(negOrPos,'Negative')
                g{2,3} = 1;
            else
                g{2,4} = negOrPos;
            end
        end
        
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

