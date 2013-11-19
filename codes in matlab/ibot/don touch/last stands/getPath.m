%% 
videoInit;
driveMotorInit;
arenaImg=imread('Ibot_2.png');

% imshow(arenaImg);
%% here we have to writ statements to acquire image and save the frame as arenaImg...

obj = videoinput('winvideo', 1);
arenaImg = getsnapshot(obj);
% save('ab.mat','arenaImg');
% clear arenaImg;
% load('ab.mat');
imshow(arenaImg);

%% here we have to select ROI

[rect_pos] = Crop_it(arenaImg);                             %COMMENT AFTER CALIB  
arenaImg=imcrop(arenaImg,rect_pos);
arenaImg=imresize(arenaImg,[480 640]);
% figure, imshow(arenaImg);
filteredArenaImg=arenaImg;


%% here we have to do all sorts of filtering....

negImg=im2bw(arenaImg,.05);

bw1 = bwareaopen(negImg,200);
se = strel('square',1);
bw1 = imclose(bw1,se);

bw1 = bwareaopen(negImg,250);
se = strel('square',1);
bw1 = imclose(bw1,se);
se = strel('square',1);
bw1 = imclose(bw1,se);
% figure,imshow(bw1);

s=size(negImg);
 for k=1:s(1,1)
            for l=1:s(1,2)
                if(bw1(k,l)==0)
                    arenaImg(k,l,:)=0;
                end
            end
 end
%   figure,imshow(arenaImg);
  
  
srgb2lab = makecform('srgb2lab');
lab2srgb = makecform('lab2srgb');
arena_lab = applycform(arenaImg, srgb2lab); % convert to L*a*b*
max_luminosity = 100;
L = arena_lab(:,:,1)/max_luminosity;
arena_imadjust = arena_lab;
arena_imadjust(:,:,1) = imadjust(L)*max_luminosity;
arena_imadjust = applycform(arena_imadjust, lab2srgb);
% arena_imadjust= bwareaopen(arena_imadjust,20);
se = strel('square',10);
arena_imadjust = imclose(arena_imadjust,se);

se = strel('square',5);
arena_imadjust = imclose(arena_imadjust,se);
% figure, imshow(arena_imadjust);


filteredArenaImg1=arenaImg;

testAren=im2bw(arena_imadjust,.8);

se = strel('square',5);
arena_imadjust = imclose(arena_imadjust,se);
% figure, imshow(testAren);

for i=1:480
    for p=1:640
        if(testAren(i,p)~=1)
            filteredArenaImg1(i,p,:)=0;
%             disp('im');
        end
    end
end

[filteredArenaImg1,arenaMap]=rgb2ind(filteredArenaImg1,7);
arenaIndexed=filteredArenaImg1;
figure, imshow(filteredArenaImg1,arenaMap);
% filteredArenaImg1=ind2rgb(filteredArenaImg1,arenaMap);
% figure, imshow(filteredArenaImg1);
% 
% filteredArenaImg1=autocolor(filteredArenaImg1);

%=========================================================
greenIndex=5;       %%========================================change and calibrate
yellowIndex=2;
magIndex=4;
%=========================================================
[greenPath,gweight]=findPath(greenIndex,4,filteredArenaImg1);
[yellowPath,yweight]=findPath(yellowIndex,4,filteredArenaImg1);
if(gweight>=yweight)
    bestPath=greenPath;
    weight=gweight;
else bestPath=yellowPath;weight=yweight;
end

disp(weight);

%%  finding regionprops of da nodes of best path
bwlbest=bwlabel(bestPath);
bestProps=regionprops(bwlbest);
% minArea=bestProps(1).Area;
% for i=1:size(bestProps)
%     if(bestProps(i).Area<=minArea)
%         minArea=bestProps(i).Area;
%         k=i;
%      end
% end
% startNode=bestProps(k).Centroid;
% disp(startNode);
figure,imshow(bwlbest);
srcDest1;
% startNode=srcDest(1).Centroid;
% endNode=srcDest(2).Centroid;
%  disp(startNode);
%  disp(endNode);
%%  traversing path

% centroids=pathTraverse(bestPath,startNode,endNode,bestProps);

findingPath;

%%
runbot1;            %%=============================give centroids



%% spin a rooni

putvalue(dio,[0 1 0 1]);
pause(3);
 putvalue(dio,0);


