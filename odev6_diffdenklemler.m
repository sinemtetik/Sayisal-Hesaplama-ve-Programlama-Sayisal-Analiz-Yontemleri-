function varargout = odev6_diffdenklemler(varargin)
% ODEV6_DIFFDENKLEMLER MATLAB code for odev6_diffdenklemler.fig
%      ODEV6_DIFFDENKLEMLER, by itself, creates a new ODEV6_DIFFDENKLEMLER or raises the existing
%      singleton*.
%
%      H = ODEV6_DIFFDENKLEMLER returns the handle to a new ODEV6_DIFFDENKLEMLER or the handle to
%      the existing singleton*.
%
%      ODEV6_DIFFDENKLEMLER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ODEV6_DIFFDENKLEMLER.M with the given input arguments.
%
%      ODEV6_DIFFDENKLEMLER('Property','Value',...) creates a new ODEV6_DIFFDENKLEMLER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before odev6_diffdenklemler_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to odev6_diffdenklemler_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help odev6_diffdenklemler

% Last Modified by GUIDE v2.5 31-Dec-2024 02:13:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @odev6_diffdenklemler_OpeningFcn, ...
                   'gui_OutputFcn',  @odev6_diffdenklemler_OutputFcn, ...
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


% --- Executes just before odev6_diffdenklemler is made visible.
function odev6_diffdenklemler_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to odev6_diffdenklemler (see VARARGIN)

% Choose default command line output for odev6_diffdenklemler
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes odev6_diffdenklemler wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = odev6_diffdenklemler_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function pushbutton1_Callback(hObject, eventdata, handles)
    % Kullanıcıdan gerekli girdileri al
    fxy = get(handles.edit1, 'String'); % Kullanıcıdan f(x,y) fonksiyonunu al
    f = inline(fxy); % Inline fonksiyon oluştur
    x0 = str2num(get(handles.edit2, 'String')); % Başlangıç x0 değerini al
    y0 = str2num(get(handles.edit3, 'String')); % Başlangıç y0 değerini al
    h = str2num(get(handles.edit4, 'String')); % Adım büyüklüğünü al
    n = str2num(get(handles.edit5, 'String')); % Adım sayısını al

    % Heun (yamuklar) yöntemi için başlangıç değerleri
    x = x0;
    y = y0;
    xs(1) = x; % x değerlerini saklayan dizi
    ys(1) = y; % y değerlerini saklayan dizi

    % Heun (yamuklar) yöntemi ile sayısal çözüm
    for k = 1:n
        y_euler = y + h * f(x, y); % Euler yöntemiyle tahmin
        y = y + (h / 2) * (f(x, y) + f(x + h, y_euler)); % Yamuklar düzeltmesi
        x = x + h; % Bir sonraki x değeri
        xs(k + 1) = x; % x dizisine ekle
        ys(k + 1) = y; % y dizisine ekle
    end

    % MATLAB'in kendi çözüm fonksiyonu ile gerçek çözüm
    x_real = x0:h:(x0 + n * h); % x değerlerini oluştur
    odeFunc = @(x, y) f(x, y); % ODE fonksiyonu
    [x_matlab, y_matlab] = ode45(odeFunc, [x0, x0 + n * h], y0); % MATLAB çözümü

    % Grafik çizimi (axes1 üzerinde)
    axes(handles.axes1); % axes1'e odaklan
    plot(xs, ys, '-o', 'DisplayName', 'Heun Yöntemi (Sayısal)'); % Heun yöntemi çözümü
    hold on;
    plot(x_matlab, y_matlab, '-x', 'DisplayName', 'Gerçek Çözüm (MATLAB)'); % MATLAB çözümü
    hold off;
    legend('show'); % Grafik açıklamasını göster
    xlabel('x'); % x ekseni etiketi
    ylabel('y'); % y ekseni etiketi
    title('Gerçek ve Sayısal Çözüm Karşılaştırması'); % Başlık

    % Sonuçları listboxlara yazdır
    set(handles.listbox1, 'String', num2str(xs', '%.15f')); % x sonuçları
    set(handles.listbox2, 'String', num2str(ys', '%.15f')); % y sonuçları



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


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
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



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
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
