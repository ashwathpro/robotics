
global vid
global input_colored_image;
global no_of_balls;
global balls_coodinates;

input_colored_image = getsnapshot(vid);
%input_colored_image =imread('withball.jpg');
global tolcirc_ball;
global ball_dia
global ball_dia_tol

ball_dia=16;
ball_dia_tol=4;
tolcirc_ball=0.35;
clc
close all
%% color 1: yellow
global color_min_yellowball;
global color_max_yellowball;
global red_over_blue_yellowBall;
global green_over_blue_yellowBall;

color_min_yellowball=[160 170 0];
color_max_yellowball=[255 255 100];
red_over_blue_yellowBall=50;
green_over_blue_yellowBall=60;

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

color_min_orangeball=[150 0 0];
color_max_orangeball=[255 150 70];
red_over_green_orangeBall=50;
red_over_blue_orangeBall=150;
green_over_blue_orangeBall =20;

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
 

