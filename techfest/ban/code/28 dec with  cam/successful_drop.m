function successful_drop(no_of_corners,corner_cordinates,color_of_ball)

global vid;
global dio1;
global ROBOT_FRONT_CORDINATES
global ROBOT_BACK_CORDINATES
global input_colored_image

%global tolcirc_robot;
global no_of_balls;
global balls_coodinates;
global No_of_balls_becomed_zero
global black_dist
global size_input_colored_image;
putvalue(dio1.Line(1:8),0);
%% These Variabals are set from successful_grab.m 
%% so if want to change then go to successful_grab.m
global Max_ON_linear_mov
global Min_ON_linear_mov
global STOPPING_DISTANCE_CORNER
global STOPPING_DISTANCE_DESTI
global slow_down_dist
global Max_ON_linear_mov_dis
global EQU_ANGLE
global REVERSE_EQU_ANGLE
%%
skip_mov=0;
open_mouth=0;

%% close the mouth
for j=1:4
    putvalue(dio1.Line(1:8),16);
end
putvalue(dio1.Line(1:8),0);
%% ***** achiving corners other than last corners
for j=2:no_of_corners-1
    Destination_point_cordinate=corner_cordinates(j,:);
    while(1)
        skip_mov=0;
        getting_robot_cordinates(0);
        
        ROBOT_CORDINATES=ROBOT_FRONT_CORDINATES;
        hold on
        plot(ROBOT_CORDINATES(1),ROBOT_CORDINATES(2),'yx','LineWidth',2);
        [r t]=ditance_and_angle(ROBOT_CORDINATES,Destination_point_cordinate,...
            2*ROBOT_FRONT_CORDINATES-ROBOT_BACK_CORDINATES);

        fprintf('To DROP BALL OF COLOR: %d  (In between) r=%.1f    t=%.1f \n',color_of_ball,r,t);
        if(r<=STOPPING_DISTANCE_CORNER | (r<=100 & (abs(t)>=180-REVERSE_EQU_ANGLE)))
            break;
        elseif(r<=2*STOPPING_DISTANCE_CORNER & abs(t)<=2*EQU_ANGLE)
            No_of_mov=Min_ON_linear_mov;
            output=10;%slow forward speed
        elseif(r<=slow_down_dist & abs(t)<=2*EQU_ANGLE)
            % EQU_ANGLE=EQU_ANGLE*(2-r/slow_down_dist)
            No_of_mov=1+Min_ON_linear_mov;
            output=10;%slow forward speed
        elseif( r>slow_down_dist & abs(t)<=2*EQU_ANGLE )
            No_of_mov=Min_ON_linear_mov+((Max_ON_linear_mov-Min_ON_linear_mov)/(Max_ON_linear_mov_dis-slow_down_dist))*(r-slow_down_dist);
            output=10;
        else
            putvalue(dio1.Line(1:8),16);
            achived=allignment_of_robot(2*EQU_ANGLE,Destination_point_cordinate,STOPPING_DISTANCE_CORNER,16);
            output=0;
            if(achived)
                putvalue(dio1.Line(1:8),0);
                break;
            else
                skip_mov=1;
            end
        end
        if(~skip_mov)
            if(No_of_mov> Max_ON_linear_mov) No_of_mov= Max_ON_linear_mov; end
            if(No_of_mov<Min_ON_linear_mov)No_of_mov=Min_ON_linear_mov;end
            for i=1:No_of_mov
                putvalue(dio1.Line(1:8),output);
            end
            putvalue(dio1.Line(1:8),0);
        end
         putvalue(dio1.Line(1:8),16); %close atleast once in each loop
          putvalue(dio1.Line(1:8),0);
    end% of while(1)
    
    if(j==2)
        input_colored_image=getsnapshot(vid);
         getting_robot_cordinates(0);
        ROBOT_CORDINATES=(9*ROBOT_FRONT_CORDINATES-5*ROBOT_BACK_CORDINATES)/4;
        upper_ball_cordi=round(ROBOT_CORDINATES-[20 20]);
        if(upper_ball_cordi(1)<=0)upper_ball_cordi(1)=1;end
        if(upper_ball_cordi(2)<=0)upper_ball_cordi(2)=1;end
        lower_ball_cordi=round(ROBOT_CORDINATES+[20 20]);
        if(lower_ball_cordi(1)>=size_input_colored_image(2))lower_ball_cordi(1)=size_input_colored_image(2);end
        if(lower_ball_cordi(2)>=size_input_colored_image(1))lower_ball_cordi(2)=size_input_colored_image(1);end

        input_colored_image(upper_ball_cordi(2):lower_ball_cordi(2)...
            ,upper_ball_cordi(1):lower_ball_cordi(1),:)=0;

        if(No_of_balls_becomed_zero==0)
            %removing corners
            input_colored_image(1:black_dist,1:black_dist,:)=0;
            input_colored_image(size_input_colored_image(1)-black_dist:size_input_colored_image(1),1:black_dist,:)=0;
            input_colored_image(1:black_dist,size_input_colored_image(2)-black_dist:size_input_colored_image(2),:)=0;
            input_colored_image(size_input_colored_image(1)-black_dist:size_input_colored_image(1)...
                ,size_input_colored_image(2)-black_dist:size_input_colored_image(2),:)=0;
            % figure,imshow(input_colored_image);
        end
        [temp_no_of_balls,balls_coodinates]=balls_information();
        if(temp_no_of_balls(color_of_ball)>no_of_balls(color_of_ball))
            fprintf('\n\n*****firsr****\n')
            return;
        end

    end%of if(j==2)

