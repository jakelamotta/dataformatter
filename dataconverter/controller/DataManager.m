classdef DataManager < handle
    %DATAMANAGER A central class that is responsible for talking to most
    %parts of the system. Its the datamanager that is the link between the
    %GUI and all the underlying data handling. It passes any command from
    %the user to the correct class instance s
    
    
    properties (Access = private)
        xlsWriter;
        adapter;
        manager;
        observation;
        unfilteredObj;
        spectroDP;
        olfactoryDP;
        handler;
    end
    
    methods (Access=public)
        
        
        %%Function for importing an Observation matrix from file. Any
        %%existing data will be deleted.
        function this = importOldData(this,filename) 
            [~,~,old] = xlsread(filename);
            this.observation.setMatrix(old);
        end
        
        %%Default constructor, takes an instance of an InputManager and a
        %%an GUIHandler object respectively
        function this = DataManager(inM,inH)
            this.manager = inM;
            this.handler = inH;
            this.xlsWriter = XLSWriter();
            this.unfilteredObj = Observation();%DataObject();
            this.observation = Observation();%DataObject();
            
            %Initializes to 300 and 15000 respectively, once its set after this its final to not
            %create inconcistensies between observations
            this.spectroDP = 220;
            this.olfactoryDP = 15000;
        end
        
        %% Clears all data from the session any information that isnt saved to excel is lost
        function this = clearAll(this)
            this = this.setUnfObject(Observation());
            this = this.setObject(Observation());
        end
        
        %%
        function this = addObject(this,id,path)
            temp = this.manager.getObservation(id,path,this.getObject());
            current = this.getUnfObject();
            tempMat = temp.getMatrix();
            
            rows = [2];
            
            [h_new,w_new] = size(tempMat);
            [h_old,w_old] = size(this.getObject().getMatrix());
            
            diff = w_old-w_new;
            
            if diff > 0
                padding = cell(h_new,diff);
                tempMat = [tempMat,padding];
                
                tempMat2 = this.getObject().getMatrix();
                tempMat2 = tempMat2(1,:);
                
                current.setMatrix(tempMat2);
            end
            
            newMat = [current.getMatrix();tempMat(2:h_new,:)];
            current = current.setMatrix(newMat);
            
            this = this.setUnfObject(current);
        end
        
        function this = finalize(this,id)
            obj = this.getUnfObject();
            
            %Interpolate and expnd the spectrum points to their own columns
            if strcmp(id,'Spectro')
               obj.downSample(this.getNrOfSpectroDP(),id);
               obj.expandSpectrumPoints(id);
            end
            
            if strcmp(id,'Olfactory')
                obj.downSample(this.getNrOfOlfactoryDP(),id);
                obj.expandSpectrumPoints(id);
            end
            
            %Remove the temporary columns for storing the arrays which
            %contains spectro and olfactory data
            obj.removeArrays();
            
            %If there are more than one row of an observation, calc avg.
            if obj.hasMultiples()
                obj.doAverage(8);
                this.setUnfObject(obj);
            end
            
            objID = obj.getObjectID();
            
            numberOfObs = length(objID);
            listOfIds = cell(1,1);
            index = 1;
            
            %%Find out for which IDs in the incoming observation already exist
            %%in the current one.
            for k=1:numberOfObs
                id = objID{1,k};
                
                if ~isempty(this.getObject().getRowFromID(id))
                    listOfIds{1,index} = id;
                    index = index +1;
                end
            end
            
            %%If there are an observation that already exist, these rows
            %%need to be combined
            if ~isempty(listOfIds{1,1})
                this.getObject().appendObservation(this.getUnfObject());
                
                for i=1:length(listOfIds)
                   id = listOfIds{1,i};
                   this.getObject().combine(id);
                end
            else
                this.merge();
            end
            
            this = this.setUnfObject(Observation());        
        end
        
        %%Write to persistant storage
        function success = store(this,path)
            obj = this.getObject();
            success = this.xlsWriter.appendXLS(path,obj);
        end
                
        function this = merge(this)
            unfObj = this.getUnfObject();
            fobj = this.getObject();
            fobj.appendObservation(unfObj);
            this.setObject(fobj);
        end
        
        %%Adds a comment to the comment column
        function this = addComment(this,row,comment)
            obj = this.getObject();
            d = obj.getMatrix();
            
            size_ = size(d);
            for i=2:size_(2)
                if strcmp(d{1,i},'Comment') || strcmp(d{1,i},'comment')
                    d{row,i} = [d{row,i},' ',comment];
                    col_ = i;
                    break;
                end
            end
            
            obj.setMatrix(d);
            id_ = d{row,2};
            
            obj = this.objList(id_);
            objMat = obj.getMatrix();
            objMat{2,col_} = comment;            
                       
            obj.setMatrix(objMat);            
            this.setObject(obj);
        end
        
        %%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%GETTERS AND SETTERS%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function obj = getObject(this)
            obj = this.observation;
        end
        
        function this = setObject(this,obj)
            this.observation = obj;
        end
        
        function this = setUnfObject(this,obj)
            this.unfilteredObj = obj;
        end
        
        function obj = getUnfObject(this)
            obj = this.unfilteredObj;
        end
        
        function handler = getHandler(this)
           handler = this.handler; 
        end
        
        function dp = getNrOfSpectroDP(this)
            dp = this.spectroDP;
        end
        
        function dp = getNrOfOlfactoryDP(this)
            dp = this.olfactoryDP;
        end
        
        function this = setNrOfOlfactoryDP(this,dp)
           %The value can only be changed once, from it's original value
           
           if ischar(dp)
               dp = str2double(dp);
           end
           
           if this.olfactoryDP == 15000
               this.olfactoryDP = dp;
           end
        end
        
        function this = setNrOfSpectroDP(this,dp)
            %The value can only be changed once, from it's original value
            if this.spectroDP == 300
                this.spectroDP = dp;
            end
        end
    end
end