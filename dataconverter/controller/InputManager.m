classdef InputManager
    %INPUTMANAGER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        adapterFactory;
        dataObject;
    end
    
    methods (Access = public)
        
        function this = InputManager()
            this.adapterFactory = AdapterFactory();
        end
        
        function this = setDataObject(this,adapterId,path)
            adapter = this.adapterFactory.createDataAdapter(adapterId);
            this.dataObject = adapter.getDataObject(path);
        end
        
        function this = organize(this,sources,targets)
            
            types = fieldnames(sources);
            
            for i=1:numel(types)
                type = char(types(i));
                files = fieldnames(sources.(type));
                for j=1:numel(files)
                    file = char(files(j));
                    this.saveToDir(sources.(type).(file));
                end
            end
            
        end
    end
    
    methods (Access = private)   
        function success = saveToDir(this,sourcePath, targetPath)
            success = true;
            parent = '';
            path = [parent,targetPath];
            [s,~,~] = mkdir(path);
            success = s & success;
            copyfile(sourcePath,path);
        end
    end    
end

