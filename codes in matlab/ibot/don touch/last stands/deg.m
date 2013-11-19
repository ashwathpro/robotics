function ret=deg(dy,dx)
    theta=atan2(dy,dx);
    ret=(theta*180)/pi;
%     if(ret<0)
%         ret=360+ret;
%     end
    return
    
    