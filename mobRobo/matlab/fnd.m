function [j,i,val] = fnd(F1,F2,n)

F1 = F1(:,:,n);
F2 = F2(:,:,n);

%F1 = medfilt2(F1,[3 3]);
%F2 = medfilt2(F2,[3 3]);

F1 = double(F1);
F2 = double(F2);

sf1=size(F1);
sf2=size(F2);

yf1=sf1(1);
xf1=sf1(2);
yf2=sf2(1);
xf2=sf2(2);
dy = yf1-yf2;
dx = xf1-xf2;
for ey = 1:dy;
    for ex = 1:dx;
        FF1 = F1(ey:yf2+ey-1,ex:xf2+ex-1);
        F = abs(FF1-F2);%.^2;
        k = (sum(sum(F)));
        avge(ey,ex) = k/((yf2)*(xf2));
    end
end
val = min(min(avge));
[ey,ex]=find(avge == val);
j = ey(1);
i = ex(1);

end
