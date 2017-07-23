function varargout = GUIFinal_2tipos(varargin)
% GUIFINAL_2TIPOS MATLAB code for GUIFinal_2tipos.fig
%      GUIFINAL_2TIPOS, by itself, creates a new GUIFINAL_2TIPOS or raises the existing
%      singleton*.
%
%      H = GUIFINAL_2TIPOS returns the handle to a new GUIFINAL_2TIPOS or the handle to
%      the existing singleton*.
%
%      GUIFINAL_2TIPOS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIFINAL_2TIPOS.M with the given input arguments.
%
%      GUIFINAL_2TIPOS('Property','Value',...) creates a new GUIFINAL_2TIPOS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUIFinal_2tipos_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUIFinal_2tipos_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUIFinal_2tipos

% Last Modified by GUIDE v2.5 13-May-2017 20:08:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIFinal_2tipos_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIFinal_2tipos_OutputFcn, ...
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


% --- Executes just before GUIFinal_2tipos is made visible.
function GUIFinal_2tipos_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUIFinal_2tipos (see VARARGIN)
msgbox('Bienvenido a la interfaz gráfica para clasificar el tipo de aceituna mediante su endocarpo. Para usarlo, simplemente abra una imagen o adquiérala con la cámara Genie Nano C2420. Antes de procesar la imagen, deberá cargar la red neuronal o bien entrenarla mediante la interfaz gráfica de entrenamiento, situada al darle al botón "CREAR R.Neuronal" (posteriormente deberá cargar el archivo). Por último, ajuste el binarizado de la imagen y las aceitunas aparecerán clasificadas mediante color: Rojo para Gordal, Azul para Nevadillo.', 'Información sobre la aplicación', 'help');

% Choose default command line output for GUIFinal_2tipos
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes GUIFinal_2tipos wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUIFinal_2tipos_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pb_abrir.
function pb_abrir_Callback(hObject, eventdata, handles)
% hObject    handle to pb_abrir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[nombre, direc]=uigetfile('*.jpg','Abrir imagen');

if nombre == 0
    
    return
end

im=imcrop(imread(fullfile(direc,nombre)), [730 600 1000 750]);
axes(handles.axes1);
imshow(im);
imgris=rgb2gray(im);
set(handles.pushbutton4, 'UserData', imgris);

% --- Executes on button press in pb_adquisicion.
function pb_adquisicion_Callback(hObject, eventdata, handles)
% hObject    handle to pb_adquisicion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
im=funcion_toma_imagen();

%Tras tomar la imagen la guardamos
c=clock;
e='_';
d='C:\Users\Kike Toshiba\Documents\MATLAB\Huesos_Aceituna\imag_prueb_lunes\';
nombre=strcat(d,num2str(c(1)),e,num2str(c(2)),e,num2str(c(3)),e,num2str(c(4)),e,num2str(c(5)),e,num2str(c(6)),'.jpg');
imwrite(im,nombre);
%Una vez guardada, se recorta, se muestra y se guarda en 'UserData' del
%botón de Binarizar en gris, puesto que para el resto del procesado no
%hacen falta los colores.
im_cropped=imcrop(im, [730 600 1000 750]);
axes(handles.axes1);
imshow(im_cropped);
imgris=rgb2gray(im_cropped);
set(handles.pushbutton4, 'UserData', imgris);


% --- Executes on button press in pb_procesa.
function pb_procesa_Callback(hObject, eventdata, handles)
% hObject    handle to pb_procesa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

matriz=get(handles.pb_procesa, 'UserData');
L=get(handles.pb_entrena, 'UserData');
net=get(handles.pb_cargaRED, 'UserData');

[carac, numObj] = size(matriz);
tam=size(L);

R_gordal=zeros(tam(1),tam(2));
B_nev=zeros(tam(1),tam(2));

 for j=1:numObj
    c_net=net.net(matriz(:,j)); %Por alguna razón lo carga como un struct.
    if (vec2ind(c_net>0.5))==1 %Entonces es gordal
       R_gordal(L==j)=1;
    else %Entonces es nevadillo
        B_nev(L==j)=1;
    end
 end
 
