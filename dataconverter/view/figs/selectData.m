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

% Last Modified by GUIDE v2.5 13-Oct-2014 11:33:50

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
end

% --- Executes just before selectData is made visible.
function selectData_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to selectData (see VARARGIN)
obj = varargin{1};
handler = varargin{3};
data = obj.getMatrix();
spectro = obj.getSpectroData();
id = varargin{2};
% Choose default command line output for selectData
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

userdata = struct;
userdata.handler = handler;
userdata.data = data;
userdata.spectro =spectro;
userdata.dp = handler.dataManager.getNrOfSpectroDP();
set(hObject,'UserData',userdata);
set(handles.okBtn,'UserData',false);

%data = myTable(handles.figure1,data);

%if strcmp(id,'Spectro')
setGraph(handles,spectro);

setTable(handles,data);



%set(handles.figure1,'UserData',data);
% UIWAIT makes selectData wait for user response (see UIRESUME)
 uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = selectData_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
out_ = struct;

if get(handles.okBtn,'UserData')
    if get(handles.checkbox1,'value')
        type = 'average';
    else
        type = 'random';
    end
    
    userdata = get(handles.figure1,'UserData');
    data = userdata.data;
    handler = userdata.handler;

    handler.dataManager = handler.dataManager.setNrOfSpectroDP(userdata.dp); 

    out_.data = data;
    out_.handler = handler;
    
else
    type = 'nofilter';
end

handler = get(hObject,'UserData');




out_.type = type;

varargout{1} = out_;

delete(handles.figure1);
end

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
end


% --- Executes on button press in okBtn.
function okBtn_Callback(hObject, eventdata, handles)
% hObject    handle to okBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    userdata = get(handles.figure1,'UserData');
    data = userdata.data;
    %s = size(data);
    
    if get(handles.checkbox1,'value') || validateData(data)     
        set(hObject,'UserData',true);
        close;
    else
       errordlg('Exactly one observation/row or "Use average" must be seleced'); 
    end
end

% --- Executes on button press in cancelBtn.
function cancelBtn_Callback(hObject, eventdata, handles)
% hObject    handle to cancelBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    close;
end

% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
end

function cellSelect(src,evt)
    % get indices of selected rows and make them available for other callbacks
    index = evt.Indices;
    
    if any(index)             %loop necessary to surpress unimportant errors.
        rows = index(:,1);
        set(src,'UserData',rows);
    end
end

function setTable(handles,data)
    %h = figure('Position',[600 400 402 100],'numbertitle','off','MenuBar','none');
    h = handles.figure1;
    defaultData = data;
    t = uitable(h,'Units','normalized','Position',[.15 .55, .8 .25],'Data', defaultData,'Tag','myTable',...
        'ColumnName', [],'RowName',[],...
        'CellSelectionCallback',@cellSelect);
    disp(get(t,'Position'));
    % create pushbutton to delete selected rows
    uicontrol(h,'Style','pushbutton','Position',[20,400,60,20],'String','Delete','Callback',{@deleteRow,handles});
    
    %uiwait(h);
    %data = get(t,'Data');
end

function setGraph(h,data)

handle = h.figure1;

% s = size(data);
% 
% for i=1:s(2)
%    if strcmp(data{1,i},'380')
%       idx = i;
%       break;
%    end
% end
% x = zeros(1,(s(2)-idx));
% y = zeros(1,(s(2)-idx));

% for i=idx:s(2)
%     x(i-idx+1) = str2double(data{1,i});
%     y(i-idx+1) = data{2,i};
% end

t = axes('Position',[.15 .25, .8 .25]);
plot(t,[data.obs1.x],[data.obs1.y],'blue');
hold on;
plot(t,[data.obs2.x],[data.obs2.y],'green');
%t = axes(handle,'Data',data);

toSend = data;

userdata = get(handle,'UserData');
handler = userdata.handler;
dp = handler.dataManager.getNrOfSpectroDP();

edit_ = uicontrol(handle,'Style','edit','Tag','sampleedit','String',dp,'Position',[20 240 40 20]);
uicontrol(handle,'Style','text','String','Nr of datapoints used','Position',[65 240 110 20]);

if dp > 1
    set(edit_,'Enable','off')
end

button = uicontrol(handle,'Style','pushbutton','Position',[20 190 100 20],'String','Downsample??','Callback',{@downSample,toSend,t,handle});
disp(get(button,'Position'));
end

function downSample(varargin)
    inData = varargin{3};
    
    hfig = varargin{5};
    x1 = [inData.obs1.x];
    y1 = [inData.obs1.y];
    x2 = [inData.obs2.x];
    y2 = [inData.obs2.y];
    
    t = varargin{4};
    h = findobj('Tag','sampleedit');
    rate = get(h,'String');
    
    dbrate = str2double(rate);
    x1new = linspace(380,600,dbrate);
    x2new = linspace(380,600,dbrate);
    
    y1 = interp1(x1,y1,x1new);
    y2 = interp1(x2,y2,x2new);
    
    hold off
    plot(t,x1,[inData.obs1.y],'b');
    
    hold on
    plot(t,x2,[inData.obs2.y],'g');
    plot(t,x1new,y1,'r');
    plot(t,x2new,y2,'y');
    
    userdata = get(hfig,'UserData');
    userdata.dp = dbrate;
    
    set(hfig,'UserData',userdata);
end

function deleteRow(varargin)
    handle = varargin{3};
    th = findobj('Tag','myTable');
    
    %get current data
    data = get(th,'Data');
    
    %get indices of selected rows
    rows = get(th,'UserData');
    
    %create mask containing rows to keep
    mask = (1:size(data,1))';
    mask(rows) = [];
    
    %delete selected rows and re-write data
    data = data(mask,:);
    set(th,'Data',data);
    userdata = get(handle.figure1,'UserData');
    userdata.data = data;
    set(handle.figure1,'UserData',userdata);
end

function out_ = validateData(data)
    out_ = true;
    s = size(data);
    
    temp = data{2,2};
    
    for i=3:s(1)
        if strcmp(temp,data{i,2})
            out_ = false;
            break;
        end
        temp = data{i,2};
    end
end