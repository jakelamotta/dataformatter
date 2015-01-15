classdef InputManager < handle
    %INPUTMANAGER class deals with input and some organzing of data
    
    properties (Access = private)
        adapterFactory;
        dataObject;
        objList;
        paths;
        dataManager;
        adapter;
    end
    
    methods (Access = public)
        
        %%Default constructor, can take an instance of a DataManager as an argument
        function this = InputManager(varargin)
            this.adapterFactory = AdapterFactory();
            this.paths = {};
            
            if ~isempty(varargin)
                this.dataManager = varargin{1};
            end
        end
        
        %%Function that creates a dataadapter and retrieves an object
        %%accordingly. The adapterId is the type of adapter to be created
        function obj = getObservation(this,adapterId,paths,inObj)
            
            this.adapter = this.adapterFactory.createAdapter(adapterId);
            
            if ischar(this.adapter)
                errordlg('The data adapter could not be created, the adapterfactory did not return a valid object');
            else
                tic;
                if strcmp(adapterId,'Weather') || strcmp(adapterId,'Image')
                    %spectroTime = inObj.getSpectroTime();
                    obj = this.adapter.getDataObject(paths,inObj,this);
                else
                    obj = this.adapter.getDataObject(paths);
                end
                toc
            end
        end        
                
        %%Takes a path as an input and finds all folders of the input type
        %%that are located in a subfolder of the input path
        function this = splitPaths(this,p,type)
            this.paths = {};
            this = this.recSearch(p,type);         
        end
        
        %%Function for organizing data into folders
        function success = organize(this,sources,target)
            success = true;
            types = fieldnames(sources);
            
            for i=1:numel(types)
                type = char(types(i));
                
                noExcelFile = true;
                
                if ~ischar(sources.(type))
                    
                    files = fieldnames(sources.(type));
                    
                    for j=1:numel(files)
                        file = char(files(j));
                        
                        if strcmp(type,'Behavior')
                            bFile = sources.(type).(file);
                            if strcmp(bFile(end-3:end),'xlsx')
                                noExcelFile = false;
                            end
                        end
                        
                        success = success & this.saveToDir(sources.(type).(file),[target,type]);
                    end
                else
                   success = success & this.saveToDir(sources.(type),[target,type]);
                end
                
                if strcmp(type,'Behavior') && noExcelFile
                   this.saveToDir(Utilities.getpath('template.xlsx'),[target,type]);
                end
            end
        end
        
        %%Function that writes metadata to a word document
        function writeMetaDatatoFile(this)
            rootTree = FolderTree('data');
            path = Utilities.getpath('');
            this.getMetaData(path,rootTree);
            WriteToWordFromMatlab(Utilities.getpath('metadata.doc'),rootTree);
        end
        
        %%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%GETTERS AND SETTERS%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        function this = setDataManager(this,dm)
            this.dataManager = dm;
        end
        
        function dm = getDataManager(this)
            dm = this.dataManager;
        end
        
        function ps = getPaths(this)
            ps = this.paths;
        end
        
        %%Function that recursively builds a FolderTree object collection
        function getMetaData(this,path,tree)
            temp = dir(path);
            [h,w] = size(temp);
            
            for i=3:h                    
                    %%Creates a new FolderTree child with input FolderTree as parent
                    child = FolderTree(temp(i).name,tree);
                    
                    if temp(i).isdir
                        this.getMetaData([path,'\',temp(i).name],child);
                    end
            end
        end        
    end
    
    methods (Access = private)
        
        %%A recursive folder search function, takes a path to a folder as
        %%an input and search for all occurences of the "type" in the
        %%subfolders
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
        
        
        %%This is the function that copies files from one location to
        %another location.
        %Input: - sourcePath: the path to what is to be copied as a string
        %       - targetPath: the relative path to the target folder 
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

