ser2= serial('COM1','BaudRate',4800,'DataBits',8);
fopen(ser2);
%a=binary('5');
for i=1:10
    %driveMotor(1,ser2);
    fwrite(ser2,'5','uchar');
    pause(0.5);
end
fclose(ser2);



        