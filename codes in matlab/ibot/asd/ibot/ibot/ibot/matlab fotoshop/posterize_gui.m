function varargout = posterize_gui(varargin)

%========================= INTIALISATION ===================================
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @posterize_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @posterize_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})    gui_State.gui_Callback = str2func(varargin{1});
end
if nargout    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else          gui_mainfcn(gui_State, varargin{:});
end
%==========================================================================
%=====================  GUI OPENING FUNCTION ==============================
function posterize_gui_OpeningFcn(hObject, eventdata, handles, varargin)
set(handles.slider1,'Value',cell2mat(varargin(2)));
set(handles.edit1,'String',round(cell2mat(varargin(2))));
set(handles.slider2,'Value',cell2mat(varargin(3)));
set(handles.edit2,'String',round(cell2mat(varargin(3))));
set(handles.slider3,'Value',cell2mat(varargin(4)));
set(handles.edit3,'String',round(cell2mat(varargin(4))));
set(handles.preview,'Value',cell2mat(varargin(5)));
handles.output =varargin;
guidata(hObject, handles);
%==========================================================================
%======================== SLIDER 1 ========================================
function slider1_CreateFcn(hObject, eventdata, handles)
usewhitebg = 1;
if usewhitebg    set(hObject,'BackgroundColor',[.9 .9 .9]);
else             set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
function slider1_Callback(hObject, eventdata, handles)
uiresume
set(handles.posterize_figure,'Pointer','watch');
set(handles.edit1,'String',int2str(get(hObject,'Value')));
pause(0.001); %=>for the change to show up in gui.
red_value=get(handles.slider1,'Value');
green_value=get(handles.slider2,'Value');
blue_value=get(handles.slider3,'Value');
output_image=posterize_rgb( cell2mat(handles.output(1)), [red_value green_value blue_value] );
set(handles.ok,'UserData',output_image);
%==========================================================================
%=========================== EDIT 1 =======================================
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc    set(hObject,'BackgroundColor','white');
else       set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
function edit1_Callback(hObject, eventdata, handles)
uiresume
set(handles.posterize_figure,'Pointer','watch');
if isfinite(str2double(get(hObject,'String')))
    slider_max=get(handles.slider1,'Max');
    slider_min=get(handles.slider1,'Min');
    slider_value=str2double(get(hObject,'String'));
    if slider_value<=slider_max && slider_value>=slider_min
        set(handles.slider1,'Value',slider_value);
        pause(0.001); %=>for the change to show up in gui.
        red_value=get(handles.slider1,'Value');
        green_value=get(handles.slider2,'Value');
        blue_value=get(handles.slider3,'Value');
        output_image=posterize_rgb( cell2mat(handles.output(1)), [red_value green_value blue_value] );
        set(handles.ok,'UserData',output_image);
    end
end
%==========================================================================
%======================== SLIDER 2 ========================================
function slider2_CreateFcn(hObject, eventdata, handles)
usewhitebg = 1;
if usewhitebg    set(hObject,'BackgroundColor',[.9 .9 .9]);
else             set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
function slider2_Callback(hObject, eventdata, handles)
uiresume
set(handles.posterize_figure,'Pointer','watch');
set(handles.edit2,'String',int2str(get(hObject,'Value')));
pause(0.001); %=>for the change to show up in gui.
red_value=get(handles.slider1,'Value');
green_value=get(handles.slider2,'Value');
blue_value=get(handles.slider3,'Value');
output_image=posterize_rgb( cell2mat(handles.output(1)), [red_value green_value blue_value] );
set(handles.ok,'UserData',output_image);
%==========================================================================
%=========================== EDIT 2 =======================================
function edit2_CreateFcn(hObject, eventdata, handles)
if ispc    set(hObject,'BackgroundColor','white');
else       set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
function edit2_Callback(hObject, eventdata, handles)
uiresume
set(handles.posterize_figure,'Pointer','watch');
if isfinite(str2double(get(hObject,'String')))
    slider_max=get(handles.slider1,'Max');
    slider_min=get(handles.slider1,'Min');
    slider_value=str2double(get(hObject,'String'));
    if slider_value<=slider_max && slider_value>=slider_min
        set(handles.slider2,'Value',slider_value);
        pause(0.001); %=>for the change to show up in gui.
        red_value=get(handles.slider1,'Value');
        green_value=get(handles.slider2,'Value');
        blue_value=get(handles.slider3,'Value');
        output_image=posterize_rgb( cell2mat(handles.output(1)), [red_value green_value blue_value] );
        set(handles.ok,'UserData',output_image);
    end
