
 for k=1:1200
            for l=1:1600
                
                if(arenaIndexed(k,l)==1)
                    bw1(k,l)=255;
                else
                    bw1(k,l)=0;
                end
                if(arenaIndexed(k,l)==7)
                    bw2(k,l)=255;
                else
                    bw2(k,l)=0;
                end
            end
 end
 
% figure;
% Using morphology functions, remove pixels which do not belong to the
% objects of interest.

% remove all object containing fewer than 30 pixels
bw1 = bwareaopen(bw1,30);

% fill a gap in the pen's cap
se = strel('disk',25);
bw1 = imclose(bw1,se);

% fill any holes, so that regionprops can be used to estimate
% the area enclosed by each of the boundaries
bw1 = imfill(bw1,'holes');
 
% remove all object containing fewer than 30 pixels
bw2 = bwareaopen(bw2,30);

% fill a gap in the pen's cap
se = strel('disk',25);
bw2 = imclose(bw2,se);

% fill any holes, so that regionprops can be used to estimate
% the area enclosed by each of the boundaries
bw2 = imfill(bw2,'holes');

figure, imshow(bw1);
figure, imshow(bw2);

[bw1,num1]=bwlabel(bw1);
[bw2,num2]=bwlabel(bw2);

srcDest=regionprops(bw1,'basic');
src=regionprops(bw2,'basic');



%% white
startNode=0;
endNode=0;
if(num1==2)
    cent= src(1).Centroid;
    x=round(cent(1));
    y=round(cent(2));
if(bw1(x,y)==1)
    cent= srcDest(1).Centroid;
    x1=round(cent(1));
    y1=round(cent(2));
    x2=ceil(x1/50);
    y2= ceil(y1/50);
    startNode=[y2 x2];
    miniArena(y2,x2)=10;
    
    cent= srcDest(2).Centroid;
    x1=round(cent(1));
    y1=round(cent(2));
    x2=ceil(x1/50);
    y2= ceil(y1/50);
    endNode=[y2 x2];
    miniArena(y2,x2)=20;
else
    cent= srcDest(2).Centroid;
    x1=round(cent(1));
    y1=round(cent(2));
    x2=ceil(x1/50);
    y2= ceil(y1/50);
    startNode=[y2 x2];
    miniArena(y2,x2)=10;
    cent= srcDest(1).Centroid;
    x1=round(cent(1));
    y1=round(cent(2));
    x2=ceil(x1/50);
    y2= ceil(y1/50);
    endNode=[y2 x2];
    miniArena(y2,x2)=20;
end

else
    disp('more than two source and destination');
end
