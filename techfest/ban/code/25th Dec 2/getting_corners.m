function [no_of_corners,corner_cordinates]=getting_corners(No_of_selected_ball,color_of_ball,grab_drop_flag)
% grab_drop_flag=0 for grab 1 for drop
no_of_corners=0;
corner_cordinates=[];
global BW_HOLES_IMAGE;%contains holes only
global holes_coodinates;
global no_of_balls;
global balls_coodinates;
global size_input_colored_image;
global ball_bulging
global image_resize_factor;
global Resized_BW_BULGED_IMAGE;
global ROBOT_FRONT_CORDINATES;
global ROBOT_BACK_CORDINATES;
global length_for_hole_detection
global extra_hole_point


BW_Block_image2=logical(zeros(size_input_colored_image(1),size_input_colored_image(2)));

%bulging other balls
for j=1:sum(no_of_balls)
    if(j~=No_of_selected_ball | grab_drop_flag==1 )
        try
            BW_Block_image2(balls_coodinates(j,2)-ball_bulging:balls_coodinates(j,2)+ball_bulging,...
                balls_coodinates(j,1)-ball_bulging:balls_coodinates(j,1)+ball_bulging)=logical(1);

        end

    end
end
BW_Block_image=BW_Block_image2(1:size_input_colored_image(1),1:size_input_colored_image(2));
%figure,imshow(BW_Block_image)
% grab_drop_flag=1

if(grab_drop_flag==0) % for grabing ball

    BW_Block_image=BW_Block_image | BW_HOLES_IMAGE;


    start_pt=ROBOT_FRONT_CORDINATES;
    end_pt=balls_coodinates(No_of_selected_ball,:);
    [corner_cordinates , no_of_corners]=getting_corner_points_simple(start_pt,end_pt,BW_Block_image);

    %check ball near the walls
    if(end_pt(1)<length_for_hole_detection/2) end_pt(1)=length_for_hole_detection;end
    if(end_pt(2)<length_for_hole_detection/2) end_pt(2)=length_for_hole_detection;end
    if(end_pt(1)>size_input_colored_image(2)-length_for_hole_detection)...
            end_pt(1)=size_input_colored_image(2)-length_for_hole_detection;end
    if(end_pt(2)>size_input_colored_image(2)-length_for_hole_detection)...
            end_pt(2)=size_input_colored_image(2)-length_for_hole_detection;end

    if(end_pt(1)~=balls_coodinates(No_of_selected_ball,1) | end_pt(2)~=balls_coodinates(No_of_selected_ball,2))
        %  this shoews ball is near the wall
        corner_cordinates(no_of_corners,:)=end_pt;
        no_of_corners= no_of_corners+1;
        corner_cordinates(no_of_corners,:)=balls_coodinates(No_of_selected_ball,:);
    end

    %% ****************** this wall formation must be done only one time
else % for droping ball
    %adding walls
    robot_carrier_cordinates=(ROBOT_FRONT_CORDINATES+ROBOT_BACK_CORDINATES)/2;


    start_pt=ROBOT_FRONT_CORDINATES;
    end_pt=holes_coodinates(color_of_ball,:);

    [corner_cordinates , no_of_corners]=getting_corner_points_simple(start_pt,end_pt,BW_Block_image);
    % adding extra point for hole
    corner_cordinates(no_of_corners,:)=extra_hole_point(color_of_ball,:);
    no_of_corners= no_of_corners+1;
    corner_cordinates(no_of_corners,:)=holes_coodinates(color_of_ball,:);
end


%figure,imshow(BW_Block_image)
% hold on
% plot(shortest_path(:,1),shortest_path(:,2),'rx')