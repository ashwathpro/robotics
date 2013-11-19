function ret=BFS(ELE,root)

%       got Lots to change in dis ..................
%

global parent
%     global noRows
%     global noColumns
    global noNodes
    global BFSque
    global BFSqueSt
    global BFSqueEnd
    global BFSpath
    global LINK
    
    BFSque=zeros(noNodes);
    BFSqueSt=0;
    BFSqueEnd=0;
    
    parent = zeros(1,noNodes);
    seen=zeros(1,noNodes);
    BFSpath=zeros(1,noNodes);
    
    
    if(ELE<1 || root<1)
        ret=0;
        disp('ELE or root is out of bounds');
        return;
    end
	pushQ(root);     %   check
	seen(root)=1;
	parent(root)=-1;
		
    while (seen(ELE)~=1 && ~(isEmptyQ()) )
        par =round(frontQ());      %   check
        %whos par;
        childs=find(LINK(par,:));
        for ch=1:length(childs)
            if(LINK(par,childs(ch))~=0)     % it will not b 0 but still for a check.....
                if(seen(childs(ch))==0)
                    pushQ(childs(ch));     %   check
                end
                if(parent(childs(ch))==0)
                    parent(childs(ch))=par;
                end
                seen(childs(ch))=1;
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
%% BFSpath retreive
function retreivePath(ELE,root)
	global parent
    global BFSpath
    temp=ELE;
    i=1;
	%disp('shortest BFSpath is....  ');
	while (parent(temp)~=-1)
        %disp(temp);
		BFSpath(i)=temp;		%contains da shortest BFSpath 
		temp=parent(temp);
        i=i+1;
    end
	BFSpath(i)=root;
end