function foundWhiteCircleFlag = getOurRoboCordi(full_image)

%% global variables
global vid
global sampleArena;
global asize
%% Robot detect variables
global robotBoxDimentions
global robotLargerBoxDimentions

global ourRobotFrontCordi
global ourRobotBackCordi

global smallCircleIsFront

global redPart
global greenPart


global robotSmallCircleCordi;
global robotLargeCircleCordi;

global roboSmallCircleMinDia
global roboLargeCircleMinDia
global roboSmallCircleMaxDia
global roboLargeCircleMaxDia
global OurRobotCircleTol

global maxDistBetweenCircles
global minDistBetweenCircles

global ourRobotFrontCordi
global ourRobotBackCordi



global minWhite
global maxBlack

global cropRect


global robotLargeCircleCordi
global robotSmallCircleCordi

%%

roboSmallCircleMinDia=10;
roboSmallCircleMaxDia=40;

roboLargeCircleMinDia=40;
roboLargeCircleMaxDia=70;

maxDistBetweenCircles=70;
minDistBetweenCircles=30;


OurRobotCircleTol=0.25;

smallCircleIsFront=1;


robotBoxDimentions=[100,100];
robotLargerBoxDimentions=[200,200];

sampleArena=getsnapshot(vid);
% sampleArena=imread('roboarenaFinal2.jpg');
sampleArena=imcrop(sampleArena,cropRect);
asize=size(sampleArena);
   
% 
% iSmall=0;
% iBig=0;
%    
while(1)

   sampleArena = getsnapshot(vid);
%    sampleArena=imread('roboarenaFinal2.jpg');
   sampleArena=imcrop(sampleArena,cropRect);
   
    if(full_image==0)% if search in small bax
        upper_box_point = max(min(robotSmallCircleCordi,robotLargeCircleCordi)- robotBoxDimentions ,[1 ,1]);
        lower_box_point = min(max(robotSmallCircleCordi,robotLargeCircleCordi)+ robotBoxDimentions,[asize(1),asize(2)]);
    elseif(full_image==2)% if search in bigger bax
        upper_box_point = max(min(robotSmallCircleCordi,robotLargeCircleCordi)- robotLargerBoxDimentions,[1 ,1]);
        lower_box_point = min(max(robotSmallCircleCordi,robotLargeCircleCordi)+ robotLargerBoxDimentions,[asize(1),asize(2)]);
            

    else % for full image
        BW_OurRobot=(sampleArena(:,:,1)>=minWhite(1,1) & sampleArena(:,:,2)>=minWhite(1,2) & sampleArena(:,:,3)>=minWhite(1,3))...
                | redPart | greenPart;
        upper_box_point =[1,1];
        lower_box_point = [asize(1),asize(2)];
    end%end of full image

 
    upper_box_point = round(upper_box_point);
    lower_box_point = round(lower_box_point);
%     if(full_image~=1)
%         upper_box_point = [upper_box_point(1,2) upper_box_point(1,1)]
%         lower_box_point = [lower_box_point(1,2) lower_box_point(1,1)]
%     end
% %     figure,imshow(sampleArena);
% %     hold on;
% %     plot(upper_box_point(1,2),upper_box_point(1,1),'*blue',lower_box_point(1,2),lower_box_point(1,1),'*blue');
% % %     line(upper_box_point(1,1),upper_box_point(1,2),lower_box_point(1,1),lower_box_point(1,2));
% %     

%     bwRoboAllCircle =(((sampleArena(upper_box_point(2):lower_box_point(2),upper_box_point(1):lower_box_point(1),1)>=minWhite(1))) ...
%         &((sampleArena(upper_box_point(2):lower_box_point(2),upper_box_point(1):lower_box_point(1),2)>=minWhite(2))) ...
%         &((sampleArena(upper_box_point(2):lower_box_point(2),upper_box_point(1):lower_box_point(1),3)>=minWhite(3))));
    bwRoboAllCircle =(((sampleArena(upper_box_point(1):lower_box_point(1),upper_box_point(2):lower_box_point(2),1)>=minWhite(1))) ...
        &((sampleArena(upper_box_point(1):lower_box_point(1),upper_box_point(2):lower_box_point(2),2)>=minWhite(2))) ...
        &((sampleArena(upper_box_point(1):lower_box_point(1),upper_box_point(2):lower_box_point(2),3)>=minWhite(3))));
%     
%     bwRoboAllCircle = imclose(bwRoboAllCircle,strel('square',5));
    
