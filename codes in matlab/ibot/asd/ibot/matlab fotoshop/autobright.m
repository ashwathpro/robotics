function output_image=autobright(input_img)
%==========================================================================
[m1 n1 r1]=size(input_img);
if r1==3    a=rgb2ntsc(input_img);
else    a=double(input_img)./255;
end
limit=mean(mean(a(:,:,1)));
my_limit=0.5;
limca=my_limit-limit;
%==========================================================================
for(i=1:m1)
    for(j=1:n1)
          if(limca<0)
            if(a(i,j,1)<=0.92)
               a(i,j,1)=a(i,j,1)+limca;
            end
          end
          if(a(i,j,1)>1)
              a(i,j,1)=1;
          end
          if(a(i,j,1)<0)
              a(i,j,1)=0;
          end
      end
end
%==========================================================================
if r1==3    image=ntsc2rgb(a);
else        image=a;
end
image=image.*255;
output_image=uint8(image);
%==========================================================================