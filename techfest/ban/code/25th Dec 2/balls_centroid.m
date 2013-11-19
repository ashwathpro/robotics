function [no_of_balls,ball_cordinates] = balls_centroid(BW_ball)
global tolcirc_ball;
global ball_dia
global ball_dia_tol

no_of_balls=0;
ball_cordinates=[];

  [ count_circles, centers,diameters] = findcircles(BW_ball,tolcirc_ball);
  for j=1:count_circles
      if(diameters(j)>=ball_dia-ball_dia_tol & diameters(j)<=ball_dia+ball_dia_tol)
          no_of_balls=no_of_balls+1;
          ball_cordinates(no_of_balls,1)=centers(j,2);
          ball_cordinates(no_of_balls,2)=centers(j,1);
      end
  end
  
          ball_cordinates=round(ball_cordinates);