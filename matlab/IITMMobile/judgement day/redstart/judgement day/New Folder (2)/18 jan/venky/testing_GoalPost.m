clc;close all;

global vid
global input_colored_image;
global size_input_colored_image;
global g_REDGoalPostCordiToTarget
global g_BLUEGoalPostCordiToTarget
global g_BW_RedGoalPost_Inv
global g_BW_BlueGoalPost_Inv
global g_BW_RedGoalPost
global g_BW_BlueGoalPost
global g_lengthOfGoalRegion

% distance from the goal post where robot will leave the ball
global g_minShootDist
global g_maxShootDist

% robot has run before shoot
% ?? can calculate by simulation
global g_runDistForShoot

% the cordi where robot start running for shoot the balls
global g_minShootCordisRedGoalPost
global g_maxShootCordisRedGoalPost
global g_minShootCordisBlueGoalPost
global g_maxShootCordisBlueGoalPost


%
global freeMovementndex
freeMovementndex = 1;
global g_numOfShootPtsAtOneSide
global g_maxAngleOfShoot %in degree

global g_BBLeftGoalPost; % bounding box used to for cropping image in ball_information
global g_BBRightGoalPost;
%% oparameters to change
g_lengthOfGoalRegion=120;

g_minShootDist = 100;
g_maxShootDist = 120;

g_runDistForShoot = 20;

g_numOfShootPtsAtOneSide = 3;
g_maxAngleOfShoot = 30;

% ???? ***g_minGoalPostArea=3000;
g_REDGoalPostCordiToTarget=[];
g_BLUEGoalPostCordiToTarget=[];

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
g_color_min_red_GoalPost = [70 0 0];
g_color_max_red_GoalPost = [255 70 50];
g_red_over_green_GoalPost_red = 30;
g_red_over_blue_GoalPost_red = 30;

%Blue Goal Post
g_color_min_blue_GoalPost = [0 0 70];
g_color_max_blue_GoalPost = [90 90 255];
g_blue_over_green_GoalPost_blue = 30 ;
g_blue_over_red_GoalPost_blue = 35;



%%
input_colored_image=getsnapshot(vid);
%input_colored_image=imread('withBall2.jpg');
size_input_colored_image=size(input_colored_image);
%% removing unnecessory part of arena
goalPostColoredInage=input_colored_image;

goalPostColoredInage(1:size_input_colored_image(1),...
    g_lengthOfGoalRegion+1:size_input_colored_image(2)-g_lengthOfGoalRegion,:)=0;
figure,imshow(goalPostColoredInage);
%% intiating the shooti coodinates
g_minShootCordisRedGoalPost    = zeros(g_numOfShootPtsAtOneSide*2+1,2);
g_maxShootCordisRedGoalPost    = zeros(g_numOfShootPtsAtOneSide*2+1,2);
g_minShootCordisBlueGoalPost   = zeros(g_numOfShootPtsAtOneSide*2+1,2);
g_maxShootCordisBlueGoalPost   = zeros(g_numOfShootPtsAtOneSide*2+1,2);

minShootDist = g_minShootDist+g_runDistForShoot;
maxShootDist = g_maxShootDist+g_runDistForShoot;
if(g_numOfShootPtsAtOneSide~=0)
    stepAngle = g_maxAngleOfShoot / g_numOfShootPtsAtOneSide;
end
%making points
minShootPts = zeros(g_numOfShootPtsAtOneSide*2+1,2);
maxShootPts = zeros(g_numOfShootPtsAtOneSide*2+1,2);

minShootPts(1,:) =[minShootDist 0];
maxShootPts(1,:) =[maxShootDist 0];
for pointCount = 1:g_numOfShootPtsAtOneSide
    t = stepAngle * pointCount;
    minShootPts(pointCount*2,:)  = [cosd(t) sind(t)]*minShootDist;
    minShootPts(pointCount*2+1,:)= [cosd(t) -sind(t)]*minShootDist;

    maxShootPts(pointCount*2,:)  = [cosd(t) sind(t)]*maxShootDist;
    maxShootPts(pointCount*2+1,:)= [cosd(t) -sind(t)]*maxShootDist;

end


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
    AreaArrayRed=zeros(NRed,1);
    for count=1:NRed
        AreaArrayRed(count) = regionPropertiesRed(count).Area;
    end

    [maxAreaRed indexRed] = max(AreaArrayRed);
    bbRed       =  max(floor(regionPropertiesRed(indexRed).BoundingBox),[1,1,1,1]);
    filledImageRed = regionPropertiesRed(indexRed).FilledImage;
else
    bbRed =  max(floor(regionPropertiesRed.BoundingBox),[1,1,1,1]);
    filledImageRed = regionPropertiesRed.FilledImage;
end

