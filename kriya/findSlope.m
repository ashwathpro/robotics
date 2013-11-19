function slope=findSlope(x1,y1,x2,y2)
    if(x2-x1 == 0)
        slope=1;
        return;
    else
        if(y2-y1 == 0)
            slope=0;
            return;
        end
    end
    slope=-1;
end