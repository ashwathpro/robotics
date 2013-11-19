%% here we have to writ statements to acquire image and save the frame as arenaImg...

obj = videoinput('winvideo', 1);
arenaImg = getsnapshot(obj);
% imshow(arenaImg);

%% here we have to select ROI

[rect_pos] = Crop_it(arenaImg);
arenaImg=imcrop(arenaImg,rect_pos);
arenaImg=imresize(arenaImg,[480 640]);
% figure, imshow(arenaImg);

%% here we have to do all sorts of filtering....

filteredArenaImg=arenaImg;



%%  here we have to give the filtered image to clusterImg

% [arenaIndexed, arenaMap]=clusterImg(filteredImg, 8);

clusterImg(filteredArenaImg, 4);
imshow(arenaIndexed,arenaMap);