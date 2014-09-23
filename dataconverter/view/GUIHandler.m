classdef GUIHandler
    %GUIHANDLER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
        manager;
        updater;
        mainWindow;
        menuBar;
    end
    
    methods (Access = public)
        function this = GUIHandler(mng)
            this.manager = mng;

            this.initGUI();
            %this.updater = WindowUpdater(this.mainWindow);
            %updater.update();
        end
        
        function run(this)
            
            while true
               
                
                
                if somethingsomething
                    break;
                end
            end
        
            
        end
        
    end
    
    methods (Static)
        
    end
    
    methods (Access = private)
        
        function this = controlCallback(varargin)%this,hObj,event,~)
            this = varargin(1);
            
            
        end
        
        function this = initGUI(this)
            
            scrsz = get(0,'ScreenSize');            
            this.mainWindow = figure('Position',[scrsz(3)/8 scrsz(4)/8 scrsz(3)/1.5 scrsz(4)/1.5],'MenuBar','None','ToolBar','None');
            %this.mainWindow = figure('Position',[240 135 1280 720],'MenuBar','None','ToolBar','None');
            %this.menuBar = figure('MenuBar','None');
            
            %panel1 = uipanel('Parent',this.mainWindow,'Controls','My Panel1','Position',[.25 .1 .5 .8]);
            %panel2 = uipanel('Parent',this.mainWindow,'Data','My Panel2','Position',[.25 .1 .5 .8]);
            loadBtn = uicontrol(this.mainWindow,'Style','pushbutton','String','Load Data','Position',[100 630 120 50],'Callback',@this.controlCallback);
            %file_ = uimenu(this.menuBar,'Label','File');
            %help_ = uimenu(this.menuBar,'Label','Help');           
            
            
        end
        
    end    
end

