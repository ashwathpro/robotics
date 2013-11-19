function [lowin, highin, lowout, highout, gammaval, imgout] = intensityadjust(imgin)

% Syntax: [LOWIN, HIGHIN, LOWOUT, HIGHOUT, GAMMA, IMGOUT] = INTENSITYADJUST(IMGIN)
% 
% INTENSITYADJUST launches an interactive, uicontrolled figure for use with the 
% Image Processing Toolbox function IMADJUST. The class support for the input argument
% is the same as that for imadjust.
%
% The function will display a two versions of the input image. The version of the left 
% will be the original, un-adjusted image. The version on the right will change interactively
% when the slider controls are moved, updating the five arguments for imadjust:
%
% low_in, high_in, low_out, high_out, and gamma.(HELP IMADJUST for more details).
% 
% The function return all of these variables as output arguments, along with IMGOUT, 
% which will contain the input image operated on using imadjust with the specified parameters.
%
% Written by Brett Shoelson, Ph.D.
% brett.shoelson@joslin.harvard.edu
%
% Last modification: 10/18/2001. Written/Tested under version 6.1, R12.1, using IP Toolbox version 3.1.
% 
% REQUIRES THE IP TOOLBOX.
%
% SEE ALSO: IMADJUST

IAVals.adjfig=figure('NumberTitle','off','name','Select Image Adjustment Values','units','normalized',...
	'position',[0.02 0.1 0.96 0.85],'tag','intensityIAVals.adjfig','menubar','none');
IAVals.lowout = 0;
IAVals.currimage = imgin;
IAVals.done = 0;
IAVals.gammaval = 1;
IAVals.highin = 1;
IAVals.lowin = 0;
IAVals.highout = 1;

setappdata(gcf,'IAVals',IAVals);

txtplot=subplot('position',[0.5157 0.265 0.4528 0.085]);
set(txtplot,'xtick',[],'ytick',[]);
msgstring=sprintf('Select options for image adjustment, then click ''DONE''.\n(Use ''help imadjust for more variable descriptions.)');
text(0.5,0.5,msgstring,'units','normalized','fontunits','normalized','fontsize',0.25,'fontweight','bold','horizontalalignment','center','color','r');

msgstring1=sprintf('IMADJUST(I,[LOWIN HIGHIN],[LOWOUT HIGHOUT],GAMMA)');
msgstring2=sprintf('transforms the values in the intensity image I to values in J by mapping values between lowin and highin to values between lowout and highout. Values below lowin and above highin are clipped; that is, values below lowin map to lowout, and those above highin map to highout. You can use an empty matrix ( [ ] ) for [lowin highin] or for [lowout highout] to specify the default of [0 1].');
msgstring3=sprintf('Gamma specifies the shape of the curve describing the relationship between the values in I and J. If gamma is less than 1, the mapping is weighted toward higher (brighter) output values. If gamma is greater than 1, the mapping is weighted toward lower (darker) output values. If you omit the argument, gamma defaults to 1 (linear mapping).');
msgstr = sprintf('%s\n%s\n\n%s',msgstring1,msgstring2,msgstring3);

txtplot2=uicontrol('style','edit','string',msgstr,...
	'units','normalized','position',[0.0314 0.05 0.4528 0.3],...
	'fontname','times','min',0,'max',10,'backgroundcolor','w','horizontalalignment','left',...
	'fontunits','normalized','fontsize',0.06);

plot1=subplot('position',[0.0314 0.4 0.4528 0.54]);
imshow(imgin);
title('Original');
plot2=subplot('position',[0.5157 0.4 0.4528 0.54]);
imshow(imgin);
title('No Adjustment');
set(plot1,'xtick',[],'ytick',[]);
set(plot2,'xtick',[],'ytick',[]);

slidelowval;
slidehighval;
slidebottomval;
slidetopval;
slidegammaval;

