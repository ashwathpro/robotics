global cropRect
global rawArena

rawArena=getsnapshot(vid);
figure,(imshow(rawArena));
[rawArena,cropRect]=imcrop(rawArena);
rawArena = imresize(rawArena,[480 640]);
figure,(imshow(rawArena));

pause

close all;

