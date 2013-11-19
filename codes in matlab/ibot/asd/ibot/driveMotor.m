dio=digitalio('parallel','lpt1');
addline(dio,0:3,0,'out');
    putvalue(dio,[0 1 1 0]);
    pause(3);
    putvalue(dio,0);


