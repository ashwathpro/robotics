    t=cputime;
global rawArena
global targets
global sampleArena

global DIJdist
global parent
global DIJpath
global final   
global noNodes

global LINK
global ourRobotFrontCordi
global ourRobotBackCordi


%           uncomment target to move as frontcordi


%               IF UR GETTTING A GRAPH WID WIERD AND LONGER PATHS THEN MAKE
%               DA CONSTRAINTS MORE STRONG..... PARTICULARLY DA COLOR
%               DETECTING
%               

global maxRed
global maxGreen
global maxBlue
global minBlue
global minRed
global minGreen

global blueOverRed
global blueOverGreen

global redOverBlue
global redOverGreen

global greenOverBlue
global greenOverRed
global smallCircleIsFront
global cropRect

global red_minRed
global red_maxGreen
global red_maxBlue
global red_redOverBlue
global red_redOverGreen

global green_maxRed
global green_minGreen
global green_maxBlue
global green_greenOverBlue
global green_greenOverRed

global yellow_minRed
global yellow_minGreen
global yellow_maxBlue
global yellow_redOverBlue
global yellow_greenOverBlue


global pink_minRed
global pink_maxGreen
global pink_minBlue
global pink_redOverGreen
global pink_blueOverGreen

global blue_maxRed
global blue_maxGreen
global blue_minBlue
global blue_blueOverRed
global blue_blueOverGreen




maxRed=60;
maxGreen=70;
maxBlue=85;

minBlue=130;
minRed=150;
minGreen=150;

blueOverRed=50;
blueOverGreen=50;

redOverBlue=20;
redOverGreen=20;

greenOverBlue=20;
greenOverRed=20;

minesMinDia =  14;
minesMaxDia =  26; 

smallCircleIsFront=1;
centLineDistRatio = 1.2;
tolCircVal=.3;

numLinesMaze=4;


red_minRed = 150;
red_maxGreen = 50;
red_maxBlue = 50;
red_redOverBlue = 100;
red_redOverGreen = 100;

green_maxRed = 120;
green_minGreen = 200;
green_maxBlue = 120;
green_greenOverBlue = 100;
green_greenOverRed = 100;

yellow_minRed = 200;
yellow_minGreen = 200;
yellow_maxBlue = 150;
yellow_redOverBlue = 80;
yellow_greenOverBlue = 80;


pink_minRed = 160;
pink_maxGreen = 50;
pink_minBlue = 160;
pink_redOverGreen = 100;
pink_blueOverGreen =100;

blue_maxRed = 50;
blue_maxGreen = 50;
blue_minBlue = 150;
blue_blueOverRed = 130;
blue_blueOverGreen = 130;


%% finding partition

close all;

imRows =size(rawArena,1);
imCols =size(rawArena,2);

toCirc=(rawArena(:,:,1)<=maxRed) & ((rawArena(:,:,2)<=maxGreen)) & ((rawArena(:,:,3)>=minBlue) ...
        & rawArena(:,:,3)-rawArena(:,:,1) >= blueOverRed & rawArena(:,:,3)-rawArena(:,:,2) >= blueOverGreen);

arenaImage=toCirc;

%%


 se = strel('disk',5);
 arenaImage = imdilate(arenaImage,se);
 imshow(arenaImage);
 %pause
 % remove all object containing fewer than 30 pixels
 % arenaImage = bwareaopen(arenaImage,100);
 % imshow(arenaImage);
 % pause
 
max1 = 0;
% maxi=1;
for  i = 1 : size(arenaImage,2)
    temp = length(find(arenaImage(:,i)));
    
    if temp > max1
        max1= temp;
        maxi = i;
    end
end

imshow(rawArena);
hold on;
line([ maxi maxi] , [1 size(arenaImage,1)],'Color','r' )

% offset = -imCols/40;
offset =0;
maxi = maxi + offset;


