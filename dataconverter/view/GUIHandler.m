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
        mergeBtn;
        scrsz
        panel
        tableSize;
    end
    
    methods (Access = public)
        
        function this = GUIHandler()
            this.scrsz = get(0,'ScreenSize');    
            sz = this.scrsz;
            this.tableSize = [sz(3)/27.4286 sz(4)/12.0 sz(3)/1.7588 sz(4)/2.6091];

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
        
        function time_ = getTime(this,id)
            time_ = weatherQuest(id);
            time_ = ['multiple-',time_];
        end        
        
        function this = run(this)
            while true
                if somethingsomething
                    break;
                end
            end
        end
        
        function [croppedImage,keep] = getCroppedImage(this,image_,p)
            keep = true;
            croppedImage = imageCrop(image_,p);
            if ischar(croppedImage)
                keep = false;
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
                    this.dataTable = uitable(this.mainWindow,'Position',this.tableSize);
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
        
        function this = mergeCallback(this,varargin)
            this.dataManager.getObject().mergeObservations(2,3);
            this = this.updateGUI();                
        end
        
        function this = tableCallback(this,varargin)
            jtable = this.dataTable.getTable();
            
            jtable.setRowSelectionInterval(jtable.getSelectedRow(),jtable.getSelectedRow());
            jtable.setColumnSelectionInterval(0,jtable.getColumnCount());            
        end
        
        function this = initGUI(this)
            sz = this.scrsz;
            
            this.mainWindow = figure('Name','Title','DockControls','off','NumberTitle','off','Position',[sz(3)/8 sz(4)/8 sz(3)/1.5 sz(4)/1.5],'MenuBar','None','ToolBar','None');
%           this.panel = uibuttongroup(this.mainWindow,'Position',[(sz(3)/8)-50 (sz(4)/8)-50 (sz(3)/1.9)-50 (sz(4)/2.3)-50]);            
            this.loadBtn = uicontrol(this.mainWindow,'Style','pushbutton','String','Load Data','Position',[sz(3)/19.2 sz(4)/1.84 sz(3)/16 sz(4)/21.6],'Callback',@this.loadCallback);
            this.importBtn = uicontrol(this.mainWindow,'Style','pushbutton','String','Import data', 'Position',[sz(3)/7.68 sz(4)/1.84 sz(3)/16 sz(4)/21.6],'Callback',@this.importCallback);
            this.manageBtn = uicontrol(this.mainWindow,'Style','pushbutton','String','Manage data','Position',[sz(3)/4.8 sz(4)/1.84 sz(3)/16 sz(4)/21.6],'Callback',@this.manageCallback);
            this.exportBtn = uicontrol(this.mainWindow,'Style','pushbutton','String','Export','Position',[sz(3)/2.95 sz(4)/1.8848 sz(3)/12.8 sz(4)/14.4],'Callback',@this.exportCallback);
            this.mergeBtn = uicontrol(this.mainWindow,'Style','pushbutton','String','Merge','Position',[sz(3)/1.6226 sz(4)/2.4273 sz(3)/38.4 sz(4)/35.2],'Callback',@this.mergeCallback);
            this.dataTable = uitable(this.mainWindow,'Position',this.tableSize,'CellSelectionCallback',@this.tableCallback);
            
            %jtable = this.dataTable.getTable();
            this.file_ = uimenu(this.mainWindow,'Label','File');
            this.clear_ = uimenu(this.file_,'Label','Clear data','Callback',@this.clearCallback);
            this.exit_ = uimenu(this.file_,'Label','Exit');
        end
        
        function this = updateGUI(this)
            this.dataTable = uitable(this.mainWindow,'data',this.dataManager.getObject().getMatrix(),'Position',this.tableSize);
        end
        
        function this = launchDialogue(this,id,varargin)
            profile viewer;
            out_ = selectData(this.dataManager.getUnfObject(),id,this);
            type = out_.type;
            
            if ~strcmp(type,'nofilter')
                this = out_.handler;
                %input_ = out_.data;
                this.dataManager = this.dataManager.applyFilter(id,type);
                this.dataManager = this.dataManager.finalize();
            end            
        end
    end    
end