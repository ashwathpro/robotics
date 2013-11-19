function rotategui(varargin)
% ROTATEGUI is an interface to the IMROTATE function.  
%
% ROTATEGUI rotates a single image contained in the current
% figure window.
%
% ROTATEGUI('demo') displays 'pout.tif' and opens GUI.
%
% ROTATEGUI(HANDLE) rotates a single image contained in HANDLE.
% HANDLE can be a handle to a figure, axes, or image object.
%
% To retrieve rotated image use the GETIMAGE function on the appropriate
% figure window.
%
% Example:
% I = checkerboard(50);
% imshow(I);
% rotategui % rotate image and push 'OK' then call GETIMAGE
% B = getimage(gcf);
%
% Note that ROTATEGUI only rotates one of the images contained in a figure.
%
% See also IMROTATE

%   Author: Birju Patel
%   Copyright 2006 The MathWorks, Inc. 

% If using on a figure window where images are contained in subplots,
% you'll need to augment code for OK, and Apply callbacks.
 
[im,original_figure] = parseInputs(varargin);
LayoutRotateTool(im);

%% Setup GUI layout
    function LayoutRotateTool(horiginalImage)
        % LayoutRotateTool defines GUI components for the rotatetool. First
        % input argument is handle to the image that will be
        % rotated.

        defaultFigurePos = [400 200 450 350];

        hfig = figure('Visible',     'off',...
            'NumberTitle', 'off',...
            'Name',        'RotateTool Demo',...
            'MenuBar',     'none',...
            'Units',       'Pixels',...
            'Position', defaultFigurePos);
        iptwindowalign(original_figure,'bottom',hfig,'top');
        hpanelImage = uipanel('Parent',hfig,...
            'Units'   ,'Pixels',...
            'Position',[0.3*defaultFigurePos(3) 0.4*defaultFigurePos(4) 0.70*defaultFigurePos(3) 0.6*defaultFigurePos(4)]);

        hpanelAdvanced = uipanel('Parent',hfig,...
            'Units','Pixels',...
            'Position',[.3*defaultFigurePos(3) 0.1*defaultFigurePos(4) .7*defaultFigurePos(3) .3*defaultFigurePos(4)]);

        hpanel = uipanel('Parent'  ,hfig,...
            'Units'   ,'Pixels',...
            'Position',[0 .1*defaultFigurePos(4) .3*defaultFigurePos(3) 0.9*defaultFigurePos(4)]);
        hpanelUIbuttons = uipanel('Parent', hfig,...
            'Units', 'Pixels',...
            'Position',[0 0 defaultFigurePos(3) .1*defaultFigurePos(4)]);

        % Determine resize needed so that preivew image fits in defined
        % area.
        %
        reductionFactor = calcReductionFactor(hpanelImage,horiginalImage);
        previewImage = imresize(get(horiginalImage,'Cdata'),reductionFactor);
        [imWidth,imHeight] = imageSize(previewImage);

        % Center axes containing preview image in the "image" panel so
        % rotation will look like a pin-wheel
        [leftPosition,bottomPosition] = calcPosition(imWidth,imHeight);

        haxesImage = axes('Parent',hpanelImage,...
            'Units','Pixels',...
            'Position',[leftPosition bottomPosition imWidth imHeight],...
            'Ydir','reverse',...
            'XtickLabel',[],...
            'YtickLabel',[],...
            'TickDir', 'out', ...
            'XGrid', 'off', ...
            'YGrid', 'off', ...
            'DataAspectRatio', [1 1 1], ...
            'PlotBoxAspectRatioMode', 'auto',...
            'Visible','off');

        %display image in axes
        himage = displayPreviewImage(previewImage,haxesImage,hfig,horiginalImage);
        improps = struct('angle',0,'interpmethod','nearest','bbox','loose',...
            'originalImage',getimage(original_figure),...
            'flipud',0,'fliplr',0);
        % Advanced rotation control panel (interpolation and image size
        % options)

        hslider = uicontrol(hpanelAdvanced,'Style','Slider',...
            'Units','Normalized',...
            'Position',[.05 .75 .5 .20],...
            'Max',180,...
            'Min',-180,...
            'SliderStep',[1/360 5/360],...
            'BackgroundColor',[.89 .88 .86],...
            'Callback',@slider_Callback);
        uicontrol(hpanelAdvanced,'Style','Text',...
            'String',['180' char(186)],...
            'Units','Normalized',...
            'Position',[.48 .59 .1 .15]);
        uicontrol(hpanelAdvanced,'Style','Text',...
            'String',['-180' char(186)],...
            'Units','Normalized',...
            'Position',[.025 .59 .1 .15]);
        uicontrol(hpanelAdvanced,'Style','Text',...
            'String',['0' char(186)],...
            'Units','Normalized',...
            'Position',[.256 .59 .1 .15]);
        hangletext = uicontrol(hpanelAdvanced,'Style','Edit',...
            'Units','Normalized',...
            'Position',[.65 .75 .25 .2],...
            'BackgroundColor','white',...
            'String','0',...
            'Callback',@editbox_Callback);
        uicontrol(hpanelAdvanced,'Style','text',...
            'String','Output Size:',...
            'Units','Normalized',...
            'HorizontalAlignment','Center',...
            'Position',[.05 .3 .2 .2]);
        hbboxmenu = uicontrol(hpanelAdvanced,'Style','popupmenu',...
            'String',{'Expanded to Fit Rotated Input Image','Same as Input Image'},...
            'Value',1,...
            'Units','Normalized',...
            'Position',[.3 .32 .7 .2],...
            'BackgroundColor','white',...
            'Callback',@bboxmenu_Callback);
        bboxlist = {'loose','crop'};

        uicontrol(hpanelAdvanced,'Style','text',...
            'String','Interpolation:',...
            'Units','Normalized',...
            'HorizontalAlignment','Center',...
            'Position',[.05 .02 .2 .2]);
        hinterpmenu = uicontrol(hpanelAdvanced,'Style','popupmenu',...
            'String',{'Nearest-neighbor','Bilinear','Bicubic'},...
            'Value',1,...
            'Units','Normalized',...
            'Position',[.3 .05 .4 .2],...
            'Tag','nearest',...
            'BackgroundColor','white',...
            'Callback',@interpmenu_Callback);

        interplist = {'nearest','bilinear','bicubic'};

        % Basic rotation control panel (cw ccw fliplr flipup operations)

        btnPanelPos = get(hpanel,'Position');

        % Positive rotation is assumed to be in the clockwise direction.
        hbutton_cw = uicontrol(hpanel, ...
            'Style'   ,'Pushbutton',...
            'Units'   ,'Pixels',...
            'Position', [5 btnPanelPos(4)-30 btnPanelPos(3)-10 20],...
            'String', ['Clockwise 90' char(186)],...
            'Callback',{@rotatebutton_Callback,90});
        %assuming cw rotation is positive

        hbutton_ccw = uicontrol(hpanel, ...
            'Style'   ,'Pushbutton',...
            'Units'   ,'Pixels',...
            'Position', [5 btnPanelPos(4)-60 btnPanelPos(3)-10 20],...
            'String', ['Counterclockwise 90' char(186)],...
            'Callback',{@rotatebutton_Callback,-90});
        %assuming cw rotation is positive

        hbutton_fliplr = uicontrol(hpanel, ...
            'Style'   ,'Pushbutton',...
            'Units'   ,'Pixels',...
            'Position', [5 btnPanelPos(4)-90 btnPanelPos(3)-10 20],...
            'String', 'Flip Left/Right',...
            'Callback',{@flipbutton_Callback,@fliplr});
        hbutton_flipud = uicontrol(hpanel, ...
            'Style'   ,'Pushbutton',...
            'Units'   ,'Pixels',...
            'Position', [5 btnPanelPos(4)-120 btnPanelPos(3)-10 20],...
            'String', 'Flip Up/Down',...
            'Callback',{@flipbutton_Callback,@flipud});

        hok = uicontrol(hpanelUIbuttons,...
            'Style','PushButton',...
            'Units','Normalized',...
            'Position',[.5 .05 .15 .90],...
            'String','OK',...
            'Callback',@ok_Callback);
        hcancel = uicontrol(hpanelUIbuttons,...
            'Style','PushButton',...
            'Units','Normalized',...
            'Position',[.67 .05 .15 .90],...
            'String','Cancel',...
            'Callback',@cancel_Callback);
        happly = uicontrol(hpanelUIbuttons,...
            'Style','PushButton',...
            'Units','Normalized',...
            'Position',[.84 .05 .15 .90],...
            'String','Apply',...
            'Callback',@apply_Callback);

        set(hfig,'Visible','On');
        %% GUI callbacks
        %=============================================
        function ok_Callback(handle,eventdata,varargin)
            updateOriginalImage(himage);
            delete(hfig);
        end % of ok_Callback

        %==================================================
        function cancel_Callback(handle,eventdata,varargin)
            set(0,'CurrentFigure',original_figure);
            imshow(improps.originalImage);
            delete(hfig);
        end % of cancel_Callback

        %================================================
        function apply_Callback(handle,eventdata,varargin)
            updateOriginalImage(himage);
        end % of apply_Callback

        %=====================================================
        function flipbutton_Callback(handle,eventdata,varargin)
            fcnhandle = varargin{1};
            Cdata = getimage(himage);
            newCdata = flipimage(Cdata,fcnhandle);
            set(himage,'Cdata',newCdata);
            %update the preview image data
            previewImage = flipimage(previewImage,fcnhandle);
            updateImage(improps.angle);
            if isequal(fcnhandle,@fliplr)
                improps.fliplr = ~(improps.fliplr);
            end
            if isequal(fcnhandle,@flipud)
                improps.flipud = ~(improps.flipud);
            end
        end % of flipbutton Callback

        %========================================================
        function rotatebutton_Callback(handle,eventdata,varargin)
            % When the rotation button is pushed repeatedly, the rotation
            % applied to the image is cumulative.  Pushing the cw button n
            % times will rotate preview image 90*n degrees.
            updateAngleInfo(varargin{1});
            updateImage(improps.angle);
        end % of rotatebutton_Callback

        %=========================================
        function slider_Callback(handle,eventdata)
            % Affordance for manual rotation. User can drag slider to
            % rotate preview image in small increments. The slider
            % boundaries are [-180, 180].  Text box next to slider will
            % show values within this range.
            slider_value = get(handle,'Value');
            updateImage(slider_value);
            set(hangletext,'String',num2str(slider_value));

        end % of slider_Callback

        %=========================================
        function editbox_Callback(handle,eventdata)
            % User can enter in a single scalar number (rotation angle in
            % degrees) and image will be rotated by that amount.  If the
            % input angle is out of the [-180,180] range, the value will be
            % wrapped into this range using the checkAngle function.
            textvalue = str2double(get(hangletext,'String'));
            % Expression not allowe in text field.
            if (~isempty(textvalue) && ~isnan(textvalue) && isreal(textvalue))
                textvalue = checkAngle(textvalue);
                updateImage(textvalue);
                set(hslider,'Value',textvalue);
                set(hangletext,'String',num2str(textvalue));
            else
                errordlg('Text field must contain a single scalar value.')
            end

        end % of editbox_Callback

        %============================================
        function interpmenu_Callback(handle,eventdata)
            % changes to interp method won't be noticeable in preview image so
            % the preview image will always use nearest interp. But we need
            % to record the selected option in case the user exits without
            % further rotations to image
            improps.interpmethod = interplist{get(hinterpmenu,'Value')};
        end % of interpmenu_Callback

        %===========================================
        function bboxmenu_Callback(handle,eventdata)
            % changes bounding box option for IMROTATE
            updateImage(improps.angle);
        end % of bboxmenu_Callback
        %% Rotate functions
        %=======================================================
        function [reduction] = calcReductionFactor(hpanel,horiimage)
            % calcReductionFactor determines how to scale original image so
            % that it fits in the defined preview area.

            imPanelPos = get(hpanel,'Position');
            %Constraining dimension in image panel
            panelImageConstr = min(imPanelPos(3),imPanelPos(4));
            [oriImageWidth,oriImageHeight] = imageSize(get(horiimage,'Cdata'));
            %Length of Image diagonal in pixels
            dImage = ceil(sqrt(oriImageHeight^2 + oriImageWidth^2)) + 15;
            % +15 added to allow for some panel border effects
            reduction = (panelImageConstr/dImage);
        end

        %==============================================
        function [leftpos,bottompos] = calcPosition(w,h)
            %calculate position values to center axes(image) in preview
            %area. Rotation will look like a pin wheel.
            PanelPos = get(hpanelImage,'Position');
            leftpos   = (PanelPos(3) - w)/2;
            bottompos = (PanelPos(4) - h)/2;
        end

        %=============================
        function updateAngleInfo(angle)
            % used for the +/- 90 rotation callbacks, which rotate current
            % preview image in increments of +/- 90 degrees
            updatedAngle = checkAngle(angle + improps.angle);
            improps.angle = updatedAngle;
            set(hangletext,'String',num2str(updatedAngle));
            set(hslider,'Value',updatedAngle);
        end

        %=======================================
        function updatedAngle = checkAngle(angle)
            % used to wrap rotation angle between +/- 180
            updatedAngle = angle;
            if ~(abs(angle) <= 180) % wrap angle if necessary
                r = rem(angle,360);
                if (abs(r) <= 180)
                    updatedAngle = r;
                else
                    updatedAngle = r-sign(r)*360;
                end
            end
        end

        %=========================
        function updateImage(angle)
            % updateImage performs the rotates preview image
            interpmethod = 'nearest'; %changes to the interp method will
            % not be noticeable in the preview image.
            outsize = bboxlist{get(hbboxmenu,'Value')};
            %assuming cw rotation is positive (need to use -angle because
            %IMROTATE assumes cw rotation is negative)
            rotCdata = imrotate(previewImage,-angle,interpmethod,outsize);
            [w,h] = imageSize(rotCdata);
            [left,bottom] = calcPosition(w,h);
            set(haxesImage, ...
                'Xlim',[1 w],...
                'Ylim',[1 h],...
                'Position',[left bottom w h],...
                'Visible','off');
            set(himage,'Cdata',rotCdata)
            %Store rotation specific information needed to rotate the
            %original image after the rotate GUI is closed or the user hits
            %apply.

            improps.angle = angle;
            improps.interpmethod = interplist{get(hinterpmenu,'Value')};
            improps.bbox = outsize;
        end % of updateImage
        
        %====================================
        function updateOriginalImage(him)
            A = improps.originalImage;
            if improps.fliplr
                A = flipimage(A,@fliplr);
            end
            if improps.flipud
                A = flipimage(A,@flipud);
            end
            B = imrotate(A,-improps.angle,improps.interpmethod,improps.bbox);
            set(0,'CurrentFigure',original_figure);
            imshow(B);
        end % of updateOriginalImage
    end % of LayoutRotateTool
