function output_image=sketching(input_image,value)
%value ranges from -1 to 1.
value=(value+1)/2; %to make the range of value=[-1,1], but originally range was [0,1].
if ~isgray(input_image)  input_image=rgb2gray(input_image);
end
input_image=double(input_image);
[m n]=size(input_image);
for(num=2:255)
   inv=255-edge(input_image,'prewitt',num).*255;
   count_black=0;
   for(i=1:m)
       for(j=1:n)
            if ~inv(i,j)    count_black=count_black+1;
            end
       end
   end
   ratio=(m*n-count_black)/count_black;
   if(ratio>value*35)    break,end
end
output_image=uint8(inv);