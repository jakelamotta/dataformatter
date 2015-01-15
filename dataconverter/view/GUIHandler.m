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
        sortDateBtn;
        sortIdBtn;
        metadata;
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
    end
    
    methods (Access = private)
        
        %%Callback function called when the user presses the import data
        %%button
        function this = loadCallback(this,varargin)
            this.organizer = this.organizer.launchGUI();
            %             if iscell(this.organizer.target)
            %                 size_ = size(this.organizer.target);
            %                 for i=1:size_(2)
            %                     success = this.inputManager.organize(this.organizer.sources,this.organizer.target{1,i});
            %                 end
            %             end
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
            
            profile on;
            if iscell(importInfo) && ~isnumeric(importInfo{1,2})
                %type = importInfo{1,1};
                types =importInfo{1,1};
                p = importInfo{1,2};
                    
                for index=1:length(types)
                    type = types{index};
                    
                    
                    if strcmp(type,'load')
                        [fname,pname,nonImportant] = uigetfile('*.*');
                        
                        this.dataManager.importOldData([pname,fname]);
                    else
                        this.inputManager = this.inputManager.splitPaths(p,type);
                        paths_ = this.inputManager.getPaths();
                        
                        if isempty(paths_)
                            errordlg(['There are no ', type,' data files in the specified folder, please try again.'],'No such file')
                        end
                        
                        try
                            this.dataManager = this.dataManager.addObject(type,paths_);
                        catch ex
                            errordlg(['Something went wrong when trying to parse the ',type,' data file. Error message: ',ex.message],'Parse error');
                        end
                        
                        %s = size(this.dataManager.getUnfObject().getMatrix());
                        if this.dataManager.getUnfObject.hasMultiples() || strcmp(type,'Spectro') || strcmp(type,'Olfactory')
                            this = this.launchDialogue(type);
                        else
                            this.dataManager.finalize(type);
                        end
                    end
                    
                    this = this.updateGUI();
                end
            end
        end
        
        %%Callback functin called when the user presses the "Clear data"
        %%option in the file menu
        function this = clearCallback(this,varargin)
            this.dataManager = this.dataManager.clearAll();
            this = this.updateGUI();
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
        
        function this = tableCallback(this,varargin)
            jtable = this.dataTable.getTable();
            
            jtable.setRowSelectionInterval(jtable.getSelectedRow(),jtable.getSelectedRow());
            jtable.setColumnSelectionInterval(0,jtable.getColumnCount());
        end
        
        function this = metadataCallback(this,varargin)
            this.inputManager.writeMetaDatatoFile();
        end
        
        %%Function that sets upp all the gui elements. Each position is
        %%relative to the screensize to make the application more flexible.
        function this = initGUI(this)
            sz = this.scrsz;
            
            %             this.mainWindow = figure('Name','Title','DockControls','off','NumberTitle','off','Position',[sz(3)/8 sz(4)/8 sz(3)/1.5 sz(4)/1.5],'MenuBar','None','ToolBar','None');
            % %           this.panel = uibuttongroup(this.mainWindow,'Position',[(sz(3)/8)-50 (sz(4)/8)-50 (sz(3)/1.9)-50 (sz(4)/2.3)-50]);
            %             this.loadBtn = uicontrol(this.mainWindow,'Style','pushbutton','String','Import Data','Position',[sz(3)/19.2 sz(4)/1.84 sz(3)/16 sz(4)/21.6],'Callback',@this.loadCallback);
            %             this.importBtn = uicontrol(this.mainWindow,'Style','pushbutton','String','Load data', 'Position',[sz(3)/7.68 sz(4)/1.84 sz(3)/16 sz(4)/21.6],'Callback',@this.importCallback);
            %             this.manageBtn = uicontrol(this.mainWindow,'Style','pushbutton','String','Manage data','Position',[sz(3)/4.8 sz(4)/1.84 sz(3)/16 sz(4)/21.6],'Callback',@this.manageCallback);
            %             %this.exportBtn = uicontrol(this.mainWindow,'Style','pushbutton','String','Export','Position',[sz(3)/2.95 sz(4)/1.8848 sz(3)/12.8 sz(4)/14.4],'Callback',@this.exportCallback);
            %             this.exportBtn =  uicontrol('parent', this.mainWindow, 'style', 'pushbutton', 'units', 'normalized', 'position', [0.5 0.8 0.1 0.1], 'string', 'Export', 'fontunits', 'normalized', 'fontsize', 0.1 );
            %
            %             this.sortDateBtn = uicontrol('parent',this.mainWindow,'Style','pushbutton','String','Sort by date','Position',[sz(3)/1.6226 sz(4)/2.3273 sz(3)/29.0 sz(4)/35.2],'Callback',@this.mergeCallback);
            %             this.sortIdBtn = uicontrol(this.mainWindow,'Style','pushbutton','String','Sort by id','Position',[sz(3)/1.6226 sz(4)/2.6273 sz(3)/29.0 sz(4)/35.2],'Callback',@this.sortIdCallback);
            %             uicontrol ('parent', this.mainWindow, 'style', 'pushbutton', 'units', 'normalized', 'position', [0.1 0.1 0.1 0.1], 'string', 'test', 'fontunits', 'normalized', 'fontsize', 0.2 );
            %
            
            this.mainWindow = figure('Name','Title','DockControls','off','NumberTitle','off','Position',[sz(3)/8 sz(4)/8 sz(3)/1.5 sz(4)/1.5],'MenuBar','None','ToolBar','None');
            %           this.panel = uibuttongroup(this.mainWindow,'Position',[(sz(3)/8)-50 (sz(4)/8)-50 (sz(3)/1.9)-50 (sz(4)/2.3)-50]);
            this.importBtn = uicontrol('parent', this.mainWindow, 'style', 'pushbutton', 'units', 'normalized', 'position', [0.14 0.8 0.1 0.1], 'string', 'Import data', 'fontunits', 'normalized', 'fontsize', 0.2, 'Callback',@this.loadCallback);
            this.importBtn = uicontrol('parent', this.mainWindow, 'style', 'pushbutton', 'units', 'normalized', 'position', [0.26 0.8 0.1 0.1], 'string', 'Load data', 'fontunits', 'normalized', 'fontsize', 0.2, 'Callback',@this.importCallback);
            this.manageBtn = uicontrol('parent', this.mainWindow, 'style', 'pushbutton', 'units', 'normalized', 'position', [0.38 0.8 0.1 0.1], 'string', 'Manage data', 'fontunits', 'normalized', 'fontsize', 0.2,'Callback',@this.manageCallback );
            this.exportBtn =  uicontrol('parent', this.mainWindow, 'style', 'pushbutton', 'units', 'normalized', 'position', [0.5 0.8 0.1 0.1], 'string', 'Export', 'fontunits', 'normalized', 'fontsize', 0.2,'Callback',@this.exportCallback);
            
            this.sortDateBtn = uicontrol('parent', this.mainWindow, 'style', 'pushbutton', 'units', 'normalized', 'position', [0.93 0.64 0.06 0.05], 'string', 'Sort by date', 'fontunits', 'normalized', 'fontsize', 0.3,'Callback',@this.mergeCallback);
            this.sortIdBtn = uicontrol('parent', this.mainWindow, 'style', 'pushbutton', 'units', 'normalized', 'position', [0.93 0.58 0.06 0.05], 'string', 'Sort by id', 'fontunits', 'normalized', 'fontsize', 0.3,'Callback',@this.sortIdCallback);
            
            this.dataTable = uitable(this.mainWindow,'Position',this.tableSize,'units','normalized','CellSelectionCallback',@this.tableCallback);
            
            this.file_ = uimenu(this.mainWindow,'Label','File');
            this.clear_ = uimenu(this.file_,'Label','Clear data','Callback',@this.clearCallback);
            this.metadata = uimenu(this.file_,'Label','Export metadata','Callback',@this.metadataCallback);
            this.exit_ = uimenu(this.file_,'Label','Exit');
        end
        
        %%Function that updates the datatable
        function this = updateGUI(this)
            this.dataTable = uitable(this.mainWindow,'data',this.dataManager.getObject().getMatrix(),'Position',this.tableSize);
        end
        
        
        function this = launchDialogue(this,id,varargin)
            profile viewer;
            out_ = selectData(this.dataManager.getUnfObject(),id,this);
            
            this = out_.handler;
            this.getDataManager().getUnfObject().setMatrix(out_.data);
            %this.getDataManager().applyFilter();
            this.getDataManager().finalize(id);
        end
    end
end