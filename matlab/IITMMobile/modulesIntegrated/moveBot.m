function moveBot(dir)

global serObj


for i=1:10

    fwrite(serObj,dir,'async');
    while ~(strcmp(serObj.transferstatus,'idle'))
    end
end

end