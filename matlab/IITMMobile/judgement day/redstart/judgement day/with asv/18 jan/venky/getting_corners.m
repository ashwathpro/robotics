function [numOfCorners,corner_cordinates]=getting_corners(selectedBallIndex,allBallsCordinates,numOfBalls,grab_drop_flag)

% grab_drop_flag= 0 for grab, 1 for drop
global g_ourRobotFrontCordi
global g_ourRobotBackCordi

global size_input_colored_image;
global ballBulgeThickness
global g_BWOppRobot
global g_ourRobotColorIndex   % red is 1...blue is 2
global g_REDGoalPostCordiToTarget
global g_BLUEGoalPostCordiToTarget


%*******have to work on maxShootCordi
global g_minShootCordisRedGoalPost
global g_maxShootCordisRedGoalPost
global g_minShootCordisBlueGoalPost
global g_maxShootCordisBlueGoalPost

global ballCornerCutDist % we will see balls in center of arena first

% grab_drop_flag=1
start_pt=g_ourRobotFrontCordi;

if(grab_drop_flag==0) % for grabing ball

    %making balls as obstracle if x cordi of ball is lies between our robot and our goalPost
    if(g_ourRobotColorIndex==1)% our color is red then we have to shoot BLUE goal post
        ourGoalPost = g_REDGoalPostCordiToTarget; 
    else
        ourGoalPost = g_BLUEGoalPostCordiToTarget;
    end
    minX = min(ourGoalPost(1),min(g_ourRobotFrontCordi(1),g_ourRobotBackCordi(1)))-10;
    maxX = max(ourGoalPost(1),max(g_ourRobotFrontCordi(1),g_ourRobotBackCordi(1)))+10;


    BW_Block_image2 = logical(zeros(size_input_colored_image(1),size_input_colored_image(2)));

    for ballCount=1:sum(numOfBalls)
        if((ballCount~=selectedBallIndex ) && (allBallsCordinates(ballCount,1) > minX ) && (allBallsCordinates(ballCount,1) > minX ) )
            try
                BW_Block_image2(allBallsCordinates(ballCount,2)-ballBulgeThickness:allBallsCordinates(ballCount,2)+ballBulgeThickness,...
                    allBallsCordinates(ballCount,1)-ballBulgeThickness:allBallsCordinates(ballCount,1)+ballBulgeThickness)=logical(1);
            end
        elseif(ballCount==selectedBallIndex  )
            try
                BW_Block_image2(allBallsCordinates(ballCount,2)-ballBulgeThickness:allBallsCordinates(ballCount,2)+ballBulgeThickness,...
                    allBallsCordinates(ballCount,1)-ballBulgeThickness:allBallsCordinates(ballCount,1)+ballBulgeThickness)=logical(0);
            end
        end
        
    end

    % while bulging image may become bigger size so w have to get only needed
    % portion of image
    BW_Block_image=BW_Block_image2(1:size_input_colored_image(1),1:size_input_colored_image(2));
    % add opponnent robot also in
    BW_Block_image=BW_Block_image | g_BWOppRobot;
    %figure,imshow(BW_Block_image)

    end_pt=allBallsCordinates(selectedBallIndex,:);
    [corner_cordinates , numOfCorners]=getting_corner_points_simple(start_pt,end_pt,BW_Block_image);

    %check ball near the walls, if its so then add one extra point
    if(end_pt(1)<ballCornerCutDist) end_pt(1)= 2*ballCornerCutDist;
    elseif(end_pt(1)>size_input_colored_image(2)-ballCornerCutDist)...
            end_pt(1)=size_input_colored_image(2)-2*ballCornerCutDist;
    end
    if(end_pt(2)<ballCornerCutDist) end_pt(2)=2*ballCornerCutDist;

    elseif(end_pt(2)>size_input_colored_image(1)-ballCornerCutDist)...
            end_pt(2)=size_input_colored_image(1)-2*ballCornerCutDist;
    end
    if((end_pt(1) ~= corner_cordinates(numOfCorners,1)) || (end_pt(2) ~= corner_cordinates(numOfCorners,2)))
        %  this shoews ball is near the wall
        corner_cordinates(numOfCorners,:)=end_pt;
        numOfCorners= numOfCorners+1;
        corner_cordinates(numOfCorners,:)=allBallsCordinates(selectedBallIndex,:);
    end

  
