
        
        [dy,dx]=findSlope(startNode,[centroids(1,1) centroids(1,2)]);
        slope(1)=deg(-dy,dx);
        
for i=1:length(centroids)-1
        [dy ,dx]= findSlope([centroids(i,1) centroids(i,2)] ,[centroids(i+1,1)  centroids(i+1),2]);
        slope(i+1)=deg(-dy,dx);
end
 [dy ,dx]=findSlope([centroids(length(centroids)-1,1) centroids(length(centroids)-1,2)],endNode);
 slope(length(centroids)+2)=deg(-dy,dx);
disp(slope);