donebutton=uicontrol('style','pushbutton','string','DONE','units','normalized',...
	'position',[0.801 0.05 0.0925 0.09],'foregroundcolor',[1 .4 .4],'callback',...
	['IAVals = getappdata(gcf,''IAVals'');',...
		'IAVals.done = 1;',...
		'setappdata(gcf,''IAVals'',IAVals);'],...
	'fontname','Helvetica','fontsize',14,'fontweight','bold');

cancelbutton=uicontrol('style','pushbutton','string','Cancel','units','normalized',...
	'position',[0.90075 0.05 0.0677 0.03],'callback',...
	['IAVals = getappdata(gcf,''IAVals'');',...
		'IAVals.done = 1;',...
		'IAVals.lowin = 0;',...
		'IAVals.highin = 1;',...
		'IAVals.lowout = 0;',...
		'IAVals.highout = 1;',...
		'IAVals.gammaval = 1;', ...
		'setappdata(gcf,''IAVals'',IAVals);'],...
	'fontname','Helvetica','fontsize',10,'fontweight','bold');

while ~isfield(IAVals,'done') | IAVals.done == 0
	IAVals = getappdata(gcf,'IAVals');
	pause(0.01);
end
close(IAVals.adjfig);

if IAVals.lowout == 0 & IAVals.highout == 1 & IAVals.lowin == 0 & IAVals.highin == 1 & IAVals.gammaval == 1
	fprintf('Cancelling intensity adjustment.\n');
end

lowout = IAVals.lowout;
gammaval = IAVals.lowout;
highin = IAVals.highin;
lowin = IAVals.lowin;
highout = IAVals.highout;
imgout=imadjust(imgin, [IAVals.lowin IAVals.highin], [IAVals.lowout IAVals.highout], IAVals.gammaval);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SUBFUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function slidelowval(lvalcommand_str)
%*****************************************************************************
global lvalhandles
IAVals = getappdata(gcf,'IAVals');
figurename=IAVals.adjfig; 
variablereturned='IAVals.lowin'; 
functionname='slidelowval';
slidertext='LOW IN value:';
minslidervalue=0;
maxslidervalue=1;
sliderdefaultvalue=0;
identifier='lval';
%Action on Completion
completeaction=['IAVals = getappdata(gcf,''IAVals'');',...
		'tmp=imadjust(IAVals.currimage,[IAVals.lowin IAVals.highin],[IAVals.lowout IAVals.highout],IAVals.gammaval);', ...
		'imshow(tmp)',';',...
		'title([''Low In = '' num2str(IAVals.lowin) ''; High in = '' num2str(IAVals.highin) ''; Low Out = '' num2str(IAVals.lowout) ''; High Out = '' num2str(IAVals.highout) ''; Gamma = '' num2str(IAVals.gammaval)]);', ...
		'setappdata(gcf,''IAVals'',IAVals);'];
%Position
sliderposn=[60 15 9.375 9]; %Percentages screen width and height
if nargin < 1
	lvalcommand_str = 'initialize';
end
if ~strcmp(lvalcommand_str,'initialize')
	lvalh_sldr = lvalhandles(1);
	lvalh_min = lvalhandles(2);
	lvalh_max = lvalhandles(3);
	lvalh_val = lvalhandles(4);
