t=cputime;
global DIJdist
global parent
global DIJpath
global final   
global noNodes
% global noRows
% global noColumns
global LINK
% global BFSpath
global ourRobotFrontCordi
global ourRobotBackCordi

final=imread('finalBig2.jpg');
[sizex sizey]=size(final);
% final=imcrop(final,[75 1 sizey-75 sizex]);
% imshow(final)



% 
% 
%               IF UR GETTTING A GRAPH WID WIERD AND LONGER PATHS THEN MAKE
%               DA CONSTRAINTS MORE STRONG..... PARTICULARLY DA COLOR
%               DETECTING
%               
%               
% 
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
% 
% sampleArena=getsnapshot(vid);
% % % % % sampleArena=imread('roboarenaFinal2.jpg');
% sampleArena=imcrop(sampleArena,cropRect);
% asize=size(sampleArena);

maxRed=40;
maxGreen=35;
maxBlue=85;
minBlue=150;
minRed=150;
minGreen=150;

blueOverRed=20;
blueOverGreen=20;

redOverBlue=20;
redOverGreen=20;

greenOverBlue=20;
greenOverRed=20;


smallCircleIsFront=1;
%%
% toCirc=zeros(sizex,sizey);

toCirc=(final(:,:,1)<=maxRed) & ((final(:,:,2)<=maxGreen)) & ((final(:,:,3)>=minBlue) ...
        & final(:,:,3)-final(:,:,1) >= blueOverRed & final(:,:,3)-final(:,:,2) >= blueOverGreen);

% imtool(toCirc);

[cnt c d]=findcircles(toCirc,.3);           % increase 2nd argument to detect small circles...... change below also
[sizex sizey]=size(toCirc);
% imshow(toCirc);
% hold on;
% 
% plot(c(:,2) , c(:,1), '*');
% hold off;
% orgX=min(c(:,2))-sizex/15;
% orgY=min(c(:,1))-sizey/15;
% toCirc=imcrop(toCirc , [min(c(:,2))-sizex/15 min(c(:,1))-sizey/15 sizey-(min(c(:,1))-sizex/15) sizex] );

orgX=((7/32)*sizey)+sizex/20;
orgY=1+sizex/20;
toCirc=imcrop(toCirc , [orgX orgY sizey-(min(c(:,1))-sizex/15) sizex] );   %  given laser is of size 70x240

% figure, imshow(toCirc);

[sizex sizey]=size(toCirc);

% toCirc=zeros(sizex,sizey);

% toCirc=(final(:,:,1)<=maxRed) & ((final(:,:,2)<=maxGreen)) & ((final(:,:,3)>=minBlue));

% imtool(toCirc);

[cnt centres dia]=findcircles(toCirc,.3);            % increase 2nd argument to detect small circles...... change below also
% figure,imshow(toCirc);
% hold on;
% 
% 
% plot(centres(:,2) , centres(:,1), '*');
p=[];
for i=1:size(centres,1)%-1
	
	for j=1:size(centres,1)%-1
		
		plot(centres(i,2),centres(j,1) ,'*');
		
		p=[p;centres(i,1) centres(j,2)];

% 		plot(j * sizey /size(centres,1),i * sizex /size(centres,1),'*');
% 		
% 		p=[p;j * sizey /size(centres,1),i * sizex /size(centres,1)];


	end
	
	
end

cn=0;
minPtCentreDist=size(toCirc,1)/20;                  % careful.... set a value dat avoids hardcoding ... lik sizex/10 or so
minPtDist=size(toCirc,1)/20;
maxEdgeVal=size(toCirc,1)/8;


addHeight=size(toCirc,1)/20;
addWidth=size(toCirc,2)/20;

for i=1:size(toCirc,1)/10:size(toCirc,1)        % add some points at borders
    p=[p;addHeight i];
    p=[p;size(toCirc,1)-addHeight i];
    
end
for i=1:size(toCirc,2)/10:size(toCirc,2)        % add some points at borders
    p=[p;i addWidth];
    p=[p;i size(toCirc,2)-addWidth];
    
end






