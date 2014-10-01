classdef DataManager
    %DATAMANAGER Summary of this class goes here
    %Detailed explanation goes here
    
    properties (Access = private)
        xlsWriter;
        adapter;
        manager;
        dataObject;
        objList;
        filterFactory;
    end
    
    methods (Access=public)
        
        function this = DataManager(inM)
            this.filterFactory = FilterFactory();
            this.manager = inM;
            this.xlsWriter = XLSWriter();
            this.objList = containers.Map();
            this.dataObject = DataObject();
            this.dataObject = this.dataObject.setMatrix({})
        end
        
        function this = addObject(this,id,path)
            row = this.manager.getDataObject(id,path);
            
            filter = this.filterFactory.createFilter(id);
            row = row.setMatrix(filter.filter(row));
            
            objID = row.getObjectID();
            
            if this.objList.isKey(objID)
                this.objList(objID) = this.combine(row);
            else
                this.objList(objID) = row;
            end
            
            if ~isempty(this.dataObject.getMatrix())
                this = this.setObject(this.merge());
            else
                this = this.setObject(row);
                this.objList.remove(objID);
            end
            
        end
        
        function obj = getObject(this)
            obj = this.dataObject;
        end
        
        function this = setObject(this,obj)
            this.dataObject = obj;
        end
        
        function list = getObjectList(this)
            list = this.objList;
        end
        
        function success = store(this,path)
            obj = this.getObject();
            success = this.xlsWriter.appendXLS(path,obj);
        end
        
        function this = clearObj(this)
            this.dataObject = containers.Map();
            this.objList = containers.Map();
        end
    end
    
    methods (Access = private)
        
        function obs = filter(this,rows)
            rows = rows.getMatrix();
            obs = rows([1 2],:);
        end
        
        function obj = combine(this,obj)
            %Not implemented yet, function that combines two objects
            %corresponding to the same observation
        end
        
        function obj = merge(this)
            keys_ = this.objList.keys();
            obj = this.getObject();
            
            for i=1:length(keys_)
                key = keys_{1,i};
                obs = this.objList(key);
                
                if isempty(obj)
                    obj = obs;
                else
                    obs = obs.getMatrix();
                    matrix = obj.getMatrix();
                    obj = obj.setMatrix([matrix;obs(2,:)]);
                end
                this.objList.remove(key);
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


