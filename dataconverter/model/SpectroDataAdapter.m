classdef SpectroDataAdapter < DataAdapter
    %SPECTRODATAADAPTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Access = public)
        
        function this = SpectroDataAdapter()
            this.dobj = Observation();
            this.tempMatrix = {'lux_flower','lux_up','SpectroX','SpectroY','SpectroXUp','SpectroYUp','/SpectroTime'};
        end
        
        function rawData = fileReader(this,path)
            rawData = fileReader@DataAdapter(this,path);
        end
        
        function this = addValues(this,idx,path)
            matrix = this.tempMatrix;
            [h,w] = size(matrix);
            g = [{'Flower','DATE','Negative','Positive'};cell(h-1,4)];
            
            %[g,matrix] = Utilities.padMatrix(g,matrix);
            matrix = [g,matrix];
            
            date_ = path(idx(end-7):idx(end-6));
            
            
            
            %           date_ = paths{1,i}(idx(end-5):idx(end-4));
             flower = path(idx(end-6):idx(end-5));
             negOrPos = path(idx(end-5):idx(end-4));
%             this.tempMatrix{i+1,1} = flower;
%             this.tempMatrix{i+1,3} = date_;
%           
            for i=2:h
                matrix{i,1} = flower(2:end-1);
                matrix{i,2} = date_(2:end-1);
                matrix{i,3} = strcmp(negOrPos,'negative')*1;
                matrix{i,4} = ~strcmp(negOrPos,'negative')*1;
            end
            
            this.tempMatrix = matrix;
        end
        
        function obj = getDataObject(this,paths)
            
            s = size(paths);
            obj = Observation();%Spectro();
            
            for i=1:s(2)
                if strcmp(paths{1,i}(end-10:end),'rawData.txt')
                    
                    indices = strfind(paths{1,i},'\');
                    timeStringStart = strfind(paths{1,i},'multiple');
                    
                    if isempty(timeStringStart)
                        timeString = '';
                    else
                        timeString = paths{1,i}(timeStringStart:end);
                        timeStringEnd = strfind(timeString,'\');
                        timeString = timeString(1:timeStringEnd);
                    end
                    
                    try
                        id_ = paths{1,i}(indices(end-4)+1:indices(end-3)-1);
                    catch e
                        errordlg(['Incorrect path was passed to the file reader. Matlab error: ',e.message]);
                    end
                    
                    path = paths{1,i};
                    rawData = this.fileReader(path);
                    
                    wli = strfind(rawData,'spectrumPoints');
                    wli = wli{1};
                    
%                     tempStruct = struct;
%                     tempStruct.id = id_;
%                     tempStruct.time = timeString;
%                    
                    this.tempMatrix{2,7} = timeString;
                    %this.dobj.setSpectroTime(id_,timeString);
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
                            
                            idx = strfind(tempData,'spectrumPoints');
                            first = idx+17;
                            
                            points = tempData(first:end);
                            points = regexp(points,',','split');
                            
                            temp = cellfun(@this.createDob,points,'UniformOutput',false);
                           
                            x = zeros(size(temp));
                            y = zeros(size(temp));
                            
                            len_ = length(temp);
                            
                            for k=1:len_
                                
                                
                                x(k) = str2double(temp{k}(1));
                                val1 = temp{k}(2);
                                y(k) = val1{1};
                            end
                            
                            
                            this.tempMatrix{2,2*obs+1} = x;
                            this.tempMatrix{2,2+2*obs} = y;
%                             var1 = ['obs',(num2str(obs))];
%                             tempStruct.(var1).x = x;
%                             tempStruct.(var1).y = y;                            
                        end
                    %catch e
                    %    errordlg(['Spectrophotometer file was in an incorrect format. Matlab error output: ',e.message]);
                    %end                
                    this = this.addValues(indices,paths{1,i});
                    this.dobj = this.dobj.setObservation(this.tempMatrix,id_);
                    this.tempMatrix = {'lux_flower','lux_up','SpectroX','SpectroY','SpectroXUp','SpectroYUp','/SpectroTime'};
                    %obj = this.dobj.addSpectroData(tempStruct,id_);%tempStruct.obs1.x,tempStruct.obs1.x,tempStruct.obs2.x,tempStruct.obs2.x,id_);
                end
            end
            
        obj = this.dobj;
        
        end
        
    end
    
    methods (Access = private)
        
        function temp = createDob(this, inRow)
            row = regexp(inRow,':','split');
            
            x = row{1};
            x = x(3:end-1);
            
            y = row{2};
            y = str2double(y(1:end-1));
            temp = {x,y};
        end
        
        function this = doSomething(this,rawData)
            
        end
        
    end
    
end

