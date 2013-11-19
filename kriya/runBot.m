function successFlag = runBot(cornerToMove)
%**************   for color parport

%**************   +  -  - +
%**************   R  m  L m
%**************   32 16 8 4

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
moveFront=9; % for IBot0901
moveBack=6;
moveLeft=5;
moveRight=10;


minSpeed=100;
maxSpeed=300;
% maxSpeed=minSpeed;
% minResponce=10;
% minMov=5;



STOPPING_DISTANCE_CORNER=15;
% STOPPING_DISTANCE_DESTI=15;
slow_down_dist=35;

numOfCorners=length(cornerToMove);

EQU_ANGLE=20;
REVERSE_EQU_ANGLE=20;
successFlag = 1;

%% PLOT
imshow(sampleArena);
hold on;


plot(cornerToMove(:,1),cornerToMove(:,2),'rx','LineWidth',2);
for cornerCount=1:numOfCorners-1
    line([cornerToMove(cornerCount:cornerCount+1,1)],[cornerToMove(cornerCount:cornerCount+1,2)]);
end

timeOutFlag = getOurRoboCordi(1);
timeOutFlag = getOurRoboCordi(0);
%% ***** achiving corners 
for cornerCount=2:numOfCorners
    Destination_point_cordinate=cornerToMove(cornerCount,:);
    timeOutFlag = getOurRoboCordi(0);
    % start the timer
%     initTime = clock;
    initRoboCenterCordi = (ourRobotFrontCordi +ourRobotBackCordi)/2;

    while(1)
        speed=minSpeed;
        timeOutFlag = getOurRoboCordi(0);
        ROBOT_CORDINATES=ourRobotFrontCordi;

        %hold on
        % plot(ROBOT_CORDINATES(1),ROBOT_CORDINATES(2),'yx','LineWidth',2);
        [r t]=ditance_and_angle(ROBOT_CORDINATES,Destination_point_cordinate,2*ourRobotFrontCordi - ourRobotBackCordi);
%         [r t]=ditance_and_angle(initRoboCenterCordi,Destination_point_cordinate,2*ourRobotFrontCordi - ourRobotBackCordi);

        fprintf('moving for before corners :  (In between) r=%.1f    t=%.1f\n',r,t);
        if((r<=STOPPING_DISTANCE_CORNER) | ((r<=35) & (abs(t)>=180-REVERSE_EQU_ANGLE)))
            break;
        elseif((r<=slow_down_dist) & (abs(t)<=2*EQU_ANGLE))
            speed=round(minSpeed+(maxSpeed)/8);
            output=moveFront;%slow forward speed
        elseif( (r>slow_down_dist) & (abs(t)<=EQU_ANGLE ))
            speed=maxSpeed;
            output=moveFront;
        else% alignment of robot
            fprintf('Alignment for  Distance before =%.1f       angle=%.1f\n',r,t);
            if(abs(t)>=4*EQU_ANGLE)
                speed=round(minSpeed-20);
            else
                speed=round(minSpeed-20);
            end
            if(t>=0)
                output=moveRight;
                
                %putvalue(dio,6+drop_grab_output);
            else
                output=moveLeft;
                %putvalue(dio,9+drop_grab_output);
            end

            
            for temp=1:speed
                putvalue(dio,output);
            end

            putvalue(dio,stopAll);
            continue

        end

        
        for temp=1:speed
            putvalue(dio,output);
        end
        putvalue(dio,stopAll);

    end% of while(1)
    successFlag=1;
end%of for loop
 successFlag=1;
 putvalue(dio,64);
end

