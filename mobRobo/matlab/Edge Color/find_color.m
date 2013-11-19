function [image,index]=find_color(image,map,tr,colors) 
%[IMAGE,IND]=FIND_COLOR(A,MAP,THRESHOLD,COLOR VECTOR) 
%Finds a color of an Image A and returns IMAGE, the 
%original image with the pixels with the specified color set 
%to zero, and IND, an index to the pixels that are were 
%equal to the selected color.
%
%MAP is the input if the image is indexed, if the image is not indexed
%enter empty brackerts ( [] ), TR is the threshold tolerance for the 
%color range, COLOR VECTOR is an additional argument that takes 
%in the hard-coded values for the color, use empty brackects ( [] )
%if you wish to select the color from the origimal image using the mouse.
%
%Composite image, EXAMPLE:
%x=imread('football.jpg');
%subplot(2,1,1);imshow(x);
%title('Before');
%[image,ind]=find_color(x,[],90,[27 80 111]);
%subplot(2,1,2);imshow(image);
%title('After')
%figure
% y=imread('saturn.tif');
% image(328,438,:)=0;
% i= ~(im2bw(image,0.01));
% c=immultiply(y,i);
% c(:,:,2)=c;
% c(:,:,3)=c(:,:,2);
% y(:,:,2)=y;
% y(:,:,3)=y(:,:,1);
% C=imadd(image,c);
% imshow(C)


%by is

%this file has the following functions 
%make_rgb
%getcolor
%

I=make_rgb(image,map); 

if isempty(colors)%if colors in the input argument are given as empty..to get the color from the mousse input
disp('Right click on the color you want off the image with the mouse:') ;
disp('Procesing');

colors=impixel(I); %this command get the color amp from the mouse click coordinate 
%and gives the 1 x 3 array to the colors input.
close 
end

[i j]=size(colors);
if i>1,%for single ow procesisng only..nt multiple row..at any time
    colors=colors(1,:);
end
[image,index]= getcolor(I,colors,tr);%tr is the treshold value..required;I is the image,color is the clicked image

% figure
% imshow(image);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [image,index]=getcolor(I,color,tr) 
[i j k]=size(I);
R=color(1,1);
G=color(1,2);
B=color(1,3);
%uint8->the inout image..the size is 8 bits unsigned.for double,the size is 64 bit folatign point
%give this command to check the amount of memory taken bt uint8 and double--- 

I=double(I);
% whos
% disp('Check the BYTE occupied by image and I');
mask=( abs(I(:,:,1)-R) <tr ) & ( abs(I(:,:,2)-G) <tr ) &( abs(I(:,:,3)-B) <tr );
%in the above example I(:,:,1),we are gettig the first color component R ans subtracting the color component R 
%by doing so,we may have some negative values..its we are checking that..wheather to mask the color or not
%based in logical function..so after dng for R v,do for G and B respectively..
%( abs(I(:,:,1)-R) <tr ) in this all the values will b either TRUE or FALESE,so either 1 or 0..in the matrix
I(:,:,1)=I(:,:,1).*(~mask);%multiplyign each color component R,G and B vth mask(complemented)
I(:,:,2)=I(:,:,2).*(~mask);
I(:,:,3)=I(:,:,3).*(~mask);
image=uint8(I);
index=find(mask==1);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function I=make_rgb(image,map)
[i j k]=size(image);
if (~isempty(map)), 
    I=ind2rgb(image,map); %if the image is indexed..only..isempty(map)will return
    %1 since for an rgb image ,map is zero,ans ~ will return 0
    I=im2uint8(I);
elseif (isempty(k)), 
    I(:,:,2)=I; %for gray scale image only..since k will b zero
    I(:,:,3)=I(:,:,1);     
else
I=image;%for rgb image ..it will have all i,j and k
end

