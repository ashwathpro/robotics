function load_file
global gray_image;
global color_image;
global s;

delete *.mat;
clc;
clear all;
axes('position',[0.85 0.85, 0.15 0.15]);
a=imread('logo.jpg');
imshow(a)


buffer=pwd;
[file, pathname] = uigetfile('*.jpg','Load Image');
cd(pathname);
color_image=imread(file);%color image
cd(buffer);
a=size(color_image,3);
if (a>1)
    gray_image=rgb2gray(color_image);%Grayscale Image
end
      
 figure(2)
 imshow(color_image);
 save color_image; 
 save gray_image; 
 