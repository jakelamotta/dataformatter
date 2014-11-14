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
            this.dataManager = DataManager(this.inputManager,this);
            this.inputManager.setDataManager(this.dataManager);
            this.organizer = Organizer();    
            this.initGUI();
            this.dialogues = containers.Map();
            
        end
        
        function manager = getDataManager(this)
           manager = this.dataManager; 
        end
        
        function time_ = getTime(this)
            time_ = weatherQuest;
            time_ = ['multiple-',time_];
        end        
        
        function this = run(this)
            
            while true
                if somethingsomething
                    break;
                end
            end
        
            
        end
        
    end
    
    methods (Access = private)
        
        function this = loadCallback(this,varargin)           
            
            this.organizer = this.organizer.launchGUI();
            
            if iscell(this.organizer.target)
                size_ = size(this.organizer.target);
                for i=1:size_(2)
                    success = this.inputManager.organize(this.organizer.sources,this.organizer.target{1,i});
                end
            end
        end
        
        function this = exportCallback(this,varargin)
            
            fp = exportWindow();         
            
            if ~strcmp(fp(6:end),' -') && ~isnumeric(fp)
                if this.dataManager.store(fp)
                    this.dataTable = uitable(this.mainWindow,'Position',[70 90 850 220]);
                    this.dataManager = this.dataManager.clearAll();%clearObj();
                else
                    errordlg('Exporting could not be performed, please try again','Error!');
                    end
            end
        end
        
        function this = manageCallback(this, varargin)
            userdata = manageData(this.dataManager.getObject());            
            if ~strcmp('',userdata)
                this.dataManager = this.dataManager.addComment(userdata.row,userdata.comment);        
            end
            this.updateGUI();
        end
                
        function this = importCallback(this,varargin)
            importInfo = importWindow();
            profile on;
            if iscell(importInfo) && ~isnumeric(importInfo{1,2})           
                type = importInfo{1,1}; 
                p = importInfo{1,2};
                this.inputManager = this.inputManager.splitPaths(p,type);
                paths_ = this.inputManager.getPaths();
                                
                if isempty(paths_)
                    errordlg(['There are no ', type,' data files in the specified folder, please try again.'],'No such file')
                end
                
                %try    
                    this.dataManager = this.dataManager.addObject(type,paths_);
                %catch ex
                        %Suggestions is to log details of the error
                %    errordlg(['Something went wrong when trying to parse the ',type,' data file. Error message: ',ex.message],'Parse error');
                %end

                s = size(this.dataManager.getUnfObject().getMatrix());

                if s(1) > 2 || strcmp(type,'Spectro') || strcmp(type,'Olfactory')
                    this = this.launchDialogue(type);
                else
                    this.dataManager.finalize();
                end

                this = this.updateGUI();
                
            end
        end
        
        function this = clearCallback(this,varargin)
            this.dataManager = this.dataManager.clearAll();
            this = this.updateGUI();
        end
        
        function this = initGUI(this)
            scrsz = get(0,'ScreenSize');            
            this.mainWindow = figure('Name','Title','DockControls','off','NumberTitle','off','Position',[scrsz(3)/8 scrsz(4)/8 scrsz(3)/1.9 scrsz(4)/2.3],'MenuBar','None','ToolBar','None');
            
            this.loadBtn = uicontrol(this.mainWindow,'Style','pushbutton','String','Load Data','Position',[100 380 120 50],'Callback',@this.loadCallback);
            this.importBtn = uicontrol(this.mainWindow,'Style','pushbutton','String','Import data', 'Position',[250 380 120 50],'Callback',@this.importCallback);
            this.manageBtn = uicontrol(this.mainWindow,'Style','pushbutton','String','Manage data','Position',[400 380 120 50],'Callback',@this.manageCallback);
            this.exportBtn = uicontrol(this.mainWindow,'Style','pushbutton','String','Export','Position',[650 368 150 75],'Callback',@this.exportCallback);
            
            this.dataTable = uitable(this.mainWindow,'Position',[70 90 850 220]);%,'Callback',@this.tableCallback);

            this.file_ = uimenu(this.mainWindow,'Label','File');
            this.clear_ = uimenu(this.file_,'Label','Clear data','Callback',@this.clearCallback);
            this.exit_ = uimenu(this.file_,'Label','Exit');
        end
        
        function this = updateGUI(this)
            this.dataTable = uitable(this.mainWindow,'data',this.dataManager.getObject().getMatrix(),'Position',[70 90 850 220]);
        end
        
        function this = launchDialogue(this,id,varargin)
            profile viewer;
            out_ = selectData(this.dataManager.getUnfObject(),id,this);
            type = out_.type;
            
            if ~strcmp(type,'nofilter')
                this = out_.handler;
                input_ = out_.data;
                this.dataManager = this.dataManager.applyFilter(id,type);
                this.dataManager = this.dataManager.finalize();
            end
        end
    end    
end

