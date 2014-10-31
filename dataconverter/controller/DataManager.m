classdef DataManager < handle
    %DATAMANAGER Summary of this class goes here
    %Detailed explanation goes here
    
    properties (Access = private)
        xlsWriter;
        adapter;
        manager;
        dataObject;
        unfilteredObj;
        filterFactory;
        spectroDP;
    end
    
    methods (Access=public)
        
        function this = DataManager(inM)
            this.filterFactory = FilterFactory();
            this.manager = inM;
            this.xlsWriter = XLSWriter();
            this.unfilteredObj = DataObject();
            this.dataObject = DataObject();
            
            %Initializes to 300, once its set after this its final to not
            %create inconcistensies between observations
            this.spectroDP = 300;
        end
        
        function dp = getNrOfSpectroDP(this)
            dp = this.spectroDP;
        end
        
        function this = setNrOfSpectroDP(this,dp)
            if this.spectroDP == 300
                this.spectroDP = dp;
            end
        end
        
        function this = clearAll(this)
            this = this.setUnfObject(DataObject());
            this = this.setObject(DataObject());
            this.objList = containers.Map();
        end
        
        function this = addObject(this,id,path)
            temp = this.manager.getDataObject(id,path,this.getObject());
            current = this.getUnfObject();
            tempMat = temp.getMatrix();
            rows = [2];
            s = size(tempMat);
            for i=3:s(1)
                rows(end+1) = i;
            end                       
            
            newMat = [current.getMatrix();tempMat(rows,:)];
            current = current.setMatrix(newMat);
            current = current.addSpectroData(temp.getSpectroData());
            
            this = this.setUnfObject(current);
        end
        
        function this = applyFilter(this,id,type)
            row = this.getUnfObject();
            filter = this.filterFactory.createFilter(id);
            this.setUnfObject(filter.filter(row,type,this.spectroDP));
        end
                
        function this = finalize(this)
            
            obj = this.getUnfObject();
            objID = obj.getObjectID();
            
            numberOfObs = length(objID);
            
            for k=1:numberOfObs
                id = objID{1,k};
                
                if ~isempty(this.getObject().getRowFromID(id))%this.objList.isKey(id);
                    row = this.combine(obj,id);
                    this = this.setObject(row);
%                 else
%                     row = DataObject();
%                     row = row.setMatrix(obj.getRowFromID(id));
%                     row = row.addSpectroData(obj.getSpectroData());
                end
            end
            
            this.merge();
            this = this.setUnfObject(DataObject());        
        end
        
        function obj = getObject(this)
            obj = this.dataObject;
        end
        
        function this = setObject(this,obj)
            this.dataObject = obj;
        end
        
        function this = setUnfObject(this,obj)
            this.unfilteredObj = obj;
        end
        
        function obj = getUnfObject(this)
            obj = this.unfilteredObj;
        end
        
        function list = getObjectList(this)
            list = this.objList;
        end
        
        function success = store(this,path)
            obj = this.getObject();
            success = this.xlsWriter.appendXLS(path,obj);
        end
        
        function this = merge(this)
            
            unfObj = this.getUnfObject();
            fobj = this.getObject();
            
            if fobj.getNumRows() == 1
                this.setObject(unfObj);
            else
               matrix = fobj.getMatrix();
               row = unfObj.getMatrix();
               
               [matrix,row] = Utilities.padMatrix(matrix,row);
               matrix = [matrix;row(2:end,:)];
               fobj.setMatrix(matrix);
               this.setObject(fobj);
            end
        end
        
        function combined = combine(this,obj,id)
            combinee = this.getObject();
            combineeMat = combinee.getRowFromID(id);
            
            objMat = obj.getRowFromID(id);
            combined = DataObject();
            s = size(combineeMat);
            
            temp = combined.getMatrix();
            for i=1:s(2)
                if isempty(objMat{2,i})
                    temp{2,i} = combineeMat{2,i};
                else
                    temp{2,i} = objMat{2,i};
                end
            end
            
            newSpectro = mergestruct(combinee.getSpectroData(),obj.getSpectroData());
            combined = combined.addSpectroData(newSpectro);
            
            obj.deleteRowFromID(id);
            
            combined = combined.setMatrix(temp);
        end

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
    end
    
    methods (Access = private)
        
        
        
        function obs = filter(this,rows)
            rows = rows.getMatrix();
            obs = rows([1 2],:);
        end
        
        function this = removeColumn(this,col)
        end
        
        function this = removeRow(this,row)
        end
    end