if(bbRed(1) < g_lengthOfGoalRegion)
    g_REDGoalPostCordiToTarget = [bbRed(1)+bbRed(3),bbRed(2)+bbRed(4)/2 ];
    g_minShootCordisRedGoalPost = [g_REDGoalPostCordiToTarget(1) + minShootPts(:,1) ,g_REDGoalPostCordiToTarget(2) + minShootPts(:,2)]; 
    g_maxShootCordisRedGoalPost = [g_REDGoalPostCordiToTarget(1) + maxShootPts(:,1) ,g_REDGoalPostCordiToTarget(2) + maxShootPts(:,2)]; 
    g_BBLeftGoalPost = bbRed;
    
else
    g_REDGoalPostCordiToTarget = [bbRed(1),bbRed(2)+bbRed(4)/2 ];
    g_minShootCordisRedGoalPost = [g_REDGoalPostCordiToTarget(1) - minShootPts(:,1) ,g_REDGoalPostCordiToTarget(2) + minShootPts(:,2)]; 
    g_maxShootCordisRedGoalPost = [g_REDGoalPostCordiToTarget(1) - maxShootPts(:,1) ,g_REDGoalPostCordiToTarget(2) + maxShootPts(:,2)]; 
    g_BBRightGoalPost = bbRed;
end
if(bbRed(1)<=0)bbRed(1)=1;end
if(bbRed(2)<=0)bbRed(2)=1;end


g_BW_RedGoalPost = logical(zeros([size_input_colored_image(1) size_input_colored_image(2)]));
g_BW_RedGoalPost(bbRed(2):bbRed(2)+bbRed(4)-1,bbRed(1):bbRed(1)+bbRed(3)-1) = filledImageRed;
g_BW_RedGoalPost_Inv = ~g_BW_RedGoalPost;

figure,imshow(g_BW_RedGoalPost);
hold on

plot(g_REDGoalPostCordiToTarget(1),g_REDGoalPostCordiToTarget(2),'rx')
plot(g_minShootCordisRedGoalPost(:,1),g_minShootCordisRedGoalPost(:,2),'wo')
plot(g_maxShootCordisRedGoalPost(:,1),g_maxShootCordisRedGoalPost(:,2),'bs')

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
    AreaArrayBlue  = zeros(NBlue,1);
    for count=1:NBlue
        AreaArrayBlue(count) = regionPropertiesBlue(count).Area;
    end

    [maxAreaBlue indexBlue] = max(AreaArrayBlue);
    bbBlue =  max(floor(regionPropertiesBlue(indexBlue).BoundingBox),[1,1,1,1]);
    filledImageBlue = regionPropertiesBlue(indexBlue).FilledImage;
else
    bbBlue =  max(floor(regionPropertiesBlue.BoundingBox),[1,1,1,1]);
    filledImageBlue = regionPropertiesBlue.FilledImage;
end

if(bbBlue(1) < g_lengthOfGoalRegion)
    g_BLUEGoalPostCordiToTarget = [bbBlue(1)+bbBlue(3),bbBlue(2)+bbBlue(4)/2 ];
    g_minShootCordisBlueGoalPost = [g_BLUEGoalPostCordiToTarget(1) + minShootPts(:,1) ,g_BLUEGoalPostCordiToTarget(2) + minShootPts(:,2)]; 
    g_maxShootCordisBlueGoalPost = [g_BLUEGoalPostCordiToTarget(1) + maxShootPts(:,1) ,g_BLUEGoalPostCordiToTarget(2) + maxShootPts(:,2)]; 
    g_BBLeftGoalPost = bbBlue;
else
    g_BLUEGoalPostCordiToTarget = [bbBlue(1),bbBlue(2)+bbBlue(4)/2 ];
    g_minShootCordisBlueGoalPost = [g_BLUEGoalPostCordiToTarget(1) - minShootPts(:,1) ,g_BLUEGoalPostCordiToTarget(2) + minShootPts(:,2)]; 
    g_maxShootCordisBlueGoalPost = [g_BLUEGoalPostCordiToTarget(1) - maxShootPts(:,1) ,g_BLUEGoalPostCordiToTarget(2) + maxShootPts(:,2)]; 
    g_BBRightGoalPost = bbBlue;
end

g_BW_BlueGoalPost = logical(zeros([size_input_colored_image(1) size_input_colored_image(2)]));
g_BW_BlueGoalPost(bbBlue(2):bbBlue(2)+bbBlue(4)-1,bbBlue(1):bbBlue(1)+bbBlue(3)-1) = filledImageBlue;
g_BW_BlueGoalPost_Inv = ~g_BW_BlueGoalPost;

figure,imshow(g_BW_BlueGoalPost);
hold on
plot(g_BLUEGoalPostCordiToTarget(1),g_BLUEGoalPostCordiToTarget(2),'bx')
plot(g_minShootCordisBlueGoalPost(:,1),g_minShootCordisBlueGoalPost(:,2),'go')
plot(g_maxShootCordisBlueGoalPost(:,1),g_maxShootCordisBlueGoalPost(:,2),'ys')



return
