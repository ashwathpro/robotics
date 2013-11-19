close all;
clc;



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
global stIndex
global endIndex
global smallBox
global path
global finalCordiToMove
global asize
global time
global ourRobotFrontCordi
global ourRobotBackCordi
global robotSmallCircleCordi;
global robotLargeCircleCordi;


global robotBoxDimentions
global robotLargerBoxDimentions

% global ourRobotFrontCordi
% global ourRobotBackCordi

global smallCircleIsFront

global redPart
global greenPart


% global robotSmallCircleCordi;
% global robotLargeCircleCordi;

global roboSmallCircleMinDia
global roboLargeCircleMinDia
global roboSmallCircleMaxDia
global roboLargeCircleMaxDia
global OurRobotCircleTol

global maxDistBetweenCircles
global minDistBetweenCircles

% global ourRobotFrontCordi
% global ourRobotBackCordi



global minWhite
global maxBlack

global cropRect


% global robotLargeCircleCordi
% global robotSmallCircleCordi

%%  
noNodes=noRows*noColumns;

mapArena;

%%
stIndex=[round((stPoint(2)+(smallBox(2))/2)/smallBox(2)) round((stPoint(1)+(smallBox(1))/2)/smallBox(1)) ];
endIndex=[round((endPoint(2)+(smallBox(2))/2)/smallBox(2)) round((endPoint(1)+(smallBox(1))/2)/smallBox(1)) ];

temp=noColumns*(stIndex(1)-1)+stIndex(2);
stIndex=[stIndex temp];

temp=noColumns*(endIndex(1)-1)+endIndex(2);
endIndex=[endIndex temp];

%%  call BFS and get da path
fillLink(stIndex(1),stIndex(2));

BFS(stIndex(3),endIndex(3));
disp(path);

figure,imshow(logicWhiteArena);
hold on;
i=1;
pathCordis=zeros(length(find(path)),2);
%%  retreiving path
while (path(i)~=0)
    [row,col]=find(nodalPoints(:,:)==path(i));
    plot(myArena(row,col,3),myArena(row,col,2),'*red');
    pathCordis(i,:)=[myArena(row,col,3),myArena(row,col,2)];
    i=i+1;
end


disp(pathCordis);

%%  optimising path
finalCordiToMove=zeros(2,2);
prevSlope=findSlope(pathCordis(1,1),pathCordis(1,2),pathCordis(2,1),pathCordis(2,2));
finalCordiToMove(1,:)=pathCordis(1,:);
counter=2;
for i=1:length(pathCordis)-1
    currentSlope=findSlope(pathCordis(i,1),pathCordis(i,2),pathCordis(i+1,1),pathCordis(i+1,2));
    if(currentSlope == prevSlope)
        finalCordiToMove(counter,:)=pathCordis(i+1,:);
    else
        counter=counter+1;
        finalCordiToMove(counter,:)=pathCordis(i+1,:);
    end
    prevSlope=currentSlope;
    
end
disp(finalCordiToMove);
figure,imshow(logicWhiteArena);
hold on;
for i=1:length(finalCordiToMove)-1
plot(finalCordiToMove(i,1),finalCordiToMove(i,2),finalCordiToMove(i+1,1),finalCordiToMove(i+1,2),'*red');
end
line(finalCordiToMove(:,1),finalCordiToMove(:,2),'color',[1,0,0]);


%% for converting finalCordi to moving index


for i=1:length(finalCordiToMove)
    finalCordiToMove(i,:)=[finalCordiToMove(i,2) finalCordiToMove(i,1)];
end
%%
disp('Running time of this prroram on this machine =  ');
disp(etime(clock,time));
%%  run ur bot
% 
% while(1)
%     sampleArena=imread('roboarenaFinal2.jpg');
%     sucessFlag=runBot(finalCordiToMove);
%     if(sucessFlag == 1)
%         disp('bot has reached da destination point.. HURRAY');
%         blinkLED;
%     end
% end