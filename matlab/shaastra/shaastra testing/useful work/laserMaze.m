global final
% imshow(final)

% rect = imrect(gca)

imRows  = size(final,1); 
imCols  = size(final,2);

lenX=(7/32)*size(final,2)+sizex/20;
lenY=size(final,1);
laser=imcrop(final ,  [ 1 1 lenX lenY]);


laser=(laser(:,:,1)<=maxRed) & ((laser(:,:,2)<=maxGreen)) & ((laser(:,:,3)>=minBlue) ...
        & laser(:,:,3)-laser(:,:,1) >= blueOverRed & laser(:,:,3)-laser(:,:,2) >= blueOverGreen);
    
laser=bwlabel(laser);
laserProps=regionprops(laser);

temp=[];
temp=[temp;(laserProps(:).Area)];

[minAr ind]=min(temp);
laser=laser & (laser(:,:)~=ind);

[i j]=find(laser);
stLineY=min(i);

imshow(laser);


