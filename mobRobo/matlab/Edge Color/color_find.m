function color_find
global color_image;
load color_image;
% %using the gui for user display..
% disp('enter the details in the dialog box');
%  prompt={'Enter persons name:'};
%    %prompt is an cell array..
%    dlgTitle='Image Directory name';
%    def={'Enter the Image File name'};
%    i1=inputdlg(prompt,dlgTitle,1,def);
%    i=i1{1,1};%search or cell command ..go to celldisp(i1)
%    %i=input('Enter the File Name in the current directory\n','s');
%    %ALSO USE UIGETFILE .INTESTING FUNCTION,POPS UP WINDOW TO BE USED 
%    %FOR BROWSING AND GETTING THE DESIRED FILE
%    %[FILE,PATHNAME]=UIGETFILE('*.*','UR TITLE ON THE WINDOW TOP LEFT');
%    
tr=90;%input('Enter the THRESHOLD VALUE 1-99\n');
r=color_image;%imread(i);
figure(4)

subplot(3,1,1);
imshow(r);
title('Original Image')
pixel_color=impixel(r);
color_map=pixel_color./255;
cm=colormap(color_map);
subplot(3,1,2)

%i m using color_map to display the image color selected..only not for passing it on to the find_color function
image(cm);%if imshow function is used..its not working..!!>?
title('Selected COlor');
[image,index]=find_color(r,[],tr,pixel_color);%color_map);
%dnt use color_map variable to send it to the find_color function..
pause(1);
rehash;
subplot(3,1,3)
imshow(image);
title('Selected Color Eliminated')
color_image=image;
save color_image;
%figure
%imhist(r);




