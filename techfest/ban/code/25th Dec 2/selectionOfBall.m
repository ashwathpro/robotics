function  selectedBallCordi = selectionOfBall()

%%  **** global variable defined for this file alone
global movingBallDist
movingBallDist = 20;

%% 
global no_of_balls;
global balls_coodinates;
global g_OurRobotBlackCordi;
%  ****global g_OurRobotWhiteCordi;
global g_REDGoalPostCordiToShoot
global g_BLUEGoalPostCordiToShoot
global g_ourRobotColorIndex   % red is 1...blue is 2

global g_BWOppRobotResized
global g_BWresizeFactorOppRobo
%%

% **** for the time being i am taking black circle as front cordi
robot_carrier_cordinates=g_OurRobotBlackCordi; 

if(g_ourRobotColorIndex==1)% our color ir we have to shoot BLUE goal post
    goalPostCordiToShoot = g_BLUEGoalPostCordiToShoot;
else
    goalPostCordiToShoot = g_REDGoalPostCordiToShoot;
end
p=0;
for color_no=1:2
    for j=1:no_of_balls(color_no)
        p=p+1;
        R(p)=abs((balls_coodinates(p,:)-robot_carrier_cordinates)*[1 ; i])+...
            abs((goalPostCordiToShoot-balls_coodinates(p,:))*[1 ; i]);
        
        index_of_ball_color(p)=color_no;
    end
end
[sorted_R sorted_R_index]=sort(R);


for k=1:sum(no_of_balls)
    selecetd_ball_index=sorted_R_index(k);
    free_hole_flag(selecetd_ball_index)=check_hole_is_free(index_of_ball_color(selecetd_ball_index));

    if(free_hole_flag(selecetd_ball_index))
        % means corresponding hole is free
        moving_flag(selecetd_ball_index)=check_moving_ball(index_of_ball_color(selecetd_ball_index)...
            ,selecetd_ball_index);
        if(~moving_flag(selecetd_ball_index))
            % means ball is not moving..
            % chalo bhaiya ball ko select kar do
            No_of_selected_ball=selecetd_ball_index;
            color_of_ball=index_of_ball_color(selecetd_ball_index);
            fprintf('\n\n BALL SELECTED PROPERLY\n');

            return;
        else
            continue;
        end
    else
        continue;
    end
end%end of for

%MATALB KI SABHI BALLS K SAATH KUCH TO PANGA HAI

% TO  BHAIYA PAHLE JISKA BHI HOLE FREE HAI SELECTT KAR DEO
for k=1:sum(no_of_balls)
    selecetd_ball_index=sorted_R_index(k);
    if(free_hole_flag(selecetd_ball_index))
        No_of_selected_ball=selecetd_ball_index;
        color_of_ball=index_of_ball_color(selecetd_ball_index);
        fprintf('+\n\n Hole free ball  SELECTED\n');
        return
    end
end
%Ab bhaiya sab k sab holes ghire hue hain  to ka karen
% pahli ball ka select kar deo jyada matha pachi na karo
No_of_selected_ball=sorted_R_index(1);
color_of_ball=index_of_ball_color(sorted_R_index(1));
fprintf('\n\n All holes are occupied\n');
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

moving_flag=1;

upper_ball_cordi=round(balls_coodinates(No_of_selected_ball,:)-[ball_dia ball_dia]);
if(upper_ball_cordi(1)<=0)upper_ball_cordi(1)=1;end
if(upper_ball_cordi(2)<=0)upper_ball_cordi(2)=1;end
lower_ball_cordi=round(balls_coodinates(No_of_selected_ball,:)+[ball_dia ball_dia]);
if(lower_ball_cordi(1)>=size_input_colored_image(2))lower_ball_cordi(1)=size_input_colored_image(2);end
if(lower_ball_cordi(2)>=size_input_colored_image(1))lower_ball_cordi(2)=size_input_colored_image(1);end


input_colored_image=getsnapshot(vid);
A=input_colored_image(upper_ball_cordi(2):lower_ball_cordi(2),upper_ball_cordi(1):lower_ball_cordi(1),:);
%figure,imshow(A)
switch color_of_ball
    case 1 %yellow ball
        global color_min_yellow_ball;
        global color_max_yellow_ball;
        global red_over_blue_ball_yellow;
        global green_over_blue_ball_yellow;

        BW_ball=((A(:,:,1)>=A(:,:,3)+red_over_blue_ball_yellow) ...
            &((A(:,:,2)>=A(:,:,3))+green_over_blue_ball_yellow) ...
            &((A(:,:,1)>=color_min_yellow_ball(1))) ...
            &((A(:,:,2)>=color_min_yellow_ball(2))) ...
            &((A(:,:,3)<=color_max_yellow_ball(3))));

    case 2 %red ball
        global color_min_red_ball;
        global color_max_red_ball;
        global red_over_green_ball_red;
        global red_over_blue_ball_red;

        BW_ball=((A(:,:,1)>=A(:,:,2)+red_over_green_ball_red) ...
            &((A(:,:,1)>=A(:,:,3)+red_over_blue_ball_red)) ...
            &((A(:,:,1)>=color_min_red_ball(1))) ...
            &((A(:,:,2)<=color_max_red_ball(2))) ...
            &((A(:,:,3)<=color_max_red_ball(3))));

    case 3 %green ball
        global color_min_green_ball;
        global color_max_green_ball;
        %global green_over_red_ball_green;
        global green_over_blue_ball_green;

        %BW_ball=((A(:,:,2)>=A(:,:,1)+green_over_red_ball_green) ...
        BW_ball=(((A(:,:,2)>=A(:,:,3)+green_over_blue_ball_green)) ...
            &((A(:,:,2)>=color_min_green_ball(2))) ...
            &((A(:,:,1)<=color_max_green_ball(1))) ...
            &((A(:,:,3)<=color_max_green_ball(3))));


end
BW_ball=imclose(BW_ball, strel('square',5));
[new_no_of_balls,new_ball_cordinates] = balls_centroid(BW_ball);
clear i

if(new_no_of_balls==1)
    new_ball_cordinates=new_ball_cordinates+upper_ball_cordi-[1 1];
    dist=abs(new_ball_cordinates-balls_coodinates(No_of_selected_ball,:))*[1;i];
    if(dist<=movingBallDist)
        moving_flag=0;% ball is not moving
        return

    end

end
moving_flag=1;% ball is moving
return

