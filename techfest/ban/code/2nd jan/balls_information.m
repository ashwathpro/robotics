function  [no_of_balls, balls_coodinates]=balls_information(inputColoredImage)
%it returns no_of_balls, balls_coodinates as global variables;
% ?? can v remove the following global variables
%global no_of_balls;
%global balls_coodinates;


no_of_balls=0;
balls_coodinates=[];
hole_cordinates=[];

%% color 1: yellow
global color_min_yellowball;
global color_max_yellowball;
global red_over_blue_yellowBall;
global green_over_blue_yellowBall;

BW_YELLOW=((inputColoredImage(:,:,1)>=color_min_yellowball(1)) ...
      &(inputColoredImage(:,:,2)>=color_min_yellowball(2)) ...
      &(inputColoredImage(:,:,3)<=color_max_yellowball(3))...
      &(inputColoredImage(:,:,1)>=inputColoredImage(:,:,3)+red_over_blue_yellowBall) ...
      &((inputColoredImage(:,:,2)>=inputColoredImage(:,:,3))+green_over_blue_yellowBall));
   BW_YELLOW=imclose(BW_YELLOW, strel('square',5));
  
[no_of_balls(1), yellowball_cordinates]=balls_centroid(BW_YELLOW);

if(no_of_balls(1)==0) fprintf('  *** No YELLOW ball detected *****\n');
else
%balls_coodinates(sum(no_of_balls(1:2))+1:sum(no_of_balls),:)=yellowball_cordinates;
balls_coodinates=yellowball_cordinates;
end
%figure,imshow(BW_YELLOW);

%% color 2: Orange Balls
global color_min_orangeball;
global color_max_orangeball;
global red_over_green_orangeBall;
global red_over_blue_orangeBall;
global green_over_blue_orangeBall

BW_ORANGE=((inputColoredImage(:,:,1)>=color_min_orangeball(1)) ...
      &(inputColoredImage(:,:,2)<=color_max_orangeball(2)) ...
      &(inputColoredImage(:,:,3)<=color_max_orangeball(3))...
      &(inputColoredImage(:,:,1)>=inputColoredImage(:,:,2)+red_over_green_orangeBall) ...
      &((inputColoredImage(:,:,1)>=inputColoredImage(:,:,3)+red_over_blue_orangeBall)) ...
      &((inputColoredImage(:,:,2)>=inputColoredImage(:,:,3)+green_over_blue_orangeBall)));
 BW_ORANGE=imclose(BW_ORANGE, strel('square',5));

[no_of_balls(2), red_ball_cordinates]=balls_centroid(BW_ORANGE);
if(no_of_balls(2)==0) fprintf('  *** No ORANGE ball detected *****\n');end
balls_coodinates=cat(1,balls_coodinates,red_ball_cordinates);
%figure,imshow(BW_ORANGE)



