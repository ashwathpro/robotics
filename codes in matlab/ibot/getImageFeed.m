botImg=getsnapshot(vid);

% botImg=imread('bot1.jpg');
% figure,imshow(botImg);
% [rect_pos] = Crop_it(arenaImg);
% disp(rect_pos);

botImg=imcrop(botImg,rect_pos);
botImg=imresize(botImg,[480 640]);

negImg=im2bw(botImg,.6);       %%===========calibrate
bw1 = bwareaopen(negImg,200);
se = strel('disk',4);
bw1 = imclose(bw1,se);
bw1=bwlabel(bw1);
botDet=regionprops(bw1,'basic');
% disp(botDet);
imshow(bw1);

 for k = 1:2 
    centroid = botDet(k).Centroid;
        temp(k,1)=centroid(1);
        temp(k,2)=centroid(2);
        temp(k,3)=botDet(k).Area;
 end
 temp=sortrows(temp,3);
c1=[temp(1,1) temp(1,2)];
c2=[temp(2,1) temp(2,2)];
 
[dy,dx]=findSlope(c1,c2);
ret=deg(-dy,dx);
disp(ret);
% figure,imshow(bw1);