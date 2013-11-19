function successfulFlag = successful_grab_drop(numOfCorners,corner_cordinates,selectedBallColor,grabDropFlag)

global dio1;
global g_ourRobotFrontCordi
global g_ourRobotBackCordi
global input_colored_image
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
global g_minFlap
%speed setting of robot
global g_minSpeed
global g_maxSpeed
global g_minResponce
global g_minMov
%% %%
global STOPPING_DISTANCE_CORNER
global STOPPING_DISTANCE_DESTI
global slow_down_dist
global EQU_ANGLE
global REVERSE_EQU_ANGLE

global g_cordiTimeoutSec
global g_TimeOutDisplacement
%%
putvalue(dio1.Line(1:4),g_stopAll);
%%


STOPPING_DISTANCE_CORNER=25;
STOPPING_DISTANCE_DESTI=15;
slow_down_dist=40;

EQU_ANGLE=12;
REVERSE_EQU_ANGLE=30;
successfulFlag = 1;

%% PLOT
close all
figure,imshow(input_colored_image);
hold on;
plot(corner_cordinates(:,1),corner_cordinates(:,2),'rx','LineWidth',2);
for cornerCount=1:numOfCorners-1
    line([corner_cordinates(cornerCount:cornerCount+1,1)],[corner_cordinates(cornerCount:cornerCount+1,2)]);
end


%% the mouth
if ((grabDropFlag==1) || ( grabDropFlag==3))
    for j=1:g_minFlap
        putvalue(dio1.Line(1:4),g_openFlap);
    end
else
    for j=1:g_minFlap
        putvalue(dio1.Line(1:4),g_closeFlap);
    end
end

putvalue(dio1.Line(1:4),g_stopAll);
%% ***** achiving corners other than last corners
for cornerCount=2:numOfCorners-1
    Destination_point_cordinate=corner_cordinates(cornerCount,:);
    timeOutFlag = getOurRoboCordi(0);
    %*** TIME OUT SUB ROUTINE NOT IMP
    % start the timer
    initTime = clock;
    initRoboCenterCordi = (g_ourRobotFrontCordi +g_ourRobotBackCordi)/2;

    while(1)
        speed=g_minSpeed;
        timeOutFlag = getOurRoboCordi(0);
        
        if(timeOutFlag==1)
            timeOutSubRoutine(1);
            successfulFlag = 0;
            return
        end
            
        % ######################################################
        % time out checker
        if(etime(clock,initTime)>= g_cordiTimeoutSec)
            initTime = clock;
            roboCenterCordi = (g_ourRobotFrontCordi +g_ourRobotBackCordi)/2;
            RoboDisplacement = abs((roboCenterCordi - initRoboCenterCordi) * [1;i]);
            initRoboCenterCordi = roboCenterCordi;

            if(RoboDisplacement < g_TimeOutDisplacement)
                %****** call time out routine
                timeOutSubRoutine(1);
                successfulFlag = 0;
                
                fprintf('\n$$$$ ERROR : Time Out happen as robot got stuck $$$$\n')

                return
            end
        end
        %####################################################
        ROBOT_CORDINATES=g_ourRobotFrontCordi;

        %hold on
        % plot(ROBOT_CORDINATES(1),ROBOT_CORDINATES(2),'yx','LineWidth',2);
        [r t]=ditance_and_angle(ROBOT_CORDINATES,Destination_point_cordinate,2*g_ourRobotFrontCordi - g_ourRobotBackCordi);

        fprintf('moving for before corners : %d  (In between) r=%.1f    t=%.1f\n',selectedBallColor,r,t);
        if((r<=STOPPING_DISTANCE_CORNER) | ((r<=50) & (abs(t)>=180-REVERSE_EQU_ANGLE)))
            break;
        elseif((r<=slow_down_dist) & (abs(t)<=2*EQU_ANGLE))
            speed=(g_minSpeed+g_maxSpeed)/2;
            output=g_moveFront;%slow forward speed
        elseif( (r>slow_down_dist) & (abs(t)<=EQU_ANGLE ))
            speed=g_maxSpeed;
            output=g_moveFront;
        else% allignment of robot
            fprintf('Allignment for  Distance before =%.1f       angle=%.1f\n',r,t);
            if(abs(t)>=4*EQU_ANGLE)
                speed=(g_minSpeed+g_maxSpeed)/2;
            else
                speed=g_minSpeed;
            end
            if(t>=0)
                output=g_moveLeft;
                %putvalue(dio1.Line(1:4),6+drop_grab_output);
            else
                output=g_moveRight;
                %putvalue(dio1.Line(1:4),9+drop_grab_output);
            end

            for temp=1:g_minResponce
                putvalue(dio1.Line(1:4),speed),
            end
            for temp=1:g_minMov
                putvalue(dio1.Line(1:4),output);
            end

            putvalue(dio1.Line(1:4),g_stopAll);
            continue

        end

        for temp=1:g_minResponce
            putvalue(dio1.Line(1:4),speed),
        end
        for temp=1:g_minMov
            putvalue(dio1.Line(1:4),output);
        end
        putvalue(dio1.Line(1:4),g_stopAll);

    end% of while(1)
