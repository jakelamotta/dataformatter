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

