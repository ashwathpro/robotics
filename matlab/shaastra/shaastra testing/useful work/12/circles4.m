
%% READ IMAGE FILE

final=imread('iitbArena3.jpg');
[rows cols]=size(final);
sx = cols;
sy = rows;

global toCirc;

%% ORIGINAL PROGRAM STARTS HERE

maxRed  = 25;
maxGreen= 25;
maxBlue = 25;
minBlue = 170;

toCirc=(final(:,:,1)<=maxRed) & ((final(:,:,2)<=maxGreen)) & ((final(:,:,3)>=minBlue));

% figure, imshow(toCirc);


%% NEED TO WRITE A CODE TO CORRECT NOISES HERE...

% 
% 


%% FINDING THE NO OF CIRCLES...

[rows cols]=size(toCirc);
[cnt centres dia]=findcircles(toCirc,.1);
figure,imshow(toCirc);
hold on;
plot(centres(:,2) , centres(:,1), '*');
hold on;

%% PLOTTING THE DESTINATION DIRECTION

% 
% a^2 + b^2 > c^2 is an acute triangle
% a^2 + b^2 < c^2 is an obtuse triangle
% a^2 + b^2 = c^2 is a right triangle

% 
% endNode = [ 932 995];
% startNode = [ 893 223 ];% % % 

% % % 

[x, y] = getpts;

startNode = [ x(1,1) y(1,1) ];
endNode = [ x(2,1) y(2,1) ];

% startNode = [ 650 550 ];
% endNode = [ 1250 550 ];

node = [x y];
s1 = size(node,1);
node = getPath(node)

while s1 ~= size(node,1)
    
    s1 =  size(node,1);
    node = getPath(node)
    
end

figure, imshow(toCirc);
hold on;
plot(node(:,1),node(:,2),'g');

% route = [ startNode ; endNode];
% plot(route(:,1),route(:,2),'g');
% hold on;

% %% FINDING CENTRES CLOSE TO THE ROUTE
% 
% rectol  = 30;
% 
% 
% % DRAW RECTANGLE AROUND THE ROUTE
% rectangle('Position', [min( startNode(1,1),  endNode(1,1) )-rectol min( startNode(1,2),  endNode(1,2) )-rectol ...
%                         abs(endNode(1,1)-startNode(1,1))+60 abs(endNode(1,2)-startNode(1,2))+60 ],'EdgeColor','y');
%                     
% % SEARCH CIRCLES WITHIN THIS RECTANGLE
% 
% reqdcenters  = centres(logical( centres(:,2) > min(startNode(1,1),  endNode(1,1))-rectol  & centres(:,2) < max( startNode(1,1),  endNode(1,1))+rectol & ...
%                 centres(:,1) > min(startNode(1,2),  endNode(1,2))-rectol & centres(:,1) < max( startNode(1,2),  endNode(1,2))+rectol),:);
% 
% plot(reqdcenters(:,2) , reqdcenters(:,1), '+','MarkerEdgeColor','r');
% hold on;
% 
% %% FINDING THE CENTRES WHICH ARE CLOSE TO THE LINE
% 
% % sorting reqdcenters based on their closseness to the start node
% 
% distance = sqrt ( (reqdcenters(:,2)-startNode(1,1)).^2 + (reqdcenters(:,1)-startNode(1,2)).^2 ) ;
% [temp, index] = sort(distance,'ascend');
% reqdcenters = fliplr(reqdcenters(index,:));
% 
% minCircLineDist=2*max(dia);
% 
% node = [];
% node = startNode;

