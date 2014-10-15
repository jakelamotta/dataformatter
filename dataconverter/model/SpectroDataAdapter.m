classdef SpectroDataAdapter < DataAdapter
    %SPECTRODATAADAPTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dobj;
        tempMatrix;
    end
    
    methods (Access = public)

        function this = SpectroDataAdapter()
           this.dobj = DataObject();
           this.tempMatrix = {};
        end
   
        function rawData = fileReader(this,path)
            rawData = fileReader@DataAdapter(this,path);
        end    
        
        function obj = getDataObject(this,paths)
            
            s = size(paths);
            for i=1:s(2)
                idx = strfind(paths{1,i},'\');
                id_ = paths{1,i}(idx(end-2)+1:idx(end-1)-1);
                
                path = paths{1,i};
                rawData = this.fileReader(path);
                
                idx = strfind(rawData,'lux');
                last = idx{1}(1)-4;
                
                idx = strfind(rawData,'spectrumPoints');
                first = idx{1}(1)+17;
                %this = this.doSomething(rawData);
                points = rawData{1}(first:last);
                points = regexp(points,',','split');
                temp = cellfun(@this.createDob,points,'UniformOutput',false);
                x = zeros(size(temp));
                y = zeros(size(temp));
                
                for k=1:length(temp)
                   x(k) = temp{k}(1);
                   y(k) = temp{k}(2);
                end
            end
            
            obj = struct;
            obj.x = x;
            obj.y = y;% this.dobj;
        end
        
    end
    
    methods (Access = private)
        
        function temp = createDob(this, inRow)
            row = regexp(inRow,':','split');
            
            x = row{1};
            x = x(3:end-1);
            x = str2double(x);
            
            y = row{2};
            y = str2double(y(1:end-1));
            temp = [x,y];
            
            
            %temp = cellfun(@AbioticDataAdapter.handleRow,row,'UniformOutput',false);
            
            %temp = cellfun(@str2num,row,'UniformOutput',false);%[this.tempMatrix;cellfun(@str2num,row,'UniformOutput',false)];
        end
       
        function this = doSomething(this,rawData)
            
        end
        
    end
    
end

