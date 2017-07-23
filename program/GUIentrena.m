function varargout = GUIentrena(varargin)
% GUIENTRENA MATLAB code for GUIentrena.fig
%      GUIENTRENA, by itself, creates a new GUIENTRENA or raises the existing
%      singleton*.
%
%      H = GUIENTRENA returns the handle to a new GUIENTRENA or the handle to
%      the existing singleton*.
%
%      GUIENTRENA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIENTRENA.M with the given input arguments.
%
%      GUIENTRENA('Property','Value',...) creates a new GUIENTRENA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUIentrena_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUIentrena_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUIentrena

% Last Modified by GUIDE v2.5 13-May-2017 17:37:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIentrena_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIentrena_OutputFcn, ...
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


% --- Executes just before GUIentrena is made visible.
function GUIentrena_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUIentrena (see VARARGIN)
msgbox('Bienvenido a la interfaz gráfica para entrenar la red neuronal. Para usarlo, simplemente abra una imagen o adquiérala con la cámara Genie Nano C2420. Luego ajuste el binarizado de la imagen y elija el tipo de hueso que es (sólo un tipo en cada imagen, por favor). Finalmente, guarde los datos. Cuando tenga el número de capturas que considere necesario, pulse el botón "Crear red neuronal"', 'Información sobre la aplicación', 'help');
contador=0;
% Choose default command line output for GUIentrena
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%Guardamos la variable contador en el objeto del texto que se mostrará (sólo número)
%SE INICIALIZA ASÍ EL CONTADOR DE FOTOS A GUARDAR A 0.
set(handles.staticText_cont, 'String', num2str(contador));


% UIWAIT makes GUIentrena wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUIentrena_OutputFcn(hObject, eventdata, handles) 
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


% --- Executes on button press in pb_hist.
function pb_hist_Callback(hObject, eventdata, handles)
% hObject    handle to pb_hist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes2);
imhist(get(handles.pushbutton4, 'UserData'));


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
set(handles.pb_savedata, 'UserData', matriz);


% --- Executes on button press in pb_savedata.
function pb_savedata_Callback(hObject, eventdata, handles)
% hObject    handle to pb_savedata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datos_im_actual=get(handles.pb_savedata, 'UserData');
[caract, numeroObj]=size(datos_im_actual);
%El números de Targets se obtiene a partir del size de la matriz
tipo=get(handles.uipanel2, 'UserData');
if tipo==false
    datos_im_actual(caract+1,:)= zeros(1,numeroObj);   %Será el NEVADILLO
    datos_im_actual(caract+2,:)= ones(1,numeroObj);    
else%Así el dafult será éste, cuando aún no se haya seleccionado el valor, es el primero que aparece
    datos_im_actual(caract+1,:)= ones(1,numeroObj); %Será el GORDAL
    datos_im_actual(caract+2,:)= zeros(1,numeroObj);
end

%Una vez contruida la matriz de datos, ahorá se añadirá a las de las demás
%fotos. Por lo tanto, se debe tener en cuenta un contador y una variable
contadornuevo=str2num(get(handles.staticText_cont, 'String'))+1;
set(handles.staticText_cont, 'String', num2str(contadornuevo));

if contadornuevo==1 %Será la primera vez que se guarden datos
    set(handles.pushbutton6, 'UserData', datos_im_actual);
else        %No será la primera vez que se tomen datos
    final_actual=get(handles.pushbutton6, 'UserData');
    [N]=size(final_actual);
    final_actual(:,(N(2)+1):(N(2)+numeroObj))=datos_im_actual;
    set(handles.pushbutton6, 'UserData', final_actual);
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%EN EL HANDLES SE GUARDARÁ LA TABLA FINAL. CUANDO SE PULSE, SE UTILIZARÁ
%TODA LA MATRIZ EXISTENTE PARA CREAR LA RED NEURONAL
matriz=get(handles.pushbutton6, 'UserData');
%Separamos la matriz en inputs y targets.
inputs=matriz(1:5,:);
targets=matriz(6:end,:);

%CREAMOS AQUÍ LA RED NEURONAL CON 10 NEURONAS INTERMEDIAS Y LUEGO ASIGNAMOS
%LAS VARIABLES
net = patternnet(10);
net = train(net,inputs,targets);
view(net);
num_imagenes=str2num(get(handles.staticText_cont, 'String'));
file__name=strcat('Gui_entrena_',num2str(num_imagenes),'_im.mat');

%Guardamos también las matrices por si queremos variarlas manualmente.
save(file__name, 'inputs', 'targets', 'num_imagenes', 'net');
view(net);


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


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over text2.
function text2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to text2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected object is changed in uipanel2.
function uipanel2_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel2 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
switch get(eventdata.NewValue, 'Tag') 
  case 'r_gordal'
     tipo=true;
        
  case 'r_nev'
     tipo=false;
end
set(handles.uipanel2, 'UserData', tipo);
