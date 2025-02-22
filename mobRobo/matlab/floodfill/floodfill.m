function floodfill(varargin)
% FLOODFILL Fill image regions OR do color segmentation with a mouse click
%
% USAGE:
%   FLOODFILL(HANDLE) operates in the single image contained in HANDLE.
%   HANDLE can be a handle to a figure, axes, or image object.
%   Mouse left-clicks select the connected groups of pixels, a right-click stops selection
%
%   In the top GUI part the user selects to do a flood-fill operation. The filling
%   color may be set to a constant value or to change randomly between mouse clicks.
%   Two pushbuttons exists: "Paint once" & "Paint multiple"
%   Like their titles says the firts change the color of a single selected shape
%   and the second do that for each mouse click.
%
%   The bottom part is used to do color segmentation. Here, instead of repainting
%   a certain colored shape, this shape is isolated and diplayed in a separate
%   figure. The "Pick single shape" & "Pick multiple shapes" buttons control whether
%   only the hited shape is extracted, or all shapes that share the same color.
%   Be aware that this two options do not work exactly the same way. Within the "multiple"
%   choice the seed pixel color is not directly the "hit pixel" but the mean color inside
%   the region returned by the "single shape" option.
%   
%   Specifying connectivity:
%   By default, FLOODFILL uses 4-connected neighbors but you can select
%   8-connected in the apropriate radio buttons
%
%   Specifying tolerance:
%   The "Tolerance" slider selects the maximal lower/higher brightness/color difference
%   between the currently hited pixel and its neighbors. Pixels within the -> hit pixel +- |tolerance|
%   are considered to belong to the repainted domain.
%
%   The "Use dilation" option perform the morphological dilation operation on the mask
%   array returned by the floo-dfill operation. This leads to smoother shapes borders
%   and better identifications on the borders.
%
%   When the Image Processing TBX is detected, very small shapes are rejected.
%
%   NOTE1: FLOODFILL is an GUI interface to the floodfill function in the
%   CVLIB_MEX library, so you must have it installed to run this function
%
%   NOTE2: Although FLOODFILL works with both indexed and truecolor RGB images
%   the results are more trustfull in the second case (I think).
%
% EXAMPLES:
%   img = imread('j.jpg')
%   h = image(img);
%   Now click as you will   

%   AUTHOR
%       Joaquim Luis  - 19-October-2006
%       jluis@ualg.pt - Universidade do Algarve
%
%       M-File changed by desGUIDE and manualy edited after 
 
hObject = figure('Tag','figure1','Visible','off');
handles = guihandles(hObject);
guidata(hObject, handles);
floodfill_LayoutFcn(hObject,handles);
handles = guihandles(hObject);

if (~isempty(varargin))
    handles.hCallingFig = varargin{1};
else
    handles.hCallingFig = gcf;
end

if ((numel(handles.hCallingFig) ~= 1) || ~ishandle(handles.hCallingFig))
    errordlg('Error, first argument is not single valid figure/axes/image handle','ERROR');
    delete(hObject);    return
end

if ( strcmp(get(handles.hCallingFig,'type'),'axes') || strcmp(get(handles.hCallingFig,'type'),'figure'))
    handles.hImage = findobj(handles.hCallingFig,'type','image');
elseif ( strcmp(get(handles.hCallingFig,'type'),'image') )
    handles.hImage = handles.hCallingFig;
end

if (isempty(handles.hImage))
    errordlg('Error, no image found','ERROR');
    delete(hObject);    return
end

% Ok now we will fish the tue fig handle (before it could have been an img handle for example)
handles.hCallingFig = get(get(handles.hImage,'Parent'),'Parent');


% Try to position this figure glued to the right of calling figure
posThis = get(hObject,'Pos');
posParent = get(handles.hCallingFig,'Pos');
ecran = get(0,'ScreenSize');
xLL = posParent(1) + posParent(3) + 6;
xLR = xLL + posThis(3);
if (xLR > ecran(3))         % If figure is partially out, bring totally into screen
    xLL = ecran(3) - posThis(3);
end
yLL = (posParent(2) + posParent(4)/2) - posThis(4) / 2;
set(hObject,'Pos',[xLL yLL posThis(3:4)])