% pathfound = 0;
% node = [];
% node = startNode;
%     
% prev  = 100;
% 
% while pathfound == 0
%     
% %     imshow(toCirc);
% %     hold on;
% 
% 
%     
% 
%     % FINDING CENTRES CLOSE TO THE ROUTE
%     % ----------------------------------
%     rectol  = 30;
%     % DRAW RECTANGLE AROUND THE ROUTE
%     rectangle('Position', [min( startNode(1,1),  endNode(1,1) )-rectol min( startNode(1,2),  endNode(1,2) )-rectol ...
%                             abs(endNode(1,1)-startNode(1,1))+2*rectol abs(endNode(1,2)-startNode(1,2))+2*rectol ],'EdgeColor','y');
% 
%     % SEARCH CIRCLES WITHIN THIS RECTANGLE
%     reqdcenters  = centres(logical( centres(:,2) > min(startNode(1,1),  endNode(1,1))-rectol  & centres(:,2) < max( startNode(1,1),  endNode(1,1))+rectol & ...
%                     centres(:,1) > min(startNode(1,2),  endNode(1,2))-rectol & centres(:,1) < max( startNode(1,2),  endNode(1,2))+rectol  & ...%),:);%& ...
%                     ((abs( rad2deg(atan2(centres(:,1)-startNode(1,2),(centres(:,2)-startNode(1,1)))) - ...
%                      rad2deg(atan2(endNode(1,2)-startNode(1,2),(endNode(1,1)-startNode(1,1)))) )) < 10 | ...
%                      sqrt ( (centres(:,2)-startNode(1,1)).^2 + (centres(:,1)-startNode(1,2)).^2 ) / ...
%                      sqrt ( (endNode(1,1)-startNode(1,1))^2 + (endNode(1,2)-startNode(1,2))^2 ) < 0.4 )),:);
%     
% %                 size(reqdcenters,1)
%                 
%     if size(reqdcenters,1)~=0
%       
%         
%     flag = 0;
%         
%     plot(reqdcenters(:,2) , reqdcenters(:,1), '+','MarkerEdgeColor','r');
%     hold on;
% 
%     % FINDING THE CENTRES WHICH ARE CLOSE TO THE LINE
%     % -----------------------------------------------
%     % sorting reqdcenters based on their closseness to the start node
% 
%     distance = sqrt ( (reqdcenters(:,2)-startNode(1,1)).^2 + (reqdcenters(:,1)-startNode(1,2)).^2 ) ;
%     [dist, index] = sort(distance,'ascend');
%     reqdcenters = fliplr(reqdcenters(index,:));   %____________ FlipLR is used from here onwards
% 
%     minCircLineDist=2*max(dia);
%     
%     base  = sqrt ( (endNode(1,1)-startNode(1,1))^2 + (endNode(1,2)-startNode(1,2))^2 ) ;
%     
%     if ( dist(1) > base)           % hard coding
%         disp('hi');
%         pathfound = 1;
%         break
%     end
%     
%     
%     for i  = 1:size(reqdcenters,1)
%         
%   
%     if ( (abs( det ( [startNode(1,1) startNode(1,2) 1 ; endNode(1,1) endNode(1,2),1; reqdcenters(i,1) reqdcenters(i,2) 1])) / base ) < minCircLineDist ) 
%         plot(reqdcenters(i,1) , reqdcenters(i,2), 'o','MarkerEdgeColor','r','MarkerFaceColor',[.49 1 .63],'MarkerSize',12);
%         hold on;
%     
%     
%     slope = (endNode(1,2)-startNode(1,2))/(endNode(1,1)-startNode(1,1));
%     theta = rad2deg(atan2(endNode(1,2)-startNode(1,2),(endNode(1,1)-startNode(1,1))));
% %     slope = -1/ slope; 
%   
%     thetacenter  = rad2deg(atan2(reqdcenters(i,2)-startNode(1,2),(reqdcenters(i,1)-startNode(1,1))));
%     
%     
%     if ((thetacenter - theta) > 1 || prev == 100)
%     
%         disp('hiasd');      
%     if (thetacenter > theta)
%         theta = theta - rad2deg(pi/2);
%     else
%         theta = theta + rad2deg(pi/2);
%     end
%     
%     else
% 
%     if (prev)
%         theta = theta - rad2deg(pi/2);
%     else
%         theta = theta + rad2deg(pi/2);
%     end
% 
%     end
% 
%     prev = thetacenter > theta;
%     
%     shiftRatio = 1.3; %........... MUST BE GREATER THAN ONE
%     
%     if shiftRatio < 1
%         shiftRatio = 1.3;
%     end
%         
%     n1x = reqdcenters(i,1) +  shiftRatio * minCircLineDist * cos(deg2rad(theta));
%     n1y = reqdcenters(i,2) +  shiftRatio * minCircLineDist * sin(deg2rad(theta));
%     
%     n2x = reqdcenters(i,1) -  shiftRatio * minCircLineDist * cos(deg2rad(theta));
%     n2y = reqdcenters(i,2) -  shiftRatio * minCircLineDist * sin(deg2rad(theta));
%     
%     plot([n1x] , [n1y], '*','MarkerEdgeColor','r');
%     plot([n2x] , [n2y], '*','MarkerEdgeColor','y');    
%     hold on;
%         
%     
%     
%     
%     
%     tempNode = startNode;
%     startNode = [n1x n1y];
%     
%     node = [node; startNode];
%     route = [ startNode ; endNode]; 
%     botroute = [ tempNode ; startNode]; 
%     plot(route(:,1),route(:,2),'g');
%     hold on;
%     plot(botroute(:,1),botroute(:,2),'r');
%     hold on;
%     
% %     pause(3);
%     
%     flag = 1;
%     disp('hihiah')
%     
%     end
%     
%     end
%     
%     if flag == 1
%         continue
%     end
%       
%     end
%         
%     
%     pathfound = 1;
%     
%     
%     
% %     pause(3);
% 
% end
% 
% 
% node = [node; endNode]

