%% this m file is used to initialise parallel port  object...

dio=digitalio('parallel','lpt1');
addline(dio,0:3,0,'out');
