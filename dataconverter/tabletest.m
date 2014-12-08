function varargout = tabletest(varargin)
% TABLETEST MATLAB code for tabletest.fig
%      TABLETEST, by itself, creates a new TABLETEST or raises the existing
%      singleton*.
%
%      H = TABLETEST returns the handle to a new TABLETEST or the handle to
%      the existing singleton*.
%
%      TABLETEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TABLETEST.M with the given input arguments.
%
%      TABLETEST('Property','Value',...) creates a new TABLETEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tabletest_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tabletest_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tabletest

% Last Modified by GUIDE v2.5 04-Dec-2014 15:03:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tabletest_OpeningFcn, ...
                   'gui_OutputFcn',  @tabletest_OutputFcn, ...
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


% --- Executes just before tabletest is made visible.
function tabletest_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tabletest (see VARARGIN)

% Choose default command line output for tabletest
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

a = {'a','b','c';1,2,3};
set(handles.uitable1,'data',a);


% UIWAIT makes tabletest wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = tabletest_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when selected cell(s) is changed in uitable1.
function uitable1_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
    disp(get(hObject,'data'));