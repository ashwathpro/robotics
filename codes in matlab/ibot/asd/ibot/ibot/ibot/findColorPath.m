
function [colorPathIndexed, colorPath, weightColor]= findColorPath(color_index,mag_index)

colorPath=zeros(24,32);
colorPathIndexed=zeros(24,32);
% color_index=7;
% mag_index=4;
number=1;
weightColor=0;
currentNode=startNode;


iota=sqrt(-1);
direction=iota;

	h=currentNode(1);
	k=currentNode(2);
    
    colorPath(h,k)=255;
    colorPathIndexed(h,k)=number;
        number=number+1;

while(currentNode(1)~=endNode(1) || currentNode(2)~=endNode(2))

    flag=0;
	h=currentNode(1);
	k=currentNode(2);
    

%     disp('direction');
%     disp(direction);
% 	  disp('h,k');
%     disp([h k]);

	switch(direction)
		case iota
			k=k+2;
            if(k>=32)
                direction=direction*iota;
                continue
            end
		case -1
			h=h+2;
            if(h>=24)
                direction=direction*iota;
                continue
            end
		case -iota
			k=k-2;
            if(k<=1)
                direction=direction*iota;
                continue
            end
		case 1
			h=h-2;
            if(h<=1)
                direction=direction*iota;
                continue
            end
    end
	
%     disp('h,k after switch1');
%     disp([h k]);
    
	if((miniArena(h,k)==color_index || miniArena(h,k)==mag_index) && (colorPath(h,k)~=255))
		colorPath(h,k)=255;
        colorPathIndexed(h,k)=number;
        number=number+1;
		flag=1;
        currentNode=[h k];
        if(miniArena(h,k)==mag_index)
            weightColor=weightColor+1;
        end
    end
 	
%     disp('flag');
%     disp(flag);
    
    if(flag~=1)
        switch(direction)
		case iota
			k=k+1;
            if(k>=33)
                direction=direction*iota;
                continue
            end
		case -1
			h=h+1;
            if(h>=25)
                direction=direction*iota;
                continue
            end
		case -iota
			k=k-1;
            if(k<=0)
                direction=direction*iota;
                continue
            end
		case 1
			h=h-1;
            if(h<=0)
                direction=direction*iota;
                continue
            end
    end
	
%         disp('h,k after switch2');
%         disp([h k]);
    
        
		if(miniArena(h,k)==20)
			colorPath(h,k)=255;
            colorPathIndexed(h,k)=number;
            number=number+1;
		
			currentNode=[h k];
%             disp([h k]);
        end    
        if(currentNode==startNode)
            if(miniArena(h,k)==color_index)
                    colorPath(h,k)=255;
                    colorPathIndexed(h,k)=number;
                    number=number+1;
		
                    currentNode=[h k];
%                     disp('found first color');
%                     disp([h k]);
                    flag=1;
            end
        end
        
    end


    if(flag==1)
        continue
	end
		direction=direction*iota;
end
figure, imshow(colorPath);
disp(weightColor);