classdef WeatherDataAdapter < DataAdapter
    %WEATHERDATAADAPTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        tempMatrix;
    end
    
    methods (Access = public)
        
        %%
        function this = WeatherDataAdapter()
            this.dobj = DataObject();
            this.tempMatrix = {'weatherTime','wind speed (m/s)','direction(degrees)','Temperature(c)'};
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
           
           for i=1:length(row)
               row{1,i} = str2double(row{1,i});
           end
           found = (actualTime{1,1} == row{1,1}) & (actualTime{1,2} == row{1,2});
           found = (actualTime{1,3} == row{1,3}) & found;
           found = found & (abs(actualTime{1,4}+actualTime{1,5}/60 - (row{1,4}+row{1,5}/60)) <= deltaTime/60.);
            
        end
        %%
        
        function obj = getDataObject(this,paths,varargin)
            profile on;
            %time in format: multiple-20140821-104913
            size_ = size(paths);
            spectro = varargin{1};
            inputManager = varargin{2};
            
            for i=1:size_(2)              
                idx = strfind(paths{1,i},'\');
                
                try
                    id_ = paths{1,i}(idx(end-2)+1:idx(end-1)-1);
                catch e
                    errordlg(['Incorrect path was passed to the file reader. Error:',e.message]);
                end
                
                %timeList = {};
                
                if isfield(spectro,strrep(id_,'.',''))
                    time = spectro.(strrep(id_,'.','')).time;
                else
                    time = '';
                end
                
                if strcmp('',time)
                     time = inputManager.dataManager.getHandler().getTime();
                end
                
                timeList = this.splitTime(time);
                
                rawData = this.fileReader(paths{1,i});
                rawData = strrep(rawData,'   ',' ');
                rawData = strrep(rawData,'  ',' ');
                
                temp = cellfun(@this.createDob,rawData,'UniformOutput',false);
                
                t_temp = temp{1,1};
                
                if ~isempty(timeList)
                    if timeList{1,2} == str2double(t_temp{1,2})
                        start = 1;
                    else
                        start = (length(temp)/2);%-500;
                    end

                    %Heuristic to find starting point of search
                    dayDiff = timeList{1,3}-str2double(t_temp{1,3});

                    %144 is the number of 10 minutes interval per day
                    start = start+dayDiff*144;  
                    %Safety mesure to not miss the day due to missing data
                    %points etc. The number is arbitrary but seemingly works
                    start = start-50;
                
                else
                    start = 1;
                end
                
                for j=start:length(temp)
                    
                    if ~isempty(timeList)
                        t_temp = temp{1,j}(1,1:5);
                    
                        if this.compareTime(timeList,t_temp)
                            %disp(t_temp);
                            weatherDate = temp{1,j}(1:5);
                            weatherDate = ['/',weatherDate{1},'-',weatherDate{2},'-',weatherDate{3},'-',weatherDate{4},'-',weatherDate{5}];
                            temp{1,j}(5) = {weatherDate};
                            this.tempMatrix = [this.tempMatrix;temp{1,j}(5:8)];
                            break;
                        end
                    else
                        weatherDate = temp{1,j}(1:5);
                        weatherDate = ['/',weatherDate{1},'-',weatherDate{2},'-',weatherDate{3},'-',weatherDate{4},'-',weatherDate{5}];
                        temp{1,j}(5) = {weatherDate};
                        this.tempMatrix = [this.tempMatrix;temp{1,j}(5:8)];
                    end
                    
                    s = size(this.tempMatrix);
                    
                end
                
                this.dobj = this.dobj.setObservation(this.tempMatrix,id_);
            end
            
            obj = this.dobj;
            profile viewer;
        end
        
        function rawData = fileReader(this, path)
              rawData = fileReader@DataAdapter(this,path);   
        end
        
    end
    
    methods (Access = private)
        
        function temp = createDob(this, inRow)            
            row = regexp(inRow,' ','split');
            temp = row;
            %temp = cellfun(@str2double,row,'UniformOutput',false);%[this.tempMatrix;cellfun(@str2num,row,'UniformOutput',false)];
        end
        
        function this = addObject(this)
            size_ = size(this.objList);            
            this.objList{1,size_(2)+1} = this.dobj;        
        end     
    end    
end