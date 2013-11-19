% % % % %  Dijkstra algo 

function ret=dijkstra(src,dest,LINK)
%     init single src....
    global DIJdist
    global parent
    global DIJpath
    DIJpath=[];
    DIJdist=inf*ones(1,size(LINK,1));
    parent=zeros(1,size(LINK,1));
    seen=zeros(1,size(LINK,1));
    DIJdist(src)=0;
    deleted=[];
    parent(src)=-1;
%     algo starting....
    cnt=0;
%     vertices=[1:size(LINK,1)];
    vertices=DIJdist;
    while(cnt<length(vertices))
%         cnt
        [qwe u]=min(vertices);
        
        seen(u)=1;
%         u
        
        verticesV=find(LINK(u,:));
        for i=1:length(verticesV)
            
            relax(u,verticesV(i) , LINK(u,verticesV(i)));
            seen(verticesV(i))=1;
%             parent(verticesV(i))=u;
%             i
        end
        cnt=cnt+1;
%         DIJdist(u)=[];
        deleted=[deleted;u];
        vertices=DIJdist;
        vertices(deleted)=[];
        
    end
%     cnt
%     deleted
    retreivePath(dest);
    if(length(DIJpath)==1)  ret=0;DIJpath=deleted;  return;end
    
    ret=1;
end

function relax(u,v,w)
    global DIJdist
    global parent
    if(DIJdist(v) > DIJdist(u) + w)
        DIJdist(v)=DIJdist(u) + w;
        parent(v)=u;
    end
end

function retreivePath(dest)
    global parent
    global DIJpath
%     disp('aasdfghj');
    DIJpath=[DIJpath;dest];
    root=parent(dest);
    if(root==-1)    DIJpath=[DIJpath;root];return;end
    while(root~=-1 && root~=0 )
        DIJpath=[DIJpath;root];
        root=parent(root);
%         disp('1111111111111');
    end
    
    if(root==0) disp('went out of path');end
end


% 
% 1 INITIALIZE-SINGLE-SOURCE(G, s)
% 2 S ? Ø
% 3 Q ? V[G]
% 4 while Q ? Ø
% 5 do u ? EXTRACT-MIN(Q)
% 6 S ? S {u}
% 7 for each vertex v  Adj[u]
% 8 do RELAX(u, v, w)
% Dijkstra's algorithm relaxes edges as shown in