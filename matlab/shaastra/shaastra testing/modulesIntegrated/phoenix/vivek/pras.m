input_colored_image = imread('test2.bmp');


 h = figure;
 imshow(input_colored_image);
rect = imrect(h);
disp(rect);

BW_OurRobot=((input_colored_image(:,:,1)>=input_colored_image(:,:,2)+150) ...
                &((input_colored_image(:,:,1)>=input_colored_image(:,:,3)+150)) ...
                &((input_colored_image(:,:,1)>=230)) ...
                &((input_colored_image(:,:,2)<=50)) ...
                &((input_colored_image(:,:,3)<=50)));
            
            figure, imshow(BW_OurRobot);
            
            % remove all object containing fewer than 30 pixels


% fill a gap in the pen's cap
se = strel('disk',5);
BW_OurRobot = imclose(BW_OurRobot,se);
BW_OurRobot = bwareaopen(BW_OurRobot,5);
% fill any holes, so that regionprops can be used to estimate
% the area enclosed by each of the boundaries
BW_OurRobot = imfill(BW_OurRobot,'holes');

imshow(BW_OurRobot)