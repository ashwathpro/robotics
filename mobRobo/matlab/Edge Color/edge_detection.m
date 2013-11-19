function edge_detection
global s;

d={'sobel','prewitt','roberts','log','zerocross','canny'};
[s,v1] = listdlg('PromptString','Select a file:',...
                'SelectionMode','single',...
                'ListString',d);
            
            save s;