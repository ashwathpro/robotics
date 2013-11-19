centroids=[startNode];

l=length(bestProps);
dist=zeros(l,l);
for j=1:l
    for i=j:l
       if(j==1&&i==1)
          dist(j,i)=distance(startNode,bestProps(i).Centroid)
          
%        end
       else
         if(dist(j,i)==0)
          dist(j,i)=distance(bestProps(j).Centroid,bestProps(i).Centroid)
         end
       end
          end
    
    dmin=min(dist(j,:));
%     disp(dmin);
    for i=j:l
    if(dist(j,i)==dmin)
        centroids=[centroids; bestProps(i).Centroid];
    end
end
 
end

% disp(centroids);