%     figure,imshow(bwRoboAllCircle);

    
    
    
    [ WhiteCount_circles, WhiteCenters,WhiteDiameters] = findcircles(bwRoboAllCircle,OurRobotCircleTol)
    
    
    
        
    foundWhiteCircleFlag = 0;
 
    if(WhiteCount_circles == 2)
        %fprintf('\n ****** Error :only 1 White circle found\n ')
        [smallDia,iSmall]=min(WhiteDiameters);
        [bigDia,iBig]=max(WhiteDiameters);
        distanceBtwnCircles=dist(WhiteCenters(1,:),WhiteCenters(2,:));
        if( smallDia > roboSmallCircleMinDia && smallDia < roboSmallCircleMaxDia && ...
            bigDia > roboLargeCircleMinDia && bigDia < roboLargeCircleMaxDia &&...
            distanceBtwnCircles > minDistBetweenCircles && distanceBtwnCircles < maxDistBetweenCircles )
            
            robotSmallCircleCordi=WhiteCenters(iSmall,:);
            robotLargeCircleCordi=WhiteCenters(iBig,:);
            foundWhiteCircleFlag = 1;
                    
        end
    
    
    elseif(WhiteCount_circles == 1 || WhiteCount_circles == 0)
        fprintf('\n ****** Error :0 or only 1 White circle found\n ');
        full_image;
        if(full_image==0) full_image = 2;
        elseif(full_image==2) full_image = 1;
        end
        continue
    
   
   
%         for count = 1: WhiteCount_circles
%             if( WhiteDiameters(count) > roboSmallCircleMinDia && WhiteDiameters(count) < roboSmallCircleMaxDia )
%                 iSmall=count;
% %                 robotSmallCircleCordi=WhiteCenters(iSmall);
%             elseif(WhiteDiameters(count) > roboLargeCircleMinDia && WhiteDiameters(count)< roboLargeCircleMaxDia )
%                 iBig=count;
% %                 robotLargeCircleCordi=WhiteCenters(iBig);
%             end
%     
%         end
%         distanceBtwnCircles=dist(WhiteCenters(iSmall,:),WhiteCenters(iBig,:));
%         
%         if(distanceBtwnCircles > minDistBetweenCircles && distanceBtwnCircles < maxDistBetweenCircles )
%             foundWhiteCircleFlag = 1;
%             robotSmallCircleCordi=WhiteCenters(iSmall,:);
%             robotLargeCircleCordi=WhiteCenters(iBig,:);
%             
      else    % if more than 2 circles present
            for count = 1: WhiteCount_circles
            
            j=count;
            gotCordiFlag=0;iBigFlag=0;
            while(j<=WhiteCount_circles && WhiteDiameters(j) > roboSmallCircleMinDia && WhiteDiameters(j) < roboSmallCircleMaxDia )
                iSmall=j;
                %                 robotSmallCircleCordi=WhiteCenters(iSmall);
                    for k=1:WhiteCount_circles
                        iBigFlag=0;
                        if (WhiteDiameters(k) > roboLargeCircleMinDia && WhiteDiameters(k)< roboLargeCircleMaxDia && k~=iSmall)
                            iBig=k;
                            iBigFlag=1;
%                             break;
                        end
                        if(iBigFlag==1)
                            distanceBtwnCircles=dist(WhiteCenters(iSmall,:),WhiteCenters(iBig,:));
                            if(distanceBtwnCircles > minDistBetweenCircles && distanceBtwnCircles < maxDistBetweenCircles )
                                foundWhiteCircleFlag = 1;
                                robotSmallCircleCordi=WhiteCenters(iSmall,:);
                                robotLargeCircleCordi=WhiteCenters(iBig,:);
                                gotCordiFlag=1;
                                break
                            end
                        end
                    end
                    
                    if(gotCordiFlag==1)
                        break
                    end
                    j=j+1;
            end
        
%                   robotLargeCircleCordi=WhiteCenters(iBig);
            if(gotCordiFlag==1)
                break
            end
            end
            if(gotCordiFlag==0)
            fprintf('\n ****** Error :no 2 White circle were found in range of circles \n ')
            if(full_image==0) full_image = 2;
            elseif(full_image==2) full_image = 1;
            end
            continue
        end
    
        end
        
        
%         if(distanceBtwnCircles > minDistBetweenCircles && distanceBtwnCircles < maxDistBetweenCircles )
%             foundWhiteCircleFlag = 1;
%             robotSmallCircleCordi=WhiteCenters(iSmall,:);
%             robotLargeCircleCordi=WhiteCenters(iBig,:);
%             
%         if(gotCordiFlag==0)
%             fprintf('\n ****** Error :no 2 White circle were found in range of circles \n ')
%             if(full_image==0) full_image = 2;
%             elseif(full_image==2) full_image = 1;
%             end
%             continue
%         end
        
         %end of more than 2 circles present else
    
    
    if(full_image~=1)
        robotSmallCircleCordi=[robotSmallCircleCordi(1)+upper_box_point(1) robotSmallCircleCordi(2)+upper_box_point(2)];
        robotLargeCircleCordi=[robotLargeCircleCordi(1)+upper_box_point(1) robotLargeCircleCordi(2)+upper_box_point(2)];
    end
