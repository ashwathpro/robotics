%% TEST LINKS

global p
global centres
global toCirc
global maxi


centLineDistRatio = 1.5;

close all;
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

imshow(toCirc);
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

hold on;
plot(p(:,2),p(:,1) , '*');
pause;
close all;

%%

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
