function detectedRobot = getOpponentRoboCordi(full_image)

%% global variables
global vid
global input_colored_image;
global size_input_colored_image;
global g_ourRobotColorIndex   % red is 1...blue is 2
global g_BW_RedGoalPost_Inv
global g_BW_BlueGoalPost_Inv
global opponnentRoboBulgSize;
global g_BW_RedGoalPost
global g_BW_BlueGoalPost
%% Robot Morphology

global g_robotLargerBoxDimentions
% *****global g_maxDistBetweenCircles
% *****global g_RobotBlackCircleMinArea
% *****global g_RobotWhiteCircleMinArea

global g_OpponentRobotCordi
global g_minAreaOfOppRobo

%for making BW image for opponent robot
% ***** will see later for resize
% global g_BWresizeFactorOppRobo
%  **global g_BWOppRobotResized
global g_BWOppRobot

%% robot colors
global g_color_min_red_Robot
global g_color_max_red_Robot
global g_red_over_green_Robot_red
global g_red_over_blue_Robot_red

global g_color_min_blue_Robot
global g_color_max_blue_Robot
global g_blue_over_green_Robot_blue
global g_blue_over_red_Robot_blue

%%
detectedRobot = 0;
%input_colored_image=imread('withBall2.jpg');
input_colored_image=getsnapshot(vid);
if(full_image==0)
    upper_box_point = max( g_OpponentRobotCordi-g_robotLargerBoxDimentions,[1 ,1]);
    lower_box_point= min (g_OpponentRobotCordi+ g_robotLargerBoxDimentions,...
        [size_input_colored_image(2),size_input_colored_image(1)]);
else % for full image
    upper_box_point = [1 1];
    lower_box_point = [size_input_colored_image(2) size_input_colored_image(1)];
end %end of full image
upper_box_point = round(upper_box_point);
lower_box_point = round(lower_box_point);

if(g_ourRobotColorIndex==2)% our robot color is blue
    % opponent color will be red
    BWOpponentRobot=((input_colored_image(upper_box_point(2):lower_box_point(2),upper_box_point(1):lower_box_point(1),1)>= ...
        input_colored_image(upper_box_point(2):lower_box_point(2),upper_box_point(1):lower_box_point(1),2)+g_red_over_green_Robot_red) ...
        &((input_colored_image(upper_box_point(2):lower_box_point(2),upper_box_point(1):lower_box_point(1),1)>=...
        input_colored_image(upper_box_point(2):lower_box_point(2),upper_box_point(1):lower_box_point(1),3)+g_red_over_blue_Robot_red)) ...
        &((input_colored_image(upper_box_point(2):lower_box_point(2),upper_box_point(1):lower_box_point(1),1)>=g_color_min_red_Robot(1))) ...
        &((input_colored_image(upper_box_point(2):lower_box_point(2),upper_box_point(1):lower_box_point(1),2)<=g_color_max_red_Robot(2))) ...
        &((input_colored_image(upper_box_point(2):lower_box_point(2),upper_box_point(1):lower_box_point(1),3)<=g_color_max_red_Robot(3))));
    %*********** can b removed later
    BWOpponentGoalPost_Inv = g_BW_RedGoalPost_Inv;

elseif(g_ourRobotColorIndex==1)% our robot color is red
    % opponent color will be blue
    BWOpponentRobot=((input_colored_image(upper_box_point(2):lower_box_point(2),upper_box_point(1):lower_box_point(1),3)>=...
        input_colored_image(upper_box_point(2):lower_box_point(2),upper_box_point(1):lower_box_point(1),2)+g_blue_over_green_Robot_blue) ...
        &((input_colored_image(upper_box_point(2):lower_box_point(2),upper_box_point(1):lower_box_point(1),3)>=...
        input_colored_image(upper_box_point(2):lower_box_point(2),upper_box_point(1):lower_box_point(1),1)+g_blue_over_red_Robot_blue)) ...
        &((input_colored_image(upper_box_point(2):lower_box_point(2),upper_box_point(1):lower_box_point(1),1)<=g_color_max_blue_Robot(1))) ...
        &((input_colored_image(upper_box_point(2):lower_box_point(2),upper_box_point(1):lower_box_point(1),2)<=g_color_max_blue_Robot(2))) ...
        &((input_colored_image(upper_box_point(2):lower_box_point(2),upper_box_point(1):lower_box_point(1),3)>=g_color_min_blue_Robot(3))));

    %*********** can b removed later
    BWOpponentGoalPost_Inv = g_BW_BlueGoalPost_Inv;
else
    error('******* ERROR: Select Our color *******')

end%end of if(g_ourRobotColorIndex==1)

