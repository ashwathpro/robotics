function cropAndResize(imgin)
imgin=imcrop(imgin);
imgin=imresize(imgin,[640 480]);
LEN = 1;
THETA = 0;
PSF = fspecial('motion',LEN,THETA);
% Blurred = imfilter(imgin,PSF,'circular','conv');
figure; imshow(imgin);
imgin= deconvwnr(imgin,PSF);
figure;imshow(imgin);
return;
