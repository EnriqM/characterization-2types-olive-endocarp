function [imagen_trat] = funcion_binGUI(imagen, numSE, T_manual, tipo)
%Función para binarizar en la GUIDE, donde los datos de entrada son
% - imagen
% - numSE: número del elementro estructurante que se aplicará
% - T_manual: umbral entre 0 y 255 que se aplicará si tipo==false
% - tipo: booleano que seleeciona entre Otsu(true) o manual (false)


if tipo==false
    binaria= not(im2bw(imagen, (T_manual/255)));
else%Así el dafult será éste, cuando aún no se haya seleccionado el valor, es el primero que aparece
    binaria = not(im2bw(imagen));
end

    
if numSE>500 %Para que no sea demasiado grande y la computación no tarde
    num=500;
elseif numSE<0
    num=1;
else
    num=numSE;
end

%elemento1 = strel('square',10);
elemento1 = strel('square',num);
%elemento1=strel('disk',num); %Elemento estructurante disk radio 10

%figure,imshow(im_cropped),title('Imagen recortada'); impixelinfo;
%figure,imshow(binaria),title('Imagen binaria'); impixelinfo;

imagen_trat = imclose(binaria,elemento1);
%figure,imshow(imagen_trat),title('Close1'); %decidimos aplicar sólo hasta aquí porque se queda mejor
% imagen_trat = imopen(imagen_trat,elemento1);
% figure,imshow(imagen_trat),title('Open+Close');
% imagen_trat = imfill(imagen_trat,'holes');
% figure,imshow(imagen_trat),title('Holes');

%figure,imshow(binaria_neg),title('Imagen binaria');
%figure,imshow(imagen_trat),title('Imagen tratada');


