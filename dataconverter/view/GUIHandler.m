classdef GUIHandler
    %GUIHANDLER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        manager
        updater
    end
    
    methods (Access = public)
        function this = GUIHandler(mng)
            this.manager = mng;
            this.updater = WindowUpdater();
        end
    end
    
    methods (Access = private)
        
        function controlCallback(args)
        
        end
        
        
    end
    
end

