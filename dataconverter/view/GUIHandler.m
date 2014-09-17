classdef GUIHandler
    %GUIHANDLER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        manager;
        updater;
        mainwWindow;
    end
    
    methods (Access = public)
        function this = GUIHandler(mng)
            this.manager = mng;
            initGUI();
            this.updater = WindowUpdater(this.mainWindow);
            
        end
        
        function run(this)
            
            while true
               
                
                
                if somethingsomething
                    break;
                end
            end
        
            
        end
        
    end
    
    methods (Access = private)
        
        function controlCallback(args)
        
        end
        
        function initGUI()
            
            scrsz = get(0,'ScreenSize');            
            this.mainWindow =  figure('Position',[scrsz(3)/8 scrsz(3)/8 scrsz(3)/1.5 scrsz(4)/1.5]);
            updater.update();
            
        end
        
    end    
end