end
if strcmp(lvalcommand_str,'initialize')
	if exist('slidertext')&~isempty(slidertext)
		lvalh_frame = uicontrol(figurename,'style','frame','units','normalized','position',sliderposn/100);
		uicontrol(figurename,'style','text','string',slidertext,'units','normalized',...
			'position',(sliderposn+[0.1 2 -0.2 -2.5])/100,...
			'fontname','Helvetica','fontweight','bold','fontsize',7,'HorizontalAlignment','Center');
	else
		lvalh_frame = uicontrol(figurename,'style','frame','units','normalized','position',sliderposn/100);
	end
	lvalh_sldr = uicontrol(figurename,'callback',[functionname '(''Slider Moved'')' ';'],'style','slider',...
		'min',minslidervalue,'max',maxslidervalue,'units','normalized',...
		'position',([sliderposn(1)+0.5 sliderposn(2)+0.5 sliderposn(3)-1 2])/100);
	set(lvalh_sldr,'value',sliderdefaultvalue);
	lvalh_min = uicontrol(figurename,'style','text','string',num2str(get(lvalh_sldr,'min')),'units','normalized',...
		'position',[sliderposn(1)+1 sliderposn(2)+2.5 sliderposn(3)-7 2.5]/100,'horizontalalignment','left');
	lvalh_max = uicontrol(figurename,'style','text','string',num2str(get(lvalh_sldr,'max')),'units','normalized',...
		'position',[sliderposn(1)+sliderposn(3)-3 sliderposn(2)+2.5 sliderposn(3)-7 2.5]/100,'horizontalalignment','right');
	lvalh_val = uicontrol(figurename,'callback',[functionname '(''Change Value'')' ';'],'style','edit','string',num2str(get(lvalh_sldr,'value')),...
		'units','normalized','position',[sliderposn(1)+sliderposn(3)/2-1.25 sliderposn(2)+3 3 3]/100);
	lvalhandles = [lvalh_sldr lvalh_min lvalh_max lvalh_val];
elseif strcmp(lvalcommand_str,'Change Value')
	lvaluser_value = str2num(get(lvalh_val,'string'));
	if ~length(lvaluser_value)
		lvaluser_value = (get(lvalh_sldr,'max')+get(lvalh_sldr,'min'))/2;
	end
	lvaluser_value = min([lvaluser_value get(lvalh_sldr,'max')]);
	lvaluser_value = max([lvaluser_value get(lvalh_sldr,'min')]);
	set(lvalh_sldr,'value',lvaluser_value);
	set(lvalh_val,'string',num2str(get(lvalh_sldr,'value')));
elseif strcmp(lvalcommand_str,'Slider Moved')
	set(lvalh_val,'string',num2str(get(lvalh_sldr,'value')));
	eval([variablereturned '=' num2str(get(lvalh_sldr,'value')) '; setappdata(gcf, ''IAVals'', IAVals);']);
	if exist('completeaction')&~isempty(completeaction)
		eval(completeaction);
	end
end
return

function slidehighval(hvalcommand_str)
%*****************************************************************************
global hvalhandles
IAVals = getappdata(gcf,'IAVals');
figurename=IAVals.adjfig; 
variablereturned='IAVals.highin'; 
functionname='slidehighval';
slidertext='HIGH IN value:';
minslidervalue=0;
maxslidervalue=1;
sliderdefaultvalue=1;
identifier='hval';
%Action on Completion
completeaction=['IAVals = getappdata(gcf,''IAVals'');',...
		'tmp=imadjust(IAVals.currimage,[IAVals.lowin IAVals.highin],[IAVals.lowout IAVals.highout],IAVals.gammaval);',...
		'imshow(tmp)',';',...
		'title([''Low In = '' num2str(IAVals.lowin) ''; High in = '' num2str(IAVals.highin) ''; Low Out = '' num2str(IAVals.lowout) ''; High Out = '' num2str(IAVals.highout) ''; Gamma = '' num2str(IAVals.gammaval)]);', ...
		'setappdata(gcf,''IAVals'',IAVals);'];
%Position
sliderposn=[60 5 9.375 9]; %Percentages screen width and height
if nargin < 1
	hvalcommand_str = 'initialize';
end
if ~strcmp(hvalcommand_str,'initialize')
	hvalh_sldr = hvalhandles(1);
	hvalh_min = hvalhandles(2);
	hvalh_max = hvalhandles(3);
	hvalh_val = hvalhandles(4);