hold on;
line([ maxi  maxi] , [1 imRows],'Color','y' )
% pause
close all;



%%


[cnt centres dia]=findcircles(toCirc,tolCircVal);            % increase 2nd argument to detect small circles...... change below also
% 
cnt = sum(logical(dia(:) > repmat(minesMinDia,size(dia,1),1) & dia(:) < repmat(minesMaxDia,size(dia,1),1)));
centres = centres(logical(dia(:) > repmat(minesMinDia,size(dia,1),1) & dia(:) < repmat(minesMaxDia,size(dia,1),1)),:);
dia = dia(logical(dia(:) > repmat(minesMinDia,size(dia,1),1) & dia(:) < repmat(minesMaxDia,size(dia,1),1)));

% figure,imshow(toCirc);
hold on;



p=[];   % is in thf form [i j]

for i=1:size(centres,1)%-1
	
	for j=1:size(centres,1)%-1
		
		plot(centres(i,2),centres(j,1) ,'*');
		
		p=[p;centres(i,1) centres(j,2)];

        if i<j
            plot(round((centres(i,2)+centres(j,2))/2),round((centres(i,1)+centres(j,1))/2) ,'*');
		
            p=[p; round((centres(i,1)+centres(j,1))/2) round((centres(i,2)+centres(j,2))/2)];

        end
        

	end
	
	
end
hold on;
plot(centres(:,2) , centres(:,1), '*red');
% pause

cn=0;
minPtCentreDist=size(toCirc,1)/20;                  % careful.... set a value dat avoids hardcoding ... lik imRows/10 or so
minPtDist=size(toCirc,1)/20;
maxEdgeVal=size(toCirc,1)/8;


addHeight=size(toCirc,1)/20;
addWidth=size(toCirc,2)/20;

for i= maxi+(size(toCirc,2) - maxi)/10:(size(toCirc,2)- maxi)/10:size(toCirc,2)-(size(toCirc,2)- maxi)/10 +1        % add some points at borders
 for j = 1:1
    p=[p; j*addHeight i];
    p=[p; size(toCirc,1)-j*addHeight i];
 end
end




for i = size(toCirc,1)/10 : size(toCirc,1)/10 : size(toCirc,1) - size(toCirc,1)/10 + 1% add some points at borders
    for j = 1:1
        p=[p;  i addWidth+ j * maxi];
        p=[p;  i  size(toCirc,2)-j* addWidth] ;
    end
end


ptsIndToRemove=find(p(:,1)==1 | p(:,2)==1 );
p(ptsIndToRemove(:),:)=[];


for i=1:size(centres,1)
   ptsIndToRemove=find(sqrt(sum((repmat(centres(i,:),size(p,1),1)-p).^2,2))<=minPtCentreDist); 
   p(ptsIndToRemove(:),:)=[];
end



% COMMENTING DA FOLLOWING LINES GIVES A MORE PRECISE GRAPH....
valid=ones(length(p));
i=1;j=1;
while (i<size(p,1))
    
    if(valid(i)==1)
    j=1;
        while (j<size(p,1))
        
            if(i~=j && valid(j)==1 && sqrt( ( (p(i,1)-p(j,1))^2 + (p(i,2)-p(j,2))^2 ) ) <= minPtDist )


                valid(j)=0;
                p(i,:)=(p(i,:)+p(j,:))/2;
                p(j,:)=[];
                
            end
            
            j=j+1;
        end
    end
i=i+1;
    
end
p=[nonzeros(p(:,1)) nonzeros(p(:,2))];
clear i j;

imshow(toCirc);
hold on;
plot(p(:,2),p(:,1) , '*');
% pause;


%% adding target points....


targetsToMove=[];       % target is in the form [x y]

targetsToMove=[size(targets,2)-(12.5/240)*size(targets,1) (12.5/240)*size(targets,1);targetsToMove];  %instead of nos give bot init cordi

