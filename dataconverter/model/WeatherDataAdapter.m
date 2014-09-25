classdef WeatherDataAdapter < AbstractDataAdapter
    %WEATHERDATAADAPTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        dobj;
        tempMatrix;
    end
    
    methods (Access = public)
        
        function this = WeatherDataAdapter()
            this.dobj = DataObject(1,1);
            this.tempMatrix = {'Year','month','day','hour','min','wind speed (m/s)','direction(degrees)','temperature(c)','rel moist','pressure'};
            this.objList = cell(1);
        end
        
        function obj = getDataObject(this,paths)
            
            size_ = size(paths);
            
            for i=1:size_(2)                
                rawData = this.fileReader(paths{1,i});
                rawData = strrep(rawData,'  ',' ');
                this.tempMatrix = cellfun(@this.createDob,rawData,'UniformOutput',false);
                this.dobj = this.dobj.setObservation(this.tempMatrix);% = this.addObject();
            end
            
            obj = this.dobj;
            
        end        
    end    
    
    methods (Access = private)
        
        
        function obj = createDob(this, inRow)
            
            row = regexp(inRow,' ','split');
            obj = [this.tempMatrix;cellfun(@str2num,row,'UniformOutput',false)];
            
        end
        
        function this = addObject(this)
            size_ = size(this.objList);            
            this.objList{1,size_(2)+1} = this.dobj;        
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