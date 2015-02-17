classdef WeatherDataAdapter < DataAdapter
    %%%Class that works as an adapter between the raw WeatherData and the
    %%%Observation object. WeatherData must be a txt file with lines in the
    %%%format:
    %%%yyyy m d h min  var1  var2 var3...
    
    %%
    properties (Access = private)
        cell_;
        nrOfNewVariables;
    end
    
    %Public methods, accessible from other classes
    methods (Access = public)
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%When adding new weather variables, changes go here!!%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function this = WeatherDataAdapter()
            this.dobj = Observation();
            %this.cell_ = {'/weatherTime','W_temp','W_humid','W_Wind speed','W_Wind dir','W_Pressure','W_Radiation'};
            this.cell_ = {'/weatherTime','W_temp','W_humid','W_Wind speed'};
            this.nrOfNewVariables = 0; %Change this to 3 when using the correct weatherfile
            this.tempMatrix = this.cell_;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%Generic function for adding flower, date and negative/positive
        function matrix = addValues(this,p)
            matrix = addValues@DataAdapter(this,p,this.tempMatrix);
        end
        
        %%Splits a time string in the form 'yyyymmdd-mmss' or
        %%'yyyymmddmmss' into a cell with years, month, day, min and sec
        %%separated
        function timeList = splitTime(this,time)
            start = strfind(time,'2');
            time = time(start(1):end);
            time = strrep(time,'-','');
            timeList = struct;
            timeList.year = time(1:4);
            
            if strcmp(time(5),'0')
                timeList.month = time(6);
            else
                timeList.month = time(5:6);
            end
            
            if strcmp(time(7),'0')
                timeList.day = time(8);
            else
                timeList.day = time(7:8);
            end
            
            if length(time) >= 10
                timeList.hour = time(09:10);
                timeList.min = time(11:12);
            end
        end
        
        %%
        function [months,year] = getWeatherTimeInfo(this,fname)
            fname = strrep(fname,'.dat','');
            parts = regexp(fname,'_','split');
            year = parts{1};
            months = parts(2:end);
        end
        
        function path_ = findWeateherFileFromDate(this,weatherPaths,date_)
            stop = false;
            path_ = '';
            
            for i=1:length(weatherPaths)
                [p,fname,ext] = fileparts(weatherPaths(1).name);
                [months,year] = this.getWeatherTimeInfo(fname);
                timeParts = this.splitTime(date_);
                
                for k=1:length(months)
                    month = Utilities.getMonthFromString(months{k});
                                        
                    if strcmp(month,timeParts.month)
                        path_ = [Utilities.getpath('weatherPath\'),weatherPaths(1).name];
                        stop = true;
                        break;
                    end
                end
                
                if stop
                    break;
                end
            end
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
            
            if ~(strcmp(actualTime.year,row{1,1}))
                found = false;
                return;
            end
            
            if ~(strcmp(actualTime.month,row{1,2}))
                found = false;
                return;
            end
            
            if ~(strcmp(actualTime.day,row{1,3}))
                found = false;
                return;
            end
            
            found = (abs(str2double(actualTime.hour)+str2double(actualTime.min)/60 -...
                (str2double(row{1,4})+str2double(row{1,5})/60)) <= deltaTime/60.);
        end
        
        %%Compare the day of two time stamps, returns true if they are the
        %%same
        function found = compareDay(this,actualTime,row)
            
            found = (actualTime.year == row{1,1});
            if ~found
                return;
            end
            
            found = (actualTime.month == row{1,2});
            if ~found
                return;
            end            
            
            found = (actualTime.day == row{1,3});
        end
        
        %%Get a Observation with weather data
        function obj = getObservation(this,paths,varargin)
            %time in format: multiple-20140821-104913
            profile on;
            length_ = length(paths);
            inObj = varargin{1};
            weatherPaths = Utilities.getpath('weatherPath');
            weatherPaths = dir(weatherPaths);
            weatherPaths = weatherPaths(3:end);
            loadedFiles = containers.Map();
            
            this.nrOfPaths = length_;
            
            for i=1:length_
                %Retrieve id from the path
                this.updateProgress(i);
                
                obsInfoMatrix = this.addValues(paths{1,i});
                
                pathToWeather = this.findWeateherFileFromDate(weatherPaths,obsInfoMatrix{2,2});
                id_ = DataAdapter.getIdFromPath(paths{1,i});
                [p,f,ext] = fileparts(pathToWeather);
                
                if ~strcmp(pathToWeather,'')
                    
                    if isKey(loadedFiles,f)
                        temp = loadedFiles(f);
                    else
                        rawData = this.fileReader(pathToWeather);
                        rawData = strrep(rawData,'   ',' ');
                        rawData = strrep(rawData,'  ',' ');
                        
                        temp = cellfun(@this.getFormattedWeatherRow,rawData,'UniformOutput',false);
                        loadedFiles(f) = temp;
                    end
                    %Use spectro time as a way to find the correct weather data
                    spectroTime = inObj.getSpectroTime(id_);

                    %%If there is no spectro time check if there is a abiotic.
                    if isempty(spectroTime)
                        abioticTime = inObj.getAbioticTime(id_);
                        if isempty(abioticTime)
                            time = '';
                        else
                            time = abioticTime;
                        end
                    else
                        time = spectroTime;
                    end

                    %If there is no time to use to find weather data the day is
                    %used for narrowing down the number of potential
                    %measurements.
                    if strcmp('',time)
                        
                        %%The correct weather data is fetched from the list by
                        %%using the input time and comparing it to the weather data
                        %%time.
                        timeList = this.splitTime(obsInfoMatrix{2,2});

                        start = 1;
                        
                        counter = 0;

                        for j=start:length(temp)
                            if ~isempty(timeList)
                                t_temp = temp{1,j}(1,1:5);

                                if this.compareDay(timeList,t_temp)
                                    weatherDate = temp{1,j}(1:5);
                                    weatherDate = ['/',num2str(weatherDate{1}),'-',...
                                        num2str(weatherDate{2}),'-',num2str(weatherDate{3}),...
                                        '-',num2str(weatherDate{4}),'-',num2str(weatherDate{5})];
                                    temp{1,j}(5) = {weatherDate};
                                    this.tempMatrix = [this.tempMatrix;...
                                        temp{1,j}(5:8+this.nrOfNewVariables)];
                                    
                                counter = counter+1;    
                                    
                                %There are 144 possible rows for one day
                                %with sampling at 10 minute rate
                                if counter > 143
                                   break; 
                                end
                                    
                                end
                            end
                        end
                    else
                        timeList = this.splitTime(time);

                        t_temp = temp{1,1};

%                         %%Finds the optimal starting point to minimize search time
%                         if ~isempty(timeList)
%                             if strcmp(timeList.month,t_temp{1,2})
%                                 start = 1;
%                             else
%                                 start = (length(temp)/2);%-500;
%                             end
% 
%                             %Heuristic to find starting point of search
%                             dayDiff = timeList.day-t_temp{1,3};
% 
%                             %144 is the number of 10 minutes interval per day
%                             start = start+dayDiff*144;
% 
%                             %Safety mesure to not miss the day due to missing data
%                             %points etc. The number is somewhat arbitrary
%                             start = start-50;
%                         else
%                             start = 1;
%                         end
                        start = 1;
                        %%The correct weather data is fetched from the list by
                        %%using the input time and comparing it to the weather data
                        %%time.
                        for j=start:length(temp)
                            if ~isempty(timeList)
                                t_temp = temp{1,j}(1,1:5);

                                if this.compareTime(timeList,t_temp)
                                    weatherDate = temp{1,j}(1:5);
                                    weatherDate = ['/',weatherDate{1},'-',weatherDate{2},'-',weatherDate{3},'-',weatherDate{4},'-',weatherDate{5}];
                                    temp{1,j}(5) = {weatherDate};
                                    this.tempMatrix = [this.tempMatrix;temp{1,j}(5:8+this.nrOfNewVariables)];
                                    break;
                                end
                            else
                                weatherDate = temp{1,j}(1:5);
                                weatherDate = ['/',weatherDate{1},'-',weatherDate{2},'-',weatherDate{3},'-',weatherDate{4},'-',weatherDate{5}];
                                temp{1,j}(5) = {weatherDate};
                                this.tempMatrix = [this.tempMatrix;temp{1,j}(5:8+this.nrOfNewVariables)];
                            end
                        end
                    end

                    this.addValues(paths{1,i});
                    this.dobj = this.dobj.setObservation(this.tempMatrix,id_);
                    this.tempMatrix = this.cell_;
                end
            end
            close(this.mWaitbar);
            obj = this.dobj;
            profile viewer;
        end
        
        %%Uses the generic filreader of the parent class.
        function rawData = fileReader(this, path)
            rawData = fileReader@DataAdapter(this,path);
        end
    end
    
    %Methods only accesible within the class
    methods (Access = private)
        
        function row = getFormattedWeatherRow(this, inRow)
            row = regexp(inRow,' ','split');
            data = cellfun(@str2double,row(6:end),'UniformOutput',false);
            row(6:end) = data;
        end
        
        function this = addObject(this)
            size_ = size(this.objList);
            this.objList{1,size_(2)+1} = this.dobj;
        end
    end
end

% %%Get a Observation with weather data
%         function obj = getObservation(this,paths,varargin)
%             %time in format: multiple-20140821-104913
%             length_ = length(paths);
%             inObj = varargin{1};
%
%             this.nrOfPaths = length_;
%
%             for i=1:length_
%                 %Retrieve id from the path
%                 this.updateProgress(i);
%
%                 id_ = DataAdapter.getIdFromPath(paths{1,i});
%
%                 %Use spectro time as a way to find the correct weather data
%                 spectroTime = inObj.getSpectroTime(id_);
%
%                 %%If there is no spectro time check if there is a abiotic.
%                 if isempty(spectroTime)
%                     abioticTime = inObj.getAbioticTime(id_);
%                     if isempty(abioticTime)
%                         time = '';
%                     else
%                         time = abioticTime;
%                     end
%                 else
%                     time = spectroTime;
%                 end
%
%                 %If there is no time to use to find weather data the day is
%                 %used for narrowing down the number of potential
%                 %measurements.
%                 if strcmp('',time)
%                     %%The correct weather data is fetched from the list by
%                     %%using the input time and comparing it to the weather data
%                     %%time.
%                     parts = regexp(paths{1,i},'\', 'split');
%                     day = parts{end-5};
%
%                     timeList = this.splitTime(day);
%
%                     rawData = this.fileReader(paths{1,i});
%                     rawData = strrep(rawData,'   ',' ');
%                     rawData = strrep(rawData,'  ',' ');
%
%                     temp = cellfun(@this.createDob,rawData,'UniformOutput',false);
%                     start = 1;
%
%                     for j=start:length(temp)
%                         if ~isempty(timeList)
%                             t_temp = temp{1,j}(1,1:5);
%
%                             if this.compareDay(timeList,t_temp)
%                                 weatherDate = temp{1,j}(1:5);
%                                 weatherDate = ['/',weatherDate{1},'-',weatherDate{2},'-',weatherDate{3},'-',weatherDate{4},'-',weatherDate{5}];
%                                 temp{1,j}(5) = {weatherDate};
%                                 this.tempMatrix = [this.tempMatrix;temp{1,j}(5:8+this.nrOfNewVariables)];
%                             end
%                         end
%                     end
%                 else
%                     timeList = this.splitTime(time);
%
%                     rawData = this.fileReader(paths{1,i});
%                     rawData = strrep(rawData,'   ',' ');
%                     rawData = strrep(rawData,'  ',' ');
%
%                     temp = cellfun(@this.createDob,rawData,'UniformOutput',false);
%
%                     t_temp = temp{1,1};
%
%                     %%Finds the optimal starting point to minimize search time
%                     if ~isempty(timeList)
%                         if timeList{1,2} == str2double(t_temp{1,2})
%                             start = 1;
%                         else
%                             start = (length(temp)/2);%-500;
%                         end
%
%                         %Heuristic to find starting point of search
%                         dayDiff = timeList{1,3}-str2double(t_temp{1,3});
%
%                         %144 is the number of 10 minutes interval per day
%                         start = start+dayDiff*144;
%
%                         %Safety mesure to not miss the day due to missing data
%                         %points etc. The number is somewhat arbitrary
%                         start = start-50;
%                     else
%                         start = 1;
%                     end
%
%                     %%The correct weather data is fetched from the list by
%                     %%using the input time and comparing it to the weather data
%                     %%time.
%                     for j=start:length(temp)
%                         if ~isempty(timeList)
%                             t_temp = temp{1,j}(1,1:5);
%
%                             if this.compareTime(timeList,t_temp)
%                                 weatherDate = temp{1,j}(1:5);
%                                 weatherDate = ['/',weatherDate{1},'-',weatherDate{2},'-',weatherDate{3},'-',weatherDate{4},'-',weatherDate{5}];
%                                 temp{1,j}(5) = {weatherDate};
%                                 this.tempMatrix = [this.tempMatrix;temp{1,j}(5:8+this.nrOfNewVariables)];
%                                 break;
%                             end
%                         else
%                             weatherDate = temp{1,j}(1:5);
%                             weatherDate = ['/',weatherDate{1},'-',weatherDate{2},'-',weatherDate{3},'-',weatherDate{4},'-',weatherDate{5}];
%                             temp{1,j}(5) = {weatherDate};
%                             this.tempMatrix = [this.tempMatrix;temp{1,j}(5:8+this.nrOfNewVariables)];
%                         end
%                     end
%                 end
%
%                 this = this.addValues(paths{1,i});
%                 this.dobj = this.dobj.setObservation(this.tempMatrix,id_);
%                 this.tempMatrix = this.cell_;
%             end
%             close(this.mWaitbar);
%             obj = this.dobj;
%         end