RGB=cat(3, R_gordal.*1, L.*0, B_nev.*1);
axes(handles.axes2);
imshow(RGB);



% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imagen=get(handles.pushbutton4, 'UserData');
tipo=get(handles.uipanel1, 'UserData');
numSE=str2num(get(handles.edit_SE, 'String'));
T=str2num(get(handles.t_manual, 'String'));

BW = funcion_binGUI(imagen, numSE, T, tipo);
%set(handles.pushbutton4, 'UserData_BW', BW); No se puede poner el nombre
%que a mí me salga.




CC=bwconncomp(BW);
STATS = regionprops(CC, imagen,'Centroid','MinorAxisLength','MeanIntensity');
L=double(labelmatrix(CC)); %Así hace lo de numerar pero con bwconncomp en vez de bwlabel


set(handles.pb_entrena, 'UserData', L);

%Lo guardaremos como UserData de la función "ENTRENA", el botón que abre
%otra GUI porque no se utiliza


textura=zeros(6 ,CC.NumObjects);
haralick=zeros(14 ,CC.NumObjects);

axes(handles.axes2);
imshow(BW);

for i=1:CC.NumObjects
    
    rectangle('Position', Cuadrado1(STATS(i).MinorAxisLength, STATS(i).Centroid),'EdgeColor','r', 'LineWidth', 2);
   text(round(STATS(i).Centroid(1))+5,round(STATS(i).Centroid(2)),sprintf('%d', i), 'Units', 'data');
    textura(:,i)=statxture(imcrop(imagen, Cuadrado1(STATS(i).MinorAxisLength, STATS(i).Centroid)));
    GLCM_cuadrado = graycomatrix(imcrop(imagen, Cuadrado1(STATS(i).MinorAxisLength, STATS(i).Centroid)),'Offset',[2 0],'Symmetric', true);
    haralick(:,i)= haralickTextureFeatures(GLCM_cuadrado);
end

%Creamos la matriz de datos que se utilizará para las redes de neuronas.
%Sólo se crearán los inputs, los target se crearán después
matriz=zeros(5,CC.NumObjects);
matriz(1,:)=textura(3,:); %Así añadimos el valor T(e) de textura, smoothness
matriz(2:4,:)= haralick([4,6:7],:);
matriz(end,:) = [STATS.MeanIntensity];
set(handles.pb_procesa, 'UserData', matriz);


function t_manual_Callback(hObject, eventdata, handles)
% hObject    handle to t_manual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of t_manual as text
%        str2double(get(hObject,'String')) returns contents of t_manual as a double
T=get(hObject,'String');
set(hObject, 'String', T);


% --- Executes during object creation, after setting all properties.
function t_manual_CreateFcn(hObject, eventdata, handles)
% hObject    handle to t_manual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_SE_Callback(hObject, eventdata, handles)
% hObject    handle to edit_SE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_SE as text
%        str2double(get(hObject,'String')) returns contents of edit_SE as a double
SE=get(hObject,'String');
set(hObject, 'String', SE);

% --- Executes during object creation, after setting all properties.
function edit_SE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_SE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in uipanel1.
function uipanel1_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel1 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
switch get(eventdata.NewValue, 'Tag') 
  case 'r_otsu'
     tipo=true;
        
  case 'r_manual'
     tipo=false;
end
set(handles.uipanel1, 'UserData', tipo);


% --- Executes on button press in pb_cargaRED.
function pb_cargaRED_Callback(hObject, eventdata, handles)
% hObject    handle to pb_cargaRED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[nombre, direc]=uigetfile('*.mat','Cargar Workspace');

if nombre == 0
    
    return
end

%direcYnombre=strcat(direc, nombre);
net=load(nombre, 'net');
set(handles.pb_cargaRED, 'UserData', net);


% --- Executes on button press in pb_entrena.
function pb_entrena_Callback(hObject, eventdata, handles)
% hObject    handle to pb_entrena (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GUIentrena
