function [input2]=ripper(input,th,l)
if l==0
if(th>.08)
    a=th-.05;
else
    a=th;
end

if(th<.94)
    b=th+.05;
else
    b=th;
end    

input1=im2bw(input,a);
input1 = bwmorph(bwmorph(bwmorph(input1,'spur'),'clean'),'fill');

input=im2bw(input,b);
input = bwmorph(bwmorph(bwmorph(input,'spur'),'clean'),'fill');

[I,J]=find(and(input1,input)==1);
input1(I,J)=0;
input2=input1;
% imshow(input1);

else
    input3=ripper(input,th,0);
    input2=im2bw(input,th);
    [I,J]=find(and(input2,input3)==1);
    input2(I,J)=0;
    input2= bwmorph(bwmorph(bwmorph(input2,'spur'),'clean'),'fill');
%     imshow(input2);
end

end