handles.hImage = findobj(handles.hCallingFig,'Type','image');
img = get(handles.hImage,'CData');
handles.origFig = img;        % Make a copy of the original image

% Initialize some vars
handles.connect = 4;
handles.tol = 20;
handles.randColor = 1;
handles.fillColor = [];
handles.useDilation = 1;            % Dilate mask before using it in picking shapes
handles.bg_color = 0;               % Background color (or color number in cmap) 
set(handles.slider_tolerance,'Value',handles.tol)

% Check if Image Processing toolbox is available
try
    zz = rgb2gray([1 .1 .5]);
    handles.haveIPtbx = true;
catch
    handles.haveIPtbx = false;
end

handles.output = hObject;
guidata(hObject, handles);
set(hObject,'Visible','on');

% -------------------------------------------------------------------------------------
function slider_tolerance_Callback(hObject, eventdata, handles)
    handles.tol = round(get(hObject,'Value'));
    set(handles.text_tol,'String',['Tolerance = ' num2str(handles.tol)])
    guidata(handles.figure1,handles)
    
% -------------------------------------------------------------------------------------
function pushbutton_repaintSingle_Callback(hObject, eventdata, handles)
    [params,but] = prepareParams(handles, 1);
    if (isempty(params) || but ~= 1),   return;     end
    img = get(handles.hImage,'CData');
    if (ndims(img) == 2)            % Here we have to permanently change the image type to RGB
        img = uint8(ind2rgb(img,get(handles.hCallingFig,'ColorMap'))*255);
        handles.origFig = img;      % Update the copy of the original image
        guidata(handles.figure1,handles)
    end
    img = cvlib_mex('floodfill',img,params);
    set(handles.hImage,'CData', img);

% -------------------------------------------------------------------------------------
function pushbutton_repaintMultiple_Callback(hObject, eventdata, handles)
    [params,but] = prepareParams(handles, 1);
    if (isempty(params) || but ~= 1),   return;     end
    while (but == 1)
        img = get(handles.hImage,'CData');
        if (ndims(img) == 2)            % Here we have to permanently change the image type to RGB
            img = uint8(ind2rgb(img,get(handles.hCallingFig,'ColorMap'))*255);
            handles.origFig = img;      % Update the copy of the original image
            guidata(handles.figure1,handles)
        end
        img = cvlib_mex('floodfill',img,params);
        set(handles.hImage,'CData', img); 
        [x,y,but] = ginput(1);          % Get next point
        params.Point = [x y];
    end

% -------------------------------------------------------------------------------------
function [params,but] = prepareParams(handles, opt)
% Prepare the params structure that is to be transmited to cvlib_mex (gets also the point)
% OPT is optional and ment to be used (its enough if ~= []) when painting with Cte color
% BUT returns which button has been pressed.
    if (nargin == 1),   opt = [];   end
    if (~handles.randColor && ~isempty(opt))        % That is, Cte color
        if (~isempty(handles.fillColor))
            params.FillColor = handles.fillColor;
        else
            errordlg('I don''t have yet a filling color. You must select one first.','Error')
            params = [];
            return
        end
    end
    figure(handles.hCallingFig)         % Bring the figure containing image forward
    but = 1;                            % Initialize to a left click
    [x,y,but]  = ginput(1);
    params.Point = [x y];
    params.Tolerance = handles.tol;
    params.Connect = handles.connect;

% -------------------------------------------------------------------------------------
function radio_randColor_Callback(hObject, eventdata, handles)
    if (~get(hObject,'Value')),      set(hObject,'Value',1);   return;     end
    set(handles.radio_cteColor,'Value',0)
    handles.randColor = 1;
    set(findobj(handles.figure1,'Style','toggle'),'Enable','Inactive')
    set(handles.pushbutton_moreColors,'Enable','Inactive')
    set(handles.toggle_currColor,'BackgroundColor','w')
    guidata(handles.figure1,handles)

% -------------------------------------------------------------------------------------
function radio_cteColor_Callback(hObject, eventdata, handles)
    if (~get(hObject,'Value')),      set(hObject,'Value',1);   return;     end
    set(handles.radio_randColor,'Value',0)
    handles.randColor = 0;
    set(findobj(handles.figure1,'Style','toggle'),'Enable','on');
    set(handles.pushbutton_moreColors,'Enable','on')
    guidata(handles.figure1,handles)