end
%==========================================================================
%======================== SLIDER 3 ========================================
function slider3_CreateFcn(hObject, eventdata, handles)
usewhitebg = 1;
if usewhitebg    set(hObject,'BackgroundColor',[.9 .9 .9]);
else             set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
function slider3_Callback(hObject, eventdata, handles)
uiresume
set(handles.posterize_figure,'Pointer','watch');
set(handles.edit3,'String',int2str(get(hObject,'Value')));
pause(0.001); %=>for the change to show up in gui.
red_value=get(handles.slider1,'Value');
green_value=get(handles.slider2,'Value');
blue_value=get(handles.slider3,'Value');
output_image=posterize_rgb( cell2mat(handles.output(1)), [red_value green_value blue_value] );
set(handles.ok,'UserData',output_image);
%==========================================================================
%=========================== EDIT 3 =======================================
function edit3_CreateFcn(hObject, eventdata, handles)
if ispc    set(hObject,'BackgroundColor','white');
else       set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
function edit3_Callback(hObject, eventdata, handles)
uiresume
set(handles.posterize_figure,'Pointer','watch');
if isfinite(str2double(get(hObject,'String')))
    slider_max=get(handles.slider1,'Max');
    slider_min=get(handles.slider1,'Min');
    slider_value=str2double(get(hObject,'String'));
    if slider_value<=slider_max && slider_value>=slider_min
        set(handles.slider3,'Value',slider_value);
        pause(0.001); %=>for the change to show up in gui.
        red_value=get(handles.slider1,'Value');
        green_value=get(handles.slider2,'Value');
        blue_value=get(handles.slider3,'Value');
        output_image=posterize_rgb( cell2mat(handles.output(1)), [red_value green_value blue_value] );
        set(handles.ok,'UserData',output_image);
    end
end
%==========================================================================
%============ OK CANCEL AND PREVIEW BUTTONS ===============================
function ok_Callback(hObject, eventdata, handles)
uiresume
function cancel_Callback(hObject, eventdata, handles)
uiresume
function preview_Callback(hObject, eventdata, handles)
uiresume
%==========================================================================
%===================== GUI OUTPUT FUNCTION ================================
function varargout = posterize_gui_OutputFcn(hObject, eventdata, handles)
uiwait
%--------------------------------------------------------------------------
varargout{1} =~ishandle(handles.ok);%=> When delete button is pressed all handles are removed(my guess).
%--------------------------------------------------------------------------
varargout{2}=[];
%--------------------------------------------------------------------------
varargout{3} = cell2mat(handles.output(2));
varargout{4} = cell2mat(handles.output(3));
varargout{5} = cell2mat(handles.output(4));
varargout{6} =0;varargout{7} =0;
varargout{8} =cell2mat(handles.output(5));
%--------------------------------------------------------------------------
if ~varargout{1}
varargout{2} =get(handles.ok,'UserData');
varargout{3} =get(handles.slider1,'Value');
varargout{4} =get(handles.slider2,'Value');
varargout{5} =get(handles.slider3,'Value');
varargout{6} =get(handles.ok,'Value');
varargout{7} =get(handles.cancel,'Value');
varargout{8} =get(handles.preview,'Value');
delete(handles.posterize_figure);
end
%==========================================================================
%##########################################################################
%---------------------------Extra Used Function(s)-------------------------
%**************************** POSTERIZE_RGB *****************************************
function output_data=posterize_rgb(img_data,no_of_level)
[m n r]=size(img_data);
img_data=double(img_data);
for(i=1:m)
    for(j=1:n)
        for(k=1:3)
        img_data(i,j,k)=(round(img_data(i,j,k)/255*no_of_level(k))*255/no_of_level(k));
        end
    end
end
output_data=uint8(img_data);
%##########################################################################






