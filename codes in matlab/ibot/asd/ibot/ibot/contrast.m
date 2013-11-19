arenaImg= imread('ibot4.jpg');

srgb2lab = makecform('srgb2lab'); 
lab2srgb = makecform('lab2srgb'); 
arenaImg_lab = applycform(arenaImg, srgb2lab); % convert to L*a*b*
% the values of luminosity can span a range from 0 to 100; scale them % to
% [0 1] range (appropriate for MATLAB intensity images of class double) % before applying the three contrast enhancement techniques 
max_luminosity = 50; 
L = arenaImg_lab(:,:,1)/max_luminosity;

% replace the luminosity layer with the processed data and then convert %
% the image back to the RGB colorspace 
arenaImg_imadjust = arenaImg_lab; 
arenaImg_imadjust(:,:,1) = imadjust(L)*max_luminosity; 
arenaImg_imadjust = applycform(arenaImg_imadjust, lab2srgb);

arenaImg_histeq = arenaImg_lab; 
arenaImg_histeq(:,:,1) = histeq(L)*max_luminosity; 
arenaImg_histeq = applycform(arenaImg_histeq, lab2srgb);

arenaImg_adapthisteq = arenaImg_lab; 
arenaImg_adapthisteq(:,:,1) = adapthisteq(L)*max_luminosity; 
arenaImg_adapthisteq = applycform(arenaImg_adapthisteq, lab2srgb);

figure, imshow(arenaImg); 
title('Original');
figure, imshow(arenaImg_imadjust); 
title('Imadjust');

figure, imshow(arenaImg_histeq); title('Histeq');
figure, imshow(arenaImg_adapthisteq); title('Adapthisteq');