% -------------------------------------------------------------------------------------
function radio_fourConn_Callback(hObject, eventdata, handles)
    if (~get(hObject,'Value')),      set(hObject,'Value',1);   return;     end
    set(handles.radio_eightConn,'Value',0)
    handles.connect = 4;
    guidata(handles.figure1,handles)

% -------------------------------------------------------------------------------------
function radio_eightConn_Callback(hObject, eventdata, handles)
    if (~get(hObject,'Value')),      set(hObject,'Value',1);   return;     end
    set(handles.radio_fourConn,'Value',0)
    handles.connect = 8;
    guidata(handles.figure1,handles)

% -------------------------------------------------------------------------------------
function toggle00_Callback(hObject, eventdata, handles)
    % All color toggle end up here
    toggleColors(hObject,handles)

% -------------------------------------------------------------------------------------
function toggleColors(hCurr,handles)
% hCurr is the handle of the current slected toggle color. Get its color
% and assign it to toggle_currColor.
    set(hCurr,'Value',1);               % Reset it to pressed state
    set(handles.toggle_currColor,'BackgroundColor',get(hCurr,'BackgroundColor'))
    handles.fillColor = round(get(hCurr,'BackgroundColor')*255);
    guidata(handles.figure1,handles)

% -------------------------------------------------------------------------------------
function pushbutton_moreColors_Callback(hObject, eventdata, handles)
    c = uisetcolor;
    if (length(c) > 1)          % That is, if a color was selected
        handles.fillColor = round(c*255);
        set(handles.toggle_currColor,'BackgroundColor',c)
        guidata(handles.figure1,handles)
    end

% -------------------------------------------------------------------------------------
function pushbutton_pickSingle_Callback(hObject, eventdata, handles)
    [params,but] = prepareParams(handles, []);
    if (isempty(params) || but ~= 1),   return;     end
    img = get(handles.hImage,'CData');              % Get the image
    [dumb,mask] = cvlib_mex('floodfill',img,params);
    if (get(handles.checkbox_useDilation,'Value'))
        if (handles.haveIPtbx)
            mask  = bwmorph(mask,'dilate');       % I think this is more efficient than OCV
        else
            mask  = cvlib_mex('dilate',mask);
        end
    end
    if (ndims(img) == 3)
        mask = repmat(mask,[1 1 3]);
    end
    img(~mask) = handles.bg_color;
    h = figure;     image(img);
    if (ndims(img) == 2)
        set(h,'ColorMap',get(handles.hCallingFig,'ColorMap'),'Name','Color segmentation')
    end
    
% -------------------------------------------------------------------------------------
function pushbutton_pickMultiple_Callback(hObject, eventdata, handles)

    [params,but] = prepareParams(handles, 1);
    if (isempty(params) || but ~= 1),   return;     end
    img = get(handles.hImage,'CData');              % Get the image
    nColors = 0;
    mask = false([size(img,1) size(img,2)]);        % Initialize the mask
    while (but == 1)
        nColors = nColors + 1;
        [dumb,mask(:,:,nColors)] = cvlib_mex('floodfill',img,params);
        [x,y,but] = ginput(1);                      % Get next point
        params.Point = [x y];
    end
            
    if (ndims(img) == 3)            % RGB image
        a = img(:,:,1);
        b = img(:,:,2);
        c = img(:,:,3);
        cm = zeros(nColors, 6);
        for count = 1:nColors
            cm(count,1) = mean2(a(mask(:,:,count)));
            cm(count,1:2) = [max(cm(count,1) - handles.tol, 0) min(cm(count,1) + handles.tol, 255)];
            cm(count,3) = mean2(b(mask(:,:,count)));
            cm(count,3:4) = [max(cm(count,3) - handles.tol, 0) min(cm(count,3) + handles.tol, 255)];
            cm(count,5) = mean2(c(mask(:,:,count)));
            cm(count,5:6) = [max(cm(count,5) - handles.tol, 0) min(cm(count,5) + handles.tol, 255)];
            tmp = (a >= cm(count,1) & a <= cm(count,2) & b >= cm(count,3) & b <= cm(count,4) & ...
                c >= cm(count,5) & c <= cm(count,6));
            if (handles.haveIPtbx)
                tmp  = bwmorph(tmp,'clean');      % Get rid of isolated pixels
            end
            if (get(handles.checkbox_useDilation,'Value'))
                if (handles.haveIPtbx)
                    tmp  = bwmorph(tmp,'dilate');       % I think this is more efficient than OCV
                else
                    tmp  = cvlib_mex('dilate',tmp);
                end
            end
            tmp = repmat(tmp,[1 1 3]);
            img(~tmp) = handles.bg_color;
   	        figure;     image(img);
        end
    else                        % That is, indexed image
        cm = zeros(nColors, 2);
        for count = 1:nColors
            cm(count,1) = mean2(img(mask(:,:,count)));
            cm(count,1:2) = [max(cm(count,1) - handles.tol, 0) min(cm(count,1) + handles.tol, 255)];
            tmp = (img >= cm(count,1) & img <= cm(count,2));
            if (handles.haveIPtbx)
                tmp  = bwmorph(tmp,'clean');        % Get rid of isolated pixels
            end
            if (get(handles.checkbox_useDilation,'Value'))
                if (handles.haveIPtbx)
                    tmp  = bwmorph(tmp,'dilate');    % I think this is more efficient than OCV
                else
                    tmp  = cvlib_mex('dilate',tmp);
                end
            end
            img(~tmp) = handles.bg_color;
  	        h = figure;     image(img);
            set(h,'ColorMap',get(handles.hCallingFig,'ColorMap'),'Name','Color segmentation')
        end
    end