else % for droping ball
    % ****adding walls is not required
    %adding walls

    selectedShootPtIndex  = getSelectedShootPtInfo();

    if(g_ourRobotColorIndex==1)% our color is red then we have to shoot BLUE goal post
        end_pt = g_minShootCordisBlueGoalPost(selectedShootPtIndex,:);
        goalPostCordiToTarget = g_BLUEGoalPostCordiToTarget;
    else
        end_pt = g_minShootCordisRedGoalPost(selectedShootPtIndex,:);
        goalPostCordiToTarget = g_REDGoalPostCordiToTarget;
    end
    [corner_cordinates , numOfCorners]=getting_corner_points_simple(start_pt,end_pt,g_BWOppRobot);
    % adding extra point for target goalPost point
    corner_cordinates(numOfCorners+1,:) = goalPostCordiToTarget;
    numOfCorners =numOfCorners+1;
end

return

%figure,imshow(BW_Block_image)
% hold on
% plot(shortest_path(:,1),shortest_path(:,2),'rx')

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% #############################################################
function [corner_array , numOfCorners]=getting_corner_points_simple(start_pt,desti_pt,BW_image)

global maxAllowableCorners
global distance_from_corner
global size_input_colored_image;
corner_array=start_pt;
next_point=start_pt;

%figure,imshow(BW_image)
stepSize = 4;
stdPerLine = logical(zeros(4*distance_from_corner+1,1));

for cornerCount=1:maxAllowableCorners
    %calculating number of points
    numOfPoints = round(abs([next_point-desti_pt]*[1;i])/stepSize);
    findBlockFlag = 0;
    if(numOfPoints <=2) %only two points to check then we will assume we are at desti itself
        break;%break the for loop
    end
    % move points wise in one step towards the desti
    %check at each point wether
    for pointsCount=1:numOfPoints
        cordiToCheck = round([((numOfPoints-pointsCount)*next_point(1)+pointsCount*desti_pt(1))/numOfPoints ((numOfPoints-pointsCount)*next_point(2)+pointsCount*desti_pt(2))/numOfPoints]);
        %I have put "try " as the cordiToCheck has calculated may beyond
        %the image size
        try
            if(BW_image(cordiToCheck(2),cordiToCheck(1)));
                findBlockFlag =1;
                break;%break the for loop
            end
        end
    end%end of for cornerCount=1:maxAllowableCorners

    if(findBlockFlag==0)% f there is no obstracle we have reached desti nation
        break;
    else% else insert new corner
        if((next_point(2)-desti_pt(2))==0)
            per_slope=inf;
        else
            per_slope=-1*(next_point(1)-desti_pt(1))/(next_point(2)-desti_pt(2));
        end

        if(abs(per_slope)<=1)
            perLineArray_X=cordiToCheck(1)-2*distance_from_corner:cordiToCheck(1)+2*distance_from_corner;
            perLineArray_Y=round(cordiToCheck(2)+(perLineArray_X(:)-cordiToCheck(1))*per_slope);
        else
            perLineArray_Y=cordiToCheck(2)-2*distance_from_corner:cordiToCheck(2)+2*distance_from_corner;
            perLineArray_X=round(cordiToCheck(1)+(perLineArray_Y(:)-cordiToCheck(2))/per_slope);
        end
        per_lineBW = stdPerLine;
        for linePointCount=1:4*distance_from_corner+1
            %try %using try as calculated cordi point beyond the image size
            if((perLineArray_Y(linePointCount)> size_input_colored_image(1) ) |...
                    (perLineArray_X(linePointCount) > size_input_colored_image(2)) |...
                    (perLineArray_Y(linePointCount)< 1 ) |...
                    (perLineArray_X(linePointCount) < 1))
                continue;
            else
                per_lineBW(linePointCount)=~BW_image(perLineArray_Y(linePointCount),perLineArray_X(linePointCount));
            end
                %per_lineBW(linePointCount)=~BW_image(perLineArray_Y(linePointCount),perLineArray_X(linePointCount));
            %end
        end
        [labled_image numOfPaths]=bwlabel(per_lineBW);
        proptiesOfLine=regionprops(labled_image,'Centroid','Area');

        if(numOfPaths==0)
          %  distance_from_corner=distance_from_corner+5;%??? i have to think for this case
        elseif(numOfPaths==1)%only one path to go
            indexOfcordi=round(proptiesOfLine.Centroid(2));
            next_point=[perLineArray_X(indexOfcordi) perLineArray_Y(indexOfcordi)];
        else
            clear r;
            clear i;
            for pathCount=1:numOfPaths
                r(pathCount)=abs(proptiesOfLine(pathCount).Centroid(2) - 2*distance_from_corner) /proptiesOfLine(pathCount).Area;
                pathCenter(pathCount,:)=round(proptiesOfLine(pathCount).Centroid(2));
            end

            [value index]=min(r);
            next_point=[perLineArray_X(pathCenter(index)) perLineArray_Y(pathCenter(index))];

        end
        corner_array=cat(1,corner_array,next_point);
        
