classdef DataManager
    %DATAMANAGER Summary of this class goes here
    %Detailed explanation goes here
    
    properties (SetAccess = private)
        xlsWriter;
        adapter;
        manager;
        dataObject;
        objList;
    end
    
    methods (Access=public)        
        
        function this = DataManager(inM)
            this.manager = inM;
            this.xlsWriter = XLSWriter();    
            this.objList = containers.Map();
        end
        
        function this = addObject(this,id,path)
            
            obj = this.manager.getDataObject(id,path);
            
            objID = obj.getObjectID();
            
            if this.objList.isKey(objID)
                this.objList(objID) = this.combine(obj);                
            else
                this.objList(objID) = obj;
            end       
        end
        
        function store(this)
            
            obj = this.merge();
            this.xlsWriter.writeToXLS('C:\Users\Kristian\Documents\GitHub\dataformatter\dataconverter\data\test2.xls',obj);            
        end
    end
    
    methods (Access = private)
        
        function obj = combine(this,obj)
            %Not implemented yet, function that combines two objects
            %corresponding to the same observation
        end
        
        function obj = merge(this)
            obj = cell(1,1);
            keys_ = this.objList.keys();
            for i=1:length(keys_)
                key = keys_{1,i};
                obs = this.objList(key);
                
                if length(obj) == 1
                    obj = obs;
                else
                    
                    s = size(obs);
                    s = s(1);
                    rows = [];
                    
                    for i=2:s
                        rows(end+1) = i;
                    end
                    
                    obj = [obj;obs(rows,:)];
                end
            end
        end        
                
        function this = addComment(this,row,comment)
            d = this.dataObject;
            size_ = size(d);
            for i=2:size_(2)
                if strcmp(d{1,i},'Comment')
                    d{row,i} = [d{row,i},' ',comment];
                    break;
                end
            end
            
            this.dataObject = d;
        end        
        
        function this = removeColumn(this,col)
        end
        
        function this = removeRow(this,row)
        end        
    end
end

