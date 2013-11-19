
 for k=1:480
            for l=1:640
                
                if(arenaIndexed(k,l)==1)%<++++++++++++++++CALIB FOR RED
                    bw1(k,l)=255;
                else
                    bw1(k,l)=0;
                end
                if(arenaIndexed(k,l)==5)%%====================CALIB 4 WHITE
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
bw1 = bwareaopen(bw1,50); %<========================================CALIBRATE

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
s=size(bw1);
for i=1:s(1,1)
    for j=1:s(1,2)
    if(bw1(i,j)~=1)
        bw2(i,j)=0;
    end
    end
end


figure, imshow(bw1);
figure, imshow(bw2);

[bw1,num1]=bwlabel(bw1);
[bw2,num2]=bwlabel(bw2);

srcnDest=regionprops(bw1,'basic');
src=regionprops(bw2,'basic');



%% white
startNode=src(1).Centroid;
endNode=srcnDest(2).Centroid; %%================

disp(startNode);
disp(endNode);



