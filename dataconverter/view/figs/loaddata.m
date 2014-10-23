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

% Last Modified by GUIDE v2.5 24-Sep-2014 14:34:50

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

%Set output to the Organizer object passed to the function
initGuiElements(handles,varargin);

% UIWAIT makes loaddata wait for user response (see UIRESUME)
uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = loaddata_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

if get(handles.okBtn,'UserData') 
    
    varargout{1}.sources = get(handles.output,'UserData');
    date_ = get(handles.editDate,'String');
    flower = get(handles.editFlower,'String');
    %id_ = get(handles.editID,'String');
    pos = get(handles.posRdbtn,'value');
    negOrPos = 'negative';

    if pos
        negOrPos = 'positive';
    end
    
    target = [date_,'\',flower,'\',negOrPos,'\'];

    %varargout{1}.sources = get(handles.output,'UserData');
    varargout{1}.target = target;
else
    varargout = cell(1,1);
end
delete(handles.figure1);   

% --- Executes on button press in okBtn.
function okBtn_Callback(hObject, eventdata, handles)
% hObject    handle to okBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    varargout{1}.sources = get(handles.output,'UserData');
    date_ = get(handles.editDate,'String');
    flower = get(handles.editFlower,'String');
    
    stringsExist = ~isempty(date_) & ~isempty(flower);

    if stringsExist%~iscell(varargout{1}.sources) && stringsExist
        set(hObject,'UserData',true);
        close;
    else
        errordlg('All fields are not entered correctly or no file is selected for loading','Error!');
    end
    
% --- Executes on button press in cancelBtn.
function cancelBtn_Callback(hObject, eventdata, handles)
% hObject    handle to cancelBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    close;
    
function editFlower_Callback(hObject, eventdata, handles)
% hObject    handle to editFlower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editFlower as text
%        str2double(get(hObject,'String')) returns contents of editFlower as a double


% --- Executes during object creation, after setting all properties.
function editFlower_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editFlower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in posRdbtn.
function posRdbtn_Callback(hObject, eventdata, handles)
% hObject    handle to posRdbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of posRdbtn
    set(handles.negRdbtn,'value',~get(hObject,'value'));

% --- Executes on button press in negRdbtn.
function negRdbtn_Callback(hObject, eventdata, handles)
% hObject    handle to negRdbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of negRdbtn
    set(handles.posRdbtn,'value',~get(hObject,'value'));


function editID_Callback(hObject, eventdata, handles)
% hObject    handle to editID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editID as text
%        str2double(get(hObject,'String')) returns contents of editID as a double


% --- Executes during object creation, after setting all properties.
function editID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editDate_Callback(hObject, eventdata, handles)
% hObject    handle to editDate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDate as text
%        str2double(get(hObject,'String')) returns contents of editDate as a double


% --- Executes during object creation, after setting all properties.
function editDate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% % --- Executes on button press in abioticBtn.
% function abioticBtn_Callback(hObject, eventdata, handles)
% % hObject    handle to abioticBtn (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
%     updateSource(handles,'Abiotic');
%     
% % --- Executes on button press in weatherBtn.
% function weatherBtn_Callback(hObject, eventdata, handles)
% % hObject    handle to weatherBtn (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
%     updateSource(handles,'Weather');
%     
% % --- Executes on button press in imageBtn.
% function imageBtn_Callback(hObject, eventdata, handles)
% % hObject    handle to imageBtn (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
%     updateSource(handles,'Image');
% 
% % --- Executes on button press in spectroBtn.
% function spectroBtn_Callback(hObject, eventdata, handles)
% % hObject    handle to spectroBtn (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
%     updateSource(handles,'Spectro');
    
    
% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    updateSource(handles,'Behaviour');

function initGuiElements(handles,varargin)
    time_ = round(clock());
    y = time_(1);
    mon = time_(2);
    d = time_(3);
    date_ = [num2str(y),num2str(mon),num2str(d)];
    
    set(handles.editDate,'String',date_);
    set(handles.posRdbtn,'value',1);   
    if ~isempty(varargin)
        set(handles.output,'UserData',varargin{1});
    end
    
% --- Executes during object deletion, before destroying properties.
        function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end
