clc;

% a=serial('COM14');
% fopen(a);
% a.baud=4800;
% a.stopbit=1;
% a.Terminator='CR';
 for i=1:10
%         fwrite(a,'c','async');
%         while ~(strcmp(a.transferstatus,'idle'))
%         end

        fwrite(a,'c','async');
        while ~(strcmp(a.transferstatus,'idle'))
        end
end
% a.valuessent
% %disp(a);
% % fwrite(a,'a','async');
% % q=fread(b);
% % b.valuesrecieved;
% fclose(a);
% delete a;
% 
% % fclose(b);
% % delete b;
% % clear b;