BWOpponentRobot=imclose(BWOpponentRobot, strel('square',5));
%figure,imshow(BWOpponentRobot);
%remove the goalpost region
BWOpponentRobot = BWOpponentRobot & BWOpponentGoalPost_Inv(upper_box_point(2):lower_box_point(2),upper_box_point(1):lower_box_point(1));

%figure,imshow(BWOpponentRobot);
[LabledImageOpponentRobot,NOpponentRobot] = bwlabel(BWOpponentRobot,8);
if(NOpponentRobot==0)
    fprintf('***** ERROR: Opponent robot color not detected *****\n')
    return
end

regionPropertiesOpponentRobot = regionprops(LabledImageOpponentRobot,'Area','Centroid','FilledImage','BoundingBox');
if(NOpponentRobot~=1)
    areaArrayOpponentRobot = zeros(1,NOpponentRobot);
    for count=1:NOpponentRobot
        areaArrayOpponentRobot(count) = regionPropertiesOpponentRobot(count).Area;
    end
    [maxAreaOpponentRobot indexOpponentRobot] = max(areaArrayOpponentRobot);

    if(maxAreaOpponentRobot<g_minAreaOfOppRobo)
        fprintf('***** ERROR:Area of the opponnent robot is lesser *****\n')
        %making there is no opponent robot on arena robot
        g_BWOppRobot =logical(zeros(size_input_colored_image(1),size_input_colored_image(2)));
        return

    end
    g_OpponentRobotCordi = round(regionPropertiesOpponentRobot(indexOpponentRobot).Centroid) ;
    bbOpponentRobot =  floor(regionPropertiesOpponentRobot(indexOpponentRobot).BoundingBox);
    opponentRoboImage = regionPropertiesOpponentRobot(indexOpponentRobot).FilledImage;
else
    if(regionPropertiesOpponentRobot.Area<g_minAreaOfOppRobo)
        fprintf('***** ERROR:Area of the opponnent robot is lesser *****\n')
        %making there is no opponent robot on arena robot
        g_BWOppRobot =logical(zeros(size_input_colored_image(1),size_input_colored_image(2)));
        return
    end
    
    g_OpponentRobotCordi = round(regionPropertiesOpponentRobot.Centroid) ;
    bbOpponentRobot =  floor(regionPropertiesOpponentRobot.BoundingBox);
    opponentRoboImage = regionPropertiesOpponentRobot.FilledImage;
end%end of (NOpponentRobot~=1)
%
upper_opponentRoboPoint = max(floor( bbOpponentRobot(1:2)+ upper_box_point - [1 1]),[1 1]);
size_opponentRoboImage = size(opponentRoboImage);
lower_opponentRoboPoint(2)=upper_opponentRoboPoint(2) + size_opponentRoboImage(1) -1;
lower_opponentRoboPoint(1)=upper_opponentRoboPoint(1) + size_opponentRoboImage(2) -1;

% lower_opponentRoboPoint = min(floor( bbOpponentRobot(1:2) +bbOpponentRobot (3:4)- [1 1]+ upper_box_point - [1 1]),...
%                                 [size_input_colored_image(2) size_input_colored_image(1) ]);

g_BWOppRobot =logical(zeros(size_input_colored_image(1),size_input_colored_image(2)));

g_BWOppRobot(upper_opponentRoboPoint(2):lower_opponentRoboPoint(2),upper_opponentRoboPoint(1):lower_opponentRoboPoint(1)) = opponentRoboImage;




%bulging opponnent robot
boundries = bwboundaries(g_BWOppRobot,'noholes');
boundries=int16(cell2mat(boundries));
size_boundries=size(boundries);

BW_image= g_BWOppRobot;

for boundryCount=1:opponnentRoboBulgSize:size_boundries(1)
    try
        BW_image(boundries(boundryCount,1)-opponnentRoboBulgSize :boundries(boundryCount,1)+opponnentRoboBulgSize,...
            boundries(boundryCount,2)-opponnentRoboBulgSize :boundries(boundryCount,2)+opponnentRoboBulgSize )=logical(1);
    end

end
BW_image = imclose(BW_image,strel('square',8));
%final_image may have greater size as that of actual image size
g_BWOppRobot=BW_image(1:size_input_colored_image(1),1:size_input_colored_image(2));

%aadding Goal posts at obstracles too
g_BWOppRobot = g_BWOppRobot | g_BW_RedGoalPost;
g_BWOppRobot = g_BWOppRobot | g_BW_BlueGoalPost;

%figure,imshow(BWOpponentRobot);
%  g_BWOppRobotResized = imresize(BWOpponentRobot,g_BWresizeFactorOppRobo);
%figure,imshow(g_BWOppRobotResized);

detectedRobot = 1;

return
