function bwLineImage = getBWLineImage(imagesize,startPoint,endPoint,thicknessOfline)

bwLineImage = logical(zeros(imagesize));

if(endPoint(1)-startPoint(1) ~= 0)
    slope = (endPoint(2)-startPoint(2))/(endPoint(1)-startPoint(1));
else
    slope = inf;
end
xVar = sin(atan(slope))* thicknessOfline;
yVar = cos(atan(slope))* thicknessOfline;

points(1,:) = startPoint + [-xVar , yVar] ;
points(2,:) = startPoint + [xVar , -yVar] ;
points(3,:) = endPoint + [-xVar , yVar] ;
points(4,:) = endPoint + [xVar , -yVar];


bwLineImage = drawLine(bwLineImage,points(1,:),points(2,:));
bwLineImage = drawLine(bwLineImage,points(3,:),points(4,:));
bwLineImage = drawLine(bwLineImage,points(1,:),points(3,:));
bwLineImage = drawLine(bwLineImage,points(2,:),points(4,:));
%bwLineImage = drawLine(bwLineImage,startPoint,endPoint);
%figure,imshow(bwLineImage)
mid =round((startPoint+endPoint)/2);
bwLineImage = imfill(bwLineImage,[mid(2),mid(1)],4);
%figure,imshow(bwLineImage)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function BWinputImage = drawLine(BWinputImage,startPoint,endPoint)

size_inputImage = size(BWinputImage);

if(endPoint(1)-startPoint(1) ~= 0)
    slope = (endPoint(2)-startPoint(2))/(endPoint(1)-startPoint(1));
else
    slope = inf;
end

%check all corner case
if(startPoint(1)<1)
   startPoint(1) = 1;
   startPoint(2) = slope * (1-endPoint(1)) + endPoint(2);
elseif(startPoint(1)>size_inputImage(2))
   startPoint(1) = size_inputImage(2);
   startPoint(2) = slope * (size_inputImage(2)-endPoint(1)) + endPoint(2);
end
if(startPoint(2)<1)
   startPoint(2) = 1;
   startPoint(1) =  (1-endPoint(2))/slope + endPoint(1);
elseif(startPoint(2)>size_inputImage(1))
   startPoint(2) = size_inputImage(1);
   startPoint(1) =  (size_inputImage(1)-endPoint(2))/slope + endPoint(1);
end
if(endPoint(1)<1)
   endPoint(1) = 1;
   endPoint(2) = slope * (1-startPoint(1)) + startPoint(2);
elseif(endPoint(1)>size_inputImage(2))
   endPoint(1) = size_inputImage(2);
   endPoint(2) = slope * (size_inputImage(2)-startPoint(1)) + startPoint(2);
end
if(endPoint(2)<1)
   endPoint(2) = 1;
   endPoint(1) =  (1-startPoint(2))/slope + startPoint(1);
elseif(endPoint(2)>size_inputImage(1))
   endPoint(2) = size_inputImage(1);
   endPoint(1) =  (size_inputImage(1)-startPoint(2))/slope + startPoint(1);
end
% even if if its not satis fied then return
if((min(min(endPoint,startPoint))<1 )...
        |( max(endPoint(1),startPoint(1))> size_inputImage(2))...
        |( max(endPoint(1),startPoint(1))> size_inputImage(2) ))
    %line is out side of image
    return
end



startPoint = int16(startPoint);
endPoint = int16(endPoint);

if(abs(slope)<1)
    diffX = 1;
    if(endPoint(1) < startPoint(1))
        diffX = -1;
    end
    c = startPoint(2) - slope* startPoint(1);
    for x = startPoint(1):diffX:endPoint(1)
        
        y =int16(slope * x + c );
        BWinputImage(y,x)=logical(1);
    end
else
    diffY = 1;
    if(endPoint(2) < startPoint(2))
        diffY = -1;
    end
    c = startPoint(1) -  startPoint(2)/slope;
    for y = startPoint(2):diffY:endPoint(2)
        x =int16(y/slope + c );
        BWinputImage(y,x)=logical(1);
    end
end


