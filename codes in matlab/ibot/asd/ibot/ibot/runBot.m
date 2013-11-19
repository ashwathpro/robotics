
if(deviation(23,botSlope())>20)
    driveMotorFunc(5);
else
    if(deviation(23,botSlope())<-20)
    driveMotorFunc(1);
    else
        driveMotorFunc(3);
    end
end
