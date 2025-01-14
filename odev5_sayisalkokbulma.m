function varargout = odev5_sayisalkokbulma(varargin)
% ODEV5_SAYISALKOKBULMA MATLAB code for odev5_sayisalkokbulma.fig
%      ODEV5_SAYISALKOKBULMA, by itself, creates a new ODEV5_SAYISALKOKBULMA or raises the existing
%      singleton*.
%
%      H = ODEV5_SAYISALKOKBULMA returns the handle to a new ODEV5_SAYISALKOKBULMA or the handle to
%      the existing singleton*.
%
%      ODEV5_SAYISALKOKBULMA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ODEV5_SAYISALKOKBULMA.M with the given input arguments.
%
%      ODEV5_SAYISALKOKBULMA('Property','Value',...) creates a new ODEV5_SAYISALKOKBULMA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before odev5_sayisalkokbulma_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to odev5_sayisalkokbulma_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help odev5_sayisalkokbulma

% Last Modified by GUIDE v2.5 23-Dec-2024 01:23:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @odev5_sayisalkokbulma_OpeningFcn, ...
                   'gui_OutputFcn',  @odev5_sayisalkokbulma_OutputFcn, ...
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


% --- Executes just before odev5_sayisalkokbulma is made visible.
function odev5_sayisalkokbulma_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to odev5_sayisalkokbulma (see VARARGIN)

% Choose default command line output for odev5_sayisalkokbulma
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes odev5_sayisalkokbulma wait for user response (see UIRESUME)
% uiwait(handles.figure1);
function varargout = odev5_sayisalkokbulma_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Kullanıcıdan fonksiyonu al
f = get(handles.edit1, 'String');  % Denklem metnini al
fx = str2func(['@(x)' regexprep(f, '\^', '.^')]);  % Anonim fonksiyona dönüştür ve ^ operatörünü .^ ile değiştir

% Kullanıcıdan başlangıç ve bitiş noktalarını al
x1 = str2double(get(handles.edit2, 'String'));  % Alt sınır
x2 = str2double(get(handles.edit3, 'String'));  % Üst sınır
h = str2double(get(handles.edit4, 'String'));  % Hata toleransı

% Başlangıçta fonksiyonun değerlerini hesapla
f1 = fx(x1);
f2 = fx(x2);

% Eğer kök aynı işareti taşıyorlarsa, yeni bir aralık al
while f1 * f2 > 0
    uiwait(msgbox('Bu aralıkta kök yoktur', 'Hata', 'error'));
    ab = inputdlg({'Yeni alt sınır', 'Yeni üst sınır'}, 'Yeni aralık', 1, {'', ''});
    x1 = str2double(ab{1});
    x2 = str2double(ab{2});
    set(handles.edit2, 'String', ab{1});
    set(handles.edit3, 'String', ab{2});
    f1 = fx(x1);
    f2 = fx(x2);
end

% Ridders yöntemi ile kök bulma
iterations = {};  % Iterasyonları saklamak için hücre dizisi
iteration_results = [];  % Iterasyon sonuçlarını saklamak için dizi
i = 1;  % Iterasyon sayacını başlat

% İlk x3 hesaplaması
x3 = (x1 + x2) / 2;
f3 = fx(x3);
x4 = x3 + sign(f1 - f2) * f3 * (x3 - x1) / sqrt(f3^2 - f1 * f2);
f4 = fx(x4);

% Iterasyonlar başlasın
while abs(f4) > h
    % Iterasyon sonucunu sakla
    iterations{i} = sprintf('Iterasyon %d: x = %.6f, f(x) = %.6f', i, x4, f4);
    iteration_results = [iteration_results, f4];  % Iterasyon sonuçlarını diziye ekle
    
    % Listbox1'e iterasyon adımlarını yaz
    set(handles.listbox1, 'String', iterations);
    
    % Listbox2'ye iterasyon sonuçlarını yaz
    set(handles.listbox2, 'String', num2str(iteration_results'));
    
    % Ridders adımlarını uygula
    if sign(f3) ~= sign(f4)
        x1 = x3; 
        x2 = x4;
    elseif sign(f1) ~= sign(f4)
        x2 = x4;
    else
        x1 = x4;
    end
    
    % Yeni x3 ve x4 hesaplamaları
    x3 = (x1 + x2) / 2;
    f1 = fx(x1);
    f2 = fx(x2);
    f3 = fx(x3);
    x4 = x3 + sign(f1 - f2) * f3 * (x3 - x1) / sqrt(f3^2 - f1 * f2);
    f4 = fx(x4);
    
    i = i + 1;  % Iterasyon sayacını arttır
end

% Sonucu edit5'te göster
set(handles.edit5, 'String', num2str(x4));

% MATLAB'ın fzero fonksiyonunu kullanarak gerçek kökü bul
real_solution = fzero(fx, [x1 x2]);

% Gerçek çözümü edit6'da göster
if isfield(handles, 'edit6')
    set(handles.edit6, 'String', num2str(real_solution));
else
    disp(['Gerçek Kök: ', num2str(real_solution)]);
end

% Fonksiyon grafiğini çiz
xx = linspace(x1, x2, 100);  % x değerlerini oluştur
yy = fx(xx);  % fx fonksiyonunun değerlerini hesapla

axes(handles.axes1);  % Grafik alanını ayarla
plot(xx, yy, 'b', 'DisplayName', 'Fonksiyon');  % Fonksiyon grafiğini çiz
hold on;
plot(x4, fx(x4), 'ro', 'MarkerFaceColor', 'r', 'DisplayName', 'Bulunan Kök');  % Sonuç olarak bulunan kökü işaretle
plot(real_solution, fx(real_solution), 'go', 'MarkerFaceColor', 'g', 'DisplayName', 'Gerçek Kök');  % Gerçek kökü işaretle
grid on;
xlabel('x');
ylabel('f(x)');
title('Fonksiyon Grafiği ve Kök Karşılaştırması');
legend('show');
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
