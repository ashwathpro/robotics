clc;
a=serial('COM14');
%  b=serial('COM14');
fopen(a);
% a.baud
% % a.parity
a.stopbit=1;
% a.stopbit
% a.databit
% a.valuessent
a.Terminator='LF';
for i=1:1
        b=fread(a,1,'uchar');
        while ~(strcmp(a.transferstatus,'idle'))
%             a.transferstatus
        end
        disp(b);
end
% a.valuessent
disp(a);
% fwrite(a,'a','async');
% q=fread(b);
% b.valuesrecieved;
fclose(a);
delete a;

% fclose(b);
% delete b;
% clear b;
