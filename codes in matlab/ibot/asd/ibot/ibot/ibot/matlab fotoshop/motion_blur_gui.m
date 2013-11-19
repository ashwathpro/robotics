function varargout = motion_blur_gui(varargin)

%============================== Example ====================================
%[close_status image_output slider_pos edit_value ok_status cancel_status preview_status]=motion_blur_gui(img2,0.056,135,1);
%==========================================================================
%========================= INTIALISATION ==================================
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @motion_blur_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @motion_blur_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})    gui_State.gui_Callback = str2func(varargin{1});
end
if nargout    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else          gui_mainfcn(gui_State, varargin{:});
end
%==========================================================================
%=====================  GUI OPENING FUNCTION ==============================
function motion_blur_gui_OpeningFcn(hObject, eventdata, handles, varargin)
set(handles.slider1,'Value',cell2mat(varargin(2)));
set(handles.edit1,'String',round(cell2mat(varargin(2))*1000));
set(handles.edit2,'String',cell2mat(varargin(3)));
set(handles.preview,'Value',cell2mat(varargin(4)));
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
set(handles.motion_blur_figure,'Pointer','watch');
set(handles.edit1,'String',int2str(get(hObject,'Value')*1000));
pause(0.001); %=>for the change to show up in gui.
distance=get(handles.slider1,'Value')*1000;
if distance~=0    
    angle=str2double(get(handles.edit2,'String'));
    MotionBlur=imfilter(cell2mat(handles.output(1)),fspecial('motion',distance,angle));
    set(handles.ok,'UserData',MotionBlur);
else
    set(handles.ok,'UserData',cell2mat(handles.output(1)));
end
%==========================================================================
%=========================== EDIT 1 =======================================
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc  set(hObject,'BackgroundColor','white');
else     set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
function edit1_Callback(hObject, eventdata, handles)
uiresume
set(handles.motion_blur_figure,'Pointer','watch');
if isfinite(str2double(get(hObject,'String')))
    slider_max=get(handles.slider1,'Max');
    slider_min=get(handles.slider1,'Min');
    slider_value=str2double(get(hObject,'String'))*0.001;
    if slider_value<=slider_max && slider_value>=slider_min
        set(handles.slider1,'Value',slider_value);
        pause(0.001); %=>for the change to show up in gui.
        distance=str2double(get(hObject,'String'));
        if distance~=0        
        angle=str2double(get(handles.edit2,'String'));
        MotionBlur=imfilter(cell2mat(handles.output(1)),fspecial('motion',distance,angle));
        set(handles.ok,'UserData',MotionBlur);
        else
        set(handles.ok,'UserData',cell2mat(handles.output(1)));
        end
    end
end
%==========================================================================
%=========================== EDIT 2 =======================================
function edit2_CreateFcn(hObject, eventdata, handles)
if ispc    set(hObject,'BackgroundColor','white');
else       set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
function edit2_Callback(hObject, eventdata, handles)
uiresume
set(handles.motion_blur_figure,'Pointer','watch');
pause(0.001); %=>for the change to show up in gui.
if isfinite(str2double(get(hObject,'String')))
    distance=str2double(get(handles.edit1,'String'));
    if distance~=0        
        angle=str2double(get(hObject,'String'));
        MotionBlur=imfilter(cell2mat(handles.output(1)),fspecial('motion',distance,angle));
        set(handles.ok,'UserData',MotionBlur);
    else
        set(handles.ok,'UserData',cell2mat(handles.output(1)));
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
function varargout = motion_blur_gui_OutputFcn(hObject, eventdata, handles)
uiwait
%--------------------------------------------------------------------------
varargout{1} =~ishandle(handles.ok);%=> When delete button is pressed all handles are removed(my guess).
%--------------------------------------------------------------------------
varargout{2}=[];
%--------------------------------------------------------------------------
varargout{3} = cell2mat(handles.output(2));
varargout{4} = cell2mat(handles.output(3));
varargout{5} =0;varargout{6} =0;
varargout{7} =cell2mat(handles.output(4));
%--------------------------------------------------------------------------
if ~varargout{1}
varargout{2} =get(handles.ok,'UserData');
varargout{3} =get(handles.slider1,'Value');
if isfinite(str2double(get(handles.edit2,'String')))
    varargout{4} =str2double(get(handles.edit2,'String'));
end
varargout{5} =get(handles.ok,'Value');
varargout{6} =get(handles.cancel,'Value');
varargout{7} =get(handles.preview,'Value');
delete(handles.motion_blur_figure);
end
%==========================================================================
%##########################################################################