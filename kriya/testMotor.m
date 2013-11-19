global dio;
global ourRobotFrontCordi
global ourRobotBackCordi
global sampleArena
%% global variables to robo output
global stopAll
%
global moveFront
global moveBack
global moveLeft
global moveRight

%speed setting of robot
global minSpeed
global maxSpeed

global speed
global output
% global minResponce
% global minMov
%% %%
global STOPPING_DISTANCE_CORNER
% global STOPPING_DISTANCE_DESTI
global slow_down_dist
global EQU_ANGLE
global REVERSE_EQU_ANGLE


%%
stopAll=0;
moveFront=36;
moveBack=24;
moveLeft=40;
moveRight=20;


minSpeed=50;
maxSpeed=100;
% minResponce=10;
% minMov=5;



STOPPING_DISTANCE_CORNER=25;
% STOPPING_DISTANCE_DESTI=15;
slow_down_dist=50;

% numOfCorners=length(cornerToMove);

EQU_ANGLE=30;
REVERSE_EQU_ANGLE=12;
successFlag = 1;

speed = maxSpeed;
output = moveFront;

%%
for temp=1:speed
    putvalue(dio,output);
end
putvalue(dio,0);