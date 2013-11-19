global cropRect;

sampleArena=getsnapshot(vid);
figure,(imshow(sampleArena));
[sampleArena,cropRect]=imcrop(sampleArena);
close all;

