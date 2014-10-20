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
           this.tempMatrix = {'dominant1','peak1','purity1','timestamp2','dominant2','peak2','purity2','timestamp2'};
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
                
                wli = strfind(rawData,'waveLengthInfo');
                wli = wli{1};
                
                tempStruct = struct;
                tempStruct.id = id_;
                
                for obs=1:length(wli)
                    idx = strfind(rawData,'lux');
                    last = idx{1}(1+2*(obs-1))-4;
                    
                    tempData = rawData{1}(wli(obs):last);
                    
                    
                    %idx = strfind(tempData,'lux');
                    %last = idx{1}(1)-4;
                    
                    idx = strfind(tempData,'spectrumPoints');
                    first = idx+17;
                    
                    %this = this.doSomething(rawData);
                    
                    points = tempData(first:end);
                    points = regexp(points,',','split');
                    temp = cellfun(@this.createDob,points,'UniformOutput',false);
                    
                    x = zeros(size(temp));
                    y = zeros(size(temp));
                    
                    len_ = length(temp);
                    %offset = 13;
                    
                    for k=1:len_
                        
                        
                        x(k) = str2double(temp{k}(1));
                        val1 = temp{k}(2);
                        %cell 
                        y(k) = val1{1};
                        
                       %x(k) = temp{k}(1);
                       %y(k) = temp{k}(2);
%                        index = size(this.tempMatrix);
%                        index = index(2)+1;
%                        pairs = temp{k};
%                        this.tempMatrix{1,k+offset} = pairs{1};%temp{k}(1);
%                        this.tempMatrix{obs+1,k+offset} = pairs{2};%temp{k}(2);
                    end
                    
                    var1 = ['obs',(num2str(obs))];
                    tempStruct.(var1).x = x;
                    tempStruct.(var1).y = y;
                    
                    winfo = tempData(1:first-20);
                    winfo = regexp(winfo,',','split');
                    winfo{1} = strrep(winfo{1},'waveLengthInfo":{','');
                    
                    offset = 9;
                       
                    for h=1:length(winfo)
                       temp = winfo{h};
                       temp = strrep(temp,'}','');
                       temp = regexp(temp,':','split');
                       
                       variable = temp{1}(2:end-1);
                       value = str2double(temp{2});
                       
                       %tempStruct.(num2str(obs)).(variable) = value;
                       
                        %this.tempMatrix{1,h+h*(obs-1)} = variable;
                        this.tempMatrix{2,h+length(winfo)*(obs-1)} = value; 
                    end
                end
            end
            
            this.dobj = this.dobj.setObservation(this.tempMatrix,id_);
            obj = this.dobj.addSpectroData(tempStruct);%tempStruct.obs1.x,tempStruct.obs1.x,tempStruct.obs2.x,tempStruct.obs2.x,id_);
        end
        
    end
    
    methods (Access = private)
        
        function temp = createDob(this, inRow)
            row = regexp(inRow,':','split');
            
            x = row{1};
            x = x(3:end-1);
            %x = str2double(x);
            
            y = row{2};
            y = str2double(y(1:end-1));
            temp = {x,y};
            
            
            %temp = cellfun(@AbioticDataAdapter.handleRow,row,'UniformOutput',false);
            
            %temp = cellfun(@str2num,row,'UniformOutput',false);%[this.tempMatrix;cellfun(@str2num,row,'UniformOutput',false)];
        end
       
        function this = doSomething(this,rawData)
            
        end
        
    end
    
end