% -------------------------------------------------------------------------------------
function push_restoreImg_Callback(hObject, eventdata, handles)
    set(handles.hImage,'CData',handles.origFig)

% -------------------------------------------------------------------------------------
function y = mean2(x)
%MEAN2 Compute mean of matrix elements.
y = sum(x(:)) / numel(x);

% -------------------------------------------------------------------------------------
function checkbox_useDilation_Callback(hObject, eventdata, handles)
% It does nothing

% --- Creates and returns a handle to the GUI figure. 
function floodfill_LayoutFcn(h1,handles)

set(h1,...
'PaperUnits',get(0,'defaultfigurePaperUnits'),...
'Color',get(0,'factoryUicontrolBackgroundColor'),...
'MenuBar','none',...
'Name','Flood Fill',...
'NumberTitle','off',...
'PaperSize',[20.98404194812 29.67743169791],...
'Position',[520 434 185 351],...
'RendererMode','manual',...
'Resize','off',...
'HandleVisibility','callback',...
'Tag','figure1');

uicontrol('Parent',h1,...
'Position',[4 33 177 70],...
'Style','frame','Tag','frame2');

uicontrol('Parent',h1,...
'Position',[4 178 176 165],...
'Style','frame','Tag','frame1');

uicontrol('Parent',h1,...
'BackgroundColor',[1 1 1],...
'Callback',{@floodfill_uicallback,h1,'slider_tolerance_Callback'},...
'Max',255,...
'Position',[4 137 176 16],...
'Style','slider',...
'SliderStep',[0.00390625 0.1],...
'TooltipString','Color detection equal pixel color +/- tolerance',...
'Tag','slider_tolerance');

uicontrol('Parent',h1,...
'Callback',{@floodfill_uicallback,h1,'pushbutton_pickSingle_Callback'},...
'Position',[12 71 160 23],...
'String','Pick single shape',...
'TooltipString','Pick up the body''s shape with the selected color',...
'Tag','pushbutton_pickSingle');

uicontrol('Parent',h1,...
'Callback',{@floodfill_uicallback,h1,'pushbutton_repaintSingle_Callback'},...
'Position',[12 214 160 23],...
'String','Paint once',...
'TooltipString','Repaint single body',...
'Tag','pushbutton_repaintSingle');

uicontrol('Parent',h1,...
'Callback',{@floodfill_uicallback,h1,'radio_fourConn_Callback'},...
'Position',[12 258 90 15],...
'String','4 connectivity',...
'Style','radiobutton',...
'Value',1,...
'Tag','radio_fourConn');

uicontrol('Parent',h1,...
'Callback',{@floodfill_uicallback,h1,'radio_eightConn_Callback'},...
'Position',[12 242 90 15],...
'String','8 connectivity',...
'Style','radiobutton',...
'Tag','radio_eightConn');

