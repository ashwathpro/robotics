 function [rect_pos] = Crop_it(I)
%
%
% Crops the Image from a resizable & draggable rectangle 
% & displays it (after the figure is closed)
%
% I is the Image to be cropped, assumed to be in the 
% matlab workspace
%
% EXAMPLES
%
% I = imread('liftingbody.png');
% [rect_pos] = Crop_it(I);
%
% RGB = imread('peppers.png');
% [rect_pos] = Crop_it(RGB);
%
% See also IMPIXEL, IMPROFILE, ANNOTATION, IMCROP.

% $author Shripad Kondra, SISSA, Trieste, Italy
% $acknowledgments Diana Bedolla (SISSA),  Erion Hasanbelliu (UFL)
% $date 21-Aug-2008
%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
r=size(I,1);
c=size(I,2);

% 1) get the screensize 
Screen_size = get(0,'ScreenSize');
min_Screen_size = min(Screen_size(3:4));
% 2) imagine the screen as a aquare with this size
% 3) find the length of diagonal
diag_Screen_size =  round(sqrt(2*min_Screen_size.^2));
% 3) Lets say you have to fit a figure which is half the screen size
scale_screen = diag_Screen_size/2;
d=sqrt(r.^2+c.^2);  % find the size of the diagonal of the image 
scale_fig = (scale_screen/d); 

%% Figure resizing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Don't use IMSHOW as it doesn't strecth the image in same proportion     % 
% as the figure when the figure is strecthed.                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure, imagesc(I); colormap gray;
rect_pos_fig = get(gcf,'position');
rect_pos_fig(3) = round(c*scale_fig);
rect_pos_fig(4) = round(r*scale_fig);
% set the figure position so that it is proportional to the image
set(gcf,'Units','pixels')
set(gcf,'position',rect_pos_fig);
% set axis to fill the figure. 
set(gca,'position',[0 0 1 1]);

%% Creating the rectangle
% create the rectangle
plotedit on

h1=annotation('rectangle',[0  0 0.4 0.4]);
set(h1,'EdgeColor','r','LineStyle','--','LineWidth',2);

% fancy stuff -> slower if image is gray or is too big
if(size(I,3)>1 && scale_fig>1) 
set(h1,'FaceAlpha',.2,'FaceColor','yellow'); 
end
 
% here is the key for resizable rectangle

% set the delete callback
set(gcf,'DeleteFcn',{@myCallback,I,h1});
waitfor(h1);

% recover the value of the position of rectangle from root.
rect_pos=get(0,'UserData');
return;



%% Callback subfunction 
function myCallback(src,eventdata,I,h1)
r=size(I,1);
c=size(I,2);

rect_pos = get(h1,'position');
rect_pos = (floor(rect_pos.*[c r c r]))+1;
rect_pos(2) = r - (rect_pos(2) + rect_pos(4));

try
I2=imcrop(I,rect_pos); % uses imageprocessing toolbox
catch
I2=myCrop(I,rect_pos);    
end    

figure, imshow(I2); colormap gray; % remove this line if you don't want
set(gca,'position',[0 0 1 1]);

% save the position of rectangle in root.
set(0,'UserData',rect_pos);

% or put imwrite function to save the
% cropped image
% e.g. 
% imwrite(I2,'temp','png');
% see imwrite

%% croping function
function I2 = myCrop(I,rect)
% copied from imcrop -> see IMCROP
m = size(I,1);
n = size(I,2);
pixelHeight = rect(4);
pixelWidth = rect(3);

r1 = round(rect(2) + 1 );
c1 = round(rect(1) + 1 );
r2 = round(rect(4) + r1);
c2 = round(rect(3) + c1);

% Check for selected rectangle completely outside the image
if ((r1 > m) || (r2 < 1) || (c1 > n) || (c2 < 1))
    b = [];
else
    r1 = max(r1, 1);
    r2 = min(r2, m);
    c1 = max(c1, 1);
    c2 = min(c2, n);
    I2 = I(r1:r2, c1:c2, :);

end

return;

