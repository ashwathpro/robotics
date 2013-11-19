%% adding target points....

targets=imread('target1.jpg');
targets=imresize(targets,[480 640]);
% imshow(targets);

targetsToMove=[];
targetsToMove=[size(targets,2)-(12.5/240)*size(targets,1) (12.5/240)*size(targets,1);targetsToMove];            %instead of nos give bot init cordi
p=[p;(12.5/240)*size(toCirc,1) size(toCirc,2)-(12.5/240)*size(toCirc,1)];
% first sort via area and den append into targets to move
% for red target
redTarget=(targets(:,:,1) > minRed & targets(:,:,3) <= maxBlue & targets(:,:,2) <= maxGreen ...
            & targets(:,:,1)-targets(:,:,2)>= redOverGreen & targets(:,:,1)-targets(:,:,3)>=redOverBlue);
redTarget=bwlabel(redTarget);

redCordi=regionprops(redTarget);
[maxArea ind]=max([redCordi(:).Area]);

targetsToMove=[targetsToMove; redCordi(ind).Centroid];

% for green target
greenTarget=(targets(:,:,1) <= maxRed & targets(:,:,3) <= maxBlue & targets(:,:,2) >= minGreen ...
                & targets(:,:,2)-targets(:,:,1)>= greenOverRed & targets(:,:,2)-targets(:,:,3)>=greenOverBlue);
greenTarget=bwlabel(greenTarget);

greenCordi=regionprops(greenTarget);
[maxArea ind]=max([greenCordi(:).Area]);

targetsToMove=[targetsToMove; greenCordi(ind).Centroid];

% for yellow target
yellowTarget=(targets(:,:,1) > minRed & targets(:,:,3) <= maxBlue & targets(:,:,2) >= minGreen ...
                & targets(:,:,1)-targets(:,:,3)>= redOverBlue & targets(:,:,2)-targets(:,:,3)>=greenOverBlue);
yellowTarget=bwlabel(yellowTarget);
yellowCordi=regionprops(yellowTarget);
[maxArea ind]=max([yellowCordi(:).Area]);

targetsToMove=[targetsToMove; yellowCordi(ind).Centroid];

% for pink target
pinkTarget=(targets(:,:,1) >= minRed & targets(:,:,3) >= minBlue & targets(:,:,2) <= maxGreen ...
                & targets(:,:,1)-targets(:,:,2)>= redOverGreen & targets(:,:,3)-targets(:,:,2)>=blueOverGreen);

se = strel('disk',5);                           % check dis if u loose white circles in pink
pinkTarget=imopen(pinkTarget,se);

pinkTarget=bwlabel(pinkTarget);

pinkCordi=regionprops(pinkTarget);
cnt=1;
for i=1:size(pinkCordi,1)
    if(pinkCordi(i).Area >= yellowCordi(ind).Area/2 )
        pinks(cnt,:)=pinkCordi(i).Centroid;
        cnt=cnt+1;
    end
end
p=[p;targetsToMove(:,2) targetsToMove(:,1)];
while(size(pinks,1)~=1)
    lastP=p(end,:);
    [q,w]=min(sum((repmat(lastP,size(pinks,1),1)-pinks).^2,2));

    targetsToMove=[targetsToMove; pinks(w,:)];
    p=[p;targetsToMove(end,2) targetsToMove(end,1)];
    pinks(w,:)=[];
end

targetsToMove=[targetsToMove;pinks];
p=[p;targetsToMove(end,2) targetsToMove(end,1)];
pinks=[];





% figure,imshow(targets);

% hold on;
% 
% plot(targetsToMove(:,1) , targetsToMove(:,2) , '*red')
targetsPoints=p;
% p=[p;targetsToMove(:,2) targetsToMove(:,1)];
