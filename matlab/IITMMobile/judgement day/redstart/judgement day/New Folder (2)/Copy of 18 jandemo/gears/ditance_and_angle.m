function [R Theta]=ditance_and_angle(origin_point,destination_point,reference_point)
%this function used to get polar cordinates of destination from origin
clear i;
clear pi;
Theta=(180/pi)* (angle((destination_point-origin_point)*[1 ; -i])-angle((reference_point-origin_point)*[1 ; -i]));
if(Theta>180) Theta=Theta-360;end
if(Theta<-180) Theta=Theta+360;end
R=abs((destination_point-origin_point)*[1 ; i]);            
return;