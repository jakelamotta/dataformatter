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
            this.updater = updater();
            
            this.launchGUI();
        end
    end
    
    methods (Access = private)
        
        function launchGUI(this)
            
        end
        
        function controlCallback(args)
        
        end
        
        
    end
    
end

