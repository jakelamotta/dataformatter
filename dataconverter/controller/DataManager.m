classdef DataManager < handle
    %DATAMANAGER Summary of this class goes here
    %Detailed explanation goes here
    
    properties (Access = private)
        xlsWriter;
        adapter;
        manager;
        observation;
        unfilteredObj;
        filterFactory;
        spectroDP;
        olfactoryDP;
        handler;
    end
    
    methods (Access=public)
        
        %%Default constructor, takes an instance of an InputManager and a
        %%an GUIHandler object respectively
        function this = DataManager(inM,inH)
            this.filterFactory = FilterFactory();
            this.manager = inM;
            this.handler = inH;
            this.xlsWriter = XLSWriter();
            this.unfilteredObj = Observation();%DataObject();
            this.observation = Observation();%DataObject();
            
            %Initializes to 300 and 15000 respectively, once its set after this its final to not
            %create inconcistensies between observations
            this.spectroDP = 300;
            this.olfactoryDP = 15000;
        end
        
        %% Clears all data from the session
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
            s = size(tempMat);
            for i=3:s(1)
                rows(end+1) = i;
            end                       
            
            newMat = [current.getMatrix();tempMat(rows,:)];
            current = current.setMatrix(newMat);
%            current.setSpectroStruct(temp.getSpectroTime());
            this = this.setUnfObject(current);
        end
        
        %%
        function this = applyFilter(this,id,type)
            row = this.getUnfObject();
            filter = this.filterFactory.createFilter(id);
            this.setUnfObject(filter.filter(row,type,this.spectroDP));
        end
          
        %%
        function this = finalize(this)
            
            obj = this.getUnfObject();
            objID = obj.getObjectID();
            
            numberOfObs = length(objID);
            listOfIds = cell(1,1);
            index = 1;
            for k=1:numberOfObs
                id = objID{1,k};
                
                if ~isempty(this.getObject().getRowFromID(id))
                    listOfIds{1,index} = id;
                    index = index +1;
                end
            end
            
            
            %
            
            if ~isempty(listOfIds{1,1})
                this.getObject().appendObservation(this.getUnfObject());
                
                for i=1:length(listOfIds)
                   id = listOfIds{1,i};
                   this.getObject().combine(id);
                   %row = this.combine(obj,id);
                   %this.getUnfObject().deleteRowFromID(id);
                   %this = this.setUnfObject(this.getUnfObject().appendObservation(rows));
                   %r = row.getRowFromID(id);
                   %temp = Observation();
                   %temp.setMatrix(r);
                   %rows = rows.appendObservation(temp);
                   %this = this.setUnfObject(row); 
                end
                %this = this.setUnfObject(this.getUnfObject().appendObservation(rows));
            else
                this.merge();
            end
            
            this = this.setUnfObject(Observation());        
        end
        
        %%
        function success = store(this,path)
            obj = this.getObject();
            success = this.xlsWriter.appendXLS(path,obj);
        end
        
        function this = merge(this)
            
            unfObj = this.getUnfObject();
            fobj = this.getObject();
%            fobj.setSpectroStruct(mergestruct(fobj.getSpectroTime(),unfObj.getSpectroTime()));
            fobj.appendObservation(unfObj);
            this.setObject(fobj);
%             if fobj.getNumRows() == 1
%                 this.setObject(unfObj);
%             else
%                matrix = fobj.getMatrix();
%                row = unfObj.getMatrix();
%                
%                [matrix,row] = Utilities.padMatrix(matrix,row);
%                matrix = [matrix;row(2:end,:)];
%                fobj.setMatrix(matrix);
%                this.setObject(fobj);
%             end
        end
        
%         function combined = combine(this,obj,id)
%             combinee = this.getObject();
%             combineeMat = combinee.getRowFromID(id);
%             
%             objMat = obj.getRowFromID(id);
%             combined = Observation();
%             
%             s_combinee = size(combineeMat);
%             s_objMat = size(objMat);
%             
%             temp = combined.getMatrix();
%             temp = [temp;cell(1,length(temp))];
%             
%             [objMat,combineeMat] = Utilities.padMatrix(objMat,combineeMat);
%             [temp,combineeMat] = Utilities.padMatrix(temp,combineeMat);
%             
%             for i=1:max(s_combinee(2),s_objMat(2))
%                 if isempty(objMat{2,i})
%                     temp{2,i} = combineeMat{2,i};
%                 else
%                     temp{2,i} = objMat{2,i};
%                 end
%             end
%             
%             obj.deleteRowFromID(id);
%             
%             [temp,oldMat] = Utilities.padMatrix(temp,obj.getMatrix());
%             
%             temp = [oldMat;temp(2:end,:)];
%             
%             this.getObject().deleteRowFromID(id);
% 
%             combined = combined.setMatrix(temp);
%         end

        %%
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