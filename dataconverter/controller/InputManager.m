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
        
        function success = saveToDir(this,sourcePath, targetPath)
            success = true;
            parent = '';
            path = [parent,targetPath];
            [s,~,~] = mkdir(path);
            success = s & success;
            copyfile(sourcePath,path);
        end        
    end
    
    methods (Access = private)   
    
    end    
end