end




% classdef DataManager < handle
%     %DATAMANAGER Summary of this class goes here
%     %Detailed explanation goes here
%     
%     properties (Access = private)
%         xlsWriter;
%         adapter;
%         manager;
%         dataObject;
%         objList;
%         unfilteredObj;
%         filterFactory;
%         spectroDP;
%     end
%     
%     methods (Access=public)
%         
%         function this = DataManager(inM)
%             this.filterFactory = FilterFactory();
%             this.manager = inM;
%             this.xlsWriter = XLSWriter();
%             this.objList = containers.Map();
%             this.unfilteredObj = DataObject();
%             this.dataObject = DataObject();
%             
%             %Initializes to 300, once its set after this its final to not
%             %create inconcistensies between observations
%             this.spectroDP = 300;
%         end
%         
%         function dp = getNrOfSpectroDP(this)
%             dp = this.spectroDP;
%         end
%         
%         function this = setNrOfSpectroDP(this,dp)
%             if this.spectroDP == 300
%                 this.spectroDP = dp;
%             end
%         end
%         
%         function this = clearAll(this)
%             this = this.setUnfObject(DataObject());
%             this = this.setObject(DataObject());
%             this.objList = containers.Map();
%         end
%         
% %         function this = addObject(this,id,path)
% %             row = this.manager.getDataObject(id,path);
% %             %%%this = this.setObject(row);
% %             this = this.setUnfObject(row);
% %         end
%         
%         function this = addObject(this,id,path)
%             temp = this.manager.getDataObject(id,path);
%             current = this.getUnfObject();
%             tempMat = temp.getMatrix();
%             rows = [2];
%             s = size(tempMat);
%             for i=3:s(1)
%                 rows(end+1) = i;
%             end           
%             
%             
%             newMat = [current.getMatrix();tempMat(rows,:)];
%             current = current.setMatrix(newMat);
%             current = current.addSpectroData(temp.getSpectroData());
%             %%%this = this.setObject(current);
%             this = this.setUnfObject(current);
%         end
%         
%         function this = applyFilter(this,id,type)
%             row = this.getUnfObject();
%             filter = this.filterFactory.createFilter(id);
% %             row = row.setMatrix(filter.filter(row,type));
% %             this = this.setObject(row);
%             this = this.setObject(filter.filter(row,type,this.spectroDP));
%         end
%         
%         function this = finalize(this)
%             
%             obj = this.getUnfObject();
%             objID = obj.getObjectID();
%             
%             numberOfObs = length(objID);
%             
%             for k=1:numberOfObs
%                 id = objID{1,k};
%                 
%                 if this.objList.isKey(id);
%                     row = this.combine(obj,id);
%                     this = this.setObject(row);
%                 else
%                     row = DataObject();
%                     row = row.setMatrix(obj.getRowFromID(id));
%                     row = row.addSpectroData(obj.getSpectroData());
%                 end
%                 
%                 this.objList(id) = row;
% 
%                 %if ~isempty(this.dataObject.getMatrix())% && (numRows(1) > 2 || append )
%                 this = this.setObject(this.merge());
%                 %else
%                 %    this = this.setObject(row);
%                     %this.objList.remove(objID);
%                 %end
%             end
%             
%             this = this.setUnfObject(DataObject());
%         
%         end
%         
%         function obj = getObject(this)
%             obj = this.dataObject;
%         end
%         
%         function this = setObject(this,obj)
%             this.dataObject = obj;
%         end
%         
%         function this = setUnfObject(this,obj)
%             this.unfilteredObj = obj;
%         end
%         
%         function obj = getUnfObject(this)
%             obj = this.unfilteredObj;
%         end
%         
%         function list = getObjectList(this)
%             list = this.objList;
%         end
%         
%         function success = store(this,path)
%             obj = this.getObject();
%             success = this.xlsWriter.appendXLS(path,obj);
%         end
% %         
% %         function this = clearObj(this)
% %             this.dataObject = DataObject();
% %             this.objList = containers.Map();
% %         end
% 
%         function this = addComment(this,row,comment)
%             obj = this.getObject();
%             d = obj.getMatrix();
%             
%             size_ = size(d);
%             for i=2:size_(2)
%                 if strcmp(d{1,i},'Comment') || strcmp(d{1,i},'comment')
%                     d{row,i} = [d{row,i},' ',comment];
%                     col_ = i;
%                     break;
%                 end
%             end
%             
%             obj.setMatrix(d);
%             id_ = d{row,2};
%             
%             obj = this.objList(id_);
%             objMat = obj.getMatrix();
%             objMat{2,col_} = comment;            
%                        
%             obj.setMatrix(objMat);
%             
%             this.setObject(obj);
%         end
%     end
%     
%     methods (Access = private)
%         
%         function obs = filter(this,rows)
%             rows = rows.getMatrix();
%             obs = rows([1 2],:);
%         end
%         
%         function combined = combine(this,obj,id)
%             %combinee = this.objList(obj.getObjectID());
%             combinee = this.objList(id);
%             combineeMat = combinee.getMatrix();
%             %objMat = obj.getMatrix();
%             objMat = obj.getRowFromID(id);
%             combined = DataObject();
%             s = size(combineeMat);
%             
%             temp = combined.getMatrix();
%             for i=1:s(2)
%                 if isempty(objMat{2,i})
%                     temp{2,i} = combineeMat{2,i};
%                 else
%                     temp{2,i} = objMat{2,i};
%                 end
%             end
%             
%             newSpectro = mergestruct(combinee.getSpectroData(),obj.getSpectroData());
%             combined = combined.addSpectroData(newSpectro);
%             
%             
%             combined = combined.setMatrix(temp);
%         end
%         
%         function obj = merge(this)
%             keys_ = this.objList.keys();
%             %obj = this.getUnfObject();
%             obj = this.getObject();
%             for i=1:length(keys_)
%                 key = keys_{1,i};
%                 obs = this.objList(key);
%                 
%                 if ~strcmp(key,obj.getObjectID())
%                     if isempty(obj)
%                         obj = obs;
%                     else
%                         obs = obs.getMatrix();
%                         matrix = obj.getMatrix();
%                         
%                         [matrix,obs] = Utilities.padMatrix(matrix,obs);
% %                         if length(matrix) < length(obs)
% %                             diff = abs(length(matrix)-length(obs));
% %                             s = size(matrix);
% %                             height = s(1);
% %                             
% %                             newMat = cell(height,diff);
% %                             matrix = [matrix,newMat];
% %                             matrix(1,:) = obs(1,:);
% %                         elseif length(matrix) > length(obs)
% %                             diff = abs(length(matrix)-length(obs));
% %                             s = size(obs);
% %                             height = s(1);
% %                             
% %                             newMat = cell(height,diff);
% %                             obs = [obs,newMat];
% %                             obs(1,:) = matrix(1,:);
% %                         end
%                         obj = obj.setMatrix([matrix;obs(2:end,:)]);
%                         
%                     end
%                     
%                 end
%                 %this.objList.remove(key);
%             end
%         end
%         
%         function this = removeColumn(this,col)
%         end
%         
%         function this = removeRow(this,row)
%         end
%     end
% end
% 
% 
