classdef DataManager < handle
    %DATAMANAGER Summary of this class goes here
    %Detailed explanation goes here
    
    properties (Access = private)
        xlsWriter;
        adapter;
        manager;
        dataObject;
        objList;
        unfilteredObj;
        filterFactory;
    end
    
    methods (Access=public)
        
        function this = DataManager(inM)
            this.filterFactory = FilterFactory();
            this.manager = inM;
            this.xlsWriter = XLSWriter();
            this.objList = containers.Map();
            this.unfilteredObj = DataObject();
            this.dataObject = DataObject();
        end
        
        function this = clearAll(this)
            this.dataObject = DataObject();            
        end
        
        function this = addObject(this,id,path)
            row = this.manager.getDataObject(id,path);
            %%%this = this.setObject(row);
            this = this.setUnfObject(row);
        end
        
        function this = appendObject(this,id,path)
            temp = this.manager.getDataObject(id,path);
            current = this.getUnfObject();
            tempMat = temp.getMatrix();
            rows = [2];
            s = size(tempMat);
            for i=3:s(1)
                rows(end+1) = i;
            end           
            
            newMat = [current.getMatrix();tempMat(rows,:)];
            current = current.setMatrix(newMat);
            
            %%%this = this.setObject(current);
            this = this.setUnfObject(current);
        end
        
        function this = applyFilter(this,id,type)
            row = this.getUnfObject();
            filter = this.filterFactory.createFilter(id);
            row = row.setMatrix(filter.filter(row,type));
            this = this.setObject(row);
        end
        
        function this = finalize(this)
            
            obj = this.getUnfObject();
            objID = obj.getObjectID();
            
            numberOfObs = length(objID);
            
            for k=1:numberOfObs
                id = objID{1,k};
                
                if this.objList.isKey(id);
                    row = this.combine(obj,id);
                    this = this.setObject(row);
                else
                    row = DataObject();
                    row = row.setMatrix(obj.getRowFromID(id));
                end

                this.objList(id) = row;

                %if ~isempty(this.dataObject.getMatrix())% && (numRows(1) > 2 || append )
                this = this.setObject(this.merge());
                %else
                %    this = this.setObject(row);
                    %this.objList.remove(objID);
                %end
            end
            
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
        
        function this = clearObj(this)
            this.dataObject = DataObject();
            this.objList = containers.Map();
        end
    end
    
    methods (Access = private)
        
        function obs = filter(this,rows)
            rows = rows.getMatrix();
            obs = rows([1 2],:);
        end
        
        function combined = combine(this,obj,id)
            %combinee = this.objList(obj.getObjectID());
            combinee = this.objList(id);
            combineeMat = combinee.getMatrix();
            %objMat = obj.getMatrix();
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
            
            combined = combined.setMatrix(temp);
        end
        
        function obj = merge(this)
            keys_ = this.objList.keys();
            obj = this.getObject();
            
            for i=1:length(keys_)
                key = keys_{1,i};
                obs = this.objList(key);
                
                if ~strcmp(key,obj.getObjectID())
                    if isempty(obj)
                        obj = obs;
                    else
                        obs = obs.getMatrix();
                        matrix = obj.getMatrix();
                        obj = obj.setMatrix([matrix;obs(2:end,:)]);
                    end
                end
                %this.objList.remove(key);
            end
        end
        
        function this = addComment(this,row,comment)
            d = this.getObject();
            size_ = size(d);
            for i=2:size_(2)
                if strcmp(d{1,i},'Comment')
                    d{row,i} = [d{row,i},' ',comment];
                    break;
                end
            end
            
            this = this.setObject(d);
        end
        
        function this = removeColumn(this,col)
        end
        
        function this = removeRow(this,row)
        end
    end
end


