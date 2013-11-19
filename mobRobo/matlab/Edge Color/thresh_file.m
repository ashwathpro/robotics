function thresh_file
if(~exist('s.mat'))
    a=warndlg('Click on the Edge Button');
end
global gray_image;
global color_image;
load color_image;

gray_image=rgb2gray(color_image);
save gray_image;
global s;
load gray_image;%grayscale file
load s;

v=get(gcbo,'Value');
Hndl=findobj(gcbf,'Tag','text1');
str=sprintf('%2f',v);
set(Hndl,'String',str);
          
 if(s==1)
 BW=edge(gray_image,'sobel',v);
 figure(3)
 imshow(BW);
elseif(s==2)  
BW=edge(gray_image,'prewitt',v);
figure(3)
imshow(BW);
elseif(s==3)
BW=edge(gray_image,'roberts',v);
figure(3)
imshow(BW);
elseif(s==4)  
BW=edge(gray_image,'log',v);
figure(3)
imshow(BW);
elseif(s==5)
BW=edge(gray_image,'zerocross',v);
figure(3)
imshow(BW);
elseif(s==6)
BW=edge(gray_image,'canny',v);
figure(3)
imshow(BW);
end
gray_image=BW;
save gray_image;
