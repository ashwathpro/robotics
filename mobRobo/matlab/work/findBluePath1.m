%% trace path for blue
bluePath=zeros(24,32);
bluePathIndexed=zeros(24,32);
blue_index=7;
mag_index=4;
number=1;
weightBlue=0;
currentNode=startNode;
%  for k=1:24
%      for l=1:32
%                 
%                 if(miniArena(k,l)==3 || miniArena(k,l)==10 || miniArena(k,l)==20 || miniArena(k,l)==4)
%                     bluePath(k,l)=255;
%                     if(miniArena(k,l)==4)
%                         weightBlue=weightBlue+1;
%                     end
%                 else
%                     bluePath(k,l)=0;
%                  
%                 end
%      end
%  end

% while(currentNode~=endNode)
%     i=currentNode(1);
%     j=currentNode(2);
%     
%     
%     while((miniArena(i,j+2)==blue_index||miniArena(i,j+2)==mag_index)&&bluePath~=255)        
%             bluePath=255;
%             j=j+2;
%     end
%     
%     while((miniArena(i,j+2)==blue_index||miniArena(i,j+2)==mag_index)&&bluePath~=255)        
%             bluePath=255;
%             
%             
%             i=i+2;
%     end
% 
%     while((miniArena(i,j+2)==blue_index||miniArena(i,j+2)==mag_index)&&bluePath~=255)
%             bluePath=255;
%             
%             
%             j=j-2;
%     end
% 
%     while((miniArena(i,j+2)==blue_index||miniArena(i,j+2)==mag_index)&&bluePath~=255)        
%             bluePath=255;
%             
%             i=i-2;
%     end
%     
%     if(miniArena(i,j+3)==20||miniArena(i+3,j)==20||miniArena(i,j-3)==20||miniArena(i-3,j)==20)
%                 currentNode=endNode;
%                 break;
%     end
%     currentNode=[i j];
% end
%             
% figure,imshow(bluePath);

iota=sqrt(-1);
direction=iota;

% disp('direction');
% disp(direction);
% 
% disp('currentNode');
% disp(currentNode);

	h=currentNode(1);
	k=currentNode(2);
    
    bluePath(h,k)=255;
    bluePathIndexed(h,k)=number;
        number=number+1;

while(currentNode(1)~=endNode(1) || currentNode(2)~=endNode(2))
	flag=0;
	h=currentNode(1);
	k=currentNode(2);
    

    disp('direction');
    disp(direction);
	disp('h,k');
    disp([h k]);

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
	
    disp('h,k after switch1');
    disp([h k]);
    
	if((miniArena(h,k)==blue_index || miniArena(h,k)==mag_index) && (bluePath(h,k)~=255))
		bluePath(h,k)=255;
        bluePathIndexed(h,k)=number;
        number=number+1;
		flag=1;
        currentNode=[h k];
        if(miniArena(h,k)==mag_index)
            weightBlue=weightBlue+1;
        end
    end
	
    disp('flag');
    disp(flag);
    
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
	
        disp('h,k after switch2');
        disp([h k]);
    
        
		if(miniArena(h,k)==20)
			bluePath(h,k)=255;
            bluePathIndexed(h,k)=number;
            number=number+1;
		
			currentNode=[h k];
            disp([h k]);
        end    
        if(currentNode==startNode)
            if(miniArena(h,k)==blue_index)
                    bluePath(h,k)=255;
                    bluePathIndexed(h,k)=number;
                    number=number+1;
		
                    currentNode=[h k];
                    disp('found first blue');
                    disp([h k]);
                    flag=1
            end
        end
        
    end


    if(flag==1)
        continue
	end
		direction=direction*iota;
end
figure, imshow(bluePath);
disp(weightBlue);