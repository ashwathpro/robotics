global vid;
global dio;
%dio=digitalio('parallel');
% addline(dio,0:7,'out');
% putvalue(dio,0);
vid=videoinput('winvideo');
preview(vid);