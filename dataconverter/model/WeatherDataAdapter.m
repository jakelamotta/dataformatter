classdef WeatherDataAdapter < DataAdapter
    %WEATHERDATAADAPTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        dobj;
        tempMatrix;
    end
    
    methods (Access = public)
        
        %%
        function this = WeatherDataAdapter()
            this.dobj = DataObject();
            this.tempMatrix = {'wind speed (m/s)','direction(degrees)','Temperature(c)'};
        end
        
        %%
        function timeList = splitTime(this,time)
            start = strfind(time,'2');
            time = time(start(1):end);
            timeList = cell(1,5);
            timeList{1,1} = str2double(time(1:4));
            timeList{1,2} = str2double(time(5:6));
            timeList{1,3} = str2double(time(7:8));
            timeList{1,4} = str2double(time(10:11));
            timeList{1,5} = str2double(time(12:13));
        end
        
        %%This function compares two time stamps and checks that they are
        %%sufficiently close to each other in time. Currently this time is
        %%set to 5.1 minutes. This is because the weather data is sampled
        %%at intervals of 10 minutes.
        %%**
        %%actualTime and row must be cells of at least size (1,5) and the
        %%first five cells should contain year, month, day, hour and minute
        %%respectively. 
        function found = compareTime(this,actualTime,row)
           deltaTime = 5.1;
           found = (actualTime{1,1} == row{1,1}) & (actualTime{1,2} == row{1,2});
           found = (actualTime{1,3} == row{1,3}) & found;
           found = found & (abs(actualTime{1,4}+actualTime{1,5}/60 - (row{1,4}+row{1,5}/60)) < deltaTime/60.);
        end        
        %%
        function obj = getDataObject(this,paths,varargin)
        %time in format: multiple-20140821-104913
            size_ = size(paths);
            time = varargin{1};
            timeList = {};
            if ~strcmp('',time)
                timeList = this.splitTime(time);
            end
            for i=1:size_(2)              
                idx = strfind(paths{1,i},'\');
                
                try
                    id_ = paths{1,i}(idx(end-2)+1:idx(end-1)-1);
                catch e
                    errordlg(['Incorrect path was passed to the file reader. Error:',e.message]);
                end
                
                rawData = this.fileReader(paths{1,i});
                rawData = strrep(rawData,'   ',' ');
                rawData = strrep(rawData,'  ',' ');
                
                temp = cellfun(@this.createDob,rawData,'UniformOutput',false);
                
                for j=1:length(temp)
                    
                    if ~isempty(timeList)
                        t_temp = temp{1,j}(1,1:5);
                    
                        if this.compareTime(timeList,t_temp)
                            disp(t_temp);
                            this.tempMatrix = [this.tempMatrix;temp{1,j}(6:8)];
                        end
                    else
                        this.tempMatrix = [this.tempMatrix;temp{1,j}(6:8)];
                    end
                    
                    s = size(this.tempMatrix);
                    
                    if s(1) > 2
                        break;
                    end
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