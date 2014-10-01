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
        panel1;
    end
    
    methods (Access = public)
        
        function this = GUIHandler()
            this.inputManager = InputManager();
            this.dataManager = DataManager(this.inputManager);
            this.organizer = Organizer();    
            this.initGUI();
        end
        
        function this = run(this)
            
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
            
            fp = exportWindow();            
            if this.dataManager.store(fp)
                this.dataTable = uitable(this.mainWindow,'Position',[70 90 850 220]);
                this.dataManager = this.dataManager.clearObj();
            else
                errordlg('Exporting could not be performed, please try again','Error!');
            end
        end
        
        function this = manageCallback(this, varargin)
            this.dataManager = this.dataManager.addObject('Weather',{'C:\Users\Kristian\testdata2.txt'});
            %this.dataTable = [this.dataTable,cell2table(this.dataManager.objList('1').getMatrix())];
            %set(this.dataTable,'data',this.dataManager.objList('1').getMatrix());
            %this.dataManager.store('C:\Users\Kristian\Documents\GitHub\dataformatter\dataconverter\data\test2.xls');
            this.dataTable = uitable(this.mainWindow,'data',this.dataManager.getObject().getMatrix(),'Position',[70 90 850 220]);
        end
                
        function this = importCallback(this,varargin)
            selectDataType();
        end
        
        function this = initGUI(this)
            scrsz = get(0,'ScreenSize');            
            this.mainWindow = figure('Name','Title','DockControls','off','NumberTitle','off','Position',[scrsz(3)/8 scrsz(4)/8 scrsz(3)/1.9 scrsz(4)/2.3],'MenuBar','None','ToolBar','None');
            
            %this.panel1 = uibuttongroup('position',[0 0.6 1 .4]);
%             %panel2 = uipanel('Parent',this.mainWindow,'Data','My Panel2','Position',[.25 .1 .5 .8]);
            this.loadBtn = uicontrol(this.mainWindow,'Style','pushbutton','String','Load Data','Position',[100 380 120 50],'Callback',@this.loadCallback);
            this.importBtn = uicontrol(this.mainWindow,'Style','pushbutton','String','Import data', 'Position',[250 380 120 50],'Callback',@this.importCallback);
            this.manageBtn = uicontrol(this.mainWindow,'Style','pushbutton','String','Manage data','Position',[400 380 120 50],'Callback',@this.manageCallback);
            this.exportBtn = uicontrol(this.mainWindow,'Style','pushbutton','String','Export','Position',[650 368 150 75],'Callback',@this.exportCallback);
            
            this.dataTable = uitable(this.mainWindow,'Position',[70 90 850 220]);%,'Callback',@this.tableCallback);
            %this.output = uicontrol(this.mainWindow,'Position',[70 100 850 150]);
           
            this.file_ = uimenu(this.mainWindow,'Label','File');
        end
        
    end    
end

