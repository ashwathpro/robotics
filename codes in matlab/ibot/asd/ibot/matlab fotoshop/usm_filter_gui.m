function varargout = usm_filter_gui(varargin)


%========================= INTIALISATION ==================================
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @usm_filter_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @usm_filter_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})    gui_State.gui_Callback = str2func(varargin{1});
end
if nargout    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else          gui_mainfcn(gui_State, varargin{:});
end
%==========================================================================
%=====================  GUI OPENING FUNCTION ==============================
function usm_filter_gui_OpeningFcn(hObject, eventdata, handles, varargin)
set(handles.slider1,'Value',cell2mat(varargin(2)));
set(handles.edit1,'String',cell2mat(varargin(2)));
set(handles.popupmenu1,'Value',cell2mat(varargin(3)));
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
set(handles.usm_filter_figure,'Pointer','watch');
set(handles.edit1,'String',int2str(get(hObject,'Value')));
pause(0.001); %=>for the change to show up in gui.
n=get(handles.popupmenu1,'Value')+1;
sigma=get(handles.slider1,'Value');
usm_image=usm_filter(cell2mat(handles.output(1)),sigma,n);
set(handles.ok,'UserData',usm_image);
%==========================================================================
%=========================== EDIT 1 =======================================
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc  set(hObject,'BackgroundColor','white');
else     set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
function edit1_Callback(hObject, eventdata, handles)
uiresume
set(handles.usm_filter_figure,'Pointer','watch');
if isfinite(str2double(get(hObject,'String')))
    slider_max=get(handles.slider1,'Max');
    slider_min=get(handles.slider1,'Min');
    slider_value=str2double(get(hObject,'String'));
    if slider_value<=slider_max && slider_value>=slider_min
        set(handles.slider1,'Value',slider_value);
        pause(0.001); %=>for the change to show up in gui.
        n=get(handles.popupmenu1,'Value')+1;
        sigma=get(handles.slider1,'Value');
        usm_image=usm_filter(cell2mat(handles.output(1)),sigma,n);
        set(handles.ok,'UserData',usm_image);
    end
end
%==========================================================================
%========================= POPUPMENU 1 ====================================
function popupmenu1_CreateFcn(hObject, eventdata, handles)
if ispc    set(hObject,'BackgroundColor','white');
else       set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
function popupmenu1_Callback(hObject, eventdata, handles)
uiresume
set(handles.usm_filter_figure,'Pointer','watch');
pause(0.001); %=>for the change to show up in gui.
n=get(handles.popupmenu1,'Value')+1;
sigma=get(handles.slider1,'Value');
usm_image=usm_filter(cell2mat(handles.output(1)),sigma,n);
set(handles.ok,'UserData',usm_image);
set(handles.usm_filter_figure,'Pointer','arrow');
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
function varargout = usm_filter_gui_OutputFcn(hObject, eventdata, handles)
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
varargout{4} =get(handles.popupmenu1,'Value');
varargout{5} =get(handles.ok,'Value');
varargout{6} =get(handles.cancel,'Value');
varargout{7} =get(handles.preview,'Value');
delete(handles.usm_filter_figure);
end
%==========================================================================
%##########################################################################
%-------------------- Extra Used Function(s) ------------------------------
%********************** USM FILTER ****************************************
function output_image=usm_filter(input_image,sigma,n)
for i = 1:n,
    for j = 1:n
        M_temp = [j-(n+1)/2 i-(n+1)/2]';       
        M(i,j) = exp(-(M_temp(1))^2/(2*sigma^2))/(sigma*sqrt(2*pi))*exp(-(M_temp(2))^2/(2*sigma^2))/(sigma*sqrt(2*pi));
    end
end
filter1= M/sum(sum(M));
img_filtered=convn(double(input_image),filter1,'same');
output_image=uint8(2*double(input_image)-img_filtered);
%##########################################################################