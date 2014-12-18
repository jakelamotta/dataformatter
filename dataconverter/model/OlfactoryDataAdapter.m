classdef OlfactoryDataAdapter < DataAdapter
    %OLFACTORYDATAADAPTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        tempMatrix;
    end
    
    methods
        
        function this = OlfactoryDataAdapter()
            this.dobj = Observation();
            this.tempMatrix = {'OlfX','OlfY'};
        end
        
        function this = addValues(this,idx,p)
            this.tempMatrix = addValues@DataAdapter(this,p,idx,this.tempMatrix);
        end
        
        function obj = getDataObject(this,paths)
            tic;
            size_ = size(paths);
            
            rows = cell(size_(2),2);
            this.tempMatrix = [this.tempMatrix;rows];
            
            for i=1:size_(2)
                idx = strfind(paths{1,i},'\');
                
                try
                    id_ = paths{1,i}(idx(end-2)+1:idx(end-1)-1);
                catch e
                    errordlg(['Incorrect path was passed to the file reader. Matlab error: ',e.message()]);
                end
                
                rawData = this.fileReader(paths{1,i});
                
                x = transpose(rawData(:,1));
                y = transpose(rawData(:,2));
                
                this.tempMatrix{i+1,1} = x;
                this.tempMatrix{i+1,2} = y;
                
               % this.dobj.addOlfactoryData(tempStruct,id_);
               this = this.addValues(idx,paths{1,i});
                this.dobj.setObservation(this.tempMatrix,id_);
                this.tempMatrix = {'OlfX','OlfY'};
            end
            
            obj = this.dobj;
            toc            
        end
        
        function rawData = fileReader(this,p)
            rawData = csvread(p,3,0);
        end
    end
    
    methods (Access = private)
        
    end
    
end

