classdef OlfactoryDataAdapter < DataAdapter
    %OLFACTORYDATAADAPTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        tempMatrix;
    end
    
    methods (Access = public)
        
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
            
            for i=1:size_(2)
                idx = strfind(paths{1,i},'\');
                
                try
                    id_ = paths{1,i}(idx(end-2)+1:idx(end-1)-1);
                catch e
                    errordlg(['Incorrect path was passed to the file reader. Matlab error: ',e.message()]);
                end
                
                rawData = this.fileReader(paths{1,i});
                
                if iscell(rawData)
                    x = transpose(cellfun(@this.str2double2,rawData(:,1)));
                    y = transpose(cell2mat(rawData(:,2)));
                else
                    x = transpose(rawData(:,1));
                    y = transpose(rawData(:,2));
                end
                
                this.tempMatrix{2,1} = x;
                this.tempMatrix{2,2} = y;
                
                this.addValues(idx,paths{1,i});
                this.dobj.setObservation(this.tempMatrix,id_);
                this.tempMatrix = {'OlfX','OlfY'};
            end
            
            obj = this.dobj;
            toc            
        end
        
        function rawData = fileReader(this,p)
            try
                rawData = csvread(p,3,0);
            catch e
                try
                    rawData = dlmread(p);
                catch e2
                    [uu1,uu2,rawData] = xlsread(p);                    
                end
            end
        end
        
        function element = str2double2(this,mcell)
            element = str2double(mcell);
        end
    end
    
    methods (Access = private)
        
    end    
end

