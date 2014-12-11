function varargout = imageCrop(varargin)
% IMAGECROP MATLAB code for imageCrop.fig
%      IMAGECROP, by itself, creates a new IMAGECROP or raises the existing
%      singleton*.
%
%      H = IMAGECROP returns the handle to a new IMAGECROP or the handle to
%      the existing singleton*.
%
%      IMAGECROP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGECROP.M with the given input arguments.
%
%      IMAGECROP('Property','Value',...) creates a new IMAGECROP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before imageCrop_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to imageCrop_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help imageCrop

% Last Modified by GUIDE v2.5 26-Nov-2014 12:08:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @imageCrop_OpeningFcn, ...
    'gui_OutputFcn',  @imageCrop_OutputFcn, ...
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

% --- Executes just before imageCrop is made visible.
function imageCrop_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to imageCrop (see VARARGIN)

% Choose default command line output for imageCrop
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

imageList = varargin{1}(:,2:end);
p = varargin{2};
set(handles.text1,'String',p);
s = size(imageList);

%keeps = cell(1,s(2));
% 
% for i=1:s(2)
%     imageList{i} = false;
% end

set(handles.figure1,'UserData',imageList);
set(handles.popupmenu1,'UserData',imageList);
set(handles.popupmenu1,'String',imageList(2,:));
set(handles.okBtn,'UserData',false);
set(handles.axes1,'UserData',imageList{1,1});

%set(handles.keepbox,'UserData',keeps);

setImages(handles,imageList{1,1});

% UIWAIT makes imageCrop wait for user response (see UIRESUME)
uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = imageCrop_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = '';

if get(handles.okBtn,'UserData')
    
    varargout{1} = get(handles.popupmenu1,'UserData');
end

delete(hObject);

end
% --- Executes on button press in okBtn.
function okBtn_Callback(hObject, eventdata, handles)
% hObject    handle to okBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(hObject,'UserData',true);
    close();
end
% --- Executes on button press in cancelBtn.
function cancelBtn_Callback(hObject, eventdata, handles)
% hObject    handle to cancelBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    close();
end

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)    
    showCroppedImage(handles);
    list = get(handles.popupmenu1,'UserData');
    index = get(handles.popupmenu1,'Value');
    set(handles.keepbox,'Value',true);
    list{3,index} = true;
    set(handles.popupmenu1, 'UserData',list);
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
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end
end

function showCroppedImage(handle)
    axesCroppedHandle = handle.axes2;
    
    image_ = get(handle.axes1,'UserData');
    imshow(image_,'Parent',axesCroppedHandle);
    hold on;
    axis image;
end

function setImages(handles,im)

S.h = handles;
S.fH = handles.figure1;
S.aH = handles.axes1;
%S.fH = figure('menubar','none');
%im = imread( 'C:\Users\Public\Pictures\Sample Pictures\Chrysanthemum.jpg' );
y_min = NaN;
y_max = NaN;
x_min = NaN;
x_max = NaN;
imageSize = size(im);

% S.aH = axes;
S.iH = imshow(im,'Parent',S.aH); 

axis image;

X = [];
Y = [];

set(S.aH,'ButtonDownFcn',@startDragFcn)
set(S.iH,'ButtonDownFcn',@startDragFcn)
set(S.fH, 'WindowButtonUpFcn', @stopDragFcn);

    function startDragFcn(varargin)
        set( S.fH, 'WindowButtonMotionFcn', @draggingFcn );
        pt = get(S.aH, 'CurrentPoint');
        x = pt(1,1);
        y = pt(1,2);
        X = x;
        Y = y;
    end

    function draggingFcn(varargin)
        S.iH = imshow( im ); hold on
        
        set(S.aH,'ButtonDownFcn',@startDragFcn)
        set(S.iH,'ButtonDownFcn',@startDragFcn)
        set(S.fH, 'WindowButtonUpFcn', @stopDragFcn);
        
        pt = get(S.aH, 'CurrentPoint');
        x = pt(1,1);
        y = pt(1,2);        
        
        if x <= imageSize(2) && y <= imageSize(1)
        
            X = [X x];
            Y = [Y y];

            size(im)
            if isnan(x_min)
                x_min = x;
                x_max = x;
                y_min = y;
                y_max = y;
            end

            avgX = (x_min+x_max)/2;
            avgY = (y_min+y_max)/2;


            y_min = min(Y);
            x_min = min(X);
            x_max = max(X);
            y_max = max(Y);

            if x < avgX && y < avgY
                x_min = max(x,x_min);
                y_min = max(y,y_min);
            elseif x > avgX && y < avgY
                x_max = min(x,x_max);
                y_min = max(y,y_min);
            elseif x < avgX && y > avgY
                x_min = max(x,x_min);
                y_max = min(y,y_max);
            elseif x > avgX && y > avgY
                x_max = min(x,x_max);
                y_max = min(y,y_max);
            end

            plot([x_min,x_max],[y_min,y_min]);
            plot([x_min,x_max],[y_max,y_max]);
            plot([x_min,x_min],[y_min,y_max]);
            plot([x_max,x_max],[y_min,y_max]);

            tempImage = im(floor(y_min):floor(y_max),floor(x_min):floor(x_max),:);
            tempSize = size(tempImage);
            
            if tempSize(1) ~= tempSize(2)
               avg = (tempSize(1)+tempSize(2))/2;
               
               if avg+floor(y_min) > tempSize(1)
                   avg = tempSize(1);
               end
               
               if avg+floor(x_min) > tempSize(2)
                   avg = tempSize(2);
               end
                   
               tempImage = im(floor(y_min):floor(y_min)+floor(avg),floor(x_min):floor(x_min)+floor(avg),:);
            end
            
            set(S.aH,'UserData',rgb2gray(tempImage));
            images = get(S.h.popupmenu1,'UserData');
            images{1,get(S.h.popupmenu1,'Value')} = rgb2gray(tempImage); 
            set(S.h.popupmenu1,'UserData',images);
        end
        
        hold off
    end

    function stopDragFcn(varargin)
        set(S.fH, 'WindowButtonMotionFcn', '');  %eliminate fcn on release
    end
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
    index = get(hObject,'Value');
    imageList = get(handles.figure1,'UserData');
    list = get(handles.popupmenu1,'UserData');
    
    imshow(imageList{1,index},'Parent',handles.axes1);
    setImages(handles,imageList{1,index})
    
    set(handles.axes1,'UserData',imageList{1,index});
    
    %keeps = get(handles.keepbox,'UserData');
    %set(handles.keepbox,'Value',keeps{index});
    set(handles.keepbox,'Value',list{3,index});    
end

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes on button press in keepbox.
function keepbox_Callback(hObject, eventdata, handles)
% hObject    handle to keepbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of keepbox
    list = get(handles.popupmenu1,'UserData');
    index = get(handles.popupmenu1,'Value');
    list{3,index} = get(hObject,'Value');
    set(handles.popupmenu1, 'UserData',list);
end