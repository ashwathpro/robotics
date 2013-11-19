%% global variables
global sampleArena
global stPoint
global endPoint
global noRows
global noColumns
global myArena
global miniArena
global LINK
global logicWhiteArena
global noNodes
global smallBox
global asize
global time
global cropRect
global redPart
global greenPart
global minWhite
global maxBlack
%% variables initiation
% sampleArena=imread('roboarenaFinal2.jpg');
sampleArena=getsnapshot(vid);
figure,(imshow(sampleArena));
[sampleArena,cropRect]=imcrop(sampleArena);
close all;
figure,(imshow(sampleArena));

time=clock;

noRows=5;
noColumns=5;
noNodes=noRows*noColumns;

minWhite=[150,150,150];
maxBlack=[70,70,70];

minGreen=[0,0,40];
maxGreen=[60,60,255];
greenOverRed=10;
greenOverBlue=10;

minRed=[170,0,0];
maxRed=[255,90,90];
redOverBlue=30;
redOverGreen=30;

minBlackPixels=7000;    % have more than smallBox(1)*smallBox(2)/2


%******** use set(vid,'ROIPosition',[cropStPoint cropEndPoint])

myArena=zeros(noRows,noColumns,3);
miniArena=zeros(noRows,noColumns);
nodalPoints=zeros(noRows,noColumns);

% cropStPoint=[15 15];
% cropEndPoint=[620 460];         % has width and height

[aBreadth aLength temp]=size(sampleArena);
smallBox=[round(aLength/noColumns) round(aBreadth/noRows)];
if(minBlackPixels < (smallBox(1)*smallBox(2)/2))
    error('check minBlackpixels.... its less ');
end

LINK=zeros(noRows*noColumns,4);
%% get da arena picture
% sampleArena = imcrop(sampleArena,[cropStPoint(1,1) cropStPoint(1,2) cropEndPoint(1,1)-cropStPoint(1,1) cropEndPoint(1,2)-cropStPoint(1,2)]);
% this s blue color


greenPart=( sampleArena(:,:,1)<=maxGreen(1) ...
          & sampleArena(:,:,2)<=maxGreen(2) ...
          & sampleArena(:,:,3)>=minGreen(3) ...
          & sampleArena(:,:,3)-sampleArena(:,:,1)>=greenOverRed ...
          & sampleArena(:,:,3)-sampleArena(:,:,2)>=greenOverBlue);
      
[BWgreenPart N]=bwlabel(greenPart);

greenPartInv=~greenPart;

if(N==0)
    fprintf('\n***** ERROR: Our robot color not detected *****\n');
    return;
end
regProps=regionprops(BWgreenPart,'Area','centroid');
if(N~=1)
    areaArrayOurRobot = zeros(1,N);
    for count=1:N
        areaArrayOurRobot(count) = regProps(count).Area;
    end
    [maxArea index] = max(areaArrayOurRobot);
    stPoint =  round(regProps(index).Centroid);

else
    stPoint =  round(regProps.Centroid);
end
    

redPart=( sampleArena(:,:,1)>=minRed(1) ...
          & sampleArena(:,:,2)<=maxRed(2) ...
          & sampleArena(:,:,3)<=maxRed(3) ...
          & sampleArena(:,:,1)-sampleArena(:,:,2)>=redOverGreen ...
          & sampleArena(:,:,1)-sampleArena(:,:,3)>=redOverBlue);
%endPoint=regionprops(bwlabel(redPart),'centroid');

[BWredPart N]=bwlabel(redPart);

redPartInv=~redPart;

if(N==0)
    fprintf('\n***** ERROR: Our robot color not detected *****\n')
end
regProps=regionprops(BWredPart,'Area','centroid');
if(N~=1)
    areaArrayOurRobot = zeros(1,N);
    for count=1:N
        areaArrayOurRobot(count) = regProps(count).Area;
    end
    [maxArea index] = max(areaArrayOurRobot);
    endPoint =  round(regProps(index).Centroid);

else
    endPoint =  round(regProps.Centroid);
end
    
logicWhiteArena=(sampleArena(:,:,1)>=minWhite(1) & sampleArena(:,:,2)>=minWhite(2) & sampleArena(:,:,3)>=minWhite(3))...
                | redPart | greenPart;
            
[aLength aBreadth]=size(logicWhiteArena);
%% getting cells

for m = 1:smallBox(2):(noRows-1)*smallBox(2)+1
    for n = 1:smallBox(1):(noColumns-1)*smallBox(1)+1
        %disp([m n]);
        if(length(find(logicWhiteArena(m+5:m+smallBox(2)-5,n+5:n+smallBox(1)-5)))>=minBlackPixels)
            myArena(round(m/smallBox(2))+1,round(n/smallBox(1))+1)=1;
        else
            myArena(round(m/smallBox(2))+1,round(n/smallBox(1))+1)=0;
        end
        
        myArena(round(m/smallBox(2))+1,round(n/smallBox(1))+1,2)=(2*m+smallBox(2))/2;         %storing as i,j and not x,y
        myArena(round(m/smallBox(2))+1,round(n/smallBox(1))+1,3)=(2*n+smallBox(1))/2;
       % disp(myArena);
    end
end
%miniArena=myArena;
for i1=1:noRows
    for j1=1:noColumns
        miniArena(i1,j1)=myArena(i1,j1);
        nodalPoints(i1,j1)=(noColumns*(i1-1)+j1);
    end
end
disp(myArena);
%%
figure , imshow(logicWhiteArena);
hold on;
for i1=1:noRows
    for j1=1:noColumns
        if(myArena(i1,j1)==1)
            plot(myArena(i1,j1,3),myArena(i1,j1,2),'xblue');
        end
    end
end
plot(stPoint(1),stPoint(2),'*red',endPoint(1),endPoint(2),'*green');
line([stPoint(1) endPoint(1)],[stPoint(2) endPoint(2)]);
%%
%imtool(redPart);
% close all;