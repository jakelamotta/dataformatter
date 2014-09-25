classdef GUIHandler
    %GUIHANDLER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
        dataManager;
        inputManager;
        updater;
        mainWindow;
        menuBar;
        organizer;
    end
    
    methods (Access = public)
        
        function this = GUIHandler()
            this.dataManager = DataManager();
            this.inputManager = InputManager();
            this.organizer = Organizer();    
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
        
        function this = loadCallback(this,varargin)           
            this.organizer = this.organizer.launchGUI();
            if ~strcmp(this.organizer.target,'')
                success = this.inputManager.organize(this.organizer.sources,this.organizer.target);
            end
        end
        
        function this = exportCallback(this,varargin)
        
        end
        
        function this = manageCallback(this, varargin)
        end
        
        function this = initGUI(this)
            scrsz = get(0,'ScreenSize');            
            this.mainWindow = figure('Name','Title','DockControls','off','NumberTitle','off','Position',[scrsz(3)/8 scrsz(4)/8 scrsz(3)/1.9 scrsz(4)/2],'MenuBar','None','ToolBar','None');
            
            %panel1 = uipanel('Parent',this.mainWindow,'Controls','My Panel1','Position',[.25 .1 .5 .8]);
            %panel2 = uipanel('Parent',this.mainWindow,'Data','My Panel2','Position',[.25 .1 .5 .8]);
            loadBtn = uicontrol(this.mainWindow,'Style','pushbutton','String','Load Data','Position',[100 450 120 50],'Callback',@this.loadCallback);
            importBtn = uicontrol(this.mainWindow,'Style','pushbutton','String','Import data', 'Position',[250 450 120 50]);
            manageBtn = uicontrol(this.mainWindow,'Style','pushbutton','String','Manage data','Position',[400 450 120 50],'Callback',@this.manageCallback);
            exportBtn = uicontrol(this.mainWindow,'Style','pushbutton','String','Export','Position',[650 438 150 75],'Callback',@this.exportCallback);
            
            dataTable = uitable(this.mainWindow,'Position',[70 250 850 150]);%,'Callback',@this.tableCallback);
            output = uicontrol(this.mainWindow,'Position',[70 100 850 150]);
            
            file_ = uimenu(this.mainWindow,'Label','File');
            help_ = uimenu(this.menuWindow,'Label','Help');           
        end
        
    end    
end

