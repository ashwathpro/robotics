function pie_chart
global color_image;
load color_image;
a=color_image;
[x,map]=rgb2ind(a,256);
[count,x]=imhist(x,map);
explode = zeros(size(count));
[c,offset] = max(count);
explode(offset) = 1;
figure;h = pie3(count,explode);colormap(map);
% textObjs = findobj(h,'Type','text');
% oldStr = get(textObjs,{'String'});
% val = get(textObjs,{'Extent'});
% oldExt = cat(1,val{:});
% Names = {'Product X: ';'Product Y: ';'Product Z: '};
% newStr = strcat(Names,oldStr);
% set(textObjs,{'String'},newStr)
% val1 = get(textObjs, {'Extent'});
% newExt = cat(1, val1{:});
% offset = sign(oldExt(:,1)).*(newExt(:,3)-oldExt(:,3))/2;
% pos = get(textObjs, {'Position'});
% textPos =  cat(1, pos{:});
% textPos(:,1) = textPos(:,1)+offset;
% set(textObjs,{'Position'},num2cell(textPos,[3,2]))