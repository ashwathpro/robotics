function [numOfBalls,ball_cordinates] = balls_centroid(BW_ball)
global tolcirc_ball;
global minBallDia
global maxBallDia
numOfBalls=0;
ball_cordinates=[];
  [ count_circles, centers,diameters] = findcircles(BW_ball,tolcirc_ball);
  for j=1:count_circles
      if((diameters(j)>=minBallDia) & (diameters(j)<=maxBallDia))
          numOfBalls=numOfBalls+1;
          ball_cordinates(numOfBalls,:)=[centers(j,2) , centers(j,1)];
          
      end
  end
  