end%of for loop

if(grabDropFlag==3)% as it called from free movement  
    return
end

%% achiving last corners (For ball)
Destination_point_cordinate=corner_cordinates(numOfCorners,:);

%start the timer
initTime = clock;
initRoboCenterCordi = (g_ourRobotFrontCordi +g_ourRobotBackCordi)/2;

if (grabDropFlag==1)
    %% open the mouth
    for j=1:g_minFlap
        putvalue(dio1.Line(1:4),g_openFlap);
    end
    putvalue(dio1.Line(1:4),g_stopAll);

    
    
    while(1)

        timeOutFlag = getOurRoboCordi(0);
        
        if(timeOutFlag==1)
            timeOutSubRoutine(1);
            successfulFlag = 0;
            return
        end
        % ######################################################
        % time out checker
        if(etime(clock,initTime)>= g_cordiTimeoutSec)
            initTime = clock;
            roboCenterCordi = (g_ourRobotFrontCordi +g_ourRobotBackCordi)/2;
            RoboDisplacement = abs((roboCenterCordi - initRoboCenterCordi) * [1;i]);
            initRoboCenterCordi = roboCenterCordi;

            if(RoboDisplacement < g_TimeOutDisplacement)
                %****** call time out routine
                timeOutSubRoutine(1);
                fprintf('\n$$$$ ERROR : Time Out happen as robot got stuck while grabbing the ball $$$$\n')
                successfulFlag = 0;
                return
            end
        end
        %####################################################
        ROBOT_CORDINATES=g_ourRobotFrontCordi;
        
        
        [r t]=ditance_and_angle(ROBOT_CORDINATES,Destination_point_cordinate,2*g_ourRobotFrontCordi - g_ourRobotBackCordi);

        fprintf('desti coordi grab: %d  r=%.1f    t=%.1f \n',selectedBallColor,r,t);

        % if(r<=STOPPING_DISTANCE_DESTI |(r<=50 & (abs(t)>=180-MAX_EQU_ANGLE)) )
        if(r<=50 & (abs(t)>=180-REVERSE_EQU_ANGLE))
            break;
        elseif(r<=STOPPING_DISTANCE_DESTI)
            break;
        elseif(r<=4*STOPPING_DISTANCE_DESTI & abs(t)<=EQU_ANGLE)
            speed=g_minSpeed;
            output=g_moveFront;%slow forward speed
        elseif((r<=slow_down_dist) & (abs(t)<=EQU_ANGLE))
            speed=(g_minSpeed+g_maxSpeed)/2;
            output=g_moveFront;%slow forward speed
        elseif( (r>slow_down_dist) & (abs(t)<=EQU_ANGLE) )
            speed=g_maxSpeed;
            output=g_moveFront;
        else % allignment of robot
            fprintf('Allignment for destination grab Distance =%.1f       angle=%.1f\n',r,t);
            if(abs(t)>=4*EQU_ANGLE)
                speed=(g_minSpeed+g_maxSpeed)/2;
            else
                speed=g_minSpeed;
            end
            if(t>=0)
                output=g_moveLeft;
            else
                output=g_moveRight;
            end
            for temp=1:g_minResponce
                putvalue(dio1.Line(1:4),speed),
            end
            for temp=1:g_minMov
                putvalue(dio1.Line(1:4),output);
            end
            putvalue(dio1.Line(1:4),g_stopAll);
            continue

        end
        for temp=1:g_minResponce
            putvalue(dio1.Line(1:4),speed),
        end
        for temp=1:g_minMov
            putvalue(dio1.Line(1:4),output);
        end
        putvalue(dio1.Line(1:4),g_stopAll);
    end% of while(1)
    fprintf('Ball Captured  \n');

    %capture the ball
    for temp=1:g_minResponce
        putvalue(dio1.Line(1:4),g_maxSpeed),
    end
    for temp=1:g_minFlap
        putvalue(dio1.Line(1:4),g_openFlap);
    end
    for j=1:4
        putvalue(dio1.Line(1:4),g_moveFront);
    end
    %% close the mouth
    for j=1:g_minFlap
        putvalue(dio1.Line(1:4),g_closeFlap);
    end
    for j=1:2*g_minMov
        putvalue(dio1.Line(1:4),g_moveBack);
    end
    putvalue(dio1.Line(1:4),g_stopAll);
    %%
