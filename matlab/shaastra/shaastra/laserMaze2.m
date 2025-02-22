arenaImage = imread('iitbArena4.jpg');  
imshow (arenaImage);

imRows = size(arenaImage,1);
imCols = size(arenaImage,2);

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


originalImage = arenaImage;
arenaImage=(arenaImage(:,:,1)<=maxRed) & ((arenaImage(:,:,2)<=maxGreen)) & ((arenaImage(:,:,3)>=minBlue) ...
        & arenaImage(:,:,3)-arenaImage(:,:,1) >= blueOverRed & arenaImage(:,:,3)-arenaImage(:,:,2) >= blueOverGreen);
figure;
 imshow(arenaImage);

 pause(1);
 
 
 se = strel('disk',15);
 arenaImage = imdilate(arenaImage,se);
 imshow(arenaImage);
 
 pause(1);
 % remove all object containing fewer than 30 pixels
 arenaImage = bwareaopen(arenaImage,3000);
imshow(arenaImage);
 
 pause(2);
 
max = 0;
for  i = 1 : 1 : imCols
    temp = length(find(arenaImage(:,i)));
    
    if temp > max
        max= temp;
        maxi = i;
    end
end

imshow(arenaImage);
hold on;
line([ maxi maxi] , [1 imRows],'Color','r' )

offset = -10;
maxi = maxi + offset;

hold on;
line([ maxi  maxi] , [1 imRows],'Color','y' )
pts = [];
% for i = imRows/12 : imRows/12 : imRows-1
%    for j = maxi/8: maxi/8 : maxi-1
%        
%        if arenaDilatedImage(round(i), round(j))==0
%        pts = [pts;[round(j) round(i)]];
%        end
%    end
% end
% 
% 
hold on;
% plot(pts(:,1),pts(:,2),'*red');
% 
% for i = 1 : round(imRows/15) : imRows-1
%    
%        
%         rectangle('Position', [1, round(i), maxi, round(imRows/12)] );
%         hold on;
%         pause(5);
%         L = bwlabel(~arenaImage(round(i):round(i)+ round(imRows/12), round(j):round(j)+round(maxi/8)));
%         stats = regionprops(L, 'basic');
%         [temp,inx] = sort(stats.Area);
%         coordi = stats(inx).Centroid;
%         plot(coordi(1),coordi(2),'*red')
%         hold on;
%        
%        
%    
% end
bluepts = []

for i = round(maxi/4) : round(maxi/4) : maxi-1
  

        scan=(arenaImage(:,i) == 1);
        
         [L,num] = bwlabel(scan);
         stats = regionprops(L, 'Centroid');
         
        for k = 1 : num 
            centroid = stats(k).Centroid;
            plot(i,centroid(2),'*red');
            bluepts = [bluepts; round(i) round(centroid(2))];
            hold on;
        end

%         [temp,inx] = sort(stats.Area);
%         stats(:).Centroid;
%         plot(i,stats.Centroid(2),'*red')
%         hold on;
       
       
   
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
        
        [temp,inx] = sort(area,'descend')
        centroid = stats(inx(1)).Centroid
        routepts = [routepts ; [centroid(1) bluepts(i,2)+ 50] ];
        plot(centroid(1),bluepts(i,2)+ 50,'*');
        hold on;
        
        routepts = [routepts ; [centroid(1) bluepts(i,2)+ 50] ];
        plot(centroid(1),bluepts(i,2)- 50,'*');
        
        finalRoutePts=[finalRoutePts;centroid(1) bluepts(i,2)+50];
        
        finalRoutePts=[finalRoutePts;centroid(1) bluepts(i,2)- 50];
        hold on;
%          
%         for k = 1 : num 
%             centroid = stats(k).Centroid;
%             plot(i,centroid(2),'*red');
%         end

%         [temp,inx] = sort(stats.Area);
%         stats(:).Centroid;
%         plot(i,stats.Centroid(2),'*red')
%         hold on;
       
       
   
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
        plot(maxi - offset,centroid(2),'*');
        hold on;
        
        finalRoutePts=[finalRoutePts;maxi-offset centroid(2) ];
        

        hold on;
        

finalRoutePts