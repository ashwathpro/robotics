function mean=meanPoints(im)
    im=uint8(im);
    mask=roipoly1(im);
    cnt=0;
    sumr=0;
    sumb=0;
    sumg=0;
    s=size(im);
%     disp(s);
    for i=1:s(1,1)
        for j=1:s(1,2)
            if(mask(i,j)==1)
                sumr=sumr+uint32(im(i,j,1));
%                 disp(im(i,j,1));
%                 disp(sumr);
                 sumg=sumg+uint32(im(i,j,2));
                  sumb=sumb+uint32(im(i,j,3));
                cnt=cnt+1;
%                 disp(cnt);
            end
        end
    end
    mean =[sumr sumg sumb]/cnt;
return
    