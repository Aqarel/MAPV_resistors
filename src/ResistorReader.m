function varargout = ResistorReader(varargin)
% RESISTORREADER M-file for ResistorReader.fig
%      RESISTORREADER, by itself, creates a new RESISTORREADER or raises the existing
%      singleton*.
%
%      H = RESISTORREADER returns the handle to a new RESISTORREADER or the handle to
%      the existing singleton*.
%
%      RESISTORREADER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RESISTORREADER.M with the given input arguments.
%
%      RESISTORREADER('Property','Value',...) creates a new RESISTORREADER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ResistorReader_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ResistorReader_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ResistorReader

% Last Modified by GUIDE v2.5 07-May-2013 15:58:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ResistorReader_OpeningFcn, ...
                   'gui_OutputFcn',  @ResistorReader_OutputFcn, ...
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


% --- Executes just before ResistorReader is made visible.
function ResistorReader_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ResistorReader (see VARARGIN)

% Choose default command line output for ResistorReader
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ResistorReader wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ResistorReader_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btnOpenFile.
function btnOpenFile_Callback(hObject, eventdata, handles)
% hObject    handle to btnOpenFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,FilePath] = uigetfile('*.png;*.tiff;*.gif;*.bmp;*.jpg','Select the image');

if ~isequal(FileName,0)                                     % If correct select file
   set(handles.edtOpenFile, 'String', FileName);
   set(handles.btnReadValues, 'Enable', 'on');
   
   handles.loadImage = imread(fullfile(FilePath, FileName));
   axes(handles.imLoad);
   imshow(handles.loadImage);
   axis off;
end

guidata(hObject, handles);



function edtExposure_Callback(hObject, eventdata, handles)
% hObject    handle to edtExposure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtExposure as text
%        str2double(get(hObject,'String')) returns contents of edtExposure as a double


% --- Executes during object creation, after setting all properties.
function edtExposure_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtExposure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edtGain_Callback(hObject, eventdata, handles)
% hObject    handle to edtGain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtGain as text
%        str2double(get(hObject,'String')) returns contents of edtGain as a double


% --- Executes during object creation, after setting all properties.
function edtGain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtGain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnCamera.
function btnCamera_Callback(hObject, eventdata, handles)
% hObject    handle to btnCamera (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.CamOpen == 0
    set(handles.btnCamera,'String','Close camera');
    handles.CamOpen = 1;
    
    imaqreset;
    pause(2);
    kam = GetCamera();              %videoinput('winvideo',1);
    triggerconfig(kam,'manual');
    param = getselectedsource(kam);
    param.ExposureMode = 'manual';
    param.Exposure = str2num(get(handles.edtExposure,'String')); %-6
    param.GainMode = 'manual';
    param.Gain = str2num(get(handles.edtGain,'String')); %320
    handles.kam = kam;

    preview(kam);
    pause;
    closepreview(kam);
    
    set(handles.btnGetSnapshot, 'Enable', 'on'); 
else
    set(handles.btnCamera,'String','Open camera');
    handles.CamOpen = 0;
    delete(handles.kam);
    set(handles.btnGetSnapshot, 'Enable', 'off'); 
end
    
guidata(hObject, handles);


% --- Executes on button press in btnGetSnapshot.
function btnGetSnapshot_Callback(hObject, eventdata, handles)
% hObject    handle to btnGetSnapshot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

start(handles.kam);
pause(0.5);
handles.loadImage = getsnapshot(handles.kam);
stop(handles.kam);

set(handles.edtOpenFile, 'String', FileName);
set(handles.btnReadValues, 'Enable', 'on'); 
axes(handles.imLoad);
imshow(handles.loadImage);
axis off;

guidata(hObject, handles);

function edtOpenFile_Callback(hObject, eventdata, handles)
% hObject    handle to edtOpenFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtOpenFile as text
%        str2double(get(hObject,'String')) returns contents of edtOpenFile as a double


% --- Executes during object creation, after setting all properties.
function edtOpenFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtOpenFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

handles.CamOpen = 0;
guidata(hObject, handles);


% --- Executes on button press in btnReadValues.
function btnReadValues_Callback(hObject, eventdata, handles)
% hObject    handle to btnReadValues (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.btnSaveImage, 'Enable', 'on');
set(handles.btnSaveValues, 'Enable', 'on');
[handles.resImage handles.resValues] = MainFunction(handles.loadImage);
axes(handles.imResistors);
imshow(handles.resImage);
axis off;
set(handles.lbResistorsValues,'string',handles.resValues);

guidata(hObject, handles);


% --- Executes on selection change in lbResistorsValues.
function lbResistorsValues_Callback(hObject, eventdata, handles)
% hObject    handle to lbResistorsValues (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lbResistorsValues contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lbResistorsValues


% --- Executes during object creation, after setting all properties.
function lbResistorsValues_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lbResistorsValues (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnSaveImage.
function btnSaveImage_Callback(hObject, eventdata, handles)
% hObject    handle to btnSaveImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName PathName FilterIndex] = uiputfile('*.png','Save image');

if ~isequal(FileName,0)  
    imwrite(handles.resImage, fullfile(PathName, FileName));
end


% --- Executes on button press in btnClose.
function btnClose_Callback(hObject, eventdata, handles)
% hObject    handle to btnClose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%clear all;
close all;


% --- Executes on button press in btnSaveValues.
function btnSaveValues_Callback(hObject, eventdata, handles)
% hObject    handle to btnSaveValues (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[FileName PathName FilterIndex] = uiputfile('*.txt','Save resistors values');

if ~isequal(FileName,0)  
     file = fopen(fullfile(PathName, FileName),'w');
     for i=1:length(handles.resValues)
        fprintf(file,'%s; ',handles.resValues{i});
     end
     fclose(file);
end
 
 


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.CamOpen == 1
    delete(handles.kam);
end
