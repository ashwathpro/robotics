function [ count_circles, centers,diameters] = findcircles(input,tolcirc)
count_circles=0;
diameters=0;
centers=[0, 0];
% SPECIFIC PURPOSE: To identify features in a binary image, to locate circles among the
%                   features, their centers and the distance between the first two.
%
% DESCRIPTION: Features are assumed to be made up of ones, against a background of zeros.

tolsize = 1;   
% Tolerance for rejecting small features (diameters). Range [1,2,3...]
% To reject ever larger features, increase to higher integers.

if length(find(input~=0 & input~=1)) > 0, error('Input must be binary'), end
input = bwmorph(bwmorph(bwmorph(input,'spur'),'clean'),'fill');
[numbers,features] = bwlabel(input);
count_circles = 0; centers = [0 0]; separation12 = [];

for i = 1:features
    [I,J] = find(numbers == i);
    rows = min(I):max(I); columns = min(J):max(J);
    rows = min(rows):min([size(input,1) min(rows)+max([length(rows) length(columns)])-1]);
    columns = min(columns):min([size(input,2) min(columns)+max([length(rows) length(columns)])-1]);
    testitem = input(rows,columns);
    % testitem is a square containing the feature.
    diameter = max([length(rows) length(columns)]);
    circle = imcircle(diameter);
    circle = circle(1:length(rows),1:length(columns));
    % circle is compared to testitem.
    if (length(find(xor(testitem,circle))) < round(tolcirc*diameter^2)) & (diameter >= tolsize)...
            & length(rows)/length(columns) >= 0.5 & length(rows)/length(columns) <= 2,
        count_circles = count_circles + 1;
        center_rows = rows(1):rows(1)+diameter-1;
        center_columns = columns(1):columns(1)+diameter-1;
        centers(count_circles,:) = mean([center_rows;center_columns]')-0.5;
        diameters(count_circles,:)=diameter;
    end
end
if count_circles > 1, separation12 = norm(centers(2,:)-centers(1,:)); end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y = imcircle(n)

% y = imcircle(n);
%
% Draw a solid circle of ones with diameter n pixels 
% in a square of zero-valued pixels.
%
% Example: y = imcircle(128);

if rem(n,1) > 0, 
   disp(sprintf('n is not an integer and has been rounded to %1.0f',round(n)))
   n = round(n);
end

if n < 1     % invalid n
   error('n must be at least 1')
   
elseif n < 3 % trivial n
   y = ones(n);

elseif rem(n,2) == 0,  % even n
   
   DIAMETER = n;
   diameter = n-1;
   RADIUS = DIAMETER/2;
   radius = diameter/2;
   height_45 = round(radius/sqrt(2));
   width = zeros(1,RADIUS);
   semicircle = zeros(DIAMETER,RADIUS);   

   for i  = 1 : height_45
       upward = i - 0.5;
       sine = upward/radius;
       cosine = sqrt(1-sine^2);
       width(i) = ceil(cosine * radius);
   end

   array = width(1:height_45)-height_45;

   for j = max(array):-1:min(array)
       width(height_45 + j) = max(find(array == j));
   end

   if min(width) == 0
      index = find(width == 0);
      width(index) = round(mean([width(index-1) width(index+1)]));
   end

   width = [fliplr(width) width];

   for k  = 1 : DIAMETER
       semicircle(k,1:width(k)) = ones(1,width(k));
   end   

   y = [fliplr(semicircle) semicircle];

else   % odd n
   
   DIAMETER = n;
   diameter = n-1;
   RADIUS = DIAMETER/2;
   radius = diameter/2;
   semicircle = zeros(DIAMETER,radius);
   height_45 = round(radius/sqrt(2) - 0.5);
   width = zeros(1,radius);

   for i  = 1 : height_45
       upward = i;
       sine = upward/radius;
       cosine = sqrt(1-sine^2);
       width(i) = ceil(cosine * radius - 0.5);
   end

   array = width(1:height_45) - height_45;

   for j = max(array):-1:min(array)
       width(height_45 + j) = max(find(array == j));
   end

   if min(width) == 0
      index = find(width == 0);
      width(index) = round(mean([width(index-1) width(index+1)]));
   end

   width = [fliplr(width) max(width) width];

   for k  = 1 : DIAMETER
       semicircle(k,1:width(k)) = ones(1,width(k));
   end   

   y = [fliplr(semicircle) ones(DIAMETER,1) semicircle];

end