ptsIndToRemove=find(p(:,1)==1 | p(:,2)==1);
p(ptsIndToRemove(:),:)=[];
% 
% for i=1:length(centres)
%     for j=1:length(p)
%         if( sqrt( ( (centres(i,1)-p(j,1))^2 + (centres(i,2)-p(j,2))^2 ) ) <=minPtCentreDist )
%             p(j,:)=[0 0];cn=cn+1;
%         end
%         
%     end
%     
% end


for i=1:size(centres,1)
   ptsIndToRemove=find(sqrt(sum((repmat(centres(i,:),size(p,1),1)-p).^2,2))<=minPtCentreDist); 
   p(ptsIndToRemove(:),:)=[];
end


% 
% for i=1:length(ptsIndToRemove)
%     p(ptsIndToRemove(i),:)=[0 0];
% end

% p=[nonzeros(p(:,1)) nonzeros(p(:,2))];
% 
% figure,imshow(toCirc);
% hold on;
% 
% plot(p(:,2),p(:,1) , '*');


% COMMENTING DA FOLLOWING LINES GIVES A MORE PRECISE GRAPH....
% valid=ones(length(p));
% i=1;j=1;
% while (i<size(p,1))
%     
%     if(valid(i)==1)
%     j=1;
%         while (j<size(p,1))
%         
%             if(i~=j && valid(j)==1 && sqrt( ( (p(i,1)-p(j,1))^2 + (p(i,2)-p(j,2))^2 ) ) <= minPtDist )
%                 
% %                 find(centres(:,2)== )
% 
%                 valid(j)=0;
%                 p(i,:)=(p(i,:)+p(j,:))/2;
%                 p(j,:)=[];
%                 
%             end
%             
%             j=j+1;
%         end
%     end
% i=i+1;
%     
% end
% p=[nonzeros(p(:,1)) nonzeros(p(:,2))];
% clear i j;

%% adding target points....



targetsToMove=[];
targetsToMove=[size(toCirc,2)-(12.5/240)*size(toCirc,1)+orgX (12.5/240)*size(toCirc,1)+orgY;targetsToMove];            %instead of nos give bot init cordi
p=[p;(12.5/240)*size(toCirc,1) size(toCirc,2)-(12.5/240)*size(toCirc,1)];
% first sort via area and den append into targets to move
% for red target
redTarget=(final(:,:,1) > minRed & final(:,:,3) <= maxBlue & final(:,:,2) <= maxGreen ...
            & final(:,:,1)-final(:,:,2)>= redOverGreen & final(:,:,1)-final(:,:,3)>=redOverBlue);
redTarget=bwlabel(redTarget);

redCordi=regionprops(redTarget);
[maxArea ind]=max([redCordi(:).Area]);

targetsToMove=[targetsToMove; redCordi(ind).Centroid];

% for green target
greenTarget=(final(:,:,1) <= maxRed & final(:,:,3) <= maxBlue & final(:,:,2) >= minGreen ...
                & final(:,:,2)-final(:,:,1)>= greenOverRed & final(:,:,2)-final(:,:,3)>=greenOverBlue);
greenTarget=bwlabel(greenTarget);

greenCordi=regionprops(greenTarget);
[maxArea ind]=max([greenCordi(:).Area]);

targetsToMove=[targetsToMove; greenCordi(ind).Centroid];

% for yellow target
yellowTarget=(final(:,:,1) > minRed & final(:,:,3) <= maxBlue & final(:,:,2) >= minGreen ...
                & final(:,:,1)-final(:,:,3)>= redOverBlue & final(:,:,2)-final(:,:,3)>=greenOverBlue);
yellowTarget=bwlabel(yellowTarget);
yellowCordi=regionprops(yellowTarget);
[maxArea ind]=max([yellowCordi(:).Area]);

targetsToMove=[targetsToMove; yellowCordi(ind).Centroid];

% for pink target
pinkTarget=(final(:,:,1) >= minRed & final(:,:,3) >= minBlue & final(:,:,2) <= maxGreen ...
                & final(:,:,1)-final(:,:,2)>= redOverGreen & final(:,:,3)-final(:,:,2)>=blueOverGreen);

se = strel('disk',5);                           % check dis if u loose white circles in pink
pinkTarget=imopen(pinkTarget,se);

pinkTarget=bwlabel(pinkTarget);

