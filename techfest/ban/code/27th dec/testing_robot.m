close all;
clc
global input_colored_image;
global size_input_colored_image;

%** global g_ourRobotColorIndex   % red is 1...blue is 2
%** global g_BW_RedGoalPost_Inv
%** global g_BW_BlueGoalPost_Inv

global g_BWOpponentRobot
%% Robot Morphology
global g_robotBoxDimentions
global g_robotLargerBoxDimentions
% ***** will see later for resize
%global g_BWresizeFactorOppRobo

% *****global g_maxDistBetweenCircles
% *****global g_RobotBlackCircleMinArea
% *****global g_RobotWhiteCircleMinArea

% ??? [pras] i guess the follwoing variables are not require

global g_RedRobotBlackCordi; 
global g_RedRobotWhiteCordi;

global g_BlueRobotBlackCordi; 
global g_BlueRobotWhiteCordi;

global g_OurRobotBlackCordi; 
global g_OurRobotWhiteCordi;
global g_OpponentRobotBlackCordi; 
global g_OpponentRobotWhiteCordi;



g_robotBoxDimentions      = int16([40 40]);
g_robotLargerBoxDimentions= int16([60 60]);
g_maxDistBetweenCircles   = 60;
g_RobotBlackCircleMinArea = 200;
g_RobotWhiteCircleMinArea = 200;

% ***** will see later for resize
%g_BWresizeFactorOppRobo   = 1/4;


%% robot colors
global g_minWhiteColorRobot
global g_maxBlackColorRobot


global g_color_min_red_Robot
global g_color_max_red_Robot
global g_red_over_green_Robot_red
global g_red_over_blue_Robot_red

global g_color_min_blue_Robot
global g_color_max_blue_Robot
global g_blue_over_green_Robot_blue
global g_blue_over_red_Robot_blue

%robot white color (MIN)
g_minWhiteColorRobot = [200 200 100];

%robot black color (MAX)
g_maxBlackColorRobot = [40 50 37];

%red Robot
g_color_min_red_Robot = [180 0 0];
g_color_max_red_Robot = [255 180 120];
g_red_over_green_Robot_red = 60;
g_red_over_blue_Robot_red = 100;

%Blue Robot
g_color_min_blue_Robot = [0 0 180];
g_color_max_blue_Robot = [120 100 255];
g_blue_over_green_Robot_blue = 60 ;
g_blue_over_red_Robot_blue = 70;


%%
%input_colored_image = getsnapshot(vid);
input_colored_image=imread('withBall.jpg');
size_input_colored_image=size(input_colored_image);
%% our robot

getOurRoboCordi(1)
getOurRoboCordi(0)
figure,imshow(input_colored_image)
hold on
plot(g_OurRobotBlackCordi(1),g_OurRobotBlackCordi(2),'wx')
plot(g_OurRobotWhiteCordi(1),g_OurRobotWhiteCordi(2),'rx')
%% opponent robot
detectedRobot = getOpponentRoboCordi(1);
if(detectedRobot==0)
    fprintf('******* ERROR: Opponnent robot not detected *******')
else
    
    hold on
    plot(g_OpponentRobotBlackCordi(1),g_OpponentRobotBlackCordi(2),'rx')
    plot(g_OpponentRobotWhiteCordi(1),g_OpponentRobotWhiteCordi(2),'bx')
    
end

return

%% BLUE ROBOT

BW_BlueRobot=imclose(BW_BlueRobot, strel('square',5));
BW_BlueRobot = BW_BlueRobot & g_BW_BlueGoalPost_Inv;
figure,imshow(BW_BlueRobot);

[LabledImageBlue,NBlue] = bwlabel(BW_BlueRobot,8);
if(NBlue==0)
    error('no blue color detected')
end
regionPropertiesBlue = regionprops(LabledImageBlue,'Area','BoundingBox');

if(NBlue~=1)
    AreaArrayBlue(NBlue)=0;
    for count=1:NBlue
        AreaArrayBlue(count) = regionPropertiesBlue(count).Area;
    end

    [maxAreaBlue indexBlue] = max(AreaArrayBlue);
    bbBlue =  floor(regionPropertiesBlue(indexBlue).BoundingBox);
else
    bbBlue =  floor(regionPropertiesBlue.BoundingBox);
end

BWBlueRobotWhite=(((input_colored_image(bbBlue(2):bbBlue(2)+bbBlue(4),bbBlue(1):bbBlue(1)+bbBlue(3),1)>=g_minWhiteColorRobot(1))) ...
    &((input_colored_image(bbBlue(2):bbBlue(2)+bbBlue(4),bbBlue(1):bbBlue(1)+bbBlue(3),2)>=g_minWhiteColorRobot(2))) ...
    &((input_colored_image(bbBlue(2):bbBlue(2)+bbBlue(4),bbBlue(1):bbBlue(1)+bbBlue(3),3)>=g_minWhiteColorRobot(3))));

[LabledImageBlueW,NBlueW] = bwlabel(BWBlueRobotWhite,8);
if(NBlueW==0)
    error('no white color detected on blue robot')
end
regionPropertiesBlueW = regionprops(LabledImageBlueW,'Centroid','Area');
if(NBlueW~=1)
    AreaArrayBlueW(NBlueW)=0;
    for count=1:NBlueW
        AreaArrayBlueW(count) = regionPropertiesBlueW(count).Area;
    end

    [maxAreaBlueW indexBlueW] = max(AreaArrayBlueW);
    g_BlueRobotWhiteCordi =  int16(regionPropertiesBlueW(indexBlueW).Centroid);
else
    g_BlueRobotWhiteCordi =  int16(regionPropertiesBlueW.Centroid);
end

figure,imshow(BWBlueRobotWhite)

BWBlueRobotBlack=(((input_colored_image(bbBlue(2):bbBlue(2)+bbBlue(4),bbBlue(1):bbBlue(1)+bbBlue(3),1)<=g_maxBlackColorRobot(1))) ...
    &((input_colored_image(bbBlue(2):bbBlue(2)+bbBlue(4),bbBlue(1):bbBlue(1)+bbBlue(3),2)<=g_maxBlackColorRobot(2))) ...
    &((input_colored_image(bbBlue(2):bbBlue(2)+bbBlue(4),bbBlue(1):bbBlue(1)+bbBlue(3),3)<=g_maxBlackColorRobot(3))));

figure,imshow(BWBlueRobotBlack)

[LabledImageBlueB,NBlueB] = bwlabel(BWBlueRobotBlack,8);
if(NBlueB==0)
    error('no black color detected on blue robot')
end
regionPropertiesBlueB = regionprops(LabledImageBlueB,'Centroid','Area');
if(NBlueB~=1)
    AreaArrayBlueB(NBlueB)=0;
    for count=1:NBlueB
        AreaArrayBlueB(count) = regionPropertiesBlueB(count).Area;
    end

    [maxAreaBlueB indexBlueB] = max(AreaArrayBlueB);
    g_BlueRobotBlackCordi =  int16(regionPropertiesBlueB(indexBlueB).Centroid);
else
    g_BlueRobotBlackCordi =  int16(regionPropertiesBlueB.Centroid);
end


return


BW=(((input_colored_image(:,:,1)>=color_min_white(1))) ...
    &((input_colored_image(:,:,2)>=color_min_white(2))) ...
    &((input_colored_image(:,:,3)>=color_min_white(3))));
BW=imclose(BW, strel('square',5));


figure,imshow(BW)

%[ count_circles, centers,diameters] = findcircles(~BW,tolcirc_robot)
return
%%
getting_robot_cordinates(1);


if(ROBOT_FRONT_CORDINATES(1)>=ROBOT_BACK_CORDINATES(1))
    ROBOT_UPPER_CORDINATES(1)=ROBOT_BACK_CORDINATES(1);
    ROBOT_LOWER_CORDINTES(1)=ROBOT_FRONT_CORDINATES(1);
else
    ROBOT_UPPER_CORDINATES(1)=ROBOT_FRONT_CORDINATES(1);
    ROBOT_LOWER_CORDINTES(1)=ROBOT_BACK_CORDINATES(1);
end

if(ROBOT_FRONT_CORDINATES(2)>=ROBOT_BACK_CORDINATES(2))
    ROBOT_UPPER_CORDINATES(2)=ROBOT_BACK_CORDINATES(2);
    ROBOT_LOWER_CORDINTES(2)=ROBOT_FRONT_CORDINATES(2);
else
    ROBOT_UPPER_CORDINATES(2)=ROBOT_FRONT_CORDINATES(2);
    ROBOT_LOWER_CORDINTES(2)=ROBOT_BACK_CORDINATES(2);
end


upper_box_point=ROBOT_UPPER_CORDINATES-robot_box_dimentions;
lower_box_point=ROBOT_LOWER_CORDINTES+robot_box_dimentions;



if(upper_box_point(1)<=1) upper_box_point(1)=1;end
if(upper_box_point(2)<=1) upper_box_point(2)=1;end

size_input_colored_image=size(input_colored_image);

if(lower_box_point(1)>=size_input_colored_image(2)) lower_box_point(1)=size_input_colored_image(2);end
if(lower_box_point(2)>=size_input_colored_image(1)) lower_box_point(2)=size_input_colored_image(1);end

int_upper_box_point=int16(upper_box_point);
int_lower_box_point=int16(lower_box_point);

A=input_colored_image(int_upper_box_point(2):int_lower_box_point(2),int_upper_box_point(1):int_lower_box_point(1),:);
figure,imshow(A)

