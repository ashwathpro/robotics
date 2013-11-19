function findPath(clrIndex,magIndex,filteredArenaImg1)
s=size(filteredArenaImg1);
tempbw=zeros(s(1,1),s(1,2));
for k=1:s(1,1)
            for l=1:s(1,2)
                if(filteredArenaImg1(k,l)==clrIndex || filteredArenaImg1(k,l)==magIndex)
                    tempbw(k,l)=1;
                else
                    tempbw(k,l)=0;
                end
            end
end
bw1=tempbw;
bw1 = bwareaopen(bw1,300);
se = strel('square',1);
bw1 = imclose(bw1,se);

bw1 = bwareaopen(bw1,100);
se = strel('square',1);
bw1 = imclose(bw1,se);
figure, imshow(bw1);
return