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
            this.tempMatrix = {'lux1','lux2'};
        end
        
        function rawData = fileReader(this,path)
            rawData = fileReader@DataAdapter(this,path);
        end
        
        function obj = getDataObject(this,paths)
            
            s = size(paths);
            obj = DataObject();
            
            for i=1:s(2)
                if strcmp(paths{1,i}(end-10:end),'rawData.txt')
                    
                    idx = strfind(paths{1,i},'\');
                    
                    timeStringStart = strfind(paths{1,i},'multiple');
                    
                    if isempty(timeStringStart)
                        timeString = '';
                    else
                        timeString = paths{1,i}(timeStringStart:end);
                        timeStringEnd = strfind(timeString,'\');
                        timeString = timeString(1:timeStringEnd);
                    end
                    
                    try
                        id_ = paths{1,i}(idx(end-4)+1:idx(end-3)-1);
                    catch e
                        errordlg(['Incorrect path was passed to the file reader. Matlab error: ',e.message]);
                    end
                    
                    path = paths{1,i};
                    rawData = this.fileReader(path);
                    
                    wli = strfind(rawData,'spectrumPoints');
                    wli = wli{1};
                    
                    tempStruct = struct;
                    tempStruct.id = id_;
                    tempStruct.time = timeString;
                    
                    %try
                        for obs=1:length(wli)
                            idx = strfind(rawData,'lux');
                            last = idx{1}(1+2*(obs-1))-4;
                            
                            luxIndex = idx{1}(2+2*(obs-1));
                            tempData = rawData{1}(luxIndex:end);
                            
                            idx = strfind(tempData,'}');
                            lastLux = idx(1);
                            
                            luxValue = str2num(tempData(6:lastLux-1));
                            this.tempMatrix{2,obs} = luxValue;
                            
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
                            
%                             winfo = tempData(1:first-20);
%                             winfo = regexp(winfo,',','split');
%                             winfo{1} = strrep(winfo{1},'waveLengthInfo":{','');
%                             
%                             offset = 9;
%                             
                            %                     for h=1:length(winfo)
                            %                        temp = winfo{h};
                            %                        temp = strrep(temp,'}','');
                            %                        temp = regexp(temp,':','split');
                            %
                            %                        variable = temp{1}(2:end-1);
                            %                        value = str2double(temp{2});
                            %
                            %                        %tempStruct.(num2str(obs)).(variable) = value;
                            %
                            %                         %this.tempMatrix{1,h+h*(obs-1)} = variable;
                            %                         this.tempMatrix{2,h+length(winfo)*(obs-1)} = value;
                            %                     end
                        end
                    %catch e
                    %    errordlg(['Spectrophotometer file was in an incorrect format. Matlab error output: ',e.message]);
                    %end                
                
                    this.dobj = this.dobj.setObservation(this.tempMatrix,id_);
                    obj = this.dobj.addSpectroData(tempStruct,id_);%tempStruct.obs1.x,tempStruct.obs1.x,tempStruct.obs2.x,tempStruct.obs2.x,id_);
                end
            end
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

