function output_img=autocontrast(input_img)
%--------------------------------------------------------------------------
[m1 n1 r1]=size(input_img);
img2=double(input_img);
%--------------------calculation of vmin and vmax--------------------------
for k=1:r1
arr=sort(reshape(img2(:,:,k),m1*n1,1));
vmin(k)=arr(ceil(0.008*m1*n1));
vmax(k)=arr(ceil(0.992*m1*n1));
end
%--------------------------------------------------------------------------
if r1==3
    vmin=rgb2ntsc(vmin);
    vmax=rgb2ntsc(vmax);
end
%--------------------------------------------------------------------------
for(i=1:m1)
     for(j=1:n1)
         for(k=1:r1)
                img2(i,j,k)=255*(img2(i,j,k)-vmin(1))/(vmax(1)-vmin(1));
         end
     end
end
%--------------------------------------------------------------------------
output_img=uint8(img2);
%--------------------------------------------------------------------------