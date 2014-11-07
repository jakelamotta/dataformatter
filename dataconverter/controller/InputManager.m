classdef InputManager < handle
    %INPUTMANAGER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        adapterFactory;
        dataObject;
        objList;
        paths;
        dataManager;
    end
    
    methods (Access = public)
        
        function this = InputManager(varargin)
            this.adapterFactory = AdapterFactory();
            this.paths = {};
            
            if ~isempty(varargin)
                this.dataManager = varargin{1};
            end
        end
        
        function this = setDataManager(this,dm)
            this.dataManager = dm;
        end
        
        function obj = getDataObject(this,adapterId,paths,inObj)
            adapter = this.adapterFactory.createAdapter(adapterId);
            if ischar(adapter)
                errordlg('The data adapter could not be created, the adapterfactory did not return a valid object');
            else
                tic;
                if strcmp(adapterId,'Weather')
                    spectro = inObj.getSpectroData();
                    obj = adapter.getDataObject(paths,spectro,this);
                else
                    obj = adapter.getDataObject(paths);
                end
                toc
            end
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
        
        function this = recSearch(this,path,type)
            
            if strcmp(type,'Spectro')
               type = 'metadata';
            end
            
            temp = dir(path);
            fs = strfind(path,'\');
            last = fs(end);
            
            s = size(temp);
            
            for i=3:s(1)
                if strcmp(path(last+1:end),type)
                    typeDir = dir(path);
                    numFiles = size(typeDir);
                    
                    this.paths{1,end+1} = [path,'\',typeDir(i).name];
                    
                else
                    this = this.recSearch([path,'\',temp(i).name],type);
                end
            end
        end
        
        function success = saveToDir(this,sourcePath, targetPath)
            success = true;
            
            path = Utilities.getpath(targetPath);
            if ~exist(path,'dir')
                [s,a,b] = mkdir(path);
            else
                s = true;
            end
            success = s & success;
            
            if isdir(sourcePath)
                indices = strfind(sourcePath,'\');
                index = indices(end);
                path = [path,'\',sourcePath(index+1:end)];                
            end
            copyfile(sourcePath,path);
        end
    end    
end

