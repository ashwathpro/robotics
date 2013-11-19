clc;close all;
time1=clock;
%%
%input_colored_image=getsnapshot(vid);
input_colored_image=imread('Standard Arena copy.jpg');
size_input_colored_image=size(input_colored_image)
return
%% loop for dropping all balls
 No_of_balls_becomed_zero=0;  % as first time ball infromation give no ball it set
% ????? what is the use of black_dist
 black_dist=2*(min(min(holes_coodinates)));
while(1) %loop
    %% ******gettting robot position
    close all
    getting_robot_cordinates(0);
    %% geeting balls
    %***input_colored_image=getsnapshot(vid);
    input_colored_image=imread('Standard Arena copy.jpg');
    %removing corners points images
 
    
    if(No_of_balls_becomed_zero==0) % black the corner so first it will collect easy ball
    input_colored_image(1:black_dist,1:black_dist,:)=0;
    input_colored_image(size_input_colored_image(1)-black_dist:size_input_colored_image(1),1:black_dist,:)=0;
    input_colored_image(1:black_dist,size_input_colored_image(2)-black_dist:size_input_colored_image(2),:)=0;
    input_colored_image(size_input_colored_image(1)-black_dist:size_input_colored_image(1)...
        ,size_input_colored_image(2)-black_dist:size_input_colored_image(2),:)=0;
   % figure,imshow(input_colored_image);
    end
    [no_of_balls, balls_coodinates]=balls_information();

    %     while(sum(no_of_balls)==0)
    %         clock-time1
    %         fprintf('******** NO BALL IN ARENA ****** \n\n')
    %         [no_of_balls, balls_coodinates]=balls_information();
    %
    %     end
    if(sum(no_of_balls)==0)
        No_of_balls_becomed_zero=1;
        fprintf('\n NO ball Detected\n');
        input_colored_image=getsnapshot(vid);
        [no_of_balls, balls_coodinates]=balls_information();
        if(sum(no_of_balls)==0)
            [no_of_balls, balls_coodinates]=free_movement();
        end
        continue;
        %% choose  shortest path for (robot to ball +ball to hole)
    elseif(sum(no_of_balls)==1)
        No_of_selected_ball=1;
        color_of_ball=find(no_of_balls==1);
        fprintf('\n Only one ball is there in Arena\n');
    else
        fprintf('\n calling shortest path ball\n');
        [No_of_selected_ball,color_of_ball]=getting_shortest_path_ball();

        %         if(color_of_ball==0)
        %             fprintf(' \n******** SELECTED BALL IS MOVING*********** \n \n');
        %             continue;
        %         end
    end

    %      balls_coodinates
    
     %% camera adjustments for ball
         center_of_arena=[size_input_colored_image(2) size_input_colored_image(1)]/2;
    %     balls_coodinates
       balls_coodinates(No_of_selected_ball,:)=(balls_coodinates(No_of_selected_ball,:)*25-...
             center_of_arena)/24;



    %% movement_of_robot consist of two part
    %% part1 till successful grab of the ball
    % formation of path
    [no_of_corners,corner_cordinates]=getting_corners(No_of_selected_ball,color_of_ball,0)

    figure,imshow(input_colored_image);
    hold on;
    plot(corner_cordinates(:,1),corner_cordinates(:,2),'rx','LineWidth',2);
    for j=1:no_of_corners-1
        line([corner_cordinates(j:j+1,1)],[corner_cordinates(j:j+1,2)]);
    end

    successful_grab(no_of_corners,corner_cordinates,color_of_ball)
    clock-time1

    %check_no_of_balls again
    input_colored_image=getsnapshot(vid); %
     getting_robot_cordinates(0);
    % black in side ring
    ROBOT_CORDINATES=(9*ROBOT_FRONT_CORDINATES-5*ROBOT_BACK_CORDINATES)/4;
    upper_ball_cordi=round(ROBOT_CORDINATES-[15 15]);
    if(upper_ball_cordi(1)<=0)upper_ball_cordi(1)=1;end
    if(upper_ball_cordi(2)<=0)upper_ball_cordi(2)=1;end
    lower_ball_cordi=round(ROBOT_CORDINATES+[15 15]);
    if(lower_ball_cordi(1)>=size_input_colored_image(2))lower_ball_cordi(1)=size_input_colored_image(2);end
    if(lower_ball_cordi(2)>=size_input_colored_image(1))lower_ball_cordi(2)=size_input_colored_image(1);end

    input_colored_image(upper_ball_cordi(2):lower_ball_cordi(2)...
        ,upper_ball_cordi(1):lower_ball_cordi(1),:)=0;
    % figure,imshow(input_colored_image);

    
    
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
    if(temp_no_of_balls(color_of_ball)<no_of_balls(color_of_ball))
        %% part2 ball to hole: successful drop of the ball
       no_of_balls=temp_no_of_balls;
        [no_of_corners corner_cordinates]=getting_corners(No_of_selected_ball,color_of_ball,1)
        %close all
        figure,imshow(input_colored_image);
        hold on;
        plot(corner_cordinates(:,1),corner_cordinates(:,2),'rx','LineWidth',2);
        for j=1:no_of_corners-1
            line([corner_cordinates(j:j+1,1)],[corner_cordinates(j:j+1,2)]);
        end
        successful_drop(no_of_corners,corner_cordinates,color_of_ball)
        clock-time1
    else
        fprintf('ball is not properly grabbed\n');
    end

end%end of while lopp