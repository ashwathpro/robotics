function [x y]=intersection(line1 , line2)
%     line of da form [ax by c]
    
    if(line1(1)==0)    y=-1*line1(3);    end
    if(line2(1)==0)    y=-1*line2(3);    end
    
    if(line1(2)==0)    x=-1*line1(3);    end
    if(line2(2)==0)    x=-1*line2(3);    end
    
%     
%     if(line1(1)/line2(1)== line1(2)/line2(2) && line1(1)/line2(1)== line1(3)/line2(3))
%         x=inf;y=inf;
%         return;
%     end
%     
%     if( line1(1)/line2(1)== line1(2)/line2(2))
%             x=inf;y=inf;
%             return;
%         else
%             
%             
%         end
%     end
%     
% 
%     if((line1(1)-line2(1)) == 0)
%         x=inf;y=inf;
%         disp('lines r parallel.... \n');
%     else
%         x=(line2(2)-line1(2))/(line1(1)-line2(1));
%         y=(line1(1)*line2(2)-line2(1)*line1(2))/(line1(1)-line2(1));
%     end
%     
    

end