end
if strcmp(hvalcommand_str,'initialize')
	if exist('slidertext')&~isempty(slidertext)
		hvalh_frame = uicontrol(figurename,'style','frame','units','normalized','position',sliderposn/100);
		uicontrol(figurename,'style','text','string',slidertext,'units','normalized',...
			'position',(sliderposn+[0.1 2 -0.2 -2.5])/100,...
			'fontname','Helvetica','fontweight','bold','fontsize',7,'HorizontalAlignment','Center');
	else
		hvalh_frame = uicontrol(figurename,'style','frame','units','normalized','position',sliderposn/100);
	end
	hvalh_sldr = uicontrol(figurename,'callback',[functionname '(''Slider Moved'')' ';'],'style','slider',...
		'min',minslidervalue,'max',maxslidervalue,'units','normalized',...
		'position',([sliderposn(1)+0.5 sliderposn(2)+0.5 sliderposn(3)-1 2])/100);
	set(hvalh_sldr,'value',sliderdefaultvalue);
	hvalh_min = uicontrol(figurename,'style','text','string',num2str(get(hvalh_sldr,'min')),'units','normalized',...
		'position',[sliderposn(1)+1 sliderposn(2)+2.5 sliderposn(3)-7 2.5]/100,'horizontalalignment','left');
	hvalh_max = uicontrol(figurename,'style','text','string',num2str(get(hvalh_sldr,'max')),'units','normalized',...
		'position',[sliderposn(1)+sliderposn(3)-3 sliderposn(2)+2.5 sliderposn(3)-7 2.5]/100,'horizontalalignment','right');
	hvalh_val = uicontrol(figurename,'callback',[functionname '(''Change Value'')' ';'],'style','edit','string',num2str(get(hvalh_sldr,'value')),...
		'units','normalized','position',[sliderposn(1)+sliderposn(3)/2-1.25 sliderposn(2)+3 3 3]/100);
	hvalhandles = [hvalh_sldr hvalh_min hvalh_max hvalh_val];
elseif strcmp(hvalcommand_str,'Change Value')
	hvaluser_value = str2num(get(hvalh_val,'string'));
	if ~length(hvaluser_value)
		hvaluser_value = (get(hvalh_sldr,'max')+get(hvalh_sldr,'min'))/2;
	end
	hvaluser_value = min([hvaluser_value get(hvalh_sldr,'max')]);
	hvaluser_value = max([hvaluser_value get(hvalh_sldr,'min')]);
	set(hvalh_sldr,'value',hvaluser_value);
	set(hvalh_val,'string',num2str(get(hvalh_sldr,'value')));
elseif strcmp(hvalcommand_str,'Slider Moved')
	set(hvalh_val,'string',num2str(get(hvalh_sldr,'value')));
	eval([variablereturned '=' num2str(get(hvalh_sldr,'value')) '; setappdata(gcf, ''IAVals'', IAVals);']);
	if exist('completeaction')&~isempty(completeaction)
		eval(completeaction);
	end
end
return

function slidebottomval(bvalcommand_str)
%*****************************************************************************
global bvalhandles
IAVals = getappdata(gcf,'IAVals');
figurename=IAVals.adjfig; 
variablereturned='IAVals.lowout';
functionname='slidebottomval';
slidertext='LOW OUT value:';
minslidervalue=0;
maxslidervalue=1;
sliderdefaultvalue=0;
identifier='bval';
%Action on Completion
completeaction=['IAVals = getappdata(gcf,''IAVals'');',...
		'tmp=imadjust(IAVals.currimage,[IAVals.lowin IAVals.highin],[IAVals.lowout IAVals.highout],IAVals.gammaval);',...
		'imshow(tmp)',';',...
		'title([''Low In = '' num2str(IAVals.lowin) ''; High in = '' num2str(IAVals.highin) ''; Low Out = '' num2str(IAVals.lowout) ''; High Out = '' num2str(IAVals.highout) ''; Gamma = '' num2str(IAVals.gammaval)]);', ...
		'setappdata(gcf,''IAVals'',IAVals);'];
%Position
sliderposn=[70 15 9.375 9]; %Percentages screen width and height
if nargin < 1
	bvalcommand_str = 'initialize';
end
if ~strcmp(bvalcommand_str,'initialize')
	bvalh_sldr = bvalhandles(1);
	bvalh_min = bvalhandles(2);
	bvalh_max = bvalhandles(3);
	bvalh_val = bvalhandles(4);
