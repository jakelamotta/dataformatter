classdef WeatherDataAdapter < DataAdapter
    %WEATHERDATAADAPTER Summary of this class goes here
    %   Detailed explanation goes here
    
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
            %this.cell_ = {'/weatherTime','W_temp','W_humid','Pressure','Wind speed','Wind dir','Radiation'};
            this.cell_ = {'/weatherTime','W_temp','W_humid','Pressure'};            
            this.nrOfNewVariables = 0;
            this.tempMatrix = this.cell_;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%Generic function for adding flower, date and negative/positive
        function this = addValues(this,p)
            this.tempMatrix = addValues@DataAdapter(this,p,this.tempMatrix);
        end
        
        %%Splits a time string in the form 'yyyymmdd-mmss' or
        %%'yyyymmddmmss' into a cell with years, month, day, min and sec
        %%separated
        function timeList = splitTime(this,time)
            start = strfind(time,'2');
            time = time(start(1):end);
            time = strrep(time,'-','');
            timeList = cell(1,5);
            timeList{1,1} = str2double(time(1:4));
            timeList{1,2} = str2double(time(5:6));
            timeList{1,3} = str2double(time(7:8));
            
            if length(time) >= 10
                timeList{1,4} = str2double(time(09:10));
                timeList{1,5} = str2double(time(11:12));
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
           
           for i=1:length(row)
               row{1,i} = str2double(row{1,i});
           end
           
           found = (actualTime{1,1} == row{1,1}) & (actualTime{1,2} == row{1,2});
           found = (actualTime{1,3} == row{1,3}) & found;
           found = found & (abs(actualTime{1,4}+actualTime{1,5}/60 - (row{1,4}+row{1,5}/60)) <= deltaTime/60.);
        end
        
        %%Compare the day of two time stamps, returns true if they are the
        %%same
        function found = compareDay(this,actualTime,row)
           
           for i=1:length(row)
               row{1,i} = str2double(row{1,i});
           end
           
           found = (actualTime{1,1} == row{1,1}) & (actualTime{1,2} == row{1,2});
           found = (actualTime{1,3} == row{1,3}) & found;
        end
        
        %%Get a Observation with weather data
        function obj = getDataObject(this,paths,varargin)
            %time in format: multiple-20140821-104913
            length_ = length(paths);
            inObj = varargin{1};
            
            this.nrOfPaths = length_;
            
            for i=1:length_
                
                %Retrieve id from the path
                this.updateProgress(i);
                id_ = DataAdapter.getIdFromPath(paths{1,i});
                
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
                    %day = paths{1,i}(strfind(paths{1,i},'data\')+5:strfind(paths{1,i},'data\')+12);
                    parts = regexp(paths{1,i},'\', 'split');            
                    day = parts{end-5};
                    
                    timeList = this.splitTime(day);
                    
                    rawData = this.fileReader(paths{1,i});
                    rawData = strrep(rawData,'   ',' ');
                    rawData = strrep(rawData,'  ',' ');

                    temp = cellfun(@this.createDob,rawData,'UniformOutput',false);
                    start = 1;
                    for j=start:length(temp)

                        if ~isempty(timeList)
                            t_temp = temp{1,j}(1,1:5);

                            if this.compareDay(timeList,t_temp)
                                weatherDate = temp{1,j}(1:5);
                                weatherDate = ['/',weatherDate{1},'-',weatherDate{2},'-',weatherDate{3},'-',weatherDate{4},'-',weatherDate{5}];
                                temp{1,j}(5) = {weatherDate};
                                this.tempMatrix = [this.tempMatrix;temp{1,j}(5:8+this.nrOfNewVariables)];
                            end
                        end
                    end                    
                else
                    timeList = this.splitTime(time);

                    rawData = this.fileReader(paths{1,i});
                    rawData = strrep(rawData,'   ',' ');
                    rawData = strrep(rawData,'  ',' ');

                    temp = cellfun(@this.createDob,rawData,'UniformOutput',false);

                    t_temp = temp{1,1};

                    %%Finds the optimal starting point to minimize search time
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
                        %points etc. The number is somewhat arbitrary
                        start = start-50;                
                    else
                        start = 1;
                    end

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
                
                this = this.addValues(paths{1,i});
                
                this.dobj = this.dobj.setObservation(this.tempMatrix,id_);
                this.tempMatrix = this.cell_;
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
        
        function temp = createDob(this, inRow)            
            row = regexp(inRow,' ','split');
            temp = row;
        end
        
        function this = addObject(this)
            size_ = size(this.objList);            
            this.objList{1,size_(2)+1} = this.dobj;        
        end
    end
end