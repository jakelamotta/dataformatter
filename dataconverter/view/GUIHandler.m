classdef GUIHandler < handle
    %GUIHANDLER Class for handling the GUI. It is responsible for
    %communicating with the underlying data handling via the DataManager
    %class. It also makes sure that the correct gui file is launched at
    %when needed.
    
    properties (Access = private)
        dataManager;
        inputManager;
        updater;
        organizer;
        
        %%GUI elements
        mainWindow;
        menuBar;
        loadBtn;
        importBtn;
        manageMenuItem;
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
        sortDateBtn;
        sortIdBtn;
        metadata;
        idText;
        varText;
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
        
        function [croppedImage,keep] = getCroppedImage(this,image_,p)
            keep = true;
            croppedImage = imageCrop(image_,p);
            if ischar(croppedImage)
                keep = false;
            end
        end
        
        function manager = getDataManager(this)
            manager = this.dataManager;
        end
        
        function time_ = getTime(this,id)
            time_ = weatherQuest(id);
            time_ = ['multiple-',time_];
        end
        
        %%Callback functin called when the user presses the "Clear data"
        %%option in the file menu
        function this = clearCallback(this,varargin)
            this.dataManager = this.dataManager.clearAll();
            this = this.updateGUI();
        end
    end
    
    methods (Access = private)
        
        %%Callback function called when the user presses the import data
        %%button
        function this = loadCallback(this,varargin)
            this.organizer = this.organizer.launchGUI();
            
            success = this.inputManager.organize(this.organizer.sources,this.organizer.target);
        end
        
        %%Callback function called when the user presses the "Export"
        %%button
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
        
        %%Callback function called when the user presses the "Manage data"
        %%button
        function this = manageCallback(this, varargin)
            userdata = manageData(this.dataManager.getObject());
            
            if ~strcmp('',userdata)
                this.dataManager = this.dataManager.addComment(userdata.row,userdata.comment);
            end
            
            this.updateGUI();
        end
        
        %%Callback functin called when the user presses the "Load data"
        %%button
        function this = importCallback(this,varargin)
            importInfo = importWindow();
            
            if iscell(importInfo) && ~isnumeric(importInfo{1,2})
                %type = importInfo{1,1};
                types =importInfo{1,1};
                p = importInfo{1,2};
                
                
                
                for index=1:length(types)
                    type = types{index};
                    
                    
                    if strcmp(type,'load')
                        [fname,pname,uu] = uigetfile('*.*');
                        this.dataManager.importOldData([pname,fname]);
                    else
                        this.inputManager = this.inputManager.splitPaths(p,type);
                        paths_ = this.inputManager.getPaths();
                        
                        if isempty(paths_)
                            errordlg(['There are no ', type,' data files in the specified folder, please try again.'],'No such file')
                        end
                        
                        %try
                        
                            if strcmp(type,'Abiotic')
                               paths_ = fileChoice(paths_); 
                            end
                        
                           % this.dataManager = this.dataManager.addObject(type,paths_);
                        %catch ex
                        %    errordlg(['Something went wrong when trying to parse the ',type,' data file. Error message: ',ex.message],'Parse error');
                        %end
                        
                        %s = size(this.dataManager.getUnfObject().getMatrix());
                        obs = this.dataManager.getObs(type,paths_);
                        if obs.hasMultiples() || strcmp(type,'Spectro') || strcmp(type,'Olfactory')
                            this = this.launchDialogue(type,obs);
                        else
                            this.dataManager.finalize(type,obs);
                        end
                    end
                    
                    this = this.updateGUI();
                end
            end
        end
        
        %%Callback functin called when the user presses the "Sort by date"
        %%button
        function this = mergeCallback(this,varargin)
            %this.dataManager.getObject().mergeObservations(2,3);
            this.dataManager.getObject().sortByDate();
            this = this.updateGUI();
        end
        
        %%Callback functin called when the user presses the "Sort by id"
        %%button
        function this = sortIdCallback(this,varargin)
            %this.dataManager.getObject().mergeObservations(2,3);
            this.dataManager.getObject().sortById();
            this = this.updateGUI();
        end
        
        function this = metadataCallback(this,varargin)
            this.inputManager.writeMetaDatatoFile();
        end
        
        function this = tableCallback(this,varargin)
            index = varargin{2};
            try
                id = this.dataManager.getObject().get(index.Indices(1),2);
                variable = this.dataManager.getObject().get(1,index.Indices(2));
                set(this.idText,'String',id);
                set(this.varText,'String',variable);
                this.updateGUI();
            catch e
                set(this.idText,'String','No row selected');
                set(this.varText,'String','No column selected');
                this.updateGUI();
            end
        end
       
        %%Function that sets upp all the gui elements. Each position is
        %%relative to the screensize to make the application more flexible.
        function this = initGUI(this)
            sz = this.scrsz;
            this.mainWindow = figure('Name','PDManager','DockControls','off','NumberTitle','off','Position',[sz(3)/8 sz(4)/8 sz(3)/1.5 sz(4)/1.5],'MenuBar','None','ToolBar','None');
            this.importBtn = uicontrol('parent', this.mainWindow, 'style', 'pushbutton', 'units', 'normalized', 'position', [0.14 0.8 0.1 0.1], 'string', 'Manage data', 'fontunits', 'normalized', 'fontsize', 0.2, 'Callback',@this.loadCallback);
            this.loadBtn = uicontrol('parent', this.mainWindow, 'style', 'pushbutton', 'units', 'normalized', 'position', [0.26 0.8 0.1 0.1], 'string', 'Load data', 'fontunits', 'normalized', 'fontsize', 0.2, 'Callback',@this.importCallback);
            this.exportBtn =  uicontrol('parent', this.mainWindow, 'style', 'pushbutton', 'units', 'normalized', 'position', [0.38 0.8 0.1 0.1], 'string', 'Export', 'fontunits', 'normalized', 'fontsize', 0.2,'Callback',@this.exportCallback);
            
            this.idText = uicontrol('parent',this.mainWindow,'style','text','Position',[0 300 70 30],'String','-');
            this.varText = uicontrol('parent',this.mainWindow,'style','text','String','-','Position',[500 500 70 20]);
            disp(get(this.idText,'Position'));
            this.sortDateBtn = uicontrol('parent', this.mainWindow, 'style', 'pushbutton', 'units', 'normalized', 'position', [0.93 0.64 0.06 0.05], 'string', 'Sort by date', 'fontunits', 'normalized', 'fontsize', 0.3,'Callback',@this.mergeCallback);
            this.sortIdBtn = uicontrol('parent', this.mainWindow, 'style', 'pushbutton', 'units', 'normalized', 'position', [0.93 0.58 0.06 0.05], 'string', 'Sort by id', 'fontunits', 'normalized', 'fontsize', 0.3,'Callback',@this.sortIdCallback);
            
            this.dataTable = uitable(this.mainWindow,'Position',this.tableSize,'units','normalized','CellSelectionCallback',@this.tableCallback);
            
            this.file_ = uimenu(this.mainWindow,'Label','File');
            this.clear_ = uimenu(this.file_,'Label','Clear data','Callback',@this.clearCallback);
            this.metadata = uimenu(this.file_,'Label','Export metadata','Callback',@this.metadataCallback);
            this.manageMenuItem = uimenu(this.file_,'Label','Add comment','Callback',@this.manageCallback );
            this.exit_ = uimenu(this.file_,'Label','Exit');
        end
        
        %%Function that updates the datatable
        function this = updateGUI(this)
           %this.dataTable = uitable(this.mainWindow,'data',this.dataManager.getObject().getMatrix(),'Position',this.tableSize,'units','normalized');
            set(this.dataTable,'Data',this.dataManager.getObject().getMatrix());
            drawnow(); 
        end
        
        
        function this = launchDialogue(this,id,obj)
            out_ = selectData(obj,id,this);
            this = out_.handler;
            this.getDataManager().finalize(id,obj);
        end
    end
end