% 
% pathfound = 0;
% newNode = [];
% 
% figure,imshow(toCirc);
% hold on;
% plot(centres(:,2) , centres(:,1), '*');
% hold on;
%     
% prev  = 100;
% ni=1;
% 
% while pathfound ==  0
%     
% %     imshow(toCirc);
% %     hold on;
%     
%     if ni == (size(node,1) - 1)
%         break;
%     end
%     
%     startNode = node(ni,:)
%     endNode = node(ni+1,:)
%     
%     ni = ni + 1;
%     
%     % FINDING CENTRES CLOSE TO THE ROUTE
%     % ----------------------------------
%     rectol  = 30;
%     % DRAW RECTANGLE AROUND THE ROUTE
%     rectangle('Position', [min( startNode(1,1),  endNode(1,1) )-rectol min( startNode(1,2),  endNode(1,2) )-rectol ...
%                             abs(endNode(1,1)-startNode(1,1))+2*rectol abs(endNode(1,2)-startNode(1,2))+2*rectol ],'EdgeColor','y');
% 
%     % SEARCH CIRCLES WITHIN THIS RECTANGLE
%     reqdcenters  = centres(logical( centres(:,2) > min(startNode(1,1),  endNode(1,1))-rectol  & centres(:,2) < max( startNode(1,1),  endNode(1,1))+rectol & ...
%                     centres(:,1) > min(startNode(1,2),  endNode(1,2))-rectol & centres(:,1) < max( startNode(1,2),  endNode(1,2))+rectol  & ...%),:);%& ...
%                     ((abs( rad2deg(atan2(centres(:,1)-startNode(1,2),(centres(:,2)-startNode(1,1)))) - ...
%                      rad2deg(atan2(endNode(1,2)-startNode(1,2),(endNode(1,1)-startNode(1,1)))) )) < 10 | ...
%                      sqrt ( (centres(:,2)-startNode(1,1)).^2 + (centres(:,1)-startNode(1,2)).^2 ) / ...
%                      sqrt ( (endNode(1,1)-startNode(1,1))^2 + (endNode(1,2)-startNode(1,2))^2 ) < 0.4 )),:);
%     
% %                 size(reqdcenters,1)
%                 
%     if size(reqdcenters,1)~=0
%       
%         
%     flag = 0;
%         
%     plot(reqdcenters(:,2) , reqdcenters(:,1), '+','MarkerEdgeColor','r');
%     hold on;
% 
%     % FINDING THE CENTRES WHICH ARE CLOSE TO THE LINE
%     % -----------------------------------------------
%     % sorting reqdcenters based on their closseness to the start node
% 
%     distance = sqrt ( (reqdcenters(:,2)-startNode(1,1)).^2 + (reqdcenters(:,1)-startNode(1,2)).^2 ) ;
%     [dist, index] = sort(distance,'ascend');
%     reqdcenters = fliplr(reqdcenters(index,:));   %____________ FlipLR is used from here onwards
% 
%     minCircLineDist=2*max(dia);
%     
%     base  = sqrt ( (endNode(1,1)-startNode(1,1))^2 + (endNode(1,2)-startNode(1,2))^2 ) ;
%     
%     if ( dist(1) > base)           % hard coding
%         disp('hi');
%         pathfound = 1;
%         break
%     end
%     
%     
%     for i  = 1:size(reqdcenters,1)
%         
%   
%     if ( (abs( det ( [startNode(1,1) startNode(1,2) 1 ; endNode(1,1) endNode(1,2),1; reqdcenters(i,1) reqdcenters(i,2) 1])) / base ) < minCircLineDist ) 
%         plot(reqdcenters(i,1) , reqdcenters(i,2), 'o','MarkerEdgeColor','r','MarkerFaceColor',[.49 1 .63],'MarkerSize',12);
%         hold on;
%     
%     
%     slope = (endNode(1,2)-startNode(1,2))/(endNode(1,1)-startNode(1,1));
%     theta = rad2deg(atan2(endNode(1,2)-startNode(1,2),(endNode(1,1)-startNode(1,1))));
% %     slope = -1/ slope; 
%   
%     thetacenter  = rad2deg(atan2(reqdcenters(i,2)-startNode(1,2),(reqdcenters(i,1)-startNode(1,1))));
%     
%     
%     if ((thetacenter - theta) > 1 || prev == 100)
%     
%         disp('hiasd');      
%     if (thetacenter > theta)
%         theta = theta - rad2deg(pi/2);
%     else
%         theta = theta + rad2deg(pi/2);
%     end
%     
%     else
% 
%     if (prev)
%         theta = theta - rad2deg(pi/2);
%     else
%         theta = theta + rad2deg(pi/2);
%     end
% 
%     end
% 
%     prev = thetacenter > theta
%     
%     shiftRatio = 1.3; %........... MUST BE GREATER THAN ONE
%     
%     if shiftRatio < 1
%         shiftRatio = 1.3;
%     end
%         
%     n1x = reqdcenters(i,1) +  shiftRatio * minCircLineDist * cos(deg2rad(theta));
%     n1y = reqdcenters(i,2) +  shiftRatio * minCircLineDist * sin(deg2rad(theta));
%     
%     n2x = reqdcenters(i,1) -  shiftRatio * minCircLineDist * cos(deg2rad(theta));
%     n2y = reqdcenters(i,2) -  shiftRatio * minCircLineDist * sin(deg2rad(theta));
%     
%     plot([n1x] , [n1y], '*','MarkerEdgeColor','r');
%     plot([n2x] , [n2y], '*','MarkerEdgeColor','y');    
%     hold on;
%         
%     
%     
%     
%     
%     tempNode = startNode;
%     startNode = [n1x n1y];
%     
%     newNode = [newNode; startNode];
%     route = [ startNode ; endNode]; 
%     botroute = [ tempNode ; startNode]; 
%     plot(route(:,1),route(:,2),'g');
%     hold on;
%     plot(botroute(:,1),botroute(:,2),'r');
%     hold on;
%     
% %     pause(3);
%     
%     flag = 1;
%     disp('hihiah')
%     
%     end
%     
%     end
%     
%     if flag == 1
%         continue
%     end
%       
%     end
%         
%     
%     pathfound = 1;
%     
%     
%     
% %     pause(3);
% 
% end
% 
% 
% newNode = [newNode; node(end,:)];



% pause(6);
% 
% close all;
% circles3