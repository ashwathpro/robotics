function [ selectedBallCordi ,selectedBallColor] = getSelectedBallCordi(no_of_balls,balls_coodinates)
% selectedBallColor is 1: for yellow(Bonus) Ball, 2:  for Orange ball
%% ^^^^^^^^^ global variable defined for this file alone
global movingBallDist
movingBallDist = 10;
bonusBallDistComp = 1.3;
%%
%  ?? can v remove the following global variables
% global no_of_balls;
% global balls_coodinates;
global g_OurRobotBlackCordi;
%  ****global g_OurRobotWhiteCordi;
global g_REDGoalPostCordiToShoot
global g_BLUEGoalPostCordiToShoot
global g_ourRobotColorIndex   % red is 1...blue is 2

% global g_BWOppRobotResized
% global g_BWresizeFactorOppRobo
%%
% **** for the time being i am taking black circle as front cordi
robot_carrier_cordinates = g_OurRobotBlackCordi;

if(g_ourRobotColorIndex==1)% our color ir we have to shoot BLUE goal post
    goalPostCordiToShoot = g_BLUEGoalPostCordiToShoot;
else
    goalPostCordiToShoot = g_REDGoalPostCordiToShoot;
end

p=0;
index_of_ball_color(sum(no_of_balls)) = 0;
R(sum(no_of_balls)) = 0;
for color_no=1:2
    for j=1:no_of_balls(color_no)
        p=p+1;
        R(p)= abs((balls_coodinates(p,:)-robot_carrier_cordinates)*[1 ; i])+...
            abs((goalPostCordiToShoot-balls_coodinates(p,:))*[1 ; i]);
        % *** here opponnent robot alone taken as obstarcle
        % adding the obstracle(opponnent robot) dist
        %from robot to ball
        numOfObsPointsRoboToBall = getNumOfObsPoints(round(robot_carrier_cordinates),round(balls_coodinates(p,:)));
        numOfObsPointsBallToGoal = getNumOfObsPoints(round(balls_coodinates(p,:)),round(goalPostCordiToShoot));
        R(p)= R(p) + numOfObsPointsRoboToBall  + numOfObsPointsBallToGoal ;

        % if its bonus ball
        if(color_no==1)
            R(p) = R(p) / bonusBallDistComp;
        end
        index_of_ball_color(p)=color_no;
    end
end
[sorted_R sorted_R_index]=sort(R);

moving_flag(sum(no_of_balls)) = 0;
for k=1:sum(no_of_balls)
    selecetd_ball_index=sorted_R_index(k);
    %check wether ball is moving
    moving_flag(selecetd_ball_index)=check_moving_ball(index_of_ball_color(selecetd_ball_index)...
        ,selecetd_ball_index);
    if(~moving_flag(selecetd_ball_index))
        % means ball is not moving..
        % now we can select this ball
        selectedBallCordi = balls_coodinates(selecetd_ball_index,:);
        selectedBallColor = index_of_ball_color(selecetd_ball_index);
        % ??? No_of_selected_ball=selecetd_ball_index;
        % ???color_of_ball=index_of_ball_color(selecetd_ball_index);
        fprintf('\n\n BALL SELECTED PROPERLY\n');

        return;
    else
        continue;
    end

end%end of for

%MATALB KI SABHI BALLS K SAATH KUCH TO PANGA HAI

% % TO  BHAIYA PAHLE JISKA BHI HOLE FREE HAI SELECTT KAR DEO
% for k=1:sum(no_of_balls)
%     selecetd_ball_index=sorted_R_index(k);
%     if(free_hole_flag(selecetd_ball_index))
%         No_of_selected_ball=selecetd_ball_index;
%         color_of_ball=index_of_ball_color(selecetd_ball_index);
%         fprintf('+\n\n Hole free ball  SELECTED\n');
%         return
%     end
% end

%Ab bhaiya sab k sab holes ghire hue hain  to ka karen
% pahli ball ka select kar deo jyada matha pachi na karo

selectedBallCordi = balls_coodinates(sorted_R_index(1),:);
selectedBallColor = index_of_ball_color(sorted_R_index(1));
return

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ################################################################
function moving_flag=check_moving_ball(color_of_ball,No_of_selected_ball) 
global balls_coodinates;
global vid;
global size_input_colored_image;
global input_colored_image;
global ball_dia
global movingBallDist


%color values Yellow ball
global color_min_yellowball;
global color_max_yellowball;
global red_over_blue_yellowBall;
global green_over_blue_yellowBall;
%color values Orange ball
global color_min_orangeball;
global color_max_orangeball;
global red_over_green_orangeBall;
global red_over_blue_orangeBall;
global green_over_blue_orangeBall


%*****input_colored_image = getsnapshot(vid);
input_colored_image=imread('withBall.jpg');

upper_ball_cordi=round(max(balls_coodinates(No_of_selected_ball,:)-[ball_dia ball_dia],[1, 1]));
lower_ball_cordi=round(min(balls_coodinates(No_of_selected_ball,:)+[ball_dia ball_dia],[size_input_colored_image(2),size_input_colored_image(1)]));

