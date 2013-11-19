clc
close all

%%
global distance_from_corner
global maxAllowableCorners
global g_ourRobotFrontCordi
global vid

global g_cordiTimeoutSec
global g_TimeOutDisplacement

maxAllowableCorners  = 10;
distance_from_corner = 30;

g_cordiTimeoutSec       = 10;
g_TimeOutDisplacement   = 25;
%
input_colored_image=getsnapshot(vid);
%input_colored_image=imread('withBall2.jpg');
figure,imshow(input_colored_image)

getOurRoboCordi(0);
getOpponentRoboCordi(1)
[numOfBalls, allBallsCordinates]=balls_information(input_colored_image,2);
if(sum(numOfBalls)~=0)
    if(sum(numOfBalls)==1)
        selectedBallIndex = 1;
        selectedBallColor = find(numOfBalls==1);
        fprintf('\n Only one ball is there in Arena\n');
    elseif(sum(numOfBalls)>1) %for more than ball we have to select one ball
        fprintf('\n getting optimum ball\n');
        [ selectedBallIndex ,selectedBallColor] = getSelectedBallInfo(numOfBalls,allBallsCordinates);
    end

    % robot to ball
    [numOfCorners,corner_cordinates]=getting_corners(selectedBallIndex,allBallsCordinates,numOfBalls,0);
    selectedBallCordi = allBallsCordinates(selectedBallIndex,:);

    hold on;
    plot(corner_cordinates(:,1),corner_cordinates(:,2),'rx','LineWidth',2);
    for j=1:numOfCorners-1
        line([corner_cordinates(j:j+1,1)],[corner_cordinates(j:j+1,2)]);
    end
    %ball to goal post
    tempOurRobotFrontCordi = g_ourRobotFrontCordi;
    % temporay changing the robo cordi
    g_ourRobotFrontCordi = selectedBallCordi;
    [numOfCorners corner_cordinates]=getting_corners(0,0,0,1);
    % revert back the original value of robo cordi
    g_ourRobotFrontCordi = tempOurRobotFrontCordi ;

    hold on;
    plot(corner_cordinates(:,1),corner_cordinates(:,2),'rs','LineWidth',2);
    for j=1:numOfCorners-1
        line([corner_cordinates(j:j+1,1)],[corner_cordinates(j:j+1,2)]);
    end
    
    
else
    [numOfCorners corner_cordinates]=getting_corners(0,0,0,1);
    hold on;
    plot(corner_cordinates(:,1),corner_cordinates(:,2),'rx','LineWidth',2);
    for j=1:numOfCorners-1
        line([corner_cordinates(j:j+1,1)],[corner_cordinates(j:j+1,2)],'Color','r');
    end
end
