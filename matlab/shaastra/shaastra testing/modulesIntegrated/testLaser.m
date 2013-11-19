%% 

global finalRoutePts

global maxi
global numLinesMaze
global toCirc
global offset
global laserOffset

global blue_maxRed
global blue_maxGreen
global blue_minBlue
global blue_blueOverRed
global blue_blueOverGreen

blue_maxRed = 50;
blue_maxGreen = 50;
blue_minBlue = 150;
blue_blueOverRed = 130;
blue_blueOverGreen = 130;


numLinesMaze = 4;
laserOffset = 20;

%% solving laser maze

 arenaImage  = toCirc;
 se = strel('disk',5);
 arenaImage = imdilate(arenaImage,se);
 imshow(arenaImage);
 pause;
 
 % remove all object containing fewer than 30 pixels
 arenaImage = bwareaopen(arenaImage,30);
 imshow(arenaImage);
 pause;


maxi = maxi + offset;
hold on;
line([ maxi  maxi] , [1 imRows],'Color','y' )
pts = [];
hold on;
bluepts = [];

for i = round(maxi/numLinesMaze) : round(maxi/numLinesMaze) : maxi-3
    scan=(arenaImage(:,i) == 1);
    [L,num] = bwlabel(scan);
    stats = regionprops(L, 'Centroid');

    for k = 1 : num
        centroid = stats(k).Centroid;
        plot(i,centroid(2),'*red');
        bluepts = [bluepts; round(i) round(centroid(2))];
        hold on;
    end

end
finalRoutePts=[];
routepts = [];




for i = 1 : size(bluepts,1)
    
    scan = (~(arenaImage(bluepts(i,2),1:maxi) == 1));

    %         figure, imshow(scan);

    [L,num] = bwlabel(scan);
    stats = regionprops(L, 'basic');

    area = [];
    for k = 1 : num
        area = [area ; stats(k).Area];
    end

    [temp,inx] = sort(area,'descend');
    centroid = stats(inx(1)).Centroid;
    routepts = [routepts ; [centroid(1) bluepts(i,2)+ laserOffset] ];
%     plot(centroid(1),bluepts(i,2)+ laserOffset,'*');
    hold on;

    routepts = [routepts ; [centroid(1) bluepts(i,2)+ laserOffset] ];
%     plot(centroid(1),bluepts(i,2)- laserOffset,'*');

    finalRoutePts=[finalRoutePts;centroid(1) bluepts(i,2)+laserOffset];

    finalRoutePts=[finalRoutePts;centroid(1) bluepts(i,2)- laserOffset];
    hold on;


end


scan = (~(arenaImage(1:imRows,maxi - offset) == 1));
%         figure, imshow(scan);
%         pause

[L,num] = bwlabel(scan);
stats = regionprops(L, 'basic');

area = [];
for k = 1 : num
    area = [area ; stats(k).Area];
end

[temp,inx] = sort(area,'descend');
centroid = stats(inx(1)).Centroid;
routepts = [routepts ; [maxi-offset centroid(2) ] ];
% plot(maxi - offset,centroid(2),'*');
hold on;

finalRoutePts=[finalRoutePts;maxi-offset centroid(2) ];


i=1;j=1;
while (i<size(finalRoutePts,1))
    
%     if(valid(i)==1)
    j=1;
        while (j<size(finalRoutePts,1))
        
            if((finalRoutePts(i,:) == finalRoutePts(j,:)) & (i~=j))   %DONT USE &&
                finalRoutePts(j,:)=[];
%                 continue;
%             end
            elseif(i~=j && sqrt(((finalRoutePts(i,1)-finalRoutePts(j,1))^2 + (finalRoutePts(i,2)-finalRoutePts(j,2))^2 ) ) <=laserOffset )
%                 valid(j)=0;
                finalRoutePts(i,:)=(finalRoutePts(i,:)+finalRoutePts(j,:))/2;
                finalRoutePts(j,:)=[];
            end
                %         end
            j=j+1;
        end
%     end
i=i+1;
    
end
% p=[nonzeros(p(:,1)) nonzeros(p(:,2))];
clear i j;

hold on;
plot(finalRoutePts(:,1),finalRoutePts(:,2),'*');
pause
close all