%% GUI helper functions
%==============================================================
    function [hout] = displayPreviewImage(newCdata,haxes,fig_handle,horigimage)
        % Create a preview image from original image.

        clim = get(get(horigimage,'Parent'),'Clim');
        cdatamapping = get(horigimage,'CdataMapping');
        map = get(original_figure,'Colormap');

        [w,h] = imageSize(newCdata);
        xdata = [1 w];
        ydata = [1 h];

        hout = image(xdata,ydata,newCdata, ...
            'BusyAction', 'cancel', ...
            'CDataMapping', cdatamapping, ...
            'Parent', haxes, ...
            'Interruptible', 'off');

        % Set axes and figure properties if necessary to display the
        % image object correctly.
        axesPosition = get(haxes,'Position');
        set(haxes, ...
            'Xlim',[1 w],...
            'Ylim',[1 h],...
            'Position',[axesPosition(1:2) w h],...
            'Visible','off');

        if (~isempty(map))
            set(fig_handle, 'Colormap', map);
        end

        if (~isempty(clim))
            set(haxes, 'CLim', clim);
        end

        isIndexedUint16Image = strcmpi(get(hout,'CDataMapping'),'direct') && size(map,1) > 256;

        if isIndexedUint16Image && ispc
            set(fig_handle,'Renderer','Zbuffer');
        end
    end % of previewImageDisplay

