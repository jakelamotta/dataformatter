classdef OlfactoryDataAdapter < DataAdapter
    %OLFACTORYDATAADAPTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dobj;
    end
    
    methods
        
        function this = OlfactoryDataAdapter()
            this.dobj = DataObject();
        end
        
        function obj = getDataObject(this,paths)
            tic;
            profile on;
            size_ = size(paths);
            
            for i=1:size_(2)              
                idx = strfind(paths{1,i},'\');
                
                try
                    id_ = paths{1,i}(idx(end-2)+1:idx(end-1)-1);
                catch e
                    errordlg(['Incorrect path was passed to the file reader. Matlab error: ',e.message()]);
                end
                
                rawData = this.fileReader(paths{1,i});
                rawData = rawData(:,1:3);
                
                x = transpose(rawData(:,1));
                y = transpose(rawData(:,3));
                                
                tempStruct = struct;
                tempStruct.x = x;
                tempStruct.y = y;
                this.dobj.setOlfactory(tempStruct);                
                this.dobj.setID(id_);
            end
            
            obj = this.dobj;
            toc
            profile viewer;
        end  
        
        function rawData = fileReader(this,p)
            rawData = csvread(p,3,0);
        end
    end
    
    methods (Access = private)
        
    end
    
end

