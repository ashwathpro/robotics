function ret= isBotNode(endNode,botnode);
     dy=endNode(1,2)-botNode(1,2);
     dx=endNode(1,1)-botNode(1,1);
     if(sqrt((dy)^2 + dx^2)<30)
         ret=1;
     else
         ret=0;
     end
     return
