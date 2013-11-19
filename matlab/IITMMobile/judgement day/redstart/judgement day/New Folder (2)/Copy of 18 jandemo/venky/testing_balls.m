
global vid
global input_colored_image;


input_colored_image = getsnapshot(vid);
%input_colored_image =imread('withball2.jpg');
global tolcirc_ball;
global minBallDia
global maxBallDia
global ballBulgeThickness
global ballCornerCutDist % we will see balls in center of arena first

minBallDia=10;
maxBallDia=30;
tolcirc_ball=0.2;
ballBulgeThickness = 20;

global g_REDGoalPostCordiToTarget
global g_BLUEGoalPostCordiToTarget

ballCornerCutDist = round(min(min(g_REDGoalPostCordiToTarget,g_BLUEGoalPostCordiToTarget))/2);

clc
close all
%% color 1: yellow
global color_min_yellowball;
global color_max_yellowball;
global red_over_blue_yellowBall;
global green_over_blue_yellowBall;

color_min_yellowball=[80 80 0];
color_max_yellowball=[255 255 220];
red_over_blue_yellowBall=30;
green_over_blue_yellowBall=30;

BW_YELLOW=((input_colored_image(:,:,1)>=color_min_yellowball(1)) ...
      &(input_colored_image(:,:,2)>=color_min_yellowball(2)) ...
      &(input_colored_image(:,:,3)<=color_max_yellowball(3))...
      &(input_colored_image(:,:,1)>=input_colored_image(:,:,3)+red_over_blue_yellowBall) ...
      &((input_colored_image(:,:,2)>=input_colored_image(:,:,3))+green_over_blue_yellowBall));
   BW_YELLOW=imclose(BW_YELLOW, strel('square',5));
   
   figure,imshow(BW_YELLOW);
   [ count_circles_yellow, centers_yellow,diameters_yellow] = findcircles(BW_YELLOW,tolcirc_ball)
   [no_of_yellowballs,ball_cordinates] =balls_centroid(BW_YELLOW)
    
   
%% color 2: Orange ball 
global color_min_orangeball;
global color_max_orangeball;
global red_over_green_orangeBall;
global red_over_blue_orangeBall;
global green_over_blue_orangeBall

color_min_orangeball=[160 0 0];
color_max_orangeball=[255 150 90];
red_over_green_orangeBall=100;
red_over_blue_orangeBall=100;
green_over_blue_orangeBall =10;

BW_ORANGE=((input_colored_image(:,:,1)>=color_min_orangeball(1)) ...
      &(input_colored_image(:,:,2)<=color_max_orangeball(2)) ...
      &(input_colored_image(:,:,3)<=color_max_orangeball(3))...
      &(input_colored_image(:,:,1)>=input_colored_image(:,:,2)+red_over_green_orangeBall) ...
      &((input_colored_image(:,:,1)>=input_colored_image(:,:,3)+red_over_blue_orangeBall)) ...
      &((input_colored_image(:,:,2)>=input_colored_image(:,:,3)+green_over_blue_orangeBall)));
 BW_ORANGE=imclose(BW_ORANGE, strel('square',5));

figure,imshow(BW_ORANGE)
[ count_circles_ORANGE, centers_ORANGE,diameters_ORANGE] = findcircles(BW_ORANGE,tolcirc_ball)
 [no_of_orangeballs,ball_cordinates] =balls_centroid(BW_ORANGE)
 

