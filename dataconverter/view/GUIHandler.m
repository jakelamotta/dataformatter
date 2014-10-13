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
        clear_;
        exit_;
        output;
        dataTable;
        panel1;
        dialogues;
    end
    
    methods (Access = public)
        
        function this = GUIHandler()
            this.inputManager = InputManager();
            this.dataManager = DataManager(this.inputManager);
            this.organizer = Organizer();    
            this.initGUI();
            this.dialogues = containers.Map();
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
            
            if ~strcmp(fp(6:end),' -')
                if this.dataManager.store(fp)
                    this.dataTable = uitable(this.mainWindow,'Position',[70 90 850 220]);
                    this.dataManager = this.dataManager.clearObj();
                else
                    errordlg('Exporting could not be performed, please try again','Error!');
                    end
            end
        end
        
        function this = manageCallback(this, varargin)
            
        end
                
        function this = importCallback(this,varargin)
            importInfo = importWindow();
            type = importInfo{1,1}; 
            p = importInfo{1,2};
            this.inputManager = this.inputManager.splitPaths(p,type);
            paths_ = this.inputManager.getPaths();
            
            disp(paths_{1,1});                
            
            for i=1:length(paths_)
                this.dataManager = this.dataManager.addObject(type,{paths_{i}});
                s = size(this.dataManager.getObject().getMatrix());
                
                if s(1) > 2
                    this = this.launchDialogue(type);
                end
                
                this.dataManager = this.dataManager.finalize();
            end
            
            this = this.updateGUI();
        end
        
        function this = clearCallback(this,varargin)
            this.dataManager = this.dataManager.clearAll();
            this = this.updateGUI();
        end
        
        function this = initGUI(this)
            scrsz = get(0,'ScreenSize');            
            this.mainWindow = figure('Name','Title','DockControls','off','NumberTitle','off','Position',[scrsz(3)/8 scrsz(4)/8 scrsz(3)/1.9 scrsz(4)/2.3],'MenuBar','None','ToolBar','None');
            
            %this.panel1 = uibuttongroup('position',[0 0.6 1 .4]);
            %panel2 = uipanel('Parent',this.mainWindow,'Data','My Panel2','Position',[.25 .1 .5 .8]);
            this.loadBtn = uicontrol(this.mainWindow,'Style','pushbutton','String','Load Data','Position',[100 380 120 50],'Callback',@this.loadCallback);
            this.importBtn = uicontrol(this.mainWindow,'Style','pushbutton','String','Import data', 'Position',[250 380 120 50],'Callback',@this.importCallback);
            this.manageBtn = uicontrol(this.mainWindow,'Style','pushbutton','String','Manage data','Position',[400 380 120 50],'Callback',@this.manageCallback);
            this.exportBtn = uicontrol(this.mainWindow,'Style','pushbutton','String','Export','Position',[650 368 150 75],'Callback',@this.exportCallback);
            
            this.dataTable = uitable(this.mainWindow,'Position',[70 90 850 220]);%,'Callback',@this.tableCallback);
            %this.output = uicontrol(this.mainWindow,'Position',[70 100 850 150]);
           
            this.file_ = uimenu(this.mainWindow,'Label','File');
            this.clear_ = uimenu(this.file_,'Label','Clear data','Callback',@this.clearCallback);
            this.exit_ = uimenu(this.file_,'Label','Exit');
        end
        
        function this = updateGUI(this)
            this.dataTable = uitable(this.mainWindow,'data',this.dataManager.getObject().getMatrix(),'Position',[70 90 850 220]);
        end
        
        function this = launchDialogue(this,id)
            type = selectData(this.dataManager.getObject().getMatrix());
%            type = out_{1};
%            this.dataManager.getObject.setMatrix(out_{2});
            this.dataManager = this.dataManager.applyFilter(id,type);
        end
    end    
end