end
if strcmp(bvalcommand_str,'initialize')
	if exist('slidertext')&~isempty(slidertext)
		bvalh_frame = uicontrol(figurename,'style','frame','units','normalized','position',sliderposn/100);
		uicontrol(figurename,'style','text','string',slidertext,'units','normalized',...
			'position',(sliderposn+[0.1 2 -0.2 -2.5])/100,...
			'fontname','Helvetica','fontweight','bold','fontsize',7,'HorizontalAlignment','Center');
	else
		bvalh_frame = uicontrol(figurename,'style','frame','units','normalized','position',sliderposn/100);
	end
	bvalh_sldr = uicontrol(figurename,'callback',[functionname '(''Slider Moved'')' ';'],'style','slider',...
		'min',minslidervalue,'max',maxslidervalue,'units','normalized',...
		'position',([sliderposn(1)+0.5 sliderposn(2)+0.5 sliderposn(3)-1 2])/100);
	set(bvalh_sldr,'value',sliderdefaultvalue);
	bvalh_min = uicontrol(figurename,'style','text','string',num2str(get(bvalh_sldr,'min')),'units','normalized',...
		'position',[sliderposn(1)+1 sliderposn(2)+2.5 sliderposn(3)-7 2.5]/100,'horizontalalignment','left');
	bvalh_max = uicontrol(figurename,'style','text','string',num2str(get(bvalh_sldr,'max')),'units','normalized',...
		'position',[sliderposn(1)+sliderposn(3)-3 sliderposn(2)+2.5 sliderposn(3)-7 2.5]/100,'horizontalalignment','right');
	bvalh_val = uicontrol(figurename,'callback',[functionname '(''Change Value'')' ';'],'style','edit','string',num2str(get(bvalh_sldr,'value')),...
		'units','normalized','position',[sliderposn(1)+sliderposn(3)/2-1.25 sliderposn(2)+3 3 3]/100);
	bvalhandles = [bvalh_sldr bvalh_min bvalh_max bvalh_val];
elseif strcmp(bvalcommand_str,'Change Value')
	bvaluser_value = str2num(get(bvalh_val,'string'));
	if ~length(bvaluser_value)
		bvaluser_value = (get(bvalh_sldr,'max')+get(bvalh_sldr,'min'))/2;
	end
	bvaluser_value = min([bvaluser_value get(bvalh_sldr,'max')]);
	bvaluser_value = max([bvaluser_value get(bvalh_sldr,'min')]);
	set(bvalh_sldr,'value',bvaluser_value);
	set(bvalh_val,'string',num2str(get(bvalh_sldr,'value')));
elseif strcmp(bvalcommand_str,'Slider Moved')
	set(bvalh_val,'string',num2str(get(bvalh_sldr,'value')));
	eval([variablereturned '=' num2str(get(bvalh_sldr,'value')) '; setappdata(gcf, ''IAVals'', IAVals);']);
	if exist('completeaction')&~isempty(completeaction)
		eval(completeaction);
	end
end
return

function slidetopval(tvalcommand_str)
%*****************************************************************************
global tvalhandles
IAVals = getappdata(gcf,'IAVals');
figurename=IAVals.adjfig; 
variablereturned='IAVals.highout'; 
functionname='slidetopval';
slidertext='HIGH OUT value:';
minslidervalue=0;
maxslidervalue=1;
sliderdefaultvalue=1;
identifier='tval';
%Action on Completion
completeaction=['IAVals = getappdata(gcf,''IAVals'');',...
		'tmp=imadjust(IAVals.currimage,[IAVals.lowin IAVals.highin],[IAVals.lowout IAVals.highout],IAVals.gammaval);',...
		'imshow(tmp)',';',...
		'title([''Low In = '' num2str(IAVals.lowin) ''; High in = '' num2str(IAVals.highin) ''; Low Out = '' num2str(IAVals.lowout) ''; High Out = '' num2str(IAVals.highout) ''; Gamma = '' num2str(IAVals.gammaval)]);', ...
		'setappdata(gcf,''IAVals'',IAVals);'];
