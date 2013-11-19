function ncolor
clc;
global color_image;
load color_image;

a=color_image;%imread('glassy.jpg');
[x,map]=rgb2ind(a,256);
[count,x]=imhist(x,map);

%for first maximum color
max_color1=max(count);
total=sum(count);
for q=1:size(map,1)
    if(count(q)==max_color1)
        location1=q;
    end    
end
per1=(max_color1/total)*100;
a=map(location1,:);
a1=double(a);
figure;
imagesc(colormap(a1));
title(['First Maximum ',num2str(per1),'%']);


%for second color

count(location1)=[];
map(location1,:)=[];


max_color2=max(count);
%total=sum(count)
for q=1:size(map,1)
    if(count(q)==max_color2)
        location2=q;
    end
    
end
rehash;
clear a;
clear a1;
per2=(max_color2/total)*100;
a=map(location2,:);
a1=double(a);
figure
imagesc(colormap(a1));
title(['Second Maximum ',num2str(per2),'%']);


%for third maximum color
count(location2)=[];
map(location2,:)=[];


max_color3=max(count);
%total=sum(count)
for q=1:size(map,1)
    if(count(q)==max_color3)
        location3=q;
    end
    
end
rehash;
clear a;
clear a1;
per3=(max_color2/total)*100;
a=map(location3,:);
a1=double(a);
figure
imagesc(colormap(a1));
title(['Third Maximum Color ',num2str(per3),'%']);
    