uicontrol('Parent',h1,...
'BackgroundColor',[1 0.501960784313725 0.501960784313725],...
'Callback',{@floodfill_uicallback,h1,'toggle00_Callback'},...
'Enable','inactive',...
'Position',[13 296 15 15],...
'Style','togglebutton',...
'Value',1,...
'Tag','toggle11');

uicontrol('Parent',h1,...
'BackgroundColor',[1 0 0],...
'Callback',{@floodfill_uicallback,h1,'toggle00_Callback'},...
'Enable','inactive',...
'Position',[29 296 15 15],...
'Style','togglebutton',...
'Value',1,...
'Tag','toggle12');

uicontrol('Parent',h1,...
'BackgroundColor',[0.501960784313725 0.250980392156863 0.250980392156863],...
'Callback',{@floodfill_uicallback,h1,'toggle00_Callback'},...
'Enable','inactive',...
'Position',[45 296 15 15],...
'Style','togglebutton',...
'Value',1,...
'Tag','toggle13');

uicontrol('Parent',h1,...
'BackgroundColor',[0.250980392156863 0 0],...
'Callback',{@floodfill_uicallback,h1,'toggle00_Callback'},...
'Enable','inactive',...
'Position',[61 296 15 15],...
'Style','togglebutton',...
'Value',1,...
'Tag','toggle14');

uicontrol('Parent',h1,...
'BackgroundColor',[1 1 0.501960784313725],...
'Callback',{@floodfill_uicallback,h1,'toggle00_Callback'},...
'Enable','inactive',...
'Position',[77 296 15 15],...
'Style','togglebutton',...
'Value',1,...
'Tag','toggle15');

uicontrol('Parent',h1,...
'BackgroundColor',[1 0.501960784313725 0],...
'Callback',{@floodfill_uicallback,h1,'toggle00_Callback'},...
'Enable','inactive',...
'Position',[93 296 15 15],...
'Style','togglebutton',...
'Value',1,...
'Tag','toggle16');

uicontrol('Parent',h1,...
'BackgroundColor',[0.501960784313725 0.501960784313725 0],...
'Callback',{@floodfill_uicallback,h1,'toggle00_Callback'},...
'Enable','inactive',...
'Position',[109 296 15 15],...
'Style','togglebutton',...
'Value',1,...
'Tag','toggle17');

uicontrol('Parent',h1,...
'BackgroundColor',[0 1 0],...
'Callback',{@floodfill_uicallback,h1,'toggle00_Callback'},...
'Enable','inactive',...
'Position',[125 296 15 15],...
'Style','togglebutton',...
'Value',1,...
'Tag','toggle18');

uicontrol('Parent',h1,...
'BackgroundColor',[0 0.501960784313725 0],...
'Callback',{@floodfill_uicallback,h1,'toggle00_Callback'},...
'Enable','inactive',...
'Position',[13 280 15 15],...
'Style','togglebutton',...
'Value',1,...
'Tag','toggle21');

uicontrol('Parent',h1,...
'BackgroundColor',[0 0.501960784313725 0.501960784313725],...
'Callback',{@floodfill_uicallback,h1,'toggle00_Callback'},...
'Enable','inactive',...
'Position',[29 280 15 15],...
'Style','togglebutton',...
'Value',1,...
'Tag','toggle22');

uicontrol('Parent',h1,...
'BackgroundColor',[0.501960784313725 0.501960784313725 0.501960784313725],...
'Callback',{@floodfill_uicallback,h1,'toggle00_Callback'},...
'Enable','inactive',...
'Position',[45 280 15 15],...
'Style','togglebutton',...
'Value',1,...
'Tag','toggle23');

uicontrol('Parent',h1,...
'BackgroundColor',[0 0 1],...
'Callback',{@floodfill_uicallback,h1,'toggle00_Callback'},...
'Enable','inactive',...
'Position',[61 280 15 15],...
'Style','togglebutton',...
'Value',1,...
'Tag','toggle24');

uicontrol('Parent',h1,...
'BackgroundColor',[0 1 1],...
'Callback',{@floodfill_uicallback,h1,'toggle00_Callback'},...
'Enable','inactive',...
'Position',[77 280 15 15],...
'Style','togglebutton',...
'Value',1,...
'Tag','toggle25');