%Position
sliderposn=[70 5 9.375 9]; %Percentages screen width and height
if nargin < 1
	tvalcommand_str = 'initialize';
end
if ~strcmp(tvalcommand_str,'initialize')
	tvalh_sldr = tvalhandles(1);
	tvalh_min = tvalhandles(2);
	tvalh_max = tvalhandles(3);
	tvalh_val = tvalhandles(4);
end
if strcmp(tvalcommand_str,'initialize')
	if exist('slidertext')&~isempty(slidertext)
		tvalh_frame = uicontrol(figurename,'style','frame','units','normalized','position',sliderposn/100);
		uicontrol(figurename,'style','text','string',slidertext,'units','normalized',...
			'position',(sliderposn+[0.1 2 -0.2 -2.5])/100,...
			'fontname','Helvetica','fontweight','bold','fontsize',7,'HorizontalAlignment','Center');
	else
		tvalh_frame = uicontrol(figurename,'style','frame','units','normalized','position',sliderposn/100);
	end
	tvalh_sldr = uicontrol(figurename,'callback',[functionname '(''Slider Moved'')' ';'],'style','slider',...
		'min',minslidervalue,'max',maxslidervalue,'units','normalized',...
		'position',([sliderposn(1)+0.5 sliderposn(2)+0.5 sliderposn(3)-1 2])/100);
	set(tvalh_sldr,'value',sliderdefaultvalue);
	tvalh_min = uicontrol(figurename,'style','text','string',num2str(get(tvalh_sldr,'min')),'units','normalized',...
		'position',[sliderposn(1)+1 sliderposn(2)+2.5 sliderposn(3)-7 2.5]/100,'horizontalalignment','left');
	tvalh_max = uicontrol(figurename,'style','text','string',num2str(get(tvalh_sldr,'max')),'units','normalized',...
		'position',[sliderposn(1)+sliderposn(3)-3 sliderposn(2)+2.5 sliderposn(3)-7 2.5]/100,'horizontalalignment','right');
	tvalh_val = uicontrol(figurename,'callback',[functionname '(''Change Value'')' ';'],'style','edit','string',num2str(get(tvalh_sldr,'value')),...
		'units','normalized','position',[sliderposn(1)+sliderposn(3)/2-1.25 sliderposn(2)+3 3 3]/100);
	tvalhandles = [tvalh_sldr tvalh_min tvalh_max tvalh_val];
elseif strcmp(tvalcommand_str,'Change Value')
	tvaluser_value = str2num(get(tvalh_val,'string'));
	if ~length(tvaluser_value)
		tvaluser_value = (get(tvalh_sldr,'max')+get(tvalh_sldr,'min'))/2;
	end
	tvaluser_value = min([tvaluser_value get(tvalh_sldr,'max')]);
	tvaluser_value = max([tvaluser_value get(tvalh_sldr,'min')]);
	set(tvalh_sldr,'value',tvaluser_value);
	set(tvalh_val,'string',num2str(get(tvalh_sldr,'value')));
elseif strcmp(tvalcommand_str,'Slider Moved')
	set(tvalh_val,'string',num2str(get(tvalh_sldr,'value')));
	eval([variablereturned '=' num2str(get(tvalh_sldr,'value')) '; setappdata(gcf, ''IAVals'', IAVals);']);
	if exist('completeaction')&~isempty(completeaction)
		eval(completeaction);
	end
end
return

