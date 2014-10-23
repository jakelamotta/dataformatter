function varargout = Calibration(varargin)
% CALIBRATION MATLAB code for Calibration.fig
%      CALIBRATION, by itself, creates a new CALIBRATION or raises the existing
%      singleton*.
%
%      H = CALIBRATION returns the handle to a new CALIBRATION or the handle to
%      the existing singleton*.
%
%      CALIBRATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALIBRATION.M with the given input arguments.
%
%      CALIBRATION('Property','Value',...) creates a new CALIBRATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Calibration_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Calibration_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Calibration

% Last Modified by GUIDE v2.5 11-Apr-2014 13:48:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Calibration_OpeningFcn, ...
                   'gui_OutputFcn',  @Calibration_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Calibration is made visible.
function Calibration_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Calibration (see VARARGIN)

% Choose default command line output for Calibration
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Calibration wait for user response (see UIRESUME)
% uiwait(handles.figure1);
    calib = getappdata(0,'calib');
    if isempty(calib)
        calib = Calibrate(handles);
    end
    
    calib.avgErr = 0;
    calib.numTrials = 0;
    setappdata(0,'calib',calib);
    
    mode_ = '';

    if ~isempty(varargin)
        mode_ = varargin{1};
        set(handles.figure1,'Name','Calibrate yaw rotation');
        set(handles.prev_btn,'Visible','off');
        restartbtn_Callback(hObject, eventdata, handles)
    end
    
    setappdata(0,'mode',mode_);

% --- Outputs from this function are returned to the command line.
function varargout = Calibration_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yawedit_Callback(hObject, eventdata, handles)
% hObject    handle to yawedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yawedit as text
%        str2double(get(hObject,'String')) returns contents of yawedit as a double


% --- Executes during object creation, after setting all properties.
function yawedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yawedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in run_btn.
function run_btn_Callback(hObject, eventdata, handles)
% hObject    handle to run_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    set(handles.run_btn,'String','Running');
        
    calib = getappdata(0,'calib');
    config = getappdata(0,'config');
    
    if exist(getpath('pipe','data'),'file')
        delete(getpath('pipe','data'));
    end
            
    arg = ['mkfifo ',getpath('pipe','data')];
    system(arg); %Create named pipe if not existing
            
    arg = ['echo ',config.pwd,' | sudo -S python ',getpath('DAQ.py','py'),' "notrigger" &'];
    system(arg);
                
    data = readData(handles,'','calibration');
    
    aDist = get(handles.yawedit,'String');
    mDist = sum(data{3,1})*180/pi;
    calib = calib.calibrateYaw(mDist,str2num(aDist));
    
    setappdata(0,'calib',calib);
    
    string_ = [num2str(calib.avgErr*100),'%'];
    set(handles.text8,'String',string_);
    set(handles.text7,'String',calib.numTrials);
    
    if calib.numTrials > 2
        set(handles.next_btn,'Enable','on');
    end
    
    drawnow;
    calib
    
% --- Executes on button press in cancel_btn.
function cancel_btn_Callback(hObject, eventdata, handles)
% hObject    handle to cancel_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    mode = getappdata(0,'mode');
    
    q = questdlg('Are you sure you want to exit the configuration process? All changes will be lost');
    if strcmp(q,'Yes')
        
        if strcmp(mode,'notsetup')
            close 'Calibrate yaw rotation';
        else
            MainApp;
            close 'Setup (6/6)';
        end
    end

% --- Executes on button press in next_btn.
function next_btn_Callback(hObject, eventdata, handles)
% hObject    handle to next_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    config = getappdata(0,'config');
    calib = getappdata(0,'calib');
    mode_ = getappdata(0,'mode');
    
    config.setAlpha(mean(calib.alphas));
    
    save(getpath('config.mat','data'),'config');
    
    if strcmp(mode_,'notsetup')
        close 'Calibrate yaw rotation';
    else
        MainWindow;
        close 'Setup (6/6)';
    end
% --- Executes on button press in prev_btn.
function prev_btn_Callback(hObject, eventdata, handles)
% hObject    handle to prev_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    TranslationCal;
    close 'Setup (6/6)';

% --- Executes on button press in stop_btn.
function stop_btn_Callback(hObject, eventdata, handles)
% hObject    handle to stop_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    stopAction(handles);    
    
function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in clearbtn.
function clearbtn_Callback(hObject, eventdata, handles)
% hObject    handle to clearbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    calib = getappdata(0,'calib');
    
    calib = calib.removeLatest();
    set(handles.text8,'String','0%');
    set(handles.text7,'String',calib.numTrials);
    set(handles.next_btn,'Enable','off');
    
    drawnow;
    
    setappdata(0,'calib',calib);    

% --- Executes on button press in restartbtn.
function restartbtn_Callback(hObject, eventdata, handles)
% hObject    handle to restartbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    calib = getappdata(0,'calib');

    calib.alphas = [];
    calib.dists = []
    calib.avgErr = 0;
    calib.numTrials = 0;
    
    setappdata(0,'calib',calib);
    set(handles.text8,'String','0%');
    set(handles.text7,'String',calib.numTrials);
    drawnow;


% --- Executes on key press with focus on run_btn and none of its controls.
function run_btn_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to run_btn (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
    if strcmp(eventdata.Key,'return')
        run_btn_Callback(hObject, eventdata, handles);
    end
    
% --- Executes on key press with focus on stop_btn and none of its controls.
function stop_btn_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to stop_btn (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
    if strcmp(eventdata.Key,'return')
        stopAction(handles);
    end
    
% --- Executes on button press in helpbtn.
function helpbtn_Callback(hObject, eventdata, handles)
% hObject    handle to helpbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    helptext = 'Yaw calibration is done by rotating the ball a predfined number of degrees. Rotations should always be counter-clockwise if not the absolute values will still be correct but the positive direction will be flipped to counter-clockwise. A minimum of three runs are required but as with translation more are recommended.';
    helpWin(helptext);
    
