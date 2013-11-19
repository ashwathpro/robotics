%% global color values
global g_RED_COLOR_GOAL_POST
global g_BLUE_COLOR_GOAL_POST

%% global variables for ball

global ball_bulging
ball_bulging=50;
global distance_from_corner;
distance_from_corner=30;

%% global variables for robot
global ROBOT_FRONT_CORDINATES;
global ROBOT_BACK_CORDINATES;

%% other global variables
global vid;
global BW_HOLES_IMAGE;%contains holes only
global holes_coodinates;
global no_of_balls;
global balls_coodinates;
global input_colored_image;
global size_input_colored_image;
%global tolcirc_robot;
global No_of_balls_becomed_zero
global black_dist

global coordinate_matrix; %coordinate_matrix used in line_path_cordinates.m file
coordinate_matrix=zeros(480,640,2);
for j=1:640
    coordinate_matrix(:,j,1)=j;
end
for k=1:480
    coordinate_matrix(k,:,2)=k;
end


global dio1;% used for movement of travelling motors
dio1=digitalio('parallel','LPT1');
addline(dio1,[0:7],'out');
putvalue(dio1.Line(1:8),0);