end%of for loop

%% achiving last corners (For ball)
Destination_point_cordinate=corner_cordinates(no_of_corners,:);
open_mouth=0;
while(1)
    skip_mov=0;
    getting_robot_cordinates(0);
    ROBOT_CORDINATES=(2*ROBOT_FRONT_CORDINATES-ROBOT_BACK_CORDINATES);
    
        hold on
        plot(ROBOT_CORDINATES(1),ROBOT_CORDINATES(2),'yx','LineWidth',2);
        [r t]=ditance_and_angle(ROBOT_CORDINATES,Destination_point_cordinate,...
            4*ROBOT_FRONT_CORDINATES-3*ROBOT_BACK_CORDINATES);

    fprintf('To DROP BALL OF COLOR: %d  r=%.1f    t=%.1f   \n',color_of_ball,r,t);

     if(r<=STOPPING_DISTANCE_DESTI |(r<=50 & (abs(t)>=180-REVERSE_EQU_ANGLE)) )
%     %if(r<=50 & (abs(t)>=180-2*REVERSE_EQU_ANGLE))
         break;
         elseif(r<=2*STOPPING_DISTANCE_DESTI & abs(t)<=EQU_ANGLE)
        No_of_mov=Min_ON_linear_mov;
        output=10+16;%slow forward speed
        open_mouth=0;
    elseif(r<=slow_down_dist & abs(t)<=EQU_ANGLE)
        % EQU_ANGLE=EQU_ANGLE*(2-r/slow_down_dist)
        No_of_mov=1+Min_ON_linear_mov;
        output=10;%slow forward speed
    elseif( r>slow_down_dist & abs(t)<=EQU_ANGLE )
        No_of_mov=Min_ON_linear_mov+((Max_ON_linear_mov-Min_ON_linear_mov)/(Max_ON_linear_mov_dis-slow_down_dist))*(r-slow_down_dist);
        output=10;
    else

        if(~open_mouth)
            putvalue(dio1.Line(1:8),16);
            achived=allignment_of_robot(EQU_ANGLE,Destination_point_cordinate,STOPPING_DISTANCE_DESTI,16);
        else
            putvalue(dio1.Line(1:8),32); %close atleast once in each loop
            achived=allignment_of_robot(EQU_ANGLE,Destination_point_cordinate,STOPPING_DISTANCE_DESTI,32);
        end
        output=0;
        if(achived)
            putvalue(dio1.Line(1:8),0);
            break;
        else
            skip_mov=1;
        end
    end
    if(~skip_mov)
        if(No_of_mov> Max_ON_linear_mov) No_of_mov= Max_ON_linear_mov; end
        if(No_of_mov<Min_ON_linear_mov)No_of_mov=Min_ON_linear_mov;end
        for i=1:No_of_mov
            putvalue(dio1.Line(1:8),output);
        end
        if(~open_mouth)
            putvalue(dio1.Line(1:8),16); %close atleast once in each loop
        else
            putvalue(dio1.Line(1:8),32); %close atleast once in each loop
        end
        putvalue(dio1.Line(1:8),0);
    end
