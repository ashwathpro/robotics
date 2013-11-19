%% global variables
clc,close all
global g_ourRobotColorIndex   % red is 1...blue is 2
red=1;
blue=2;
%% parameters to change
%g_ourRobotColorIndex =red;       % default value is 0



g_ourRobotColorIndex =blue;        % ****** to be changed during testing


%%
showImage = uint8(zeros(100,100,3));
if(g_ourRobotColorIndex ==red)
    showImage(:,:,1) = 255;
elseif(g_ourRobotColorIndex ==blue)
    showImage(:,:,3) = 255;
end

figure,imshow(showImage)