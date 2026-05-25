close all
clc
clear

% Leer imágenes
img1 = imread('Img1.jpeg');
img2 = imread('Img2.jpeg');
img3 = imread('Img3.jpeg');

% Igualar altura
h = min([size(img1,1), size(img2,1), size(img3,1)]);
img1 = img1(1:h,:,:);
img2 = img2(1:h,:,:);
img3 = img3(1:h,:,:);

% Escala de grises
g1 = rgb2gray(img1);
g2 = rgb2gray(img2);
g3 = rgb2gray(img3);

% ================================
% DESPLAZAMIENTO img1 -> img2
% ================================
mejor_error = inf;
dx12 = 0;

for k = 10:200
    if k > size(g2,2)
        break
    end

    zonaA = g1(:, end-k+1:end);
    zonaB = g2(:, 1:k);

    error = sum(abs(double(zonaA(:)) - double(zonaB(:))));

    if error < mejor_error
        mejor_error = error;
        dx12 = size(g1,2) - k;
    end
end

% ================================
% DESPLAZAMIENTO img2 -> img3
% ================================
mejor_error = inf;
dx23 = 0;

for k = 10:200
    if k > size(g3,2)
        break
    end

    zonaA = g2(:, end-k+1:end);
    zonaB = g3(:, 1:k);

    error = sum(abs(double(zonaA(:)) - double(zonaB(:))));

    if error < mejor_error
        mejor_error = error;
        dx23 = size(g2,2) - k;
    end
end

% ================================
% CONTENEDOR GRANDE
% ================================
W = size(img1,2) + size(img2,2) + size(img3,2);
panorama = zeros(h, W, 3, 'uint8');

% ================================
% COLOCAR img1
% ================================
x1 = 1;
panorama(:, x1:x1+size(img1,2)-1, :) = img1;

% ================================
% COLOCAR img2 (SUPERPUESTA)
% ================================
x2 = dx12 + 1;

for i = 1:size(img2,2)
    col = x2 + i - 1;

    if col > size(panorama,2)
        break
    end

    for fila = 1:h
        if all(panorama(fila,col,:) == 0)
            panorama(fila,col,:) = img2(fila,i,:);
        end
    end
end

% ================================
% COLOCAR img3 (SUPERPUESTA)
% ================================
x3 = x2 + dx23;

for i = 1:size(img3,2)
    col = x3 + i - 1;

    if col > size(panorama,2)
        break
    end

    for fila = 1:h
        if all(panorama(fila,col,:) == 0)
            panorama(fila,col,:) = img3(fila,i,:);
        end
    end
end

% ================================
% RECORTE FINAL
% ================================
cols_validas = any(any(panorama,3),1);
panorama = panorama(:, cols_validas, :);

% ================================
% MOSTRAR
% ================================
figure
subplot(2,2,1), imshow(img1), title('Imagen 1')
subplot(2,2,2), imshow(img2), title('Imagen 2')
subplot(2,2,3), imshow(img3), title('Imagen 3')
subplot(2,2,4), imshow(panorama), title('Panorámica (superposición real)')