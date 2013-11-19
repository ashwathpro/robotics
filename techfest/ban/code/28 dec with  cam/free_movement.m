function [no_of_balls, balls_coodinates]=free_movement()
no_of_balls=[];
balls_coodinates=[];
%% global values
global dio1;
global ROBOT_FRONT_CORDINATES
global ROBOT_BACK_CORDINATES
global size_input_colored_image
global vid
global input_colored_image;
putvalue(dio1.Line(1:8),0);

free_move_point_cordinate=[size_input_colored_image(2) size_input_colored_image(1);
    size_input_colored_image(2) size_input_colored_image(1)-200;
    size_input_colored_image(2) size_input_colored_image(1)+200]/2;
index_free_move_point=0;
%%
Max_ON_linear_mov=12;          % may be 80
Min_ON_linear_mov=5;       % may be 10
Max_ON_linear_mov_dis=120;

STOPPING_DISTANCE=50;
slow_down_dist=2*STOPPING_DISTANCE;

EQU_ANGLE=20;
REVERSE_EQU_ANGLE=40;

skip_mov=0;


%% open the mouth
for j=1:10
    putvalue(dio1.Line(1:8),32+5);
end
putvalue(dio1.Line(1:8),0);

while(1)
    input_colored_image=getsnapshot(vid);
    [no_of_balls, balls_coodinates]=balls_information();
    if(sum(no_of_balls)~=0) return;end
    fprintf('******** NO BALL IN ARENA ****** \n\n')
    % index_free_move_point=index_free_move_point+1;
    index_free_move_point=rem(index_free_move_point,3)+1;

    Destination_point_cordinate=free_move_point_cordinate(index_free_move_point,:);
    while(1)
        skip_mov=0;
        getting_robot_cordinates(0);
        ROBOT_CORDINATES=ROBOT_FRONT_CORDINATES;
        hold on
        plot(ROBOT_CORDINATES(1),ROBOT_CORDINATES(2),'yx','LineWidth',2);
        [r t]=ditance_and_angle(ROBOT_CORDINATES,Destination_point_cordinate,...
            2*ROBOT_FRONT_CORDINATES-ROBOT_BACK_CORDINATES);

        fprintf('FREE MOVEMENT:   r=%.1f    t=%.1f \n',r,t);

        if(r<=STOPPING_DISTANCE |(r<=60 & (abs(t)>=180-REVERSE_EQU_ANGLE)) )
            % if(r<=50 & (abs(t)>=180-REVERSE_EQU_ANGLE))
            break;
%         elseif(r<=2*STOPPING_DISTANCE & abs(t)<=EQU_ANGLE)
%             No_of_mov=Min_ON_linear_mov;
%             output=10;%slow forward speed

        elseif( r>STOPPING_DISTANCE & abs(t)<=EQU_ANGLE )
            No_of_mov=Min_ON_linear_mov+((Max_ON_linear_mov-Min_ON_linear_mov)/(Max_ON_linear_mov_dis-slow_down_dist))*(r-slow_down_dist);
            output=10;
        else

            achived=allignment_of_robot(EQU_ANGLE,Destination_point_cordinate,STOPPING_DISTANCE,0);
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
    end% of while(1)



    fprintf('FREE POINT ACHIVED\n');

end
return
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

    ROBOT_CORDINATES=ROBOT_FRONT_CORDINATES ;
    hold on
    plot(ROBOT_CORDINATES(1),ROBOT_CORDINATES(2),'rx','LineWidth',2);
    %%
    [r t]=ditance_and_angle(ROBOT_CORDINATES,Destination_point_cordinate,...
        2*ROBOT_FRONT_CORDINATES-ROBOT_BACK_CORDINATES);
    fprintf('Allignment for destination Distance =%.1f       angle=%.1f\n',r,t);

    if(r<=STOPPING_DISTANCE | (r<=50 & (abs(t)>=180-REVERSE_EQU_ANGLE)))
        corner_achived=1;
        return;
    elseif (abs(t)<=STOPPING_ANGLE)
        corner_achived=0;
        return;
%     elseif(abs(t)<5*STOPPING_ANGLE)
%         if(t>=0)
%             %output=6;
%             if(left_right_flag==0)left_right_flag=1; output=4;
%             else left_right_flag=0; output=2;
%             end
%         else
%             % output=9;
%             if(left_right_flag==0)left_right_flag=1;output=8;
%             else left_right_flag=0;output=1;
%             end
%         end
%         putvalue(dio1.Line(1:8),output+drop_grab_output);
    else


        if(t>=0)
           % putvalue(dio1.Line(1:8),6+32);
           output=6+32;
        else
           % putvalue(dio1.Line(1:8),9+32);
            output=9+32;
        end

         for i=1:1
                putvalue(dio1.Line(1:8),output);
         end
        %%
    end
    putvalue(dio1.Line(1:8),0);
end

