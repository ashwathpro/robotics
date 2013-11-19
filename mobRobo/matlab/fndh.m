function [ey,ex,minval] = fndh(IL,IS,nop)

wh = 10;
ws = 5;
wv = 1;

ILH = rgb2hsv(IL);
ISH = rgb2hsv(IS);

FL1 = double(ILH(:,:,1));
FS1 = double(ISH(:,:,1));
FL2 = double(ILH(:,:,2));
FS2 = double(ISH(:,:,2));
FL3 = double(ILH(:,:,3));
FS3 = double(ISH(:,:,3));

sf1=size(FL1);
sf2=size(FS1);

yf1=sf1(1);xf1=sf1(2);
yf2=sf2(1);xf2=sf2(2);

dy = yf1-yf2;
dx = xf1-xf2;
for ey = 1:dy;
    for ex = 1:dx;
        FF1 = FL1(ey:yf2+ey-1,ex:xf2+ex-1);
        I1 = (FF1-FS1).^2;
        k1 = (sum(sum(I1)));
        FF2 = FL2(ey:yf2+ey-1,ex:xf2+ex-1);
        I2 = (FF2-FS2).^2;
        k2 = (sum(sum(I2)));
        FF3 = FL3(ey:yf2+ey-1,ex:xf2+ex-1);
        I3 = (FF3-FS3).^2;
        k3 = (sum(sum(I3)));
        k = wh*k1+ws*k2+wv*k3;
        avge(ey,ex) = k/((yf2)*(xf2));
    end
end

clear ey;
clear ex;

for i=1:nop
minval(i) = min(min(avge));
[ey(i),ex(i)]=find(avge == minval(i));
avge(ey(i),ex(i)) = 1e9;
end

end
