function [no_of_corners,corner_cordinates]=getting_corners(No_of_selected_ball,color_of_ball,grab_drop_flag)
% grab_drop_flag= 0 for grab, 1 for drop
no_of_corners=0;
corner_cordinates=[];

global no_of_balls;
global balls_coodinates;
global size_input_colored_image;
global ball_bulging




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

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% #############################################################
function [corner_array , no_of_corners]=getting_corner_points_simple(start_pt,end_pt,BW_image)
global distance_from_corner
global size_input_colored_image;
%??? make it global
max_corners=10;

corner_array=start_pt;

next_point=start_pt;

% ???? u  used j at two places it will effect the code
for j=1:max_corners

    n=round(abs([next_point-end_pt]*[1;i])/4);
    for j=1:n
        block_cordi=round([((n-j)*next_point(1)+j*end_pt(1))/n ((n-j)*next_point(2)+j*end_pt(2))/n]);
        if(block_cordi(1)<=1)block_cordi(1)=1;end
        if(block_cordi(2)<=1)block_cordi(2)=1;end
        if(block_cordi(1)>=size_input_colored_image(2))block_cordi(1)=size_input_colored_image(2);end
        if(block_cordi(2)>=size_input_colored_image(1))block_cordi(2)=size_input_colored_image(1);end
        if(BW_image(block_cordi(2),block_cordi(1)));
            break;
        end
    end
    if(j==n | n<=2)
        break;
    else
        if((next_point(2)-end_pt(2))==0)
            per_slope=inf;
        else
            per_slope=-1*(next_point(1)-end_pt(1))/(next_point(2)-end_pt(2));
        end

        if(abs(per_slope)<=1)
            x=block_cordi(1)-2*distance_from_corner:block_cordi(1)+2*distance_from_corner;
            y=round(block_cordi(2)+(x(:)-block_cordi(1))*per_slope);
        else
            y=block_cordi(2)-2*distance_from_corner:block_cordi(2)+2*distance_from_corner;
            x=round(block_cordi(1)+(y(:)-block_cordi(2))/per_slope);
        end

        for j=1:4*distance_from_corner+1
            try
                per_line(j)=~BW_image(y(j),x(j));
            catch
                per_line(j)=logical(1);
            end
        end
        [labled_image No_of_objects]=bwlabel(per_line);
        prop_per_line=regionprops(labled_image,'Centroid','Area');

        if(No_of_objects==0);
        elseif(No_of_objects==1)
            index_cordi=round(prop_per_line.Centroid);
            next_point=[x(index_cordi(1)) y(index_cordi(1))];
        else
            clear r;
            clear i;
            for j=1:No_of_objects
               
                r(j)=abs((prop_per_line(j).Centroid-block_cordi) *[1 ;i])/prop_per_line(j).Area;
                Centr(j,:)=round(prop_per_line(j).Centroid);
            end

            [value index]=min(r);
            next_point=[x(Centr(index,1)) y(Centr(index,1))];

        end
        figure,imshow(BW_image)

        hold on
        plot(x,y,'gx','LineWidth',2);
        plot(next_point(1),next_point(2),'rx','LineWidth',2);
        
        corner_array=cat(1,corner_array,next_point);
    end% of if else
end% of for loop
corner_array=cat(1,corner_array,end_pt);
no_of_corners=length(corner_array);

