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
        loadBtn;
        importBtn;
        manageBtn;
        exportBtn;
        file_;
        output;
        dataTable;
    end
    
    methods (Access = public)
        
        function this = GUIHandler()
            this.inputManager = InputManager();
            this.dataManager = DataManager(this.inputManager);
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
            
            %exportWindow();            
            this.dataManager = this.dataManager.addObject('Weather',{'C:\Users\Kristian\testdata.txt'});
            %this.dataTable = [this.dataTable,cell2table(this.dataManager.objList('1').getMatrix())];
            this.dataManager.store();
        end
        
        function this = manageCallback(this, varargin)
        
        end
                
        function this = importCallback(this,varargin)
            selectDataType()
        end
        
        function this = initGUI(this)
            scrsz = get(0,'ScreenSize');            
            this.mainWindow = figure('Name','Title','DockControls','off','NumberTitle','off','Position',[scrsz(3)/8 scrsz(4)/8 scrsz(3)/1.9 scrsz(4)/2],'MenuBar','None','ToolBar','None');
            
            %panel1 = uipanel('Parent',this.mainWindow,'Controls','My Panel1','Position',[.25 .1 .5 .8]);
            %panel2 = uipanel('Parent',this.mainWindow,'Data','My Panel2','Position',[.25 .1 .5 .8]);
            this.loadBtn = uicontrol(this.mainWindow,'Style','pushbutton','String','Load Data','Position',[100 450 120 50],'Callback',@this.loadCallback);
            this.importBtn = uicontrol(this.mainWindow,'Style','pushbutton','String','Import data', 'Position',[250 450 120 50],'Callback',@this.importCallback);
            this.manageBtn = uicontrol(this.mainWindow,'Style','pushbutton','String','Manage data','Position',[400 450 120 50],'Callback',@this.manageCallback);
            this.exportBtn = uicontrol(this.mainWindow,'Style','pushbutton','String','Export','Position',[650 438 150 75],'Callback',@this.exportCallback);
            
            this.dataTable = uitable(this.mainWindow,'Position',[70 250 850 150]);%,'Callback',@this.tableCallback);
            this.output = uicontrol(this.mainWindow,'Position',[70 100 850 150]);
            
            this.file_ = uimenu(this.mainWindow,'Label','File');
        end
        
    end    
end

