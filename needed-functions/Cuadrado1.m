function [ rectangle ] = Cuadrado1( MinorAxis, Centroid )
%Función para seleccionar un cuadrado de la aceituna dado su centroide y su
%eje menor. Será útil para sacar una submatriz y estudiar la textura.
%
%La salida es un vector como el que usa la funcion rectangle
%   [xmin ymin width height]

lado = MinorAxis / (sqrt(2));
x=Centroid(1)-(lado/2);
y=Centroid(2)-(lado/2);

rectangle=[x, y, lado, lado];



end
