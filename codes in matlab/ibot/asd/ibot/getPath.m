%% 
arenaImg=imread('Ibot_2.png');


%% here we have to writ statements to acquire image and save the frame as arenaImg...

obj = videoinput('winvideo', 1);
arenaImg = getsnapshot(obj);
save('ab.mat','arenaImg');
clear arenaImg;
load('ab.mat');
imshow(arenaImg);

%% here we have to select ROI

[rect_pos] = Crop_it(arenaImg);
arenaImg=imcrop(arenaImg,rect_pos);
arenaImg=imresize(arenaImg,[480 640]);
% figure, imshow(arenaImg);

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
figure,imshow(bw1);
 s=size(negImg);
 for k=1:s(1,1)
            for l=1:s(1,2)
                
                if(bw1(k,l)==0)
                    arenaImg(k,l,:)=0;
                end
            end
 end
  figure,imshow(arenaImg);
  
  
srgb2lab = makecform('srgb2lab');
lab2srgb = makecform('lab2srgb');
arena_lab = applycform(arenaImg, srgb2lab); % convert to L*a*b*
max_luminosity = 100;
L = arena_lab(:,:,1)/max_luminosity;
arena_imadjust = arena_lab;
arena_imadjust(:,:,1) = imadjust(L)*max_luminosity;
arena_imadjust = applycform(arena_imadjust, lab2srgb);
figure, imshow(arena_imadjust);


filteredArenaImg=arenaImg;



%%  here we have to give the filtered image to clusterImg

% [arenaIndexed, arenaMap]=clusterImg(filteredImg, 8);
clusterImg(filteredArenaImg, 7);
figure,imshow(arenaIndexed,arenaMap);

%% call findminiArena 

findMiniArena;


%% this to find the best path....

max=-1;
maxColor=5;
mag_index=4;
disp(startNode);

for i=5:8
    color_index=i;
    [colorPathIndexed, colorPath, weightColor]= findColorPath(color_index,mag_index,startNode,endNode,miniArena);
if(weightColor>max)
    maxColor=i;
end
end

[colorPathIndexed, colorPath, weightColor]= findColorPath(maxColor,mag_index,startNode,endNode,miniArena);