% getOurRoboCordi(1);

% targetsToMove=[fliplr(ourRobotFrontCordi);targetsToMove];  

% first sort via area and den append into targets to move

% for red target
redTarget=(targets(:,:,1) > red_minRed & targets(:,:,3) <= red_maxBlue & targets(:,:,2) <= red_maxGreen ...
            & targets(:,:,1)-targets(:,:,2)>= red_redOverGreen & targets(:,:,1)-targets(:,:,3)>=red_redOverBlue);
redTarget=bwlabel(redTarget);

redCordi=regionprops(redTarget);
[maxArea indR]=max([redCordi(:).Area]);

targetsToMove=[targetsToMove; redCordi(indR).Centroid] ;

% for green target
greenTarget=(targets(:,:,1) <= green_maxRed & targets(:,:,3) <= green_maxBlue & targets(:,:,2) >= green_minGreen ...
                & targets(:,:,2)-targets(:,:,1)>= green_greenOverRed & targets(:,:,2)-targets(:,:,3)>=green_greenOverBlue);
greenTarget=bwlabel(greenTarget);

greenCordi=regionprops(greenTarget);
[maxArea ind]=max([greenCordi(:).Area]);

targetsToMove=[targetsToMove; greenCordi(ind).Centroid];

% for yellow target
yellowTarget=(targets(:,:,1) > yellow_minRed & targets(:,:,3) <= yellow_maxBlue & targets(:,:,2) >= yellow_minGreen ...
                & targets(:,:,1)-targets(:,:,3)>= yellow_redOverBlue & targets(:,:,2)-targets(:,:,3)>=yellow_greenOverBlue);
yellowTarget=bwlabel(yellowTarget);
yellowCordi=regionprops(yellowTarget);
[maxArea ind]=max([yellowCordi(:).Area]);

targetsToMove=[targetsToMove; yellowCordi(ind).Centroid];

% for pink target
pinkTarget=(targets(:,:,1) >= pink_minRed & targets(:,:,3) >= pink_minBlue & targets(:,:,2) <= pink_maxGreen ...
                & targets(:,:,1)-targets(:,:,2)>= pink_redOverGreen & targets(:,:,3)-targets(:,:,2)>=pink_blueOverGreen);

se = strel('disk',5);                           % check dis if u loose white circles in pink
pinkTarget=imopen(pinkTarget,se);

pinkTarget=bwlabel(pinkTarget);

pinkCordi=regionprops(pinkTarget);
cnt=1;
for i=1:size(pinkCordi,1)
    if(pinkCordi(i).Area >= redCordi(indR).Area/2 )
        pinks(cnt,:)=pinkCordi(i).Centroid;
        cnt=cnt+1;
    end
end
p=[p;targetsToMove(:,2) targetsToMove(:,1)];

while(size(pinks,1)~=1)
    lastP = p(end,:);
    [q,w] = min(sum((repmat(lastP,size(pinks,1),1)-pinks).^2,2));

    targetsToMove=[targetsToMove; pinks(w,:)];
    p=[p;targetsToMove(end,2) targetsToMove(end,1)];
    pinks(w,:)=[];
end

targetsToMove=[targetsToMove;pinks];
p=[p;targetsToMove(end,2) targetsToMove(end,1)];
pinks=[];


imshow(targets);
hold on;

plot(targetsToMove(:,1) , targetsToMove(:,2) , '*red')
targetsPoints=p;

plot(targetsToMove(:,1) , targetsToMove(:,2) , 'red');

%% solving laser maze

  
 se = strel('disk',5);
 arenaImage = imdilate(arenaImage,se);
%  imshow(arenaImage);
 %pause;
 
 % remove all object containing fewer than 30 pixels
 arenaImage = bwareaopen(arenaImage,30);
%  imshow(arenaImage);


offset = -10;
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


laserOffset = 20;

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