uicontrol('Parent',h1,...
'BackgroundColor',[1 0.501960784313725 0.752941176470588],...
'Callback',{@floodfill_uicallback,h1,'toggle00_Callback'},...
'Enable','inactive',...
'Position',[93 280 15 15],...
'Style','togglebutton',...
'Value',1,...
'Tag','toggle26');

uicontrol('Parent',h1,...
'BackgroundColor',[0.250980392156863 0 0.501960784313725],...
'Callback',{@floodfill_uicallback,h1,'toggle00_Callback'},...
'Enable','inactive',...
'Position',[109 280 15 15],...
'Style','togglebutton',...
'Value',1,...
'Tag','toggle27');

uicontrol('Parent',h1,...
'BackgroundColor',[1 1 1],...
'Callback',{@floodfill_uicallback,h1,'toggle00_Callback'},...
'Enable','inactive',...
'Position',[125 280 15 15],...
'Style','togglebutton',...
'Value',1,...
'Tag','toggle28');

uicontrol('Parent',h1,...
'FontSize',9,...
'Position',[54 335 60 15],...
'String','Flood fill',...
'Style','text',...
'Tag','text1');

uicontrol('Parent',h1,...
'Callback',{@floodfill_uicallback,h1,'radio_randColor_Callback'},...
'Position',[12 319 90 15],...
'String','Random colors',...
'Style','radiobutton',...
'TooltipString','Repainting will use a randomly selected color',...
'Value',1,...
'Tag','radio_randColor');

uicontrol('Parent',h1,...
'Callback',{@floodfill_uicallback,h1,'radio_cteColor_Callback'},...
'Position',[115 319 61 15],...
'String','Cte color',...
'Style','radiobutton',...
'TooltipString','Repainting will use a selected color',...
'Tag','radio_cteColor');

uicontrol('Parent',h1,...
'Callback',{@floodfill_uicallback,h1,'pushbutton_moreColors_Callback'},...
'Enable','inactive',...
'Position',[143 294 30 19],...
'String','More',...
'TooltipString','Chose other color',...
'Tag','pushbutton_moreColors');

uicontrol('Parent',h1,...
'BackgroundColor',[1 1 1],...
'Enable','inactive',...
'Position',[145 280 25 15],...
'Style','togglebutton',...
'TooltipString','Current selected color',...
'Value',1,...
'HandleVisibility','off',...
'Tag','toggle_currColor');

uicontrol('Parent',h1,...
'Callback',{@floodfill_uicallback,h1,'pushbutton_repaintMultiple_Callback'},...
'Position',[12 186 160 23],...
'String','Paint multiple',...
'TooltipString','Each mouse click will repaint the hit shape',...
'Tag','pushbutton_repaintMultiple');

uicontrol('Parent',h1,...
'Callback',{@floodfill_uicallback,h1,'pushbutton_pickMultiple_Callback'},...
'Position',[12 42 160 23],...
'String','Pick multiple shapes',...
'TooltipString','Find out all bounding polygons that share the selected color',...
'Tag','pushbutton_pickMultiple');

uicontrol('Parent',h1,...
'HorizontalAlignment','left',...
'Position',[57 153 90 15],...
'String','Tolerance = 20',...
'Style','text',...
'Tag','text_tol');

uicontrol('Parent',h1,...
'Callback',{@floodfill_uicallback,h1,'push_restoreImg_Callback'},...
'Position',[37 4 111 23],...
'String','Restore image',...
'Tag','push_restoreImg');

uicontrol('Parent',h1,...
'Callback',{@floodfill_uicallback,h1,'checkbox_useDilation_Callback'},...
'Position',[4 117 80 15],...
'String','Use Dilation',...
'Style','checkbox',...
'TooltipString','Use dilation operation to find better limits between neighboring shapes',...
'Value',1,...
'Tag','checkbox_useDilation');

uicontrol('Parent',h1,...
'FontSize',9,...
'Position',[36 95 116 16],...
'String','Color segmentation',...
'Style','text',...
'Tag','text4');

function floodfill_uicallback(hObject, eventdata, h1, callback_name)
% This function is executed by the callback and than the handles is allways updated.
feval(callback_name,hObject,[],guidata(h1));
