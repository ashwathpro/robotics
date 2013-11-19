 arena=imread('ibot2.jpg'); % clusterImg(get croped snap (rect_pos))
 s=size(arena);
 disp(s)
 
 [arenaIndexed, arenaMap]=rgb2ind(arena,8);
 figure, imshow(arenaIndexed, arenaMap);

miniArena=zeros(24,32);
p=1;
q=1;

cutoff=10;
inc_x=s(1,1)/24;
inc_y=s(1,2)/32;
inc_half_x=round(inc_x/2);
inc_half_y=round(inc_y/2);

disp(inc_x);
disp(inc_y);

for i=0:inc_x:s(1,1)-1
    q=1;
    disp(i);
    for j=0:inc_y:s(1,2)-1
        disp(j);
        sum=0;        
        color=arenaIndexed(i+inc_half_x,j+inc_half_y);
        for k=round(inc_x/4)+i:round(inc_x-inc_x/4)+i
            for l=round(inc_y/4)+j:round(inc_y-inc_y/4)+j
                if(arenaIndexed(k,l)==color)
                    sum=sum+1;
                end
            end
        end
        
        if(sum>=cutoff)
            miniArena(p,q)=arenaIndexed(i+inc_half_x,j+inc_half_x)+1; %1 is for converting 0 index
        end
        q=q+1;
    end
    p=p+1;
end


figure, imshow(miniArena,arenaMap);