function slidegammaval(gvalcommand_str)
%*****************************************************************************
global gvalhandles
IAVals = getappdata(gcf,'IAVals');
figurename=IAVals.adjfig; 
variablereturned='IAVals.gammaval'; 
functionname='slidegammaval';
slidertext='GAMMA value:';
minslidervalue=0;
maxslidervalue=10;
sliderdefaultvalue=1;
identifier='gval';
%Action on Completion
completeaction=['IAVals = getappdata(gcf,''IAVals'');',...
		'tmp=imadjust(IAVals.currimage,[IAVals.lowin IAVals.highin],[IAVals.lowout IAVals.highout],IAVals.gammaval);',...
		'imshow(tmp)',';',...
		'title([''Low In = '' num2str(IAVals.lowin) ''; High in = '' num2str(IAVals.highin) ''; Low Out = '' num2str(IAVals.lowout) ''; High Out = '' num2str(IAVals.highout) ''; Gamma = '' num2str(IAVals.gammaval)]);', ...
		'setappdata(gcf,''IAVals'',IAVals);'];
%Position
sliderposn=[80 15 9.375 9]; %Percentages screen width and height
if nargin < 1
	gvalcommand_str = 'initialize';
end
if ~strcmp(gvalcommand_str,'initialize')
	gvalh_sldr = gvalhandles(1);
	gvalh_min = gvalhandles(2);
	gvalh_max = gvalhandles(3);
	gvalh_val = gvalhandles(4);
end
if strcmp(gvalcommand_str,'initialize')
	if exist('slidertext')&~isempty(slidertext)
		gvalh_frame = uicontrol(figurename,'style','frame','units','normalized','position',sliderposn/100);
		uicontrol(figurename,'style','text','string',slidertext,'units','normalized',...
			'position',(sliderposn+[0.1 2 -0.2 -2.5])/100,...
			'fontname','Helvetica','fontweight','bold','fontsize',7,'HorizontalAlignment','Center');
	else
		gvalh_frame = uicontrol(figurename,'style','frame','units','normalized','position',sliderposn/100);
	end
	gvalh_sldr = uicontrol(figurename,'callback',[functionname '(''Slider Moved'')' ';'],'style','slider',...
		'min',minslidervalue,'max',maxslidervalue,'units','normalized',...
		'position',([sliderposn(1)+0.5 sliderposn(2)+0.5 sliderposn(3)-1 2])/100);
	set(gvalh_sldr,'value',sliderdefaultvalue);
	gvalh_min = uicontrol(figurename,'style','text','string',num2str(get(gvalh_sldr,'min')),'units','normalized',...
		'position',[sliderposn(1)+1 sliderposn(2)+2.5 sliderposn(3)-7 2.5]/100,'horizontalalignment','left');
	gvalh_max = uicontrol(figurename,'style','text','string',num2str(get(gvalh_sldr,'max')),'units','normalized',...
		'position',[sliderposn(1)+sliderposn(3)-3 sliderposn(2)+2.5 sliderposn(3)-7 2.5]/100,'horizontalalignment','right');
	gvalh_val = uicontrol(figurename,'callback',[functionname '(''Change Value'')' ';'],'style','edit','string',num2str(get(gvalh_sldr,'value')),...
		'units','normalized','position',[sliderposn(1)+sliderposn(3)/2-1.25 sliderposn(2)+3 3 3]/100);
	gvalhandles = [gvalh_sldr gvalh_min gvalh_max gvalh_val];
elseif strcmp(gvalcommand_str,'Change Value')
	gvaluser_value = str2num(get(gvalh_val,'string'));
	if ~length(gvaluser_value)
		gvaluser_value = (get(gvalh_sldr,'max')+get(gvalh_sldr,'min'))/2;
	end
	gvaluser_value = min([gvaluser_value get(gvalh_sldr,'max')]);
	gvaluser_value = max([gvaluser_value get(gvalh_sldr,'min')]);
	set(gvalh_sldr,'value',gvaluser_value);
	set(gvalh_val,'string',num2str(get(gvalh_sldr,'value')));
elseif strcmp(gvalcommand_str,'Slider Moved')
	set(gvalh_val,'string',num2str(get(gvalh_sldr,'value')));
	eval([variablereturned '=' num2str(get(gvalh_sldr,'value')) '; setappdata(gcf, ''IAVals'', IAVals);']);
	if exist('completeaction')&~isempty(completeaction)
		eval(completeaction);
	end
end
return