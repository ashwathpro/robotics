PSF = fspecial('average',10);
disp(PSF);
BlurredNoisy=imread('ibot4.jpg');
figure;imshow(BlurredNoisy);

luc1 = deconvlucy(BlurredNoisy,PSF,2);
figure;imshow(luc1);title('Restored Image, NUMIT = 5');
% luc1_cell = deconvlucy({BlurredNoisy},PSF,5);
% luc2_cell = deconvlucy(luc1_cell,PSF);
% luc2 = im2uint8(luc2_cell{2});
% figure;imshow(luc2);title('Restored Image, NUMIT = 15');
% DAMPAR = im2uint8(3*sqrt(V));
% luc3 = deconvlucy(BlurredNoisy,PSF,15,DAMPAR);
% figure;imshow(luc3);
% title('Restored Image with Damping, NUMIT = 15');