function varargout = loaddata(varargin)
% LOADDATA MATLAB code for loaddata.fig
%      LOADDATA, by itself, creates a new LOADDATA or raises the existing
%      singleton*.
%
%      H = LOADDATA returns the handle to a new LOADDATA or the handle to
%      the existing singleton*.
%
%      LOADDATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LOADDATA.M with the given input arguments.
%
%      LOADDATA('Property','Value',...) creates a new LOADDATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before loaddata_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to loaddata_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help loaddata

% Last Modified by GUIDE v2.5 23-Sep-2014 16:36:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @loaddata_OpeningFcn, ...
                   'gui_OutputFcn',  @loaddata_OutputFcn, ...
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


% --- Executes just before loaddata is made visible.
function loaddata_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to loaddata (see VARARGIN)

% Choose default command line output for loaddata
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes loaddata wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = loaddata_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in okBtn.
function okBtn_Callback(hObject, eventdata, handles)
% hObject    handle to okBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in cancelBtn.
function cancelBtn_Callback(hObject, eventdata, handles)
% hObject    handle to cancelBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
