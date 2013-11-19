s=size(arenaIndexed);
miniArena=zeros(24,32);
p=1;
q=1;

cutoff=10;
inc_x=s(1,1)/24;
inc_y=s(1,2)/32;
inc_half_x=round(inc_x/2);
inc_half_y=round(inc_y/2);


for i=0:inc_x:s(1,1)-1
    q=1;

    for j=0:inc_y:s(1,2)-1
   
        sum=0;        
        color=arenaIndexed(i+inc_half_x,j+inc_half_y);
        for k=round(inc_x/4)+i:round(inc_x-inc_x/4)+i
            for l=round(inc_y/4)+j:round(inc_y-inc_y/4)+j
                if(arenaIndexed(k,l)==color)
                    sum=sum+1;
                end
            end
        end
        
        if(sum>=cutoff)
            miniArena(p,q)=arenaIndexed(i+inc_half_x,j+inc_half_x); %1 is for converting 0 index
        end
        q=q+1;
    end
    p=p+1;
end

figure, imshow(miniArena,arenaMap);

%%

for k=1:s(1,1)
            for l=1:s(1,2)
                
                if(arenaIndexed(k,l)==2)
                    bw1(k,l)=255;
                else
                    bw1(k,l)=0;
                end
                if(arenaIndexed(k,l)==3)
                    bw2(k,l)=255;
                else
                    bw2(k,l)=0;
                end
            end
end
 
 figure, imshow(bw1);
figure, imshow(bw2);
% figure;
% Using morphology functions, remove pixels which do not belong to the
% objects of interest.

% remove all object containing fewer than 30 pixels
bw1 = bwareaopen(bw1,10);

% fill a gap in the pen's cap
se = strel('disk',15);
bw1 = imclose(bw1,se);

% fill any holes, so that regionprops can be used to estimate
% the area enclosed by each of the boundaries
bw1 = imfill(bw1,'holes');

for k=1:s(1,1)
            for l=1:s(1,2)
                if(arenaIndexed(k,l)==3 && bw1(k,l)==1)
                    bw2(k,l)=255;
                else
                    bw2(k,l)=0;
                end
            end
 end
 
% remove all object containing fewer than 30 pixels
bw2 = bwareaopen(bw2,15);

% fill a gap in the pen's cap
se = strel('disk',10);
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

%%
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
    x2=ceil(x1/inc_x);
    y2= ceil(y1/inc_x);
    startNode=[y2 x2];
    miniArena(y2,x2)=10;
    
    cent= srcDest(2).Centroid;
    x1=round(cent(1));
    y1=round(cent(2));
    x2=ceil(x1/inc_x);
    y2= ceil(y1/inc_y);
    endNode=[y2 x2];
    miniArena(y2,x2)=20;
else
    cent= srcDest(2).Centroid;
    x1=round(cent(1));
    y1=round(cent(2));
    x2=ceil(x1/inc_x);
    y2= ceil(y1/inc_y);
    startNode=[y2 x2];
    miniArena(y2,x2)=10;
    cent= srcDest(1).Centroid;
    x1=round(cent(1));
    y1=round(cent(2));
    x2=ceil(x1/inc_x);
    y2= ceil(y1/inc_y);
    endNode=[y2 x2];
    miniArena(y2,x2)=20;
end

else
    disp('more than two source and destination');
end

%%

