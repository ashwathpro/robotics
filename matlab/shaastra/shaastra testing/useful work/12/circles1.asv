
%% READ IMAGE FILE

final=imread('iitbArena1.jpg');
[rows cols]=size(final);
sx = cols;
sy = rows;


%% ORIGINAL PROGRAM STARTS HERE

maxRed  = 25;
maxGreen= 25;
maxBlue = 25;
minBlue = 170;

toCirc=(final(:,:,1)<=maxRed) & ((final(:,:,2)<=maxGreen)) & ((final(:,:,3)>=minBlue));

% figure, imshow(toCirc);


%% NEED TO WRITE A CODE TO CORRECT NOISES HERE...

% 
% 


%% FINDING THE NO OF CIRCLES...

[rows cols]=size(toCirc);
[cnt centres dia]=findcircles(toCirc,.1);
% figure,imshow(toCirc);
% hold on;
% plot(centres(:,2) , centres(:,1), '*');

%% PLOT THE INTERSECTION POINTS


p=[];
for i=1:size(centres,1)%-1
	
	for j=1:size(centres,1)%-1
		
		plot(centres(i,2),centres(j,1) ,'*');
		
		p =[p;centres(i,1) centres(j,2)];

% 		plot(j * cols /size(centres,1),i * rows /size(centres,1),'*');
% 		
% 		p=[p;i * rows /size(centres,1), j * cols /size(centres,1)];


	end
	
end


%% REMOVING POINTS CLOSE TO THE CIRCLE...

cn=0;
minPtCentreDist=80;                     % careful.... set a value dat avoids hardcoding ... lik sizex/10 or so
minPtDist=60;
maxEdgeVal=200;


for i=1:size(centres,1)
    for j=1:size(p,1)
        if( sqrt( ( (centres(i,1)-p(j,1))^2 + (centres(i,2)-p(j,2))^2 ) ) <=minPtCentreDist )
            p(j,:)=[0 0];
            cn=cn+1;
        end
    end
end

p=[nonzeros(p(:,1)) nonzeros(p(:,2))];

% figure,imshow(toCirc);
% hold on;
% 
% plot(p(:,2),p(:,1) , '*');



valid=ones(size(p,1));
for i=1:size(p,1)
    
    if(valid(i)==1)
    
        for j=1:size(p,1)
        
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
figure,imshow(toCirc);
hold on;

plot(p(:,2),p(:,1) , '*');
finalPoints=p;

%% FIND POSSIBLE ROUTES...

minCircLineDist=2*max(dia);

bbOffsetX=size(toCirc,2)/10;
bbOffsetY=size(toCirc,1)/10;
bb=[];
linkNode=zeros(size(p,1));
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
        dist = 0;
        for k=1:size(circIndBB,1)
            dist=sqrt( ( (p(i,1)-p(j,1))^2 + (p(i,2)-p(j,2))^2 ) );
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
            linkNode(i,j)=dist;
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
%         if(linkNode(i,j)~=0)
%             line([p(i,2) p(j,2)], [p(i,1) p(j,1)]);
%             
%         end
%         
%     end
% end

figure,imshow(toCirc);
hold on;
for i=1:size(p,1)
    for j=1:size(p,1)
        if(linkNode(i,j)~=0)
            line([p(i,2) p(j,2)], [p(i,1) p(j,1)]);
            
        end
        
    end
end


