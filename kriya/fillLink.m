function fillLink(i,j)      % give initial values as start point
    global myArena
    global LINK
    global noRows
    global noColumns
    if(i<1 || i>noRows || j<1 || j>noColumns || myArena(i,j)==0)
           return;
    end
    p=1;
    if(j-1> 0 && myArena(i,j-1)==1 && LINK(noColumns*(i-1)+j,p)==0)   
        LINK(noColumns*(i-1)+j,p)=(noColumns*(i-1)+(j-1));fillLink(i,j-1);p=p+1;end
    if(j+1<=noColumns && myArena(i,j+1)==1 && LINK(noColumns*(i-1)+j,p)==0)   
        LINK(noColumns*(i-1)+j,p)=(noColumns*(i-1)+(j+1));fillLink(i,j+1);p=p+1;end
    if(i-1> 0 && myArena(i-1,j)==1 && LINK(noColumns*(i-1)+j,p)==0)  
        LINK(noColumns*(i-1)+j,p)=(noColumns*((i-1)-1)+j);fillLink(i-1,j);p=p+1;end
    if(i+1<=noRows && myArena(i+1,j)==1 && LINK(noColumns*(i-1)+j,p)==0)   
        LINK(noColumns*(i-1)+j,p)=(noColumns*((i-1+1))+j);fillLink(i+1,j);end
end
    