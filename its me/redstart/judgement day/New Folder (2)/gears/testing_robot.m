close all;
clc
global input_colored_image;
global size_input_colored_image;

%** global g_ourRobotColorIndex   % red is 1...blue is 2
%** global g_BW_RedGoalPost_Inv
%** global g_BW_BlueGoalPost_Inv

global g_BWOppRobot
%% Robot Morphology
global g_robotBoxDimentions
global g_robotLargerBoxDimentions
% ***** will see later for resize
%global g_BWresizeFactorOppRobo

% ??? [pras] i guess the follwoing variables are not require

global g_RedRobotBlackCordi;
global g_RedRobotWhiteCordi;

global g_BlueRobotBlackCordi;
global g_BlueRobotWhiteCordi;

global g_ourBlackIsFront ; % if black color is front then take it as 1 else 0
global g_OurRobotBlackCordi;
global g_OurRobotWhiteCordi;

global g_OurRobotBlackCircleDiaMin
global g_OurRobotBlackCircleDiaMax
global g_OurRobotBlackCircleTol

global g_OurRobotWhiteCircleDiaMin
global g_OurRobotWhiteCircleDiaMax
global g_OurRobotWhiteCircleTol


global g_OpponentRobotCordi
global g_minAreaOfOppRobo
%oppnnent robot bulging
global opponnentRoboBulgSize;

%time out for robot 
global ourRoboTimeoutSec

g_ourBlackIsFront = 0;%**** for the time being i am taking black circle as front cordi

g_robotBoxDimentions      = [40 40];
g_robotLargerBoxDimentions= [60 60];
g_maxDistBetweenCircles   = 60;
g_RobotBlackCircleMinArea = 200;
g_RobotWhiteCircleMinArea = 200;
%black circle of our robot
g_OurRobotBlackCircleDiaMin = 30;
g_OurRobotBlackCircleDiaMax = 45;
g_OurRobotBlackCircleTol    = 0.25;

%white circle of our robot
g_OurRobotWhiteCircleDiaMin = 30;
g_OurRobotWhiteCircleDiaMax = 45;
g_OurRobotWhiteCircleTol    = 0.25;

% ***** will see later for resize
%g_BWresizeFactorOppRobo   = 1/4;
% DUMMY VALUES FOR ROBOT
g_OurRobotBlackCordi = [50 50];
g_OurRobotWhiteCordi = [50 50];
%% robot colors
%white and black clolr
global g_minWhiteColorRobot
global g_maxBlackColorRobot
%robot red color
global g_color_min_red_Robot
global g_color_max_red_Robot
global g_red_over_green_Robot_red
global g_red_over_blue_Robot_red
%robot blue color
global g_color_min_blue_Robot
global g_color_max_blue_Robot
global g_blue_over_green_Robot_blue
global g_blue_over_red_Robot_blue
global g_ourRobotColorIndex
%robot white color (MIN)
g_minWhiteColorRobot = [150 150 150];

%robot black color (MAX)
g_maxBlackColorRobot = [70 80 90];

%red Robot
g_color_min_red_Robot = [80 0 0];
g_color_max_red_Robot = [255 120 100];
g_red_over_green_Robot_red = 35;
g_red_over_blue_Robot_red = 60;

%Blue Robot
g_color_min_blue_Robot = [0 0 90];
g_color_max_blue_Robot = [90 90 255];
g_blue_over_green_Robot_blue = 20 ;
g_blue_over_red_Robot_blue = 20;

%
g_minAreaOfOppRobo = 200;

opponnentRoboBulgSize = 15;

%
ourRoboTimeoutSec =5;
%%

input_colored_image = getsnapshot(vid);
%input_colored_image=imread('withBall2.jpg');
size_input_colored_image=size(input_colored_image);

% jut giving dummy values to robot cordinates
g_RedRobotBlackCordi = [size_input_colored_image(2), size_input_colored_image(1)]/2;
g_RedRobotWhiteCordi = [size_input_colored_image(2), size_input_colored_image(1)]/2;
g_BlueRobotBlackCordi =[size_input_colored_image(2), size_input_colored_image(1)]/2;
g_BlueRobotWhiteCordi = [size_input_colored_image(2), size_input_colored_image(1)]/2;

%% our robot


figure('Name','input_colored_image'),imshow(input_colored_image)

%black circle
BWOurRobotBlack =(((input_colored_image(:,:,1)<=g_maxBlackColorRobot(1))) ...
    &((input_colored_image(:,:,2)<=g_maxBlackColorRobot(2))) ...
    &((input_colored_image(:,:,3)<=g_maxBlackColorRobot(3))));
