botImg=imread('bot1.jpg');
% figure,imshow(botImg);
% [rect_pos] = Crop_it(arenaImg);
disp(rect_pos);
botImg=imcrop(botImg,rect_pos);
botImg=imresize(botImg,[480 640]);

negImg=im2bw(botImg,.85);
bw1 = bwareaopen(negImg,200);
se = strel('disk',4);
bw1 = imclose(bw1,se);
bw1=bwlabel(bw1);
botDet=regionprops(bw1,'basic');
% disp(botDet);
% botCentroid
figure,imshow(bw1);
% [B,L] = bwboundaries(bw1,'noholes'); 
% 
% stats = regionprops(L,'Area','Centroid'); threshold = 0.80; 
% % loop over the boundaries 
% for k = 1:2 
%     % obtain (X,Y) boundary coordinates corresponding to label 'k' 
%     boundary = B{k}; 
%     % compute a simple estimate of the object's perimeter 
%     delta_sq = diff(boundary).^2; 
%     perimeter = sum(sqrt(sum(delta_sq,2))); 
%     % obtain the area calculation corresponding to label 'k' 
%     area1 = stats(k).Area; 
%     
%    metric = 4*pi*area1/perimeter^2; % display the results 
%     if (metric > threshold)
%         centroid = stats(k).Centroid;
%         temp(k,1)=centroid(1);
%         temp(k,2)=centroid(2);
%         temp(k,3)=area1;
%     end
% end
% 
% temp=sortrows(temp,3);
% c1=[temp(1,1) temp(1,2)];
% c2=[temp(2,1) temp(2,2)];
%  for k = 1:2 
%      centroid = bw1(k).Centroid;
%  end
 for k = 1:2 
    centroid = botDet(k).Centroid;
        temp(k,1)=centroid(1);
        temp(k,2)=centroid(2);
        temp(k,3)=botDet(k).Area;
 end
 temp=sortrows(temp,3);
c1=[temp(1,1) temp(1,2)];
c2=[temp(2,1) temp(2,2)];
 
[dy,dx]=findSlope(c1,c2);
ret=deg(-dy,dx);
disp(ret);
% figure,imshow(bw1);