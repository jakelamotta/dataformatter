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
            this.dataObject = {};
        end
        
        function this = addObject(this,id,path)
            row = this.manager.getDataObject(id,path);
            
            filter = this.filterFactory.createFilter(id);
            row = row.setMatrix(filter.filter(row));%,this.dataObject));
            
            objID = row.getObjectID();
            
            if this.objList.isKey(objID)
                this.objList(objID) = this.combine(row);                
            else
                this.objList(objID) = row;
            end
            
            this.dataObject = this.merge();       
        end
        
        function obj = getObject(this)
%             obs = this.objList(id);
%             
%             s = size(obs);
%             
%             if s(1) > 2
%                 obs = this.filterWeather(obs);
%             end           
            obj = this.dataObject;            
        end
        
        function list = getObjectList(this)
            list = this.objList;
        end
        
        function store(this,path)
            this.xlsWriter.writeToXLS(path,obj);            
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
            obj = this.dataObject;
            
            
%            check = obj;
            
             for i=1:length(keys_)
                 key = keys_{1,i};
                 obs = this.objList(key);
%                 
%                 if ~exist(check,'var')
%                     obj = obs;
%                 else
%                     
%                     s = size(obs);
%                     s = s(1);
%                     rows = [];
%                     
%                     for i=2:s
%                         rows(end+1) = i;
%                     end
%                     
%                     obj = [obj;obs(rows,:)];
%                 end
                if isempty(obj)
                    obj = obs;
                else
                    obs = obs.getMatrix();
                    matrix = obj.getMatrix();
                    obj.setMatrix([matrix;obs(2,:)]);
                end
             end
             
             obj
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

