
global noNodes
% global noRows
% global noColumns
global LINK
global BFSpath

final=imread('iitmArena.jpg');
[sizex sizey]=size(final);
% final=imcrop(final,[75 1 sizey-75 sizex]);
% imshow(final)

maxRed=25;
maxGreen=25;
maxBlue=25;
minBlue=150;


% toCirc=zeros(sizex,sizey);

toCirc=(final(:,:,1)<=maxRed) & ((final(:,:,2)<=maxGreen)) & ((final(:,:,3)>=minBlue));

% imtool(toCirc);

[cnt c d]=findcircles(toCirc,.5);           % increase 2nd argument to detect small circles...... change below also
imshow(toCirc);
hold on;

plot(c(:,2) , c(:,1), '*');
hold off;
toCirc=imcrop(toCirc , [min(c(:,2))-sizex/15 min(c(:,1))-sizey/15 sizex sizey-(min(c(:,1))-sizex/15)] );
% figure, imshow(toCirc);

[sizex sizey]=size(toCirc);

% toCirc=zeros(sizex,sizey);

% toCirc=(final(:,:,1)<=maxRed) & ((final(:,:,2)<=maxGreen)) & ((final(:,:,3)>=minBlue));

% imtool(toCirc);

[cnt centres dia]=findcircles(toCirc,.5);
% figure,imshow(toCirc);
% hold on;


%plot(centres(:,2) , centres(:,1), '*');
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

for i=1:length(centres)
    for j=1:length(p)
        if( sqrt( ( (centres(i,1)-p(j,1))^2 + (centres(i,2)-p(j,2))^2 ) ) <=minPtCentreDist )
            p(j,:)=[0 0];cn=cn+1;
        end
        
    end
    
end

for i=1:length(ptsIndToRemove)
    p(ptsIndToRemove(i),:)=[0 0];
end

p=[nonzeros(p(:,1)) nonzeros(p(:,2))];

% figure,imshow(toCirc);
% hold on;
% 
% plot(p(:,2),p(:,1) , '*');



valid=ones(length(p));
for i=1:length(p)
    
    if(valid(i)==1)
    
        for j=1:length(p)
        
            if(i~=j && valid(j)==1 && sqrt( ( (p(i,1)-p(j,1))^2 + (p(i,2)-p(j,2))^2 ) ) <= minPtDist )
                
%                 find(centres(:,2)== )

                valid(j)=0;
                p(i,:)=(p(i,:)+p(j,:))/2;
                p(j,:)=[0 0];
                
            end
            
            
        end
    end
    
end
p=[nonzeros(p(:,1)) nonzeros(p(:,2))];
% figure,imshow(toCirc);
% hold on;
% 
% plot(p(:,2),p(:,1) , '*');
finalPoints=p;



%%

minCircLineDist=2*max(dia);               % centre to line perpendicular min dist ... reduce value for a better links

bbOffsetX=size(toCirc,2)/10;
bbOffsetY=size(toCirc,1)/10;
bb=[];
LINK=zeros(size(p,1));
linkFlag=1;
for i=1:size(p,1)
    for j=1:size(p,1)
%         i=9;
%         j=10;
%         
        if(i==j)    
            continue;  
%             disp('*************blah blah 1111111111************');
        end
% 	bb = [startX startY ednX endY]
        bb=[max((min(p(i,2),p(j,2))-bbOffsetX),1) max((min(p(i,1),p(j,1))-bbOffsetY),1) ...
            min((max(p(i,2),p(j,2))+bbOffsetX),size(toCirc,2)) min((max(p(i,1),p(j,1))+bbOffsetY),size(toCirc,1))];
        circIndBB=find(centres(:,2)>=bb(1) & centres(:,1)>=bb(2) & centres(:,2)<=bb(3) & centres(:,1)<=bb(4));
        linkFlag=1;
        dist=sqrt( ( (p(i,1)-p(j,1))^2 + (p(i,2)-p(j,2))^2 ) );
        for k=1:size(circIndBB,1)
            
%             height=abs(det([p(i,2) p(i,1) 1;p(j,2) p(j,1) 1;centres(circIndBB(k),2) centres(circIndBB(k),1) 1; ]) )/dist
            if ( abs(det([p(i,2) p(i,1) 1;p(j,2) p(j,1) 1;centres(circIndBB(k),2) centres(circIndBB(k),1) 1; ]) )/dist >= minCircLineDist )
                continue;
            
%             disp('*************blah blah 22222222222222************');
            else
                
%                 line : Ax+By=C
                A=(p(j,1) - p(i,1));        % y2-y1
                B=-1*(p(j,2) - p(i,2));        % x2-x1
                C=(p(i,2)*p(j,1) - p(j,2)*p(i,1));     %x1y2 - x2y1
                
%                 using cramer rule....
                x=(det([C B;-1*(A*centres(circIndBB(k),1)-B*centres(circIndBB(k),2)) -1*A]))/(-1*(A*A+B*B));      % ratio pointx
                y=(det([A C;B -1*(A*centres(circIndBB(k),1)-B*centres(circIndBB(k),2))]))/(-1*(A*A+B*B));         % ratio pointy
                
                distPt1=sqrt( ( (p(i,1)-y)^2 + (p(i,2)-x)^2 ) );
                distPt2=sqrt( ( (y-p(j,1))^2 + (x-p(j,2))^2 ) );
%                 if((dist+distPt1==distPt2 || dist+distPt2==distPt1))
%                     continue;
                if(distPt1+distPt2>=dist-10 && distPt1+distPt2<=dist+10)
                    linkFlag=0;
%                 else
% %                     if(distPt1+distPt2==dist)
% %                     continue;
%             disp('*************blah blah 33333333333333333************');
% %                     end
% %                 else
% %                     disp('******ERROR:distance mismatching....... **********');
                end
                
            end
		
        end
        
        if(linkFlag==1)
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
            
        end
        
    end
end



%%
% noColumns=noRows=size(p,1);
noNodes=size(p,1);

ret=BFS(15,40);         % working...
figure,imshow(toCirc);
hold on;
% for i=1:length(find(BFSpath))
    plot(p(BFSpath(find(BFSpath(:))),2) , p(BFSpath(find(BFSpath(:))),1) );
% end

