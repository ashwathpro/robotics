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

g_robotBoxDimentions      = [40 40];
g_robotLargerBoxDimentions= [60 60];
g_maxDistBetweenCircles   = 60;
g_RobotBlackCircleMinArea = 200;
g_RobotWhiteCircleMinArea = 200;

% ***** will see later for resize
%g_BWresizeFactorOppRobo   = 1/4;


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

%robot white color (MIN)
g_minWhiteColorRobot = [180 200 200];

%robot black color (MAX)
g_maxBlackColorRobot = [60 60 70];

%red Robot
g_color_min_red_Robot = [80 0 0];
g_color_max_red_Robot = [255 150 160];
g_red_over_green_Robot_red = 35;
g_red_over_blue_Robot_red = 60;

%Blue Robot
g_color_min_blue_Robot = [0 0 80];
g_color_max_blue_Robot = [70 70 255];
g_blue_over_green_Robot_blue = 30 ;
g_blue_over_red_Robot_blue = 30;

%%
input_colored_image = getsnapshot(vid);
%input_colored_image=imread('withBall.jpg');
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
    fprintf('******* ERROR: Opponnent robot not detected *******\n')
else
    figure,imshow(g_BWOppRobot)
    
    hold on
    plot(g_OpponentRobotBlackCordi(1),g_OpponentRobotBlackCordi(2),'rx')
    plot(g_OpponentRobotWhiteCordi(1),g_OpponentRobotWhiteCordi(2),'bx')
    
end

return
