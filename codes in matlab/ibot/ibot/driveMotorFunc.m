function driveMotorFunc(direction)

if (direction==3)  % to move forward
    putvalue(dio,[0 1 1 0]);
    pause(0.1);
    putvalue(dio,0);
end

if (direction==1)  % to turn left
    putvalue(dio,[1 0 1 0]);
    pause(0.1);
    putvalue(dio,0);
end

if (direction==5)  % to turn right
    putvalue(dio,[0 1 0 1]);
    pause(0.1);
    putvalue(dio,0);
end

return