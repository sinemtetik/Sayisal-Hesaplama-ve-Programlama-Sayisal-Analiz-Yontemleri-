function varargout = odev2_enterpolasyon(varargin)
% ODEV2_ENTERPOLASYON MATLAB code for odev2_enterpolasyon.fig
%      ODEV2_ENTERPOLASYON, by itself, creates a new ODEV2_ENTERPOLASYON or raises the existing
%      singleton*.
%
%      H = ODEV2_ENTERPOLASYON returns the handle to a new ODEV2_ENTERPOLASYON or the handle to
%      the existing singleton*.
%
%      ODEV2_ENTERPOLASYON('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ODEV2_ENTERPOLASYON.M with the given input arguments.
%
%      ODEV2_ENTERPOLASYON('Property','Value',...) creates a new ODEV2_ENTERPOLASYON or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before odev2_enterpolasyon_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to odev2_enterpolasyon_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help odev2_enterpolasyon

% Last Modified by GUIDE v2.5 09-Dec-2024 13:45:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @odev2_enterpolasyon_OpeningFcn, ...
                   'gui_OutputFcn',  @odev2_enterpolasyon_OutputFcn, ...
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


% --- Executes just before odev2_enterpolasyon is made visible.
function odev2_enterpolasyon_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to odev2_enterpolasyon (see VARARGIN)

% Choose default command line output for odev2_enterpolasyon
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes odev2_enterpolasyon wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = odev2_enterpolasyon_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% x, y ve z koordinatlarını al
x = str2num(get(handles.edit1, 'String')); % Örneğin [0.5 0.6]
y = str2num(get(handles.edit2, 'String')); % Örneğin [0.2 0.3]
z = str2num(get(handles.edit3, 'String')); % Örneğin [0.49 0.64 0.64 0.81]
xt = str2num(get(handles.edit4, 'String')); % Örneğin 0.54
yt = str2num(get(handles.edit5, 'String')); % Örneğin 0.26

% Grid kontrolü: Verilen x, y ve z boyutlarını kontrol et
if length(x) ~= 2 || length(y) ~= 2 || length(z) ~= 4
    errordlg('Lütfen x, y ve z değerlerini doğru formatta girin (2x2 grid için).');
    return;
end

% Bilineer enterpolasyon hesaplaması
% Koordinatların köşe noktaları
x1 = x(1);
x2 = x(2);
y1 = y(1);
y2 = y(2);

% Köşe noktalarındaki z değerleri
Q11 = z(1); % (x1, y1)
Q21 = z(2); % (x2, y1)
Q12 = z(3); % (x1, y2)
Q22 = z(4); % (x2, y2)

% Bilineer enterpolasyon formülü
f_xt_yt = (Q11 * (x2 - xt) * (y2 - yt) + ...
           Q21 * (xt - x1) * (y2 - yt) + ...
           Q12 * (x2 - xt) * (yt - y1) + ...
           Q22 * (xt - x1) * (yt - y1)) / ...
          ((x2 - x1) * (y2 - y1));

% Hesaplanan değeri GUI'de göster
set(handles.edit6, 'String', num2str(f_xt_yt));

% Grafik çizimi
axes(handles.axes1);
cla;

% Grid ve yüzey çizimi
[X, Y] = meshgrid(x, y); % Grid oluştur
Z = reshape(z, 2, 2); % Z dizisini 2D matrise dönüştür
surf(X, Y, Z); % 3D yüzey grafiği
hold on;

% Hesaplanan noktayı işaretle
plot3(xt, yt, f_xt_yt, 'r*', 'MarkerSize', 10);

% Grafik ayarları
grid on;
xlabel('x');
ylabel('y');
zlabel('z');
legend('Veriler', 'Hesaplanan');
title('Bilineer Enterpolasyon');


function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
