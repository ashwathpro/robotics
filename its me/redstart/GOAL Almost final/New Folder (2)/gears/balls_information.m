function  [numOfBalls, allBallsCordinates]=balls_information(inputColoredImage,imageCutIndex)
%it returns numOfBalls, allBallsCordinates as global variables;
% ?? can v remove the following global variables
%global numOfBalls;
%global allBallsCordinates;
sizeInputColoredImage = size(inputColoredImage);
global ballCornerCutDist % we will see balls in center of arena first
global g_BBLeftGoalPost; % 
global g_BBRightGoalPost;
%check image has to cut
if(imageCutIndex==0) % all sides of image has to remove
    %TOP side
    inputColoredImage(1:ballCornerCutDist,:,:)=0;
    %BOTTOM side
    inputColoredImage(sizeInputColoredImage(1)-ballCornerCutDist:sizeInputColoredImage(1),:,:)=0;
    %LEFT
    inputColoredImage(:,1:ballCornerCutDist,:)=0;
    %RIGHT side
    inputColoredImage(:,sizeInputColoredImage(2)-ballCornerCutDist:sizeInputColoredImage(2),:)=0;
    
    %Near Left Side Goal Post
    tempXtop = max(g_BBLeftGoalPost(2) - ballCornerCutDist,ballCornerCutDist);
    tempXbottom = min(g_BBLeftGoalPost(2)+g_BBLeftGoalPost(4) + ballCornerCutDist,sizeInputColoredImage(1)-ballCornerCutDist);
    inputColoredImage(tempXtop :tempXbottom,1: g_BBLeftGoalPost(1)+g_BBLeftGoalPost(3),:)=0;
    
    %Near Right Side Goal Post
    tempXtop = max(g_BBRightGoalPost(2) - ballCornerCutDist,ballCornerCutDist);
    tempXbottom = min(g_BBRightGoalPost(2)+g_BBRightGoalPost(4) + ballCornerCutDist,sizeInputColoredImage(1)-ballCornerCutDist);
    inputColoredImage(tempXtop :tempXbottom,g_BBRightGoalPost(1):sizeInputColoredImage(2),:)=0;
    
   
elseif(imageCutIndex==1) % cut only corners
    %TOP Left corner
    inputColoredImage(1:ballCornerCutDist,1:ballCornerCutDist,:)=0;
    %TOP Right corner
    inputColoredImage(1:ballCornerCutDist,sizeInputColoredImage(2)-ballCornerCutDist:sizeInputColoredImage(2),:,:)=0;
    %BOTTOM Left corner
    inputColoredImage(sizeInputColoredImage(1)-ballCornerCutDist:sizeInputColoredImage(1),1:ballCornerCutDist,:)=0;
    %BOTTOM Right corner
    inputColoredImage(sizeInputColoredImage(1)-ballCornerCutDist:sizeInputColoredImage(1)...
        ,sizeInputColoredImage(2)-ballCornerCutDist:sizeInputColoredImage(2),:,:)=0;
    
    %Near Left Side Goal Post
    tempXtop = max(g_BBLeftGoalPost(2) - ballCornerCutDist,ballCornerCutDist);
    tempXbottom = min(g_BBLeftGoalPost(2)+g_BBLeftGoalPost(4) + ballCornerCutDist,sizeInputColoredImage(1)-ballCornerCutDist);
    inputColoredImage(tempXtop :tempXbottom,1: g_BBLeftGoalPost(1)+g_BBLeftGoalPost(3),:)=0;
    
    %Near Right Side Goal Post
    tempXtop = max(g_BBRightGoalPost(2) - ballCornerCutDist,ballCornerCutDist);
    tempXbottom = min(g_BBRightGoalPost(2)+g_BBRightGoalPost(4) + ballCornerCutDist,sizeInputColoredImage(1)-ballCornerCutDist);
    inputColoredImage(tempXtop :tempXbottom,g_BBRightGoalPost(1):sizeInputColoredImage(2),:)=0;
end

%figure,imshow(inputColoredImage)
numOfBalls=0;
allBallsCordinates=[];
hole_cordinates=[];

%% color 1: yellow balls
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
  
[numOfBalls(1), yellowball_cordinates]=balls_centroid(BW_YELLOW);

if(numOfBalls(1)==0) fprintf('  *** No YELLOW ball detected *****\n');
else
%allBallsCordinates(sum(numOfBalls(1:2))+1:sum(numOfBalls),:)=yellowball_cordinates;
allBallsCordinates=yellowball_cordinates;
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

[numOfBalls(2), red_ball_cordinates]=balls_centroid(BW_ORANGE);
if(numOfBalls(2)==0) fprintf('  *** No ORANGE ball detected *****\n');end
allBallsCordinates=cat(1,allBallsCordinates,red_ball_cordinates);
%figure,imshow(BW_ORANGE)



