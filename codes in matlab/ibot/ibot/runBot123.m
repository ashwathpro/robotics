currentNode=startNode;
while(currentNode~=endNode)
    nextNode=getNextNode(currentNode);      %%
    nodeDir=findSlope(nextpoNode,currentNode);        
    getImageFeed;
    botNode=findBotNode(botPos());      %%      %%
    if(botNode~=startNode)
        disp('bot not at st point');
    end
    while(botNode~=nextNode)
        getImageFeed;       %%should return botDir and bot centroid
        angle=deviation(nodeDir,botDir);    
    if(deviation(23,botSlope())>20)
         driveMotorFunc(5);
    else
        if(deviation(23,botSlope())<-20)
        driveMotorFunc(1);
        else
            driveMotorFunc(3);
        end
    end
    end
    currentNode=nextNode;
end

