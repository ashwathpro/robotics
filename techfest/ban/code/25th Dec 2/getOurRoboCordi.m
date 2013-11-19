function getOurRoboCordi(full_image)

%% global variables
global input_colored_image;
global size_input_colored_image;
global g_ourRobotColorIndex   % red is 1...blue is 2
global g_BW_RedGoalPost_Inv
global g_BW_BlueGoalPost_Inv
%% Robot Morphology
global g_robotBoxDimentions
global g_robotLargerBoxDimentions
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
while(1)
    %****input_colored_image=getsnapshot(vid);
    if(full_image==0)
        upper_box_point = min(g_OurRobotBlackCordi,g_OurRobotWhiteCordi)- g_robotBoxDimentions;
        lower_box_point= max(g_OurRobotBlackCordi,g_OurRobotWhiteCordi)+ g_robotBoxDimentions;

        if(upper_box_point(1)<=1) upper_box_point(1)=1;end
        if(upper_box_point(2)<=1) upper_box_point(2)=1;end

        if(lower_box_point(1)>=size_input_colored_image(2)) lower_box_point(1)=size_input_colored_image(2);end
        if(lower_box_point(2)>=size_input_colored_image(1)) lower_box_point(2)=size_input_colored_image(1);end


    elseif(full_image==2)
        upper_box_point = min(g_OurRobotBlackCordi,g_OurRobotWhiteCordi)-g_robotLargerBoxDimentions;
        lower_box_point= max(g_OurRobotBlackCordi,g_OurRobotWhiteCordi)+ g_robotLargerBoxDimentions;

        if(upper_box_point(1)<=1) upper_box_point(1)=1;end
        if(upper_box_point(2)<=1) upper_box_point(2)=1;end

        if(lower_box_point(1)>=size_input_colored_image(2)) lower_box_point(1)=size_input_colored_image(2);end
        if(lower_box_point(2)>=size_input_colored_image(1)) lower_box_point(2)=size_input_colored_image(1);end
        
    else % for full image
        if(g_ourRobotColorIndex==1)% our robot color is red
            BW_OurRobot=((input_colored_image(:,:,1)>=input_colored_image(:,:,2)+g_red_over_green_Robot_red) ...
                &((input_colored_image(:,:,1)>=input_colored_image(:,:,3)+g_red_over_blue_Robot_red)) ...
                &((input_colored_image(:,:,1)>=g_color_min_red_Robot(1))) ...
                &((input_colored_image(:,:,2)<=g_color_max_red_Robot(2))) ...
                &((input_colored_image(:,:,3)<=g_color_max_red_Robot(3))));
            %*********** can b removed later
            BWOurGoalPost_Inv = g_BW_RedGoalPost_Inv;

        elseif(g_ourRobotColorIndex==2)% our robot color is blue
            BW_OurRobot=((input_colored_image(:,:,3)>=input_colored_image(:,:,2)+g_blue_over_green_Robot_blue) ...
                &((input_colored_image(:,:,3)>=input_colored_image(:,:,1)+g_blue_over_red_Robot_blue)) ...
                &((input_colored_image(:,:,1)<=g_color_max_blue_Robot(1))) ...
                &((input_colored_image(:,:,2)<=g_color_max_blue_Robot(2))) ...
                &((input_colored_image(:,:,3)>=g_color_min_blue_Robot(3))));

            %*********** can b removed later
            BWOurGoalPost_Inv = g_BW_BlueGoalPost_Inv;
        else
            error('******* ERROR: Select Our color *******')
            
        end%end of if(g_ourRobotColorIndex==1)

    
        BW_OurRobot=imclose(BW_OurRobot, strel('square',5));
        BW_OurRobot = BW_OurRobot & BWOurGoalPost_Inv;
        %figure,imshow(BW_OurRobot);
        [LabledImageOurRobot,NOurRobot] = bwlabel(BW_OurRobot,8);
        if(NOurRobot==0)
            fprintf('***** ERROR: Our robot color not detected *****')
            continue
        end
        regionPropertiesOurRobot = regionprops(LabledImageOurRobot,'Area','BoundingBox');
        if(NOurRobot~=1)
            areaArrayOurRobot = zeros(1,NOurRobot);
            for count=1:NOurRobot
                areaArrayOurRobot(count) = regionPropertiesOurRobot(count).Area;
            end
            [maxAreaOurRobot indexOurRobot] = max(areaArrayOurRobot);
            bbOurRobot =  floor(regionPropertiesOurRobot(indexOurRobot).BoundingBox);

        else
            bbOurRobot =  floor(regionPropertiesOurRobot.BoundingBox);
        end%end of (NOurRobot~=1)
        upper_box_point = bbOurRobot(1:2);
        lower_box_point = bbOurRobot(1:2) +bbOurRobot (3:4);
    end%end of full image
    upper_box_point = int16(upper_box_point);
    lower_box_point = int16(lower_box_point);
    
    
    BWOurRobotWhite =(((input_colored_image(upper_box_point(2):lower_box_point(2),upper_box_point(1):lower_box_point(1),1)>=g_minWhiteColorRobot(1))) ...
        &((input_colored_image(upper_box_point(2):lower_box_point(2),upper_box_point(1):lower_box_point(1),2)>=g_minWhiteColorRobot(2))) ...
        &((input_colored_image(upper_box_point(2):lower_box_point(2),upper_box_point(1):lower_box_point(1),3)>=g_minWhiteColorRobot(3))));
    %figure,imshow(BWOurRobotWhite)
    [LabledImageOurRobotW,NOurRobotW] = bwlabel(BWOurRobotWhite,8);
    if(NOurRobotW==0)
        fprintf('***** ERROR: White Color of Our robot  color not detected *****')
        continue
    end
    regionPropertiesOurRobotW = regionprops(LabledImageOurRobotW,'Centroid','Area');
    if(NOurRobotW~=1)
        areaArrayOurRobotW(NOurRobotW)=0;
        for count=1:NOurRobotW
            areaArrayOurRobotW(count) = regionPropertiesOurRobotW(count).Area;
        end
        [maxAreaOurRobotW indexOurRobotW] = max(areaArrayOurRobotW);
        g_OurRobotWhiteCordi =  int16(regionPropertiesOurRobotW(indexOurRobotW).Centroid) + upper_box_point-1;
    else
        g_OurRobotWhiteCordi =  int16(regionPropertiesOurRobotW.Centroid) + upper_box_point-1;
    end

    BWOurRobotBlack =(((input_colored_image(upper_box_point(2):lower_box_point(2),upper_box_point(1):lower_box_point(1),1)<=g_maxBlackColorRobot(1))) ...
        &((input_colored_image(upper_box_point(2):lower_box_point(2),upper_box_point(1):lower_box_point(1),2)<=g_maxBlackColorRobot(2))) ...
        &((input_colored_image(upper_box_point(2):lower_box_point(2),upper_box_point(1):lower_box_point(1),3)<=g_maxBlackColorRobot(3))));

    %figure,imshow(BWOurRobotBlack)

    [LabledImageOurRobotB,NOurRobotB] = bwlabel(BWOurRobotBlack,8);
    if(NOurRobotB==0)
        fprintf('no black color detected on red robot')
        continue
    end
    regionPropertiesOurRobotB = regionprops(LabledImageOurRobotB,'Centroid','Area');
    if(NOurRobotB~=1)
        areaArrayOurRobotB(NOurRobotB)=0;
        for count=1:NOurRobotB
            areaArrayOurRobotB(count) = regionPropertiesOurRobotB(count).Area;
        end

        [maxAreaOurRobotB indexOurRobotB] = max(areaArrayOurRobotB);
        g_OurRobotBlackCordi =  int16(regionPropertiesOurRobotB(indexOurRobotB).Centroid) + upper_box_point-1;
    else
        g_OurRobotBlackCordi =  int16(regionPropertiesOurRobotB.Centroid )+ upper_box_point-1;
    end


    return
    
    
    
    
    %% ROBOT BACK CORDINATES
    back_flag=0;
    for j=1:count

        if((diameters(j)>=ROBOT_BACK_DIA-BACK_DIA_TOL) & (diameters(j)<=ROBOT_BACK_DIA+BACK_DIA_TOL))
            ROBOT_BACK_CORDINATES(2)=centers(j,1)+upper_box_point(2);
            ROBOT_BACK_CORDINATES(1)=centers(j,2)+upper_box_point(1);
            back_flag=1;
            break;
        end
    end

    if(back_flag==0)
        fprintf('ROBOT_BACK_CORDINATES cant detected\n')
        full_image=1;
        continue;
    end
    %% ROBOT FRONT CORDINATES
    front_count=0;
    for j=1:count
        %ROBOT_FRONT_CORDINATES
        if((diameters(j)>=ROBOT_FRONT_DIA-FRONT_DIA_TOL) & (diameters(j)<=ROBOT_FRONT_DIA+FRONT_DIA_TOL))
            front_count=front_count+1;
            FRONT_CORDINATES_array(front_count,2)=centers(j,1)+upper_box_point(2);
            FRONT_CORDINATES_array(front_count,1)=centers(j,2)+upper_box_point(1);
        end
    end
    clear distance_array;
    clear i;
    if(front_count>0)
        for j=1:front_count
            distance_array(j)=abs((FRONT_CORDINATES_array(j,:)-ROBOT_BACK_CORDINATES)*[1 ; i]);
        end
        [value index]=min(distance_array);
        if(value<Max_dist_btw_circles)
            ROBOT_FRONT_CORDINATES=FRONT_CORDINATES_array(index,:);

            break;
        end
    end

    fprintf('ROBOT_FRONT_CORDINATES cant detected\n')
    full_image=2;
end