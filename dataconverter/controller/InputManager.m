classdef InputManager
    %INPUTMANAGER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        adapterFactory;
        dataObject;
        objList;
        paths;
    end
    
    methods (Access = public)
        
        function this = InputManager()
            this.adapterFactory = AdapterFactory();
            this.paths = {};
        end
        
        function obj = getDataObject(this,adapterId,paths)
            adapter = this.adapterFactory.createAdapter(adapterId);
            obj = adapter.getDataObject(paths);
        end
        
        function this = splitPaths(this,p,type)
            this.paths = {};
            this = this.recSearch(p,type);         
        end
        
        function ps = getPaths(this)
            ps = this.paths;
        end
        
        function success = organize(this,sources,target)
            success = true;
            types = fieldnames(sources);
            
            for i=1:numel(types)
                type = char(types(i));
                
                if ~ischar(sources.(type))
                    files = fieldnames(sources.(type));
                    for j=1:numel(files)
                        file = char(files(j));
                        success = success & this.saveToDir(sources.(type).(file),[target,type]);
                    end
                else
                   success = success & this.saveToDir(sources.(type),[target,type]);
                end    
            end
            
        end
    end
    
    methods (Access = private)
        
        function this = recSearch(this,p,t)
            temp = dir(p);
            fs = strfind(p,'\');
            last = fs(end);
            
            s = size(temp);
            
            for i=3:s(1)
                if strcmp(p(last+1:end),t)
                    typeDir = dir(p);
                    numFiles = size(typeDir);
                    
                    for j=3:numFiles
                        this.paths{1,end+1} = [p,'\',typeDir(j).name];
                    end
                else
                    this = this.recSearch([p,'\',temp(i).name],t);
                end
            end
        end
        
        function success = saveToDir(this,sourcePath, targetPath)
            success = true;
            parent = 'C:\Users\Kristian\Documents\GitHub\dataformatter\dataconverter\data\';
            path = [parent,targetPath];
            [s,~,~] = mkdir(path);
            success = s & success;
            copyfile(sourcePath,path);
        end
    end    
end

