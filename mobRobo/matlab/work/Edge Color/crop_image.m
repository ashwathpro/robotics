function crop_image

global color_image;%color image
load color_image;
figure(2)
color_image=imcrop(color_image);
imshow(color_image);
save color_image;
