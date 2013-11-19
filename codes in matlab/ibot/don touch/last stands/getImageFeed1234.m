% botImg=imread('bot1.jpg');
% figure,imshow(botImg);
% [rect_pos] = Crop_it(arenaImg);
% disp(rect_pos);

botImg=getsnapshot(vid);
botImg=imcrop(botImg,rect_pos);
botImg=imresize(botImg,[480 640]);
% figure,imshow(bw1);
negImg=im2bw(botImg,.87); %<=========================CALIBRATE FOR 2 CIRCLES
bw1 = bwareaopen(negImg,400);
se = strel('disk',4);
bw1 = imclose(bw1,se);
bw1=bwlabel(bw1);
botDet=regionprops(bw1,'basic');
% disp(botDet);
% botCentroid
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

botNode=c2;
disp('botNode');
disp(botNode);

[dy,dx]=findSlope(c1,c2);
botDir=deg(-dy,dx);
disp('Angle');
disp(botDir);


% figure,imshow(bw1);