%figure,imshow(A)
switch color_of_ball
    case 1 %yellow ball
        BW_ball=((input_colored_image(upper_ball_cordi(2):lower_ball_cordi(2),upper_ball_cordi(1):lower_ball_cordi(1),1)>=color_min_yellowball(1)) ...
            &(input_colored_image(upper_ball_cordi(2):lower_ball_cordi(2),upper_ball_cordi(1):lower_ball_cordi(1),2)>=color_min_yellowball(2)) ...
            &(input_colored_image(upper_ball_cordi(2):lower_ball_cordi(2),upper_ball_cordi(1):lower_ball_cordi(1),3)<=color_max_yellowball(3))...
            &(input_colored_image(upper_ball_cordi(2):lower_ball_cordi(2),upper_ball_cordi(1):lower_ball_cordi(1),1)>=...
            input_colored_image(upper_ball_cordi(2):lower_ball_cordi(2),upper_ball_cordi(1):lower_ball_cordi(1),3)+red_over_blue_yellowBall) ...
            &((input_colored_image(upper_ball_cordi(2):lower_ball_cordi(2),upper_ball_cordi(1):lower_ball_cordi(1),2)>=...
            input_colored_image(upper_ball_cordi(2):lower_ball_cordi(2),upper_ball_cordi(1):lower_ball_cordi(1),3))+green_over_blue_yellowBall));
    case 2 %orange ball
        BW_ball=((input_colored_image(upper_ball_cordi(2):lower_ball_cordi(2),upper_ball_cordi(1):lower_ball_cordi(1),1)>=color_min_orangeball(1)) ...
            &(input_colored_image(upper_ball_cordi(2):lower_ball_cordi(2),upper_ball_cordi(1):lower_ball_cordi(1),2)<=color_max_orangeball(2)) ...
            &(input_colored_image(upper_ball_cordi(2):lower_ball_cordi(2),upper_ball_cordi(1):lower_ball_cordi(1),3)<=color_max_orangeball(3))...
            &(input_colored_image(upper_ball_cordi(2):lower_ball_cordi(2),upper_ball_cordi(1):lower_ball_cordi(1),1)>=...
            input_colored_image(upper_ball_cordi(2):lower_ball_cordi(2),upper_ball_cordi(1):lower_ball_cordi(1),2)+red_over_green_orangeBall) ...
            &((input_colored_image(upper_ball_cordi(2):lower_ball_cordi(2),upper_ball_cordi(1):lower_ball_cordi(1),1)>=...
            input_colored_image(upper_ball_cordi(2):lower_ball_cordi(2),upper_ball_cordi(1):lower_ball_cordi(1),3)+red_over_blue_orangeBall)) ...
            &((input_colored_image(upper_ball_cordi(2):lower_ball_cordi(2),upper_ball_cordi(1):lower_ball_cordi(1),2)>=...
            input_colored_image(upper_ball_cordi(2):lower_ball_cordi(2),upper_ball_cordi(1):lower_ball_cordi(1),3)+green_over_blue_orangeBall)));
end
%figure,imshow(BW_ball)

BW_ball=imclose(BW_ball, strel('square',5));
[new_no_of_balls,new_ball_cordinates] = balls_centroid(BW_ball);
clear i

if(new_no_of_balls==1)
    new_ball_cordinates=new_ball_cordinates+upper_ball_cordi-[1 1];
    dist=abs(new_ball_cordinates-balls_coodinates(No_of_selected_ball,:))*[1;i];
    if(dist<=movingBallDist)
        %modify the ball centroid to latest values
        balls_coodinates(No_of_selected_ball,:) = new_ball_cordinates;
        moving_flag=0;% ball is not moving
        return

    end

end
moving_flag=1;% ball is moving
return

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% #############################################################
function numOfObsPoints = getNumOfObsPoints(startPoint,endPoint)
% *** here opponnent robot alone taken as obstarcle
global g_BWOppRobot

numOfObsPoints = 0;
if(endPoint(1)-startPoint(1) ~= 0)
    slope = (endPoint(2)-startPoint(2))/(endPoint(1)-startPoint(1));
else
    slope = inf;
end

if(abs(slope)<1)
    diffX = 1;
    if(endPoint(1) < startPoint(1))
        diffX = -1;
    end
    c = startPoint(2) - slope* startPoint(1);
    for x = startPoint(1):diffX:endPoint(1)
        y =int16(slope * x + c );
        if(g_BWOppRobot(y,x))
            numOfObsPoints  = numOfObsPoints  +1;
        end
    end
else
    diffY = 1;
    if(endPoint(2) < startPoint(2))
        diffY = -1;
    end
    c = startPoint(1) -  startPoint(2)/slope;
    for y = startPoint(2):diffY:endPoint(2)
        x =int16(y/slope + c );
        if(g_BWOppRobot(y,x))
            numOfObsPoints  = numOfObsPoints  +1;
        end
    end
end