end% of while(1)


fprintf('Ball DROPPED \n');
%drop the ball
for j=1:5
    
    putvalue(dio1.Line(1:8),6);%open+forward
    putvalue(dio1.Line(1:8),6);%open+forward
    putvalue(dio1.Line(1:8),6);%open+forward
    putvalue(dio1.Line(1:8),9);%open+forward
    putvalue(dio1.Line(1:8),9);%open+forward
    putvalue(dio1.Line(1:8),9);%open+forward
    putvalue(dio1.Line(1:8),10);%open+forward
     putvalue(dio1.Line(1:8),10);%open+forward
     
end
for j=1:2
    putvalue(dio1.Line(1:8),6);%open+forward
    putvalue(dio1.Line(1:8),6);%open+forward
    putvalue(dio1.Line(1:8),6);%open+forward
    putvalue(dio1.Line(1:8),9);%open+forward
    putvalue(dio1.Line(1:8),9);%open+forward
    putvalue(dio1.Line(1:8),9);%open+forward
    putvalue(dio1.Line(1:8),5);%open+backword
end

for j=1:4
     putvalue(dio1.Line(1:8),16+5);%open+backword
end
putvalue(dio1.Line(1:8),32);%open+backword
for j=1:4
     putvalue(dio1.Line(1:8),32+5);%open+backword
end
 putvalue(dio1.Line(1:8),0);%open+backword
return

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function corner_achived=allignment_of_robot(STOPPING_ANGLE,Destination_point_cordinate,...
    STOPPING_DISTANCE,drop_grab_output)
corner_achived=0;
%global varables;
global ROBOT_FRONT_CORDINATES
global ROBOT_BACK_CORDINATES
global dio1;%used for movement of travelling motors
global REVERSE_EQU_ANGLE;
global vid;  %video input
global input_colored_image
global tolcirc_robot;

%%
Min_ON_angular_mov=1;
Max_ON_angular_mov=1;
Max_ON_angular_mov_angle=120;
%right_left_motor_flag=1 move left motor right_left_motor_flag=0 move left
%right_left_motor_flag=1;
%*** make it global variable
%%
left_right_flag=0;
while(1)

    getting_robot_cordinates(0);         %robot coordinate update here

    ROBOT_CORDINATES=(2*ROBOT_FRONT_CORDINATES-ROBOT_BACK_CORDINATES);
    hold on
    plot(ROBOT_CORDINATES(1),ROBOT_CORDINATES(2),'rx','LineWidth',2);
    %%
    [r t]=ditance_and_angle(ROBOT_CORDINATES,Destination_point_cordinate,...
        4*ROBOT_FRONT_CORDINATES-3*ROBOT_BACK_CORDINATES);
    fprintf('Allignment for destination Distance =%.1f       angle=%.1f\n',r,t);

    if(r<=STOPPING_DISTANCE | (r<=50 & (abs(t)>=180-REVERSE_EQU_ANGLE)))
        corner_achived=1;
        return;
    elseif (abs(t)<=STOPPING_ANGLE)
        corner_achived=0;
        return;
    elseif(abs(t)<3*STOPPING_ANGLE)
        if(t>=0)
            %output=6;
            if(left_right_flag==0)left_right_flag=1; output=4;
            else left_right_flag=0; output=2;
            end
        else
            % output=9;
            if(left_right_flag==0)left_right_flag=1;output=8;
            else left_right_flag=0;output=1;
            end
        end
        putvalue(dio1.Line(1:8),output+drop_grab_output);
    else


        if(t>=0)
            putvalue(dio1.Line(1:8),6+drop_grab_output);
        else
            putvalue(dio1.Line(1:8),9+drop_grab_output);
        end

        % for i=1:No_of_mov
        %         putvalue(dio1.Line(1:8),output);
        % end
        %%
    end
     putvalue(dio1.Line(1:8),0);
end