%%
    
    
    
    
 

% %% for big white circle
%     %figure,imshow(bwRoboBigCircle)
%      if(count_circles == 0)
%         fprintf('\n ****** Error :No black circle found\n ')
%         if(full_image==0)full_image = 2;
%         elseif(full_image==2)full_image = 1;
%         end
%         continue
%     end
% 
%     numOfOurRoboBlackCircle = 0;
%     ourRoboBlackCircleCordi = [];
%     for count = 1: count_circles
%         if((diameters(count) >=OurRobotBlackCircleDiaMin )& (diameters(count) <=OurRobotBlackCircleDiaMax ) )
% %            foundBlackCircleFlag =1 ;
%             numOfOurRoboBlackCircle = numOfOurRoboBlackCircle + 1;
%             ourRoboBlackCircleCordi(numOfOurRoboBlackCircle,:)= [centers(count,2),centers(count,1)]+ upper_box_point-[1 1];
% %             foundWhiteCircleFlag =1 ;
% %             robotLargeCircleCordi = [WhiteCenters(count,2),WhiteCenters(count,1)]+ upper_box_point-[1 1];
%         end
%     end
%     if(numOfOurRoboBlackCircle == 0)
%         fprintf('\n ****** Error :Black Color Circle is not in range given\n ')
%         if(full_image==0)full_image = 2;
%         elseif(full_image==2)full_image = 1;
%         end
%         continue
%     
%     %if only one circle
%     elseif(numOfOurRoboBlackCircle==1)
%         robotSmallCircleCordi = ourRoboBlackCircleCordi;
%     else % more thatn one white circle
%         full_image = 1;
%         continue        
%     end
%         
%     
%     
%     
%     for count = 1: count_circles
%         if((diameters(count) >=OurRobotBlackCircleDiaMin )& (diameters(count) <=OurRobotBlackCircleDiaMax ) )
%             foundBlackCircleFlag =1 ;
%             robotSmallCircleCordi = [centers(count,2),centers(count,1)]+ upper_box_point-[1 1];
%         end
%     end
%     if(foundBlackCircleFlag == 0)
%         fprintf('\n ****** Error :Black Color Circle is not in range given\n ')
%         if(full_image==0)full_image = 2;
%         elseif(full_image==2)full_image = 1;
%         end
%         continue
%     end

    %     [LabledImageOurRobotB,NOurRobotB] = bwlabel(bwRoboBigCircle,8);
    %     if(NOurRobotB==0)
    %         fprintf('\n ****** Error :Black Color of Our robot  color not detected\n ')
    %         if(full_image==0)full_image = 2;
    %         elseif(full_image==2)full_image = 1;
    %         end
    %        continue
    %     end
    %
    %     regionPropertiesOurRobotB = regionprops(LabledImageOurRobotB,'Centroid','Area');
    %     if(NOurRobotB~=1)
    %         areaArrayOurRobotB(NOurRobotB)=0;
    %         for count=1:NOurRobotB
    %             areaArrayOurRobotB(count) = regionPropertiesOurRobotB(count).Area;
    %         end
    %
    %         [maxAreaOurRobotB indexOurRobotB] = max(areaArrayOurRobotB);
    %         robotSmallCircleCordi =  regionPropertiesOurRobotB(indexOurRobotB).Centroid + upper_box_point-[1 1];
    %     else
    %         robotSmallCircleCordi =  regionPropertiesOurRobotB.Centroid + upper_box_point-[1 1];
    %     end
    %     %if both detected properly , return from the code.

    % **** for the time being i am taking black circle as front cordi
    
 
 
%%
    if(smallCircleIsFront==1)
        ourRobotFrontCordi = robotSmallCircleCordi;
        ourRobotBackCordi  = robotLargeCircleCordi;

    else
        ourRobotFrontCordi = robotLargeCircleCordi;
        ourRobotBackCordi  = robotSmallCircleCordi;

    end
    
    imshow(sampleArena);
    hold on;
    plot(robotSmallCircleCordi(1,2),robotSmallCircleCordi(1,1),'*red',robotLargeCircleCordi(1,2),robotLargeCircleCordi(1,1),'*red');
    hold off;
%     close all;

    return
    end

end
%%
function ret=dist(cordi1,cordi2)
    ret=sqrt((cordi1(1)-cordi2(1))^2 + (cordi2(2)-cordi1(2))^2);
end
    