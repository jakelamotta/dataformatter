function varargout = selectData(varargin)
% SELECTDATA MATLAB code for selectData.fig
%      SELECTDATA, by itself, creates a new SELECTDATA or raises the existing
%      singleton*.
%
%      H = SELECTDATA returns the handle to a new SELECTDATA or the handle to
%      the existing singleton*.
%
%      SELECTDATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SELECTDATA.M with the given input arguments.
%
%      SELECTDATA('Property','Value',...) creates a new SELECTDATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before selectData_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to selectData_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help selectData

% Last Modified by GUIDE v2.5 08-Oct-2014 11:09:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @selectData_OpeningFcn, ...
                   'gui_OutputFcn',  @selectData_OutputFcn, ...
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


% --- Executes just before selectData is made visible.
function selectData_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to selectData (see VARARGIN)

% Choose default command line output for selectData
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

set(handles.okBtn,'UserData',false);

% UIWAIT makes selectData wait for user response (see UIRESUME)
 uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = selectData_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if get(handles.okBtn,'UserData')
    if get(handles.checkbox1,'value')
        type = 'average';
    else
        type = 'random';
    end
else
    type = 'nofilter';
end

varargout{1} = type;
delete(hObject);

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


% --- Executes on button press in okBtn.
function okBtn_Callback(hObject, eventdata, handles)
% hObject    handle to okBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(hObject,'UserData',true);
    close;

% --- Executes on button press in cancelBtn.
function cancelBtn_Callback(hObject, eventdata, handles)
% hObject    handle to cancelBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    close;

% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
    