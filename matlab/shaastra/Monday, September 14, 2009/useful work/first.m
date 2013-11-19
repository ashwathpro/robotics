final=imread('iitbArena1.jpg');
[sizex sizey]=size(final);
final=imcrop(final,[75 1 sizey-75 sizex]);
% imshow(final)

maxRed=25;
maxGreen=25;
maxBlue=25;
minBlue=170;


toCirc=zeros(sizex,sizey);

toCirc=(final(:,:,1)<=maxRed) & ((final(:,:,2)<=maxGreen)) & ((final(:,:,3)>=minBlue));

% imtool(toCirc);

[cnt c d]=findcircles(toCirc,.1);
% imshow(toCirc);
% hold on;
% 
% plot(c(:,2) , c(:,1), '*');
% hold off;
toCirc=imcrop(toCirc , [min(c(:,2))-70 min(c(:,1))-70 sizey-(min(c(:,1))-70) sizex] );
% figure, imshow(toCirc);

[sizex sizey]=size(toCirc);

% toCirc=zeros(sizex,sizey);

% toCirc=(final(:,:,1)<=maxRed) & ((final(:,:,2)<=maxGreen)) & ((final(:,:,3)>=minBlue));

% imtool(toCirc);

[cnt centres dia]=findcircles(toCirc,.1)
figure,imshow(toCirc);
hold on;

plot(centres(:,2) , centres(:,1), '*');
 
% xLines = [ones(length(c(:,2)),1) zeros(length(c(:,2)),1) -1*c(:,1)];
% yLines = [zeros(length(c(:,1)),1) ones(length(c(:,1)),1) -1*c(:,2)];
 len=length(centres(:,1));
 xInter=zeros(len,len,2);
 yInter=zeros(len,len,2);
 p=zeros(1,16 , 2);
for i=1:length(centres(:,1))
    xInter(i,:,:)=[centres(i,2)*ones(len,1) centres(:,1)];
%     p=[ p; xInter(i,:,:)];
    yInter(i,:,:)=[centres(i,1)*ones(len,1) centres(:,2)];
%     p=[ p; yInter(i,:,:)];
end
%%
p=[0 0];
for i=1:len
    for j=1:length(xInter(1,:,1))
%         t=xInter(i,j,:);
        p=[p;[xInter(i,j,1) xInter(i,j,2)] ];
%         y=yInter(i,j,:);
        p=[p;[yInter(i,j,1) yInter(i,j,2)]];
        
    end
end


%%
cn=0;
minDist=80;                     % careful.... set a value dat avoids hardcoding ... lik sizex/10 or so
minPtDist=60;
maxEdgeVal=200;
for i=1:length(centres)
    for j=1:length(p)
        if( sqrt( ( (centres(i,1)-p(j,1))^2 + (centres(i,2)-p(j,2))^2 ) ) <=minDist )
            p(j,:)=[0 0];cn=cn+1;
        end
        
    end
    
end

p=[nonzeros(p(:,1)) nonzeros(p(:,2))];      % chuck da zero elements


figure,imshow(toCirc);              
hold on;
plot(p(:,2),p(:,1),'*');            % plotting all possible points to navigate.....


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

p=[nonzeros(p(:,1)) nonzeros(p(:,2))];      % chuck da zero elements
close all;
figure,imshow(toCirc);              
hold on;
plot(p(:,2),p(:,1),'*');            % plotting all possible points to navigate.....

finalPoints=p;

%%

link=zeros(length(p));

for i=1:length(p)
    for j=1:length(p)
        
        if(i~=j && sqrt( ( (p(i,1)-p(j,1))^2 + (p(i,2)-p(j,2))^2 ) ) <= maxEdgeVal )
            for k=1:length(centres)
                
                a=p(j,1)-p(i,1);
                b=p(j,2)-p(i,2);
                c=p(j,2)*p(i,1)-p(j,1)*p(i,2);
                X=centres(k,2);
                Y=centres(k,1);
                
                dist=abs( ( (a*X + b*Y + c)/( sqrt(a^2 + b^2) ) ) );
                
                if(dist >= 1.2*max(dia))
                    
                    link(i,j)=sqrt( ( (p(i,1)-p(j,1))^2 + (p(i,2)-p(j,2))^2 ) );
                end
                
            end
            
        end
        
        
    end
    
end

% figure,imshow();
for i=1:length(p)
    for j=1:length(p)
        if(link(i,j)~=0)
            line([p(i,2) p(j,2)], [p(i,1) p(j,1)]);
            
        end
        
    end
end




    
