function  selectedShootPtIndex  = getSelectedShootPtInfo()

%% ^^^^^^^^^ global variable defined for this file alone

global g_ourRobotFrontCordi
global g_ourRobotColorIndex   % red is 1...blue is 2


% the cordi where robot start running for shoot the balls
global g_minShootCordisRedGoalPost
% global g_maxShootCordisRedGoalPost
global g_minShootCordisBlueGoalPost
% global g_maxShootCordisBlueGoalPost

global g_BWOppRobot

global g_numOfShootPtsAtOneSide
%%
robot_carrier_cordinates = g_ourRobotFrontCordi;
if(g_ourRobotColorIndex==1)% our color is red then we have to shoot BLUE goal post
    shootCordis = g_minShootCordisBlueGoalPost;
else
    shootCordis = g_minShootCordisRedGoalPost;
end
numOfShootCordi = g_numOfShootPtsAtOneSide*2+1;

R = zeros(numOfShootCordi,1);
multiplier = 1; % every time as we proceed towards extrem points we will prefer center point
% thus we will keep on increase distance by 10%
for cordiCount=1:numOfShootCordi
    if(rem(cordiCount,2)==0) multiplier = multiplier + 0.05; end
    %check if she shoot point is not occupied by opponent robot
    shootPoint = round(shootCordis(cordiCount,:));
    if(g_BWOppRobot(shootPoint(2),shootPoint(1)))
        R(cordiCount) = inf;
    else
        R(cordiCount) = abs((shootPoint-robot_carrier_cordinates)*[1 ; i]);
        R(cordiCount) = R(cordiCount)+ getNumOfObsPoints(round(robot_carrier_cordinates),shootPoint);
        R(cordiCount) =R(cordiCount)*multiplier;
    end
end
%[short ind]=sort(R)
[min_R min_R_index]=min(R);
selectedShootPtIndex = min_R_index;
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