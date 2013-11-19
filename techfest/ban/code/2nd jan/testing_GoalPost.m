clc;close all;

global vid
global input_colored_image;
global size_input_colored_image;
global g_REDGoalPostCordiToShoot
global g_BLUEGoalPostCordiToShoot
global g_minGoalPostArea %**** no use 
global g_BW_RedGoalPost_Inv
global g_BW_BlueGoalPost_Inv
global g_lengthOfGoalRegion
%% oparameters to change
g_lengthOfGoalRegion=120;
% ???? ***g_minGoalPostArea=3000;
g_REDGoalPostCordiToShoot=[];
g_BLUEGoalPostCordiToShoot=[];

%% GoalPost Color values

global g_color_min_red_GoalPost
global g_color_max_red_GoalPost
global g_red_over_green_GoalPost_red
global g_red_over_blue_GoalPost_red

global g_color_min_blue_GoalPost
global g_color_max_blue_GoalPost
global g_blue_over_green_GoalPost_blue
global g_blue_over_red_GoalPost_blue


%red Goal Post
g_color_min_red_GoalPost = [100 0 0];
g_color_max_red_GoalPost = [255 70 50];
g_red_over_green_GoalPost_red = 60;
g_red_over_blue_GoalPost_red = 60;

%Blue Goal Post
g_color_min_blue_GoalPost = [0 0 80];
g_color_max_blue_GoalPost = [90 90 255];
g_blue_over_green_GoalPost_blue = 30 ;
g_blue_over_red_GoalPost_blue = 35;



%%
input_colored_image=getsnapshot(vid);
%input_colored_image=imread('withBall.jpg');
size_input_colored_image=size(input_colored_image);
%% removing unnecessory part of arena
goalPostColoredInage=input_colored_image;

goalPostColoredInage(1:size_input_colored_image(1),...
    g_lengthOfGoalRegion+1:size_input_colored_image(2)-g_lengthOfGoalRegion,:)=0;
figure,imshow(goalPostColoredInage);

%% Color 1. RED Goal post

BWRed=((goalPostColoredInage(:,:,1)>=goalPostColoredInage(:,:,2)+g_red_over_green_GoalPost_red) ...
    &((goalPostColoredInage(:,:,1)>=goalPostColoredInage(:,:,3)+g_red_over_blue_GoalPost_red)) ...
    &((goalPostColoredInage(:,:,1)>=g_color_min_red_GoalPost(1))) ...
    &((goalPostColoredInage(:,:,2)<=g_color_max_red_GoalPost(2))) ...
    &((goalPostColoredInage(:,:,3)<=g_color_max_red_GoalPost(3))));

BWRed=imclose(BWRed, strel('square',5));

[LabledImageRed,NRed] = bwlabel(BWRed,8);
if(NRed==0)
    error('no red color detected')
end
regionPropertiesRed = regionprops(LabledImageRed,'Area','BoundingBox','FilledImage');

if(NRed~=1)
    AreaArrayRed(NRed)=0;
    for count=1:NRed
        AreaArrayRed(count) = regionPropertiesRed(count).Area;
    end

    [maxAreaRed indexRed] = max(AreaArrayRed);
    bbRed       =  floor(regionPropertiesRed(indexRed).BoundingBox);
    filledImageRed = regionPropertiesRed(indexRed).FilledImage;
else
    bbRed =  floor(regionPropertiesRed.BoundingBox);
    filledImageRed = regionPropertiesRed.FilledImage;
end

if(bbRed(1) < g_lengthOfGoalRegion)
   g_REDGoalPostCordiToShoot = [bbRed(1)+bbRed(3),bbRed(2)+bbRed(4)/2 ];
else
   g_REDGoalPostCordiToShoot = [bbRed(1),bbRed(2)+bbRed(4)/2 ];
end
if(bbRed(1)<=0)bbRed(1)=1;end
if(bbRed(2)<=0)bbRed(2)=1;end

    
g_BW_RedGoalPost_Inv = logical(zeros([size_input_colored_image(1) size_input_colored_image(2)]));
g_BW_RedGoalPost_Inv(bbRed(2):bbRed(2)+bbRed(4)-1,bbRed(1):bbRed(1)+bbRed(3)-1) = filledImageRed;
g_BW_RedGoalPost_Inv = ~g_BW_RedGoalPost_Inv;

figure,imshow(~g_BW_RedGoalPost_Inv);
hold on
plot(g_REDGoalPostCordiToShoot(1),g_REDGoalPostCordiToShoot(2),'rx')

%% Color 2. BLUE Goal post

BWBlue = ((goalPostColoredInage(:,:,3)>=goalPostColoredInage(:,:,1)+g_blue_over_red_GoalPost_blue) ...
    &((goalPostColoredInage(:,:,3)>=goalPostColoredInage(:,:,2)+g_blue_over_green_GoalPost_blue)) ...
    &((goalPostColoredInage(:,:,3)>=g_color_min_blue_GoalPost(3))) ...
    &((goalPostColoredInage(:,:,2)<=g_color_max_blue_GoalPost(2))) ...
    &((goalPostColoredInage(:,:,1)<=g_color_max_blue_GoalPost(1))));

BWBlue=imclose(BWBlue, strel('square',5));

[LabledImageBlue,NBlue] = bwlabel(BWBlue,8);
if(NBlue==0)
    error('no red color detected')
end
regionPropertiesBlue = regionprops(LabledImageBlue,'Area','BoundingBox','FilledImage');

if(NBlue~=1)
    AreaArrayBlue(NBlue)=0;
    for count=1:NBlue
        AreaArrayBlue(count) = regionPropertiesBlue(count).Area;
    end

    [maxAreaBlue indexBlue] = max(AreaArrayBlue);
    bbBlue =  floor(regionPropertiesBlue(indexBlue).BoundingBox);
    filledImageBlue = regionPropertiesBlue(indexBlue).FilledImage;
else
    bbBlue =  floor(regionPropertiesBlue.BoundingBox);
    filledImageBlue = regionPropertiesBlue.FilledImage;
end

if(bbBlue(1) < g_lengthOfGoalRegion)
   g_BLUEGoalPostCordiToShoot = [bbBlue(1)+bbBlue(3),bbBlue(2)+bbBlue(4)/2 ];
else
   g_BLUEGoalPostCordiToShoot = [bbBlue(1),bbBlue(2)+bbBlue(4)/2 ];
end

g_BW_BlueGoalPost_Inv = logical(zeros([size_input_colored_image(1) size_input_colored_image(2)]));
g_BW_BlueGoalPost_Inv(bbBlue(2):bbBlue(2)+bbBlue(4)-1,bbBlue(1):bbBlue(1)+bbBlue(3)-1) = filledImageBlue;
g_BW_BlueGoalPost_Inv = ~g_BW_BlueGoalPost_Inv;

figure,imshow(~g_BW_BlueGoalPost_Inv);
hold on
plot(g_BLUEGoalPostCordiToShoot(1),g_BLUEGoalPostCordiToShoot(2),'bx')

return