% finalRoutePts
[qw ind]=sort(finalRoutePts(:,2),1,'descend');
finalRoutePts = finalRoutePts(ind,:);

blueTarget=(targets(:,:,1)<=blue_maxRed & targets(:,:,2)<=blue_maxGreen & targets(:,:,3)>=blue_minBlue ...
            & targets(:,:,3)-targets(:,:,1)>=blue_blueOverRed & targets(:,:,3)-targets(:,:,2)>=blue_blueOverGreen);
blueTarget=bwlabel(blueTarget);

blueCordi=regionprops(blueTarget);
[maxArea indR]=max([blueCordi(:).Area]);

finalRoutePts=[finalRoutePts; blueCordi(indR).Centroid] 



%%

[qwe indx]=min(sum((repmat(finalRoutePts(1,:),size(p,1),1)-fliplr(p)).^2 , 2));
% targetsToMove = [targetsToMove; fliplr(p(indx,:))]

%% main linking for BFS

minCircLineDist=centLineDistRatio*max(dia);               % centre to line perpendicular min dist ... reduce value for a better links

bbOffsetX=size(toCirc,2)/10;
bbOffsetY=size(toCirc,1)/10;
bb=[];
LINK=zeros(size(p,1));
linkFlag=1;
for i=1:size(p,1)
    for j=1:size(p,1)
%         i=9;j=10;
        if(i==j )    
            continue;  
%             disp('*************blah blah 1111111111************');
        end
% 	bb = [startX startY ednX endY]
        bb=[max((min(p(i,2),p(j,2))-bbOffsetX),1) max((min(p(i,1),p(j,1))-bbOffsetY),1) ...
            min((max(p(i,2),p(j,2))+bbOffsetX),size(toCirc,2)) min((max(p(i,1),p(j,1))+bbOffsetY),size(toCirc,1))];
        
        circIndBB=find(centres(:,2)>=bb(1) & centres(:,1)>=bb(2) & centres(:,2)<=bb(3) & centres(:,1)<=bb(4));
        linkFlag=1;
        dist=sqrt( ( (p(i,1)-p(j,1))^2 + (p(i,2)-p(j,2))^2 ) );
%         if(dist==0) continue;end
        for k=1:size(circIndBB,1)
            if(dist==0) break;end
%             height=abs(det([p(i,2) p(i,1) 1;p(j,2) p(j,1) 1;centres(circIndBB(k),2) centres(circIndBB(k),1) 1; ]) )/dist
            if ( abs(det([p(i,2) p(i,1) 1;p(j,2) p(j,1) 1;centres(circIndBB(k),2) centres(circIndBB(k),1) 1; ]) )/dist >= minCircLineDist )
                continue;
%             disp('*************blah blah 22222222222222************');
            else
%                 line : Ax+By=C
                A=(p(j,1) - p(i,1));        % y2-y1
                B=-1*(p(j,2) - p(i,2));        % x2-x1
                C=(p(i,2)*p(j,1) - p(j,2)*p(i,1));     %x1y2 - x2y1
                if(A==0 && B==0)    break;end;
%                 using cramer rule....
                x=(det([C B;-1*(A*centres(circIndBB(k),1)-B*centres(circIndBB(k),2)) -1*A]))/(-1*(A*A+B*B));      % ratio pointx
                y=(det([A C;B -1*(A*centres(circIndBB(k),1)-B*centres(circIndBB(k),2))]))/(-1*(A*A+B*B));         % ratio pointy
                
                distPt1=sqrt( ( (p(i,1)-y)^2 + (p(i,2)-x)^2 ) );
                distPt2=sqrt( ( (y-p(j,1))^2 + (x-p(j,2))^2 ) );
                
                if(distPt1+distPt2>=dist-10 && distPt1+distPt2<=dist+10)
                    linkFlag=0;
                end
                
            end
		
        end
        
        if(linkFlag==1 )
            LINK(i,j)=dist;
        end
		
	
    end
