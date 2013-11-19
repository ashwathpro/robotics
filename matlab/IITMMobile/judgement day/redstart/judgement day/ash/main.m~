clc;
close all;
startTime=clock;
%%
global input_colored_image
global size_input_colored_image

input_colored_image=getsnapshot(vid);
%input_colored_image=imread('withBall2.jpg');
size_input_colored_image=size(input_colored_image);
center_of_arena=[size_input_colored_image(2) size_input_colored_image(1)]/2;
%% loop for dropping all balls
%isBallPresentFlag=1;  % as first time we will assume ball are there
imageCutIndexForBall =0; % used reomving corners of image while searching for the ball


while(1) %loop
    %close all
    %get our robot position
    timeOutFlag = getOurRoboCordi(0);
        if(timeOutFlag==1)
            timeOutSubRoutine(1);
            continue
        end
    %get opponnent robot
    detectedRobot = getOpponentRoboCordi(0);
    %if opponent robot is not detected call in full image
    if(detectedRobot==0)getOpponentRoboCordi(1);end

    %% geeting balls
    input_colored_image=getsnapshot(vid);
    %input_colored_image=imread('withBall2.jpg');

    %getting all ball information
    imageCutIndexForBall = 0;%cropping all sides
    [numOfBalls, allBallsCordinates]=balls_information(input_colored_image,imageCutIndexForBall);
    if(sum(numOfBalls)==0)
        fprintf('\n*******sorry boss.... NO ball is found in image cropped with Side alone***\n');
        %calling it again with cropping corners alone
        input_colored_image=getsnapshot(vid);
        imageCutIndexForBall = 1;%removing corners alone
        [numOfBalls, allBallsCordinates]=balls_information(input_colored_image,imageCutIndexForBall);

        %even if ball not detected then remove all cropped portion
        if(sum(numOfBalls)==0)
            fprintf('\n*********sorry boss.... NO ball detected in image cropped with Corner alone******* \n');
            %calling it again  in full image
            input_colored_image=getsnapshot(vid);
            imageCutIndexForBall = 2;%full image
            [numOfBalls, allBallsCordinates]=balls_information(input_colored_image,imageCutIndexForBall);

            if(sum(numOfBalls)==0)
                fprintf('\n******* very sorry boss...NO ball is there in FULL IMAGE also ***\n');
                %**** calling free_movements
                fprintf('\n in free runniing mode\n');
                %***dinamically change the tolerance of the ball and loose the
                %constrains in ball colors too
                [numOfBalls, allBallsCordinates]=free_movement();

                continue
            end
        end
        %% choose  shortest path for (robot to ball +ball to hole)
    end

    if(sum(numOfBalls)==1)
        selectedBallIndex = 1;
        selectedBallColor = find(numOfBalls==1);
        fprintf('\n Only one ball is there in Arena\n');
    elseif(sum(numOfBalls)>1) %for more than ball we have to select one ball
        fprintf('\n getting optimum ball\n');
        [ selectedBallIndex ,selectedBallColor] = getSelectedBallInfo(numOfBalls,allBallsCordinates);

    end

    % camera adjustments for ball
    allBallsCordinates(selectedBallIndex,:)=(allBallsCordinates(selectedBallIndex,:)*25-...
        center_of_arena)/24;

    % movement_of_robot consist of three part
    %Part1:Move till successful grab of the ball
    % formation of path
    [numOfCorners,corner_cordinates]=getting_corners(selectedBallIndex,allBallsCordinates,numOfBalls,0);

    

    successfulFlag = successful_grab_drop(numOfCorners,corner_cordinates,selectedBallColor,1);
    if(successfulFlag==0)
        continue
    end

    fprintf('\n ### Time Elapsed : %f  seconds  ####\n',etime(clock,startTime))

    %Part2: check wether we have grapped the ball properly or not
    input_colored_image=getsnapshot(vid); %
    %call ball information
    [temp_numOfBalls,allBallsCordinates]=balls_information(input_colored_image,imageCutIndexForBall);
    if(temp_numOfBalls(selectedBallColor)<numOfBalls(selectedBallColor))
        %Part3: ball to goalPost: successful drop of the ball
        numOfBalls=temp_numOfBalls;
        %for droping the ball out selected ball index as 0 as
        [numOfCorners corner_cordinates]=getting_corners(0,0,0,1);
        %close all
        successfulFlag = successful_grab_drop(numOfCorners,corner_cordinates,selectedBallColor,0);
        if(successfulFlag==0)
            continue
        end
        fprintf('\n ### Time Elapsed : %f  seconds  ####\n',etime(clock,startTime))
    else
        fprintf('****** Error : ball is not properly grabbed  ***\n ');
    end

end%end of while lopp
