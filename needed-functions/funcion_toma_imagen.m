function imagen = funcion_toma_imagen()

%Adquisici�n de la imagen
vid = videoinput('gige', 1, 'BayerRG8');
src = getselectedsource(vid);
src.ExposureTime = 4007; %Tiempo de exposici�n
vid.FramesPerTrigger = 1; %imagenes tomadas
imagen = getsnapshot(vid); %toma una captura de la camara
delete(vid); % corta la comunicaci�n con la camara
%figure,imshow(imagen),title('Imagen tomada');
%impixelinfo; %Muestra informaci�n de los ejes XY y de RGB