function ret=pathSlope(colorPathIndexed)
tmp=size(colorPathIndexed);
ret=zeros(tmp(1),tmp(2));
for i=1:tmp(1)
    for j=1:tmp(2)
        if(colorPathIndexed(i,j)~=0)
            if(colorPathIndexed(i,j+2)~=0)
                ret(i,j)=0;
            end
            if(colorPathIndexed(i,j-2)~=0)
                    ret(i,j)=180;
            end
            if(colorPathIndexed(i-2,j)~=0)
                    ret(i,j)=90;
            end
            if(colorPathIndexed(i+2,j)~=0)
                    ret(i,j)=270;
            end
        end
     end    
end
