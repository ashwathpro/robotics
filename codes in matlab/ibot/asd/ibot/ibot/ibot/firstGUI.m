function firstGUI(varargin)
tmpimg = imread('ibot1.jpg');
tmpfig=figure('numbertitle','Off','name','Tathva-- Agent Eye','visible','off');
imshow(tmpimg);
set(tmpfig,'units','pixels','position',[0 0 1000 800]);
centerfig(tmpfig);
set(tmpfig,'visible','on');

List = {'Blue','Green','Yellow','Orange'};


uicontrol('style','pushbutton','string','Get Snapshot','units','normalized',...
	'pos',[0.05 0.12 0.3 0.025],'callback',@snapshot);
uicontrol('style','pushbutton','string','Remove Noise','units','normalized',...
	'pos',[0.35 0.12 0.3 0.025],'callback',@exportClusterMask);
uicontrol('style','pushbutton','string','Index Image','units','normalized',...
	'pos',[0.65 0.12 0.3 0.025],'callback',@asdfasdf);

uicontrol('style','PopupMenu','string',List,'units','normalized',...
	'pos',[0.05 0.05 0.3 0.025],'callback',@asdfasdf);
 uicontrol('style','text','string','Weight','units','normalized',...
 	'pos',[0.35 0.05 0.15 0.025],'callback',@exportClusterMask);
 uicontrol('style','text','string','0','units','normalized',...
 	'pos',[0.5 0.05 0.15 0.025],'callback',@exportClusterMask);
uicontrol('style','pushbutton','string','Index Image','units','normalized',...
	'pos',[0.65 0.05 0.3 0.025],'callback',@asdfasdf);

function snapshot(varargin)
    tmpfig=(imread('ibot2.jpg'));
    figure(tmpfig);
end


end