else %% align for post
    %% close the mouth

    for j=1:g_minFlap
        putvalue(dio1.Line(1:4),g_closeFlap);
    end
    putvalue(dio1.Line(1:4),g_stopAll);
    while(1)
        timeOutFlag = getOurRoboCordi(0);
        
        if(timeOutFlag==1)
            timeOutSubRoutine(1);
            successfulFlag = 0;
            return
        end
        % ######################################################
        % time out checker
        if(etime(clock,initTime)>= g_cordiTimeoutSec)
            initTime = clock;
            roboCenterCordi = (g_ourRobotFrontCordi +g_ourRobotBackCordi)/2;
            RoboDisplacement = abs((roboCenterCordi - initRoboCenterCordi) * [1;i]);
            initRoboCenterCordi = roboCenterCordi;

            if(RoboDisplacement < g_TimeOutDisplacement)
                %****** call time out routine
                timeOutSubRoutine(1);
                
                fprintf('\n$$$$ ERROR : Time Out happen as robot got stuck while grabbing the ball $$$$\n')
                successfulFlag = 0;
                return
            end
        end
        %####################################################
        
        ROBOT_CORDINATES=g_ourRobotFrontCordi;

        %hold on
        %plot(ROBOT_CORDINATES(1),ROBOT_CORDINATES(2),'yx','LineWidth',2);
        [r t]=ditance_and_angle(ROBOT_CORDINATES,Destination_point_cordinate,2*g_ourRobotFrontCordi - g_ourRobotBackCordi);

        fprintf('align for shooting =%.1f       angle=%.1f\n',r,t);
        if(abs(t)>=4*EQU_ANGLE)
            speed=(g_minSpeed+g_maxSpeed)/2;
        else
            speed=g_minSpeed;
        end
        if((abs(t)<=EQU_ANGLE))
            break
        else
            if(t>=0)
                output=g_moveLeft;
            else
                output=g_moveRight;
            end
            for temp=1:g_minResponce
                putvalue(dio1.Line(1:4),speed),
            end
            for temp=1:g_minMov
                putvalue(dio1.Line(1:4),output);
            end
            putvalue(dio1.Line(1:4),g_stopAll);
            continue
        end
    end
    %% shooting code


    for temp=1:g_minFlap
        putvalue(dio1.Line(1:4),g_openFlap);
    end

    for temp=1:g_minResponce
        putvalue(dio1.Line(1:4),g_maxSpeed),
    end
    for temp=1:6*g_minMov
        putvalue(dio1.Line(1:4),g_moveFront);
    end
    for temp=1:8*g_minMov
        putvalue(dio1.Line(1:4),g_moveBack);
    end
    putvalue(dio1.Line(1:4),g_stopAll);
    %     end
end