

getImageFeed1234; 

for i=1:length(centroids)
    

 c2(1,1)=centroids(i,1);
 c2(1,2)=centroids(i,2);

[dy,dx]=findSlope(botNode,c2);
nodeDir=deg(-dy,dx);


startNode=botNode;
endNode=c2;

while(isBotNode(endNode,botNode)~=1)
    
        getImageFeed1234;        
    if(deviation(nodeDir,botDir)>20)
         driveMotorFunc(5,dio);
    else
      if(deviation(nodeDir,botDir)<-20)
          driveMotorFunc(1,dio);
       else
        driveMotorFunc(3,dio);
      end
    end
end
disp('the bot has eached the  1 destination');

end

    