%         hold on
%         plot(perLineArray_X,perLineArray_Y,'gx')
%         plot(next_point(1),next_point(2),'rs')
        
    end% of if else
end% of for loop

corner_array=cat(1,corner_array,desti_pt);
numOfCorners=length(corner_array);

% reduction of corners
if(numOfCorners<=2)
    return
end
firstPtIndex = 1;
secondPtIndex = numOfCorners;
newCorner_array = corner_array(firstPtIndex,:);
new_numOfCorners=1;

maxLoopCount = numOfCorners *(numOfCorners-1)/2;
for loopCount =1:maxLoopCount
    firstPt = corner_array(firstPtIndex,:);

    secondPt = corner_array(secondPtIndex,:);

    %calculating number of points
    numOfPoints = round(abs((secondPt-firstPt)*[1;i])/stepSize);
    % move points wise in one step towards the endPoint
    %check at each point wether
    findBlock = 0;
    for pointsCount=1:numOfPoints
        cordiToCheck = round([((numOfPoints-pointsCount)*firstPt(1)+pointsCount*secondPt(1)) , ((numOfPoints-pointsCount)*firstPt(2)+pointsCount*secondPt(2))]/numOfPoints);
        %I have put "try " as the cordiToCheck has calculated may beyond
        %the image size
        try
            if(BW_image(cordiToCheck(2),cordiToCheck(1)));
                findBlock = 1;
                break;%break the for loop
            end
        end
    end%end of for cornerCount=1:maxAllowableCorners

    if(findBlock ==1)
        if(firstPtIndex == secondPtIndex -2)
            if(secondPtIndex==numOfCorners)
                new_numOfCorners=new_numOfCorners+1;
                newCorner_array(new_numOfCorners,:) = corner_array(secondPtIndex-1,:);
                break;
            end
            firstPtIndex = firstPtIndex+1;
            secondPtIndex = numOfCorners;
            new_numOfCorners=new_numOfCorners+1;
            newCorner_array(new_numOfCorners,:) = corner_array(firstPtIndex,:);

        else
            secondPtIndex = secondPtIndex -1;
        end
        continue
    else
        new_numOfCorners=new_numOfCorners+1;
        newCorner_array(new_numOfCorners,:) = corner_array(secondPtIndex,:);
        if(secondPtIndex==numOfCorners)
            break;
        else
            firstPtIndex = secondPtIndex;
            secondPtIndex = numOfCorners;
        end
    end
end

%check last corner is added properly
if(newCorner_array(new_numOfCorners,:) ~= corner_array(numOfCorners,:))
    new_numOfCorners = new_numOfCorners+1;
    newCorner_array(new_numOfCorners,:)= corner_array(numOfCorners,:);
end

corner_array = newCorner_array;
numOfCorners = new_numOfCorners;



