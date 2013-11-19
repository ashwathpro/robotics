getImageFeed1234;

while(botDir>10 || botDir<-10)
    if(botDir>10)
    driveMotorFunc(5,dio);
    pause(.2);
    getImageFeed1234;
    end
    if(botDir<-10)
    driveMotorFunc(1,dio);
    pause(.2);
    getImageFeed1234;
    end
    
end

for i=1:10
driveMotorFunc(3,dio);
end


