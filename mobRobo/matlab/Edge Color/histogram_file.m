function histogram_file%color histogram plot

global color_image;
load color_image;

I=color_image;
[x,map]=rgb2ind(I,256);
figure(2)
subplot(2,1,1)
imhist(x,map);
title('Histogram');
[freq,no]=imhist(x,map);
subplot(2,1,2);
stem(no,freq);
title('Histogram Plot');
save map;
