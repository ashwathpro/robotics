%%  this is to trace yellow path and calculate the magenta weight...

yellowPath=zeros(24,32);
yellow_index=6;
mag_index=4;
weightYellow=0;
currentNode=startNode;

iota=sqrt(-1);
direction=iota;

% disp('direction');
% disp(direction);
% 
% disp('currentNode');
% disp(currentNode);


while(currentNode(1)~=endNode(1) || currentNode(2)~=endNode(2))
	flag=0;
	h=currentNode(1);
	k=currentNode(2);
    
%     disp('direction');
%     disp(direction);
%     disp('h,k');
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
    
	if((miniArena(h,k)==yellow_index || miniArena(h,k)==mag_index) && (yellowPath(h,k)~=255))
		yellowPath(h,k)=255;
		flag=1;
        currentNode=[h k];
        if(miniArena(h,k)==mag_index)
            weightYellow=weightYellow+1;
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
	
%         disp('h,k after switch1');
%         disp([h k]);
    
        
		if(miniArena(h,k)==20)
			yellowPath(h,k)=255;
			currentNode=[h k];
            disp([h k]);
        end    
        if(currentNode==startNode)
            if(miniArena(h,k)==yellow_index)
                    yellowPath(h,k)=255;
                    currentNode=[h k];
%                     disp('found first yellow');
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
figure, imshow(yellowPath);
disp(weightYellow);