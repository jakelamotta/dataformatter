classdef WeatherDataAdapter < DataAdapter
    %WEATHERDATAADAPTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        dobj;
        tempMatrix;
    end
    
    methods (Access = public)
        
        function this = WeatherDataAdapter()
            this.dobj = DataObject();
            this.tempMatrix = {'wind speed (m/s)','direction(degrees)','Temperature(c)'};
        end
        
        function obj = getDataObject(this,paths)
            
            size_ = size(paths);
            
            for i=1:size_(2)              
                idx = strfind(paths{1,i},'\');
                id_ = paths{1,i}(idx(end-2)+1:idx(end-1)-1);
                
                rawData = this.fileReader(paths{1,i});
                rawData = strrep(rawData,'   ',' ');
                rawData = strrep(rawData,'  ',' ');
                temp = cellfun(@this.createDob,rawData,'UniformOutput',false);
                
                for j=1:length(temp)
                    this.tempMatrix = [this.tempMatrix;temp{1,j}(6:8)];
                end
                
                this.dobj = this.dobj.setObservation(this.tempMatrix,id_);
            end
            
            obj = this.dobj;
            
        end
        function rawData = fileReader(this, path)
              rawData = fileReader@DataAdapter(this,path);   
        end
    end
    
    methods (Access = private)
        
        
        
        function temp = createDob(this, inRow)
            
            row = regexp(inRow,' ','split');
            temp = cellfun(@str2num,row,'UniformOutput',false);%[this.tempMatrix;cellfun(@str2num,row,'UniformOutput',false)];
        end
        
        function this = addObject(this)
            size_ = size(this.objList);            
            this.objList{1,size_(2)+1} = this.dobj;        
        end
        
                
    end    
end