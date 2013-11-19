function viewhelptxt(textfilename,title)

textpath=[cd '\' 'help docs\' textfilename];
fid=fopen(textpath);
cell_text='';
while 1
            tline = fgetl(fid);
            if ~ischar(tline), break, end
            cell_text=[cell_text;{tline}];
end
fclose(fid);
helpwin (cell_text,title);