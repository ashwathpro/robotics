clc;

input= imread('test.bmp');
back=input;
pic1=imread('test1.bmp');

% d=ripper(input,.74,1);
% figure;
% imshow(d);              %%%%%%yellow
% d=ripper(input,.74,0);
% figure;               %%%%%%gray
% imshow(d);
% d=ripper(input,.29,0);
% figure;               %%%%%%red
% imshow(d);
% d=ripper(input,.09,0);
% figure;               %%%%%%deep blue
% imshow(d);
% figure;
% imshow(back);

d=ripper(pic1,.09,0);
figure;
imshow(d);

%input=im2bw(back,0.8);
%input = bwmorph(bwmorph(bwmorph(input,'spur'),'clean'),'fill');
%imshow(input);

%input1=im2bw(back,0.75);
%input1 = bwmorph(bwmorph(bwmorph(input1,'spur'),'clean'),'fill');
%imshow(input1);

%input2=im2bw(back,0.29);
%input2 = bwmorph(bwmorph(bwmorph(input2,'spur'),'clean'),'fill');
%imshow(input2);

%input3=im2bw(back,0.05);
%input3 = bwmorph(bwmorph(bwmorph(input3,'spur'),'clean'),'fill');
%imshow(input3);

%[I,J]=find(and(input3,input2)==1);
%input3(I,J)=0;

%[I,J]=find(and(input2,input1)==1);
%input2(I,J)=0;

%[I,J]=find(and(input1,input)==1);
%input1(I,J)=0;

%global tolcirc; 
%tolcirc=100;
%[count_circles, centers,diameters] = second(input3,tolcirc);

%global tolcirc1; 
%tolcirc1=100;
%[count_circles1, centers1,diameters1] = second(input1,tolcirc1);

%A=centers1(1,:);
%B=centers(1,:);
%C=centers1(2,:);
%C=abs(C-B);
%A=abs(A-B);

%a(1,1)=sqrt(A(1,1)^2+A(1,2)^2);
%a(1,2)=sqrt(C(1,1)^2+C(1,2)^2);

%if a(1,1)>a(1,2)
%    C=centers1(2,:);
%else
%    C=centers1(1,:);
%end

%m=((B(1,2)-C(1,2))/(B(1,1)-C(1,1)));
%for i=B(1,1):C(1,1)
%y=round((m*i)+ C(1,2)-(m*C(1,1)));
%if(y>0)
%back(i,y,:)=255;
%end
%end

%imshow(back);
%figure,imshow(input2);
%figure,imshow(input1);
%figure,imshow(input);
  