pinkCordi=regionprops(pinkTarget);
cnt=1;
for i=1:size(pinkCordi,1)
    if(pinkCordi(i).Area >= yellowCordi(ind).Area/2 )
        pinks(cnt,:)=pinkCordi(i).Centroid;
        cnt=cnt+1;
    end
end
p=[p;targetsToMove(:,2)-orgY targetsToMove(:,1)-orgX];
while(size(pinks,1)~=1)
    lastP=p(end,:);
    [q,w]=min(sum((repmat(lastP,size(pinks,1),1)-pinks).^2,2));

    targetsToMove=[targetsToMove; pinks(w,:)];
    p=[p;targetsToMove(end,2)-orgY targetsToMove(end,1)-orgX];
    pinks(w,:)=[];
end

targetsToMove=[targetsToMove;pinks];
p=[p;targetsToMove(end,2)-orgY targetsToMove(end,1)-orgX];
pinks=[];





% figure,imshow(final);

% hold on;
% 
% plot(targetsToMove(:,1) , targetsToMove(:,2) , '*red')
finalPoints=p;
% p=[p;targetsToMove(:,2)-orgY targetsToMove(:,1)-orgX];


%% main linking for BFS

minCircLineDist=2*max(dia);               % centre to line perpendicular min dist ... reduce value for a better links

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
% 
% figure,imshow(toCirc);
% imtool(toCirc);
% hold on;
% for i=1:size(p,1)
%     for j=1:size(p,1)
%         j=32;
%         if(LINK(i,j)~=0)
%             line([p(i,2) p(j,2)], [p(i,1) p(j,1)]);
%             
%         end
%         
%     end
% end

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

plot(targetsToMove(:,1)-orgX , targetsToMove(:,2)-orgY , 'red')


% sort pinks 








%% running BFS
% % noColumns=noRows=size(p,1);
% noNodes=size(p,1);
% st=find(logical(p(:,1) == targetsToMove(1,2)-orgY & (p(:,2) == targetsToMove(1,1)-orgX)));
% figure,imshow(toCirc);
% hold on;
% for i=st:1:st+size(targetsToMove,1)-2
%     
%     ret=BFS(i,i+1);         % working...
%     
% 
% % imshow(toCirc);
% 
% % for i=1:length(find(BFSpath))
%     plot(p(BFSpath(logical(BFSpath(:))),2) , p(BFSpath(logical(BFSpath(:))),1) ,'red');
% %     pause(2);
% end
% % 
% % figure,imshow(final);
% % 
% % hold on;
% 
% % plot(targetsToMove(:,1)-orgX , targetsToMove(:,2)-orgY , '*red')
% % imshow(final)

%% running dijkstra
noNodes=size(p,1);
st=find(logical(p(:,1) == targetsToMove(1,2)-orgY & (p(:,2) == targetsToMove(1,1)-orgX)));
figure,imshow(toCirc);
hold on;
again=[];
for i=st:1:st+size(targetsToMove,1)-2
    
    ret=dijkstra(i,i+1,LINK);         % working...
    if(ret==1)  plot(p(DIJpath(logical(DIJpath(:))),2) , p(DIJpath(logical(DIJpath(:))),1) ,'red');end
    if(ret==0)  
        disp('****** path not found *******'); 
%         DIJpath=[i+1;unique(DIJpath)];
%         plot(p(DIJpath(logical(DIJpath(:))),2) , p(DIJpath(logical(DIJpath(:))),1) ,'red');
%         again=[again;i+1];
        ret=dijkstra(i+1,i,LINK);
        if(ret==1)  plot(p(DIJpath(logical(DIJpath(:))),2) , p(DIJpath(logical(DIJpath(:))),1) ,'red');end
        if(ret==0)
            disp('****** very sorry boss....path not found *******');
        end

    end
    pause(2);
end

% if(~isempty(again))
%     again=[size(p,1);again];
%     disp('say yo.....');
%     for i=1:length(again)-1
%         ret=dijkstra(i,i+1,LINK);
%         if(ret==1)  plot(p(DIJpath(logical(DIJpath(:))),2) , p(DIJpath(logical(DIJpath(:))),1) ,'red');end
%         if(ret==0)
%             disp('****** very sorry boss ...no  path found *******');
%         end
%     end
% end

e= cputime-t