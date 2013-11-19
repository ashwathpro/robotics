 arena=imread('ibot.jpg');
 [arenaIndexed, arenaMap]=rgb2ind(arena,8);
 figure, imshow(arenaIndexed, arenaMap);

miniArena=zeros(24,32);
p=1;
q=1;
for i=0:50:1150
    q=1;
    for j=0:50:1550
        sum=0;        
        color=arenaIndexed(i+25,j+25);
        for k=10+i:40+i
            for l=10+j:40+j
                
                if(arenaIndexed(k,l)==color)
                    sum=sum+1;
                end
            end
        end
        
        if(sum>=500)
            miniArena(p,q)=arenaIndexed(i+25,j+25)+1;
        end
        q=q+1;
    end
    p=p+1;
end


figure, imshow(miniArena,arenaMap);

