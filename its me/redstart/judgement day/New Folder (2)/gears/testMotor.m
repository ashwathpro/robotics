
%% global variables to robo output
global g_stopAll
% 
global g_moveFront
global g_moveBack
global g_moveLeft
global g_moveRight
%flap motor
global g_openFlap
global g_closeFlap
global g_stopFlap
%speed setting of robot
global g_minSpeed
global g_maxSpeed
global g_minResponce
global g_minMov
global g_minFlap
g_stopAll   = 0;
g_moveFront = 1;
g_moveBack  = 2;
g_moveLeft  = 3;
g_moveRight = 4;
g_openFlap  = 5;
g_closeFlap = 6;
g_stopFlap  = 7;
g_minSpeed  =11;
g_maxSpeed  =15;
g_minResponce=7;
g_minMov=8;
g_minFlap=4;

%%

for i=1:g_minResponce
    putvalue(dio1.Line(1:4),15);
end
for i=1:g_minMov
    putvalue(dio1.Line(1:4),1);
end

putvalue(dio1.Line(1:4),0);