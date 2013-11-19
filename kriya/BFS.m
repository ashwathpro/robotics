function ret=BFS(ELE,root)
    global parent
    global noRows
    global noColumns
    global noNodes
    global BFSque
    global BFSqueSt
    global BFSqueEnd
    global path
    global LINK
    
    BFSque=zeros(noNodes);
    BFSqueSt=0;
    BFSqueEnd=0;
    
    parent = zeros(1,noNodes);
    seen=zeros(1,noNodes);
    path=zeros(1,noNodes);
    
    
    if(ELE<1 || ELE>noRows*noColumns || root>noRows*noColumns || root<1)
        ret=0;
        disp('ELE or root is out of bounds');
        return;
    end
	pushQ(root);     %   check
	seen(root)=1;
	parent(root)=-1;
		
	while (seen(ELE)~=1 && ~(isEmptyQ()) )
        par =frontQ();      %   check
        %whos par;
		for ch=1:4
            if(LINK(par,ch)~=0)
                if(seen(LINK(par,ch))==0)
					pushQ(LINK(par,ch));     %   check
                end
				if(parent(LINK(par,ch))==0)
					parent(LINK(par,ch))=par;
                end
				seen(LINK(par,ch))=1;
            end
        end
        popQ();          %   check
    end
    
	if(seen(ELE)==0)
        ret=0;
		return;
    else 
        retreivePath(ELE,root);
        ret=1;
		return;
    end
    
    %*** ALL QUE OPERATIONS
    function pushQ(ele)     %   push ele
        if(BFSqueSt==0 && BFSqueEnd==0 )
            BFSqueSt=1;
            BFSqueEnd=1;
        end
        BFSque(BFSqueEnd)=ele;
        BFSqueEnd=BFSqueEnd+1;
    end
    function popQ()         %   pop ele
        if(BFSqueSt<=BFSqueEnd)
            BFSqueSt=BFSqueSt+1;
        end
    end
    function ret=frontQ()   %   return front ele
        ret=BFSque(BFSqueSt);
    end
    function ret=isEmptyQ() %   return true if que is empty
        if(BFSqueSt>BFSqueEnd || (BFSqueSt==0 && BFSqueEnd==0) )
            ret=true;
        else ret=false;
        end
    end


end
%% path retreive
function retreivePath(ELE,root)
	global parent
    global path
    temp=ELE;
    i=1;
	%disp('shortest path is....  ');
	while (parent(temp)~=-1)
        %disp(temp);
		path(i)=temp;		%contains da shortest path 
		temp=parent(temp);
        i=i+1;
    end
	path(i)=root;
end