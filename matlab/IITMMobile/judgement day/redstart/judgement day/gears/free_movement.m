function [numOfBalls, allBallsCordinates]=free_movement()
numOfBalls=[];
allBallsCordinates=[];
%% global values

global size_input_colored_image
global vid
global input_colored_image;
global g_ourRobotFrontCordi;
global freeMovementndex

global g_REDGoalPostCordiToTarget
global g_BLUEGoalPostCordiToTarget
global g_ourRobotColorIndex   % red is 1...blue is 2
%% Relax all constrains to detec a ball
% color 1: yellow ball
global color_min_yellowball;
global color_max_yellowball;
global red_over_blue_yellowBall;
global green_over_blue_yellowBall;

% color 2: Orange Balls
global color_min_orangeball;
global color_max_orangeball;
global red_over_green_orangeBall;
global red_over_blue_orangeBall;
global green_over_blue_orangeBall

global tolcirc_ball;
global minBallDia
global maxBallDia

%% loosing the color constrains of balls
%yellow color ball
color_min_yellowball       = color_min_yellowball - [2 2 2];
color_max_yellowball       = color_max_yellowball + [2 2 2];
red_over_blue_yellowBall   = red_over_blue_yellowBall - 3;
green_over_blue_yellowBall = green_over_blue_yellowBall -3;

% orange ball
color_min_orangeball       = color_min_orangeball - [2 2 2];
color_max_orangeball       = color_max_orangeball + [2 2 2];
red_over_green_orangeBall  = red_over_green_orangeBall -3;
red_over_blue_orangeBall   = red_over_blue_orangeBall  -3;
green_over_blue_orangeBall = green_over_blue_orangeBall -3;

tolcirc_ball = tolcirc_ball + 0.02;
minBallDia   = minBallDia - 0.3;
maxBallDia   = maxBallDia + 0.3;

% calling ball info
input_colored_image=getsnapshot(vid);
[numOfBalls, allBallsCordinates]=balls_information(input_colored_image,2);
if(sum(numOfBalls)~=0) return;end

freeMoveMentCordi = g_ourRobotFrontCordi;
fprintf('\n #########    FREE MOVE :-)  #############\n')


if(freeMovementndex==1)
    freeMoveMentCordi(2,:) = [size_input_colored_image(2)/4 size_input_colored_image(1)/2];
    freeMovementndex = freeMovementndex+1;
elseif(freeMovementndex==2)
    freeMoveMentCordi(2,:) = [size_input_colored_image(2)/(8/3) size_input_colored_image(1)/4];
    freeMovementndex = freeMovementndex+1;
elseif(freeMovementndex==3)
    freeMoveMentCordi(2,:) = [size_input_colored_image(2)/2 size_input_colored_image(1)/2];
    freeMovementndex = freeMovementndex+1;
elseif(freeMovementndex==4)
    freeMoveMentCordi(2,:) = [size_input_colored_image(2)/(8/3) size_input_colored_image(1)/(4/3)];
    freeMovementndex = 1;
end

if(g_ourRobotColorIndex==1)
   goalPostCordi = g_BLUEGoalPostCordiToTarget;
else
    goalPostCordi = g_REDGoalPostCordiToTarget;
end

if( goalPostCordi(1) > size_input_colored_image(2)/2)
    freeMoveMentCordi(2,1) = size_input_colored_image(2)- freeMoveMentCordi(2,1);
end

freeMoveMentCordi(3,:) = freeMoveMentCordi(2,:);
successful_grab_drop(3,freeMoveMentCordi,1,3);

% calling ball info
input_colored_image=getsnapshot(vid);
[numOfBalls, allBallsCordinates]=balls_information(input_colored_image,2);

