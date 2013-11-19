

c1(1,1)=nodeList(1,1);
c1(1,2)=nodeList(1,2);
c2(1,1)=nodeList(2,1);
c2(1,2)=nodeList(2,2);

[dy,dx]=findSlope(c1,c2);
nodeDir=deg(-dy,dx);
disp(botDir);

startNode=c1;
endNode=c2;
getImageFeed1234; 
while(isBotNode(endNode)~=1)
    
        getImageFeed1234;        
    if(deviation(nodeDir,botDir)>20)
         driveMotorFunc(5);
    else
      if(deviation(nodeDir,botDir)<-20)
          driveMotorFunc(1);
       else
        driveMotorFunc(3);
      end
    end
end
disp('the bot has reached the destination');

    
