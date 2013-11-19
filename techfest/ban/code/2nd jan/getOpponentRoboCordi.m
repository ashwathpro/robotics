function detectedRobot = getOpponentRoboCordi(full_image)

%% global variables
global vid
global input_colored_image;
global size_input_colored_image;
global g_ourRobotColorIndex   % red is 1...blue is 2
global g_BW_RedGoalPost_Inv
global g_BW_BlueGoalPost_Inv
%% Robot Morphology

global g_robotLargerBoxDimentions
% *****global g_maxDistBetweenCircles
% *****global g_RobotBlackCircleMinArea
% *****global g_RobotWhiteCircleMinArea

% ??? [pras] i guess the follwoing variables are not require
global g_RedRobotBlackCordi;
global g_RedRobotWhiteCordi;
global g_BlueRobotBlackCordi;
global g_BlueRobotWhiteCordi;
global g_OpponentRobotBlackCordi;
global g_OpponentRobotWhiteCordi;


%for making BW image for opponent robot
% ***** will see later for resize
% global g_BWresizeFactorOppRobo
%  **global g_BWOppRobotResized
global g_BWOppRobot

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

global Max_dist_btw_circles

%%
detectedRobot = 0;

input_colored_image=getsnapshot(vid);
if(full_image==0)
    upper_box_point = max( min(g_OpponentRobotBlackCordi,g_OpponentRobotWhiteCordi)-g_robotLargerBoxDimentions,[1 ,1]);
    lower_box_point= min (max(g_OpponentRobotBlackCordi,g_OpponentRobotWhiteCordi)+ g_robotLargerBoxDimentions,...
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
figure,imshow(BWOpponentRobot);
[LabledImageOpponentRobot,NOpponentRobot] = bwlabel(BWOpponentRobot,8);
if(NOpponentRobot==0)
    fprintf('***** ERROR: Opponent robot color not detected *****\n')
    return
end
regionPropertiesOpponentRobot = regionprops(LabledImageOpponentRobot,'Area','BoundingBox','FilledImage');
if(NOpponentRobot~=1)
    areaArrayOpponentRobot = zeros(1,NOpponentRobot);
    for count=1:NOpponentRobot
        areaArrayOpponentRobot(count) = regionPropertiesOpponentRobot(count).Area;
    end
    [maxAreaOpponentRobot indexOpponentRobot] = max(areaArrayOpponentRobot);
    bbOpponentRobot =  floor(regionPropertiesOpponentRobot(indexOpponentRobot).BoundingBox);
    opponentRoboImage = regionPropertiesOpponentRobot(indexOpponentRobot).FilledImage;
else
    bbOpponentRobot =  floor(regionPropertiesOpponentRobot.BoundingBox);
    opponentRoboImage = regionPropertiesOpponentRobot.FilledImage;
end%end of (NOpponentRobot~=1)

upper_opponentRoboPoint =round( bbOpponentRobot(1:2)+ upper_box_point - [1 1]);
lower_opponentRoboPoint =round( bbOpponentRobot(1:2) +bbOpponentRobot (3:4)- [1 1]+ upper_box_point - [1 1]);


BWOpponentRobotWhite =(((input_colored_image(upper_opponentRoboPoint(2):lower_opponentRoboPoint(2),upper_opponentRoboPoint(1):lower_opponentRoboPoint(1),1)>=g_minWhiteColorRobot(1))) ...
    &((input_colored_image(upper_opponentRoboPoint(2):lower_opponentRoboPoint(2),upper_opponentRoboPoint(1):lower_opponentRoboPoint(1),2)>=g_minWhiteColorRobot(2))) ...
    &((input_colored_image(upper_opponentRoboPoint(2):lower_opponentRoboPoint(2),upper_opponentRoboPoint(1):lower_opponentRoboPoint(1),3)>=g_minWhiteColorRobot(3))));

%figure,imshow(BWOpponentRobotWhite)
[LabledImageOpponentRobotW,NOpponentRobotW] = bwlabel(BWOpponentRobotWhite,8);
if(NOpponentRobotW==0)
    fprintf('\n***** ERROR: White Color of Opponent robot  color not detected *****\n')
    return
end
regionPropertiesOpponentRobotW = regionprops(LabledImageOpponentRobotW,'Centroid','Area');
if(NOpponentRobotW~=1)
    areaArrayOpponentRobotW(NOpponentRobotW)=0;
    for count=1:NOpponentRobotW
        areaArrayOpponentRobotW(count) = regionPropertiesOpponentRobotW(count).Area;
    end
    [maxAreaOpponentRobotW indexOpponentRobotW] = max(areaArrayOpponentRobotW);
    g_OpponentRobotWhiteCordi =  regionPropertiesOpponentRobotW(indexOpponentRobotW).Centroid + upper_opponentRoboPoint-1;
else
    g_OpponentRobotWhiteCordi =  regionPropertiesOpponentRobotW.Centroid + upper_opponentRoboPoint-1;
end

BWOpponentRobotBlack =(((input_colored_image(upper_opponentRoboPoint(2):lower_opponentRoboPoint(2),upper_opponentRoboPoint(1):lower_opponentRoboPoint(1),1)<=g_maxBlackColorRobot(1))) ...
    &((input_colored_image(upper_opponentRoboPoint(2):lower_opponentRoboPoint(2),upper_opponentRoboPoint(1):lower_opponentRoboPoint(1),2)<=g_maxBlackColorRobot(2))) ...
    &((input_colored_image(upper_opponentRoboPoint(2):lower_opponentRoboPoint(2),upper_opponentRoboPoint(1):lower_opponentRoboPoint(1),3)<=g_maxBlackColorRobot(3))));

%figure,imshow(BWOpponentRobotBlack)

[LabledImageOpponentRobotB,NOpponentRobotB] = bwlabel(BWOpponentRobotBlack,8);
if(NOpponentRobotB==0)
    fprintf('\n***** ERROR: Black Color of Opponent robot  color not detected *****\n')
    return
end
regionPropertiesOpponentRobotB = regionprops(LabledImageOpponentRobotB,'Centroid','Area');
if(NOpponentRobotB~=1)
    areaArrayOpponentRobotB(NOpponentRobotB)=0;
    for count=1:NOpponentRobotB
        areaArrayOpponentRobotB(count) = regionPropertiesOpponentRobotB(count).Area;
    end

    [maxAreaOpponentRobotB indexOpponentRobotB] = max(areaArrayOpponentRobotB);
    g_OpponentRobotBlackCordi =  regionPropertiesOpponentRobotB(indexOpponentRobotB).Centroid + upper_opponentRoboPoint-1;
else
    g_OpponentRobotBlackCordi =  regionPropertiesOpponentRobotB.Centroid + upper_opponentRoboPoint-1;
end

g_BWOppRobot =logical(zeros(size_input_colored_image(1),size_input_colored_image(2)));
g_BWOppRobot(upper_opponentRoboPoint(2):lower_opponentRoboPoint(2),upper_opponentRoboPoint(1):lower_opponentRoboPoint(1)) = opponentRoboImage;


%figure,imshow(BWOpponentRobot);
%  g_BWOppRobotResized = imresize(BWOpponentRobot,g_BWresizeFactorOppRobo);
%figure,imshow(g_BWOppRobotResized);

detectedRobot = 1;
return
