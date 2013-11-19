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


%plot(centres(:,2) , centres(:,1), '*');
p=[];
for i=1:size(centres,1)
	
	for j=1:size(centres,1)
		
		%plot(centres(i,2),centres(j,1) ,'*');
		
		%p=[p;centres(i,2) centres(j,1)];
        plot( j * sizex / size(centres,1), i * sizey / size(centres,1) ,'*');
		
		p=[p;i * sizex / size(centres,1) ];
        
		
	end
	
	
end

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

p=[nonzeros(p(:,1)) nonzeros(p(:,2))];

figure,imshow(toCirc);
hold on;

plot(p(:,2),p(:,1) , '*');



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
figure,imshow(toCirc);
hold on;

plot(p(:,2),p(:,1) , '*');
finalPoints=p;

link=zeros(size(p,1));



for i=1:size(p,1)
    for j=1:size(p,1)
	for k=1:size(centres,1)
		
		
		
		
		
		
		
		
	end
		
	
	
	
	
	
	
	
	
	
    end
end




