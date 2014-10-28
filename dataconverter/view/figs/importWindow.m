function varargout = importWindow(varargin)
% IMPORTWINDOW MATLAB code for importWindow.fig
%      IMPORTWINDOW, by itself, creates a new IMPORTWINDOW or raises the existing
%      singleton*.
%
%      H = IMPORTWINDOW returns the handle to a new IMPORTWINDOW or the handle to
%      the existing singleton*.
%
%      IMPORTWINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMPORTWINDOW.M with the given input arguments.
%
%      IMPORTWINDOW('Property','Value',...) creates a new IMPORTWINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before importWindow_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to importWindow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help importWindow

% Last Modified by GUIDE v2.5 07-Oct-2014 14:35:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @importWindow_OpeningFcn, ...
                   'gui_OutputFcn',  @importWindow_OutputFcn, ...
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


% --- Executes just before importWindow is made visible.
function importWindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to importWindow (see VARARGIN)

% Choose default command line output for importWindow
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

set(handles.okBtn,'UserData',NaN);
% UIWAIT makes importWindow wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = importWindow_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%varargout{1} = handles.output;

    varargout{1} = get(handles.okBtn,'UserData');    
    delete(handles.figure1);


% --- Executes on button press in okBtn.
function okBtn_Callback(hObject, eventdata, handles)
% hObject    handle to okBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    data = cell(1,2);
    
    if get(handles.radiobutton1,'value')
        type = 'Abiotic';
    elseif get(handles.radiobutton2,'value')
        type = 'Weather';
    elseif get(handles.radiobutton3,'value')
        type = 'Weather';
    elseif get(handles.radiobutton4,'value')
        type = 'Spectro';
    elseif get(handles.radiobutton5,'value')
        type = 'Behavior';
    elseif get(handles.radiobutton6,'value')
        type = 'Weather';
    else
        type = NaN;
    end
    
    path_ = uigetdir('C:\Users\Kristian\Documents\GitHub\dataformatter\dataconverter\data');
    
    data{1,1} = type;
    data{1,2} = path_;    
    
    set(hObject,'UserData',data);
    close;
    

% --- Executes on button press in cancelBtn.
function cancelBtn_Callback(hObject, eventdata, handles)
% hObject    handle to cancelBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    close();

% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1
    if get(hObject,'value')
        updateRadio(handles,hObject);
    end
    
% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2
    if get(hObject,'value')
        updateRadio(handles,hObject);
    end

% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3
    if get(hObject,'value')
        updateRadio(handles,hObject);
    end

% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4
    if get(hObject,'value')
        updateRadio(handles,hObject);
    end

% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5
    if get(hObject,'value')
        updateRadio(handles,hObject);
    end
    
% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6
    if get(hObject,'value')
        updateRadio(handles,hObject);
    end
    
function updateRadio(handles,hObject)
    set(handles.radiobutton1,'value',false);
    set(handles.radiobutton2,'value',false);
    set(handles.radiobutton3,'value',false);
    set(handles.radiobutton4,'value',false);
    set(handles.radiobutton5,'value',false);
    set(handles.radiobutton6,'value',false);
    set(hObject,'value',true);
    
    
    % --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
    if isequal(get(hObject, 'waitstatus'), 'waiting')
        % The GUI is still in UIWAIT, us UIRESUME
        uiresume(hObject);
        guidata(hObject,handles);
    else
        % The GUI is no longer waiting, just close it
        delete(hObject);
    end
