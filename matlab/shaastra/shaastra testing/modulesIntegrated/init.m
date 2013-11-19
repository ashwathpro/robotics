clear all;
clc;

global sampleArena
global vid;
vid = videoinput('winvideo',2,'RGB24_640x480');
% start(vid);
preview(vid);
sampleArena=getsnapshot(vid);
%%
global rawArena
global targets
% rawArena = getsnapshot(vid);
rawArena =imread('main2.jpg');
rawArena = imresize(rawArena,[480 640]);

targets=imread('target2.jpg');
targets=imresize(targets,[480 640]);


%% serial port init

