function [ selectedBallIndex ,selectedBallColor] = getSelectedBallInfo(numOfBalls,allBallsCordinates)
% selectedBallColor is 1: for yellow(Bonus) Ball, 2:  for Orange ball
%% ^^^^^^^^^ global variable defined for this file alone
global movingBallDist
movingBallDist = 10;
bonusBallDistComp = 1.3;
%% DO i need to call gettingROBO corr here???
%  ?? can v remove the following global variables
% global numOfBalls;
% global allBallsCordinates;
global g_OurRobotBlackCordi;
global g_OurRobotWhiteCordi;
global g_REDGoalPostCordiToTarget
global g_BLUEGoalPostCordiToTarget
global g_ourRobotColorIndex   % red is 1...blue is 2
global g_ourBlackIsFront
global g_BWOppRobot;
% global g_BWOppRobotResized
% global g_BWresizeFactorOppRobo
%%
% **** for the time being i am taking black circle as front cordi
if(g_ourBlackIsFront==1)
    robot_carrier_cordinates = g_OurRobotBlackCordi;
else
    robot_carrier_cordinates = g_OurRobotWhiteCordi;
end


if(g_ourRobotColorIndex==1)% our color ir we have to shoot BLUE goal post
    goalPostCordiToShoot = g_BLUEGoalPostCordiToTarget;
else
    goalPostCordiToShoot = g_REDGoalPostCordiToTarget;
end

p=0;
index_of_ball_color(sum(numOfBalls)) = 0;
R(sum(numOfBalls)) = 0;
for color_no=1:2
    for j=1:numOfBalls(color_no)
        p=p+1;
        ballCordi = round(allBallsCordinates(p,:));
        if(g_BWOppRobot(ballCordi(2),ballCordi(1)))
            R(p) = inf;
        else
            R(p)= abs((ballCordi-robot_carrier_cordinates)*[1 ; i])+...
                abs(goalPostCordiToShoot-ballCordi)*[1 ; i];
            % *** here opponnent robot alone taken as obstarcle
            % adding the obstracle(opponnent robot) dist
            %from robot to ball
            numOfObsPointsRoboToBall = getNumOfObsPoints(round(robot_carrier_cordinates),ballCordi);
            numOfObsPointsBallToGoal = getNumOfObsPoints(ballCordi,round(goalPostCordiToShoot));
            R(p)= R(p) + numOfObsPointsRoboToBall  + numOfObsPointsBallToGoal ;

            % if its bonus ball
            if(color_no==1)
                R(p) = R(p) / bonusBallDistComp;
            end
        end
        index_of_ball_color(p)=color_no;
    end
end
[sorted_R sorted_R_index]=sort(R);

moving_flag(sum(numOfBalls)) = 0;
for k=1:sum(numOfBalls)
    selecetd_ball_index=sorted_R_index(k);
    %check wether ball is moving
    moving_flag(selecetd_ball_index)=check_moving_ball(index_of_ball_color(selecetd_ball_index)...
        ,allBallsCordinates(selecetd_ball_index,:));
    if(~moving_flag(selecetd_ball_index))
        % means ball is not moving..
        % now we can select this ball
        selectedBallIndex = selecetd_ball_index;
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


%Ab bhaiya sab k sab holes ghire hue hain  to ka karen
% pahli ball ka select kar deo jyada matha pachi na karo

selectedBallIndex = sorted_R_index(1);
selectedBallColor = index_of_ball_color(sorted_R_index(1));
return

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ################################################################
function moving_flag=check_moving_ball(color_of_ball,ballCordi)
% global allBallsCordinates;
global vid;
global size_input_colored_image;
global input_colored_image;
global maxBallDia
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


% input_colored_image = getsnapshot(vid);
input_colored_image=imread('sample1.bmp');

upper_ball_cordi=round(max(ballCordi-[maxBallDia maxBallDia],[1, 1]));
lower_ball_cordi=round(min(ballCordi+[maxBallDia maxBallDia],[size_input_colored_image(2),size_input_colored_image(1)]));

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
[new_numOfBalls,new_ball_cordinates] = balls_centroid(BW_ball);
clear i

if(new_numOfBalls==1)
    new_ball_cordinates=new_ball_cordinates+upper_ball_cordi-[1 1];
    dist=abs(new_ball_cordinates-ballCordi)*[1;i];
    if(dist<=movingBallDist)
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

