global serialPortObj
global serialSignatureByte
global serialDelayCount


% serialSignatureByte is 44
output =10 

fwrite(serialPortObj,serialSignatureByte,'int8');

for i=1:serialDelayCount 
  temp = i;
 end
for j=1:200
fwrite(serialPortObj,8,'int8');

for i=1:serialDelayCount 
  temp = i;
end
end

