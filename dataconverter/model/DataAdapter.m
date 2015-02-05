classdef DataAdapter < handle
    %The DATAADAPTER class is a general class to the different kinds of
    %dataadapters, one for each data type. Provides the subclasses with a
    %method for reading files. The adapters are an fits the input data into
    %the DataObject interface so that all data types can be represented
    %with the same type of object.
    
    properties
        dobj;
        tempMatrix;
        genData;
        nrOfPaths;
        mWaitbar;
    end
    
    %Abstract method, methods that any subclass must implement
    methods (Abstract)
        obj = getObservation(this,paths)
    end
    
   
    
    methods (Access = public)
        
        function this = updateProgress(this,nrOfSolved)
            this.mWaitbar = waitbar(nrOfSolved/this.nrOfPaths);
        end
        
        function this = DataAdapter()
            this.genData = {'Flower','Date','Negative','Positive';};
            if ~isa(this,'ImageDataAdapter')
                this.mWaitbar = waitbar(0,'Please wait while data is loaded...','Name',class(this));
            end
        end
        
        function matrix = addValues(this,path,matrix)
            [h,w] = size(matrix);
            
            g = [{'Flower','Date','Negative','Positive'};cell(h-1,4)];
            
            parts = regexp(path,'\', 'split');            
            
            matrix = [g,matrix];
            date_ = parts{end-5};
            flower = parts{end-4};
            negOrPos = parts{end-3};
            
            for i=2:h
                matrix{i,1} = flower;
                matrix{i,2} = date_;
                matrix{i,3} = double(strcmp(negOrPos,'negative'));
                matrix{i,4} = double(~strcmp(negOrPos,'negative'));
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
    
    methods (Static)
       
        %%Function that retrieves id from a search path
        function id = getIdFromPath(path)
            
            parts = regexp(path,'\', 'split');
            id = NaN;
            
            for k=length(parts):-1:1
                if ~isnan(str2double(parts{k}))
                    id = parts{k+3};
                    break;
                end
            end
        end
        
    end
    
end

