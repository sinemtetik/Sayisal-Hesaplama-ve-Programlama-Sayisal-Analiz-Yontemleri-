function varargout = odev4_belirliintegral(varargin)
% ODEV4_BELIRLIINTEGRAL MATLAB code for odev4_belirliintegral.fig
%      ODEV4_BELIRLIINTEGRAL, by itself, creates a new ODEV4_BELIRLIINTEGRAL or raises the existing
%      singleton*.
%
%      H = ODEV4_BELIRLIINTEGRAL returns the handle to a new ODEV4_BELIRLIINTEGRAL or the handle to
%      the existing singleton*.
%
%      ODEV4_BELIRLIINTEGRAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ODEV4_BELIRLIINTEGRAL.M with the given input arguments.
%
%      ODEV4_BELIRLIINTEGRAL('Property','Value',...) creates a new ODEV4_BELIRLIINTEGRAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before odev4_belirliintegral_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to odev4_belirliintegral_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help odev4_belirliintegral

% Last Modified by GUIDE v2.5 23-Dec-2024 00:40:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @odev4_belirliintegral_OpeningFcn, ...
                   'gui_OutputFcn',  @odev4_belirliintegral_OutputFcn, ...
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


% --- Executes just before odev4_belirliintegral is made visible.
function odev4_belirliintegral_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to odev4_belirliintegral (see VARARGIN)

% Choose default command line output for odev4_belirliintegral
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes odev4_belirliintegral wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = odev4_belirliintegral_OutputFcn(hObject, eventdata, handles) 
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

f = get(handles.edit1, 'String');  % Kullanıcıdan alınan fonksiyon
fx = str2func(['@(x)' f]);  % Fonksiyonu anonim fonksiyona dönüştür

a = str2num(get(handles.edit2, 'String'));  % Başlangıç noktası
b = str2num(get(handles.edit3, 'String'));  % Bitiş noktası
n = str2num(get(handles.edit4, 'String'));  % Monte Carlo için örnekleme sayısı

% Monte Carlo yöntemi ile integral hesaplama
x_random = a + (b - a) * rand(1, n);  % [a, b] aralığında rastgele x değerleri
y_random = fx(x_random);  % Rastgele x değerlerine karşılık gelen y değerleri

% Monte Carlo yöntemi ile tahmin edilen toplam alan
I_monte_carlo = (b - a) * mean(y_random);  % Monte Carlo integral sonucu

% Iterasyonların sonuçlarını saklayacak vektör
iteration_results = zeros(1, n);  % Başlangıçta boş bir vektör

% Her iterasyonda ortalama değeri hesaplayıp kaydediyoruz
for i = 1:n
    current_random_points = x_random(1:i);  % İlk i rastgele noktayı al
    current_random_values = fx(current_random_points);  % Bu noktalara karşılık gelen y değerleri
    iteration_results(i) = (b - a) * mean(current_random_values);  % Ortalama değer ile integral tahmini
end

% Sonuçları listbox1 ve listbox2'ye yazdırma
set(handles.listbox1, 'String', num2str((1:n)'));  % 1'den n'e kadar olan adımlar
set(handles.listbox2, 'String', num2str(iteration_results'));  % Her iterasyondaki Monte Carlo sonuçları

% Analitik integral hesaplaması
f_analytic = str2func(['@(x)' f]);  % Kullanıcı fonksiyonunu anonim fonksiyona çevir
I_analytic = integral(f_analytic, a, b);  % Analitik entegrasyon

% Analitik sonucu GUI'de göster
set(handles.edit5, 'String', num2str(I_analytic));  % Analitik sonucu ekranda göster
set(handles.edit6, 'String', num2str(I_analytic));  % Analitik sonucu edit6'ya yazdır

% Toplam Monte Carlo sonuçlarını hesaplayıp edit7'ye yazdırma
total_area = sum(iteration_results);  % Toplam alan (sonuçların toplamı)
set(handles.edit7, 'String', num2str(I_monte_carlo));  % Monte Carlo ile hesaplanan toplam alan

% Grafik çizimi
xx = linspace(a, b, 100);  % x değerlerini oluştur
yy = fx(xx);  % fx fonksiyonunun değerlerini hesapla

axes(handles.axes1);  % Grafik alanını ayarla
area(xx, yy);  % Alan grafiğini çiz
hold on;
scatter(x_random, y_random, 10, 'r', 'filled');  % Rastgele seçilen noktaları işaretle
grid on;
xlabel('x');
ylabel('y');
legend('Fonksiyon Alanı', 'Monte Carlo Örnekleri');
hold off;





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



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
