dio=digitalio('parallel','lpt1');
addline(dio,0:3,0,'out');
for i=1:15
    putvalue(dio,[0 1 1 0]);
    pause(0.1);
    putvalue(dio,0);
end

for i=1:10
    putvalue(dio,[0 1 0 1]);
    pause(0.05);
    putvalue(dio,0);
end

for i=1:15
    putvalue(dio,[0 1 1 0]);
    pause(0.1);
    putvalue(dio,0);
end