end

%% show graph


imshow(toCirc);
hold on;
for i=1:size(p,1)
    for j=1:size(p,1)
        if(LINK(i,j)~=0)
            line([p(i,2) p(j,2)], [p(i,1) p(j,1)]);
%             LINK(j,i)=LINK(i,j);
        end
        
    end
end

%% running dijkstra for mines
cornersToMove=[];
noNodes=size(p,1);
st=find(logical(p(:,1) == targetsToMove(1,2) & (p(:,2) == targetsToMove(1,1))));
figure,imshow(toCirc);
hold on;
again=[];
for i=st:1:st+size(targetsToMove,1)-2
    
    ret=dijkstra(i,i+1,LINK);         % working...
    if(ret==1)  
        plot(p(DIJpath(logical(DIJpath(:))),2) , p(DIJpath(logical(DIJpath(:))),1) ,'red'); 
        cornersToMove=[cornersToMove;flipud(p(DIJpath(2:end),2)) flipud(p(DIJpath(2:end),1))];
%                                                  p(DIJpath(2),2) p(DIJpath(2),1)];
    end
    if(ret==0)  
        disp('****** path not found *******'); 
%         DIJpath=[i+1;unique(DIJpath)];
%         plot(p(DIJpath(logical(DIJpath(:))),2) , p(DIJpath(logical(DIJpath(:))),1) ,'red');
%         again=[again;i+1];
        ret=dijkstra(i+1,i,LINK);
        if(ret==1)  
            plot(p(DIJpath(logical(DIJpath(:))),2) , p(DIJpath(logical(DIJpath(:))),1) ,'red');
        cornersToMove=[cornersToMove;(p(DIJpath(1:end-1),2)) (p(DIJpath(1:end-1),1))];
%                                                  p(DIJpath(2),2) p(DIJpath(2),1)];
        end
        if(ret==0)
            disp('****** very sorry boss....path not found *******');
            i
            i+1
        end

    end
%     pause(1);
end

%reaching before laser maze....

ret=dijkstra(size(p,1),indx,LINK);         % working...
if(ret==1)
    plot(p(DIJpath(logical(DIJpath(:))),2) , p(DIJpath(logical(DIJpath(:))),1) ,'red');
        cornersToMove=[cornersToMove;flipud(p(DIJpath(2:end),2)) flipud(p(DIJpath(2:end),1))];
%                                                  p(DIJpath(2),2) p(DIJpath(2),1)];
end
if(ret==0)
    disp('****** path not found before laser pt*******');
    %         DIJpath=[i+1;unique(DIJpath)];
    %         plot(p(DIJpath(logical(DIJpath(:))),2) , p(DIJpath(logical(DIJpath(:))),1) ,'red');
    %         again=[again;i+1];
    ret=dijkstra(indx,size(p,1),LINK);
    if(ret==1)
        plot(p(DIJpath(logical(DIJpath(:))),2) , p(logical(DIJpath(:)),1) ,'red');
        cornersToMove=[cornersToMove;(p(DIJpath(1:end-1),2)) (p(DIJpath(1:end-1),1))];
%                                                  p(DIJpath(2),2)
%                                                  p(DIJpath(2),1)];
    end
    if(ret==0)
        disp('****** very sorry boss....path not found ...cant move before laser pt...*******');
        
    end

end

cornersToMove=[cornersToMove;p(DIJpath(logical(DIJpath(end))),2) p(DIJpath(logical(DIJpath(end))),1)];
% cornersToMove

finalCornersToMove=[cornersToMove;finalRoutePts]
hold on;
plot(finalRoutePts(:,1),finalRoutePts(:,2) , 'red');
plot(finalCornersToMove(:,1),finalCornersToMove(:,2) , '*green');

%% 
e= cputime-t
%% run bot.....

% runBot(fliplr(finalCornersToMove))