BWOurRobotBlack = imclose(BWOurRobotBlack,strel('square',5));

figure,imshow(BWOurRobotBlack)
[ BlackCount_circles, BlackCenters,BlackDiameters] = findcircles(BWOurRobotBlack,g_OurRobotBlackCircleTol)
foundBlackCircleFlag = 0;
for count = 1: BlackCount_circles
    if((BlackDiameters(count) >=g_OurRobotBlackCircleDiaMin )& (BlackDiameters(count) <=g_OurRobotBlackCircleDiaMax ) )
        foundBlackCircleFlag =1 ;
        hold on
       plot(BlackCenters(count,2),BlackCenters(count,1),'rx')
    end
end
if(foundBlackCircleFlag == 0)
    fprintf('\n ****** Error :Black Color Circle is not in range given\n ')
    return
end

%white circle
BWOurRobotWhite =(((input_colored_image(:,:,1)>=g_minWhiteColorRobot(1))) ...
        &((input_colored_image(:,:,2)>=g_minWhiteColorRobot(2))) ...
        &((input_colored_image(:,:,3)>=g_minWhiteColorRobot(3))));
    BWOurRobotWhite = imclose(BWOurRobotWhite,strel('square',5));

figure('Name','BW_whiteImage'),imshow(BWOurRobotWhite)
[ WhiteCount_circles, WhiteCenters,WhiteDiameters] = findcircles(BWOurRobotWhite,g_OurRobotWhiteCircleTol)


foundWhiteCircleFlag = 0;
if(WhiteCount_circles == 0)
    fprintf('\n ****** Error :No White circle found\n ')
    return
end

for count = 1: WhiteCount_circles
    if((WhiteDiameters(count) >=g_OurRobotWhiteCircleDiaMin )& (WhiteDiameters(count) <=g_OurRobotWhiteCircleDiaMax ) )
        foundWhiteCircleFlag =1 ;
        hold on
       plot(WhiteCenters(count,2),WhiteCenters(count,1),'rx')
    end
end
if(foundWhiteCircleFlag == 0)
    fprintf('\n ****** Error :White Color Circle is not in range given\n ')
    return
end

if(g_ourRobotColorIndex==1)% our robot color is red
    BW_OurRobot=((input_colored_image(:,:,1)>=input_colored_image(:,:,2)+g_red_over_green_Robot_red) ...
        &((input_colored_image(:,:,1)>=input_colored_image(:,:,3)+g_red_over_blue_Robot_red)) ...
        &((input_colored_image(:,:,1)>=g_color_min_red_Robot(1))) ...
        &((input_colored_image(:,:,2)<=g_color_max_red_Robot(2))) ...
        &((input_colored_image(:,:,3)<=g_color_max_red_Robot(3))));

    BW_OurRobot = BW_OurRobot & g_BW_RedGoalPost_Inv;

elseif(g_ourRobotColorIndex==2)% our robot color is blue
    BW_OurRobot=((input_colored_image(:,:,3)>=input_colored_image(:,:,2)+g_blue_over_green_Robot_blue) ...
        &((input_colored_image(:,:,3)>=input_colored_image(:,:,1)+g_blue_over_red_Robot_blue)) ...
        &((input_colored_image(:,:,1)<=g_color_max_blue_Robot(1))) ...
        &((input_colored_image(:,:,2)<=g_color_max_blue_Robot(2))) ...
        &((input_colored_image(:,:,3)>=g_color_min_blue_Robot(3))));

    BW_OurRobot = (BW_OurRobot & g_BW_BlueGoalPost_Inv);
else
    error('\n******* ERROR: Select Our color *******\n')

end%end of if(g_ourRobotColorIndex==1)

figure,imshow(BW_OurRobot)



getOurRoboCordi(1)
getOurRoboCordi(0)

hold on
plot(g_OurRobotBlackCordi(1),g_OurRobotBlackCordi(2),'wx')
plot(g_OurRobotWhiteCordi(1),g_OurRobotWhiteCordi(2),'rx')
%% opponent robot
detectedRobot = getOpponentRoboCordi(1);
if(detectedRobot==0)
    fprintf('******* ERROR: Opponnent robot not detected *******\n')
else
    figure('Name','BW_Oppo_color'),imshow(g_BWOppRobot)

    hold on
    plot(g_OpponentRobotCordi(1),g_OpponentRobotCordi(2),'rx')
    
end

return