%================================
    function [w,h] = imageSize(im)
        h = size(im,1);
        w = size(im,2);
    end

%======================================
    function B = flipimage(A,fcnhandle)
        B = zeros(size(A));
        if ndims(A) > 2
            for i = 1:ndims(A)
                B(:,:,i) = fcnhandle(A(:,:,i));
            end
        else
            B = fcnhandle(A);
        end
    end % of flipimage
%==================================================
    function [im,original_figure] = parseInputs(in)
        if isempty(in)
            % look for the image in the current figure.
            original_figure = get(0,'CurrentFigure');
            if isempty(original_figure)
                msg = sprintf('%s expects at least one figure window containing an image.',...
                    upper(mfilename));
                error(msg)
            end
        elseif (ischar(in{1}) && strcmpi(in{1},'demo'))
            imshow('pout.tif')
            original_figure = gcf;
        elseif (ishandle(in{1}))
            original_figure = ancestor(in{1},'figure');
            if isempty(original_figure)
                msg = sprintf('Invalid Handle');
                error(msg)
            end
        else
            msg = sprintf('Invalid input');
            error(msg)
        end
        imh = imhandles(original_figure);
        if isempty(imh)
            msg = sprintf('%s expects the figure to contain at least one image.',...
                upper(mfilename));
            error(msg)
        elseif numel(imh) > 1
            warning('Multiple images detected in figure, using first image.')
        end
        im = imh(1);
    end % of parseInputs
end % of rotategui


