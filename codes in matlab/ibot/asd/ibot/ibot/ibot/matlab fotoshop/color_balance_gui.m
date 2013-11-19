function varargout = color_balance_gui(varargin)

%============================== Example ====================================
%[close_status image_output slider_pos1 slider_pos2 slider_pos3 ok_status cancel_status preview_status]=color_balance_gui(img2,0.3423,0.11,0.22,1);
%===========================================================================
%========================= INTIALISATION ===================================
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @color_balance_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @color_balance_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})    gui_State.gui_Callback = str2func(varargin{1});
end
if nargout    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else          gui_mainfcn(gui_State, varargin{:});
end
%==========================================================================
%=====================  GUI OPENING FUNCTION ==============================
function color_balance_gui_OpeningFcn(hObject, eventdata, handles, varargin)
set(handles.slider1,'Value',cell2mat(varargin(2)));
set(handles.edit1,'String',round(cell2mat(varargin(2))*100));
set(handles.slider2,'Value',cell2mat(varargin(3)));
set(handles.edit2,'String',round(cell2mat(varargin(3))*100));
set(handles.slider3,'Value',cell2mat(varargin(4)));
set(handles.edit3,'String',round(cell2mat(varargin(4))*100));
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
set(handles.color_balance_figure,'Pointer','watch');
set(handles.edit1,'String',int2str(get(hObject,'Value')*100));
pause(0.001); %=>for the change to show up in gui.
red_v=get(handles.slider1,'Value');
green_v=get(handles.slider2,'Value');
blue_v=get(handles.slider3,'Value');
output=color(cell2mat(handles.output(1)),[red_v green_v blue_v]);
set(handles.ok,'UserData',output);
%==========================================================================
%=========================== EDIT 1 =======================================
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc    set(hObject,'BackgroundColor','white');
else       set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
function edit1_Callback(hObject, eventdata, handles)
uiresume
set(handles.color_balance_figure,'Pointer','watch');
if isfinite(str2double(get(hObject,'String')))
    slider_max=get(handles.slider1,'Max');
    slider_min=get(handles.slider1,'Min');
    slider_value=str2double(get(hObject,'String'))*0.01;
    if slider_value<=slider_max && slider_value>=slider_min
        set(handles.slider1,'Value',slider_value);
        pause(0.001); %=>for the change to show up in gui.
        red_v=get(handles.slider1,'Value');
        green_v=get(handles.slider2,'Value');
        blue_v=get(handles.slider3,'Value');
        output=color(cell2mat(handles.output(1)),[red_v green_v blue_v]);
        set(handles.ok,'UserData',output);
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
set(handles.color_balance_figure,'Pointer','watch');
set(handles.edit2,'String',int2str(get(hObject,'Value')*100));
pause(0.001); %=>for the change to show up in gui.
red_v=get(handles.slider1,'Value');
green_v=get(handles.slider2,'Value');
blue_v=get(handles.slider3,'Value');
output=color(cell2mat(handles.output(1)),[red_v green_v blue_v]);
set(handles.ok,'UserData',output);
%==========================================================================
%=========================== EDIT 2 =======================================
function edit2_CreateFcn(hObject, eventdata, handles)
if ispc    set(hObject,'BackgroundColor','white');
else       set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
function edit2_Callback(hObject, eventdata, handles)
uiresume
set(handles.color_balance_figure,'Pointer','watch');
pause(0.001); %=>for the change to show up in gui.
if isfinite(str2double(get(hObject,'String')))
    slider_max=get(handles.slider2,'Max');
    slider_min=get(handles.slider2,'Min');
    slider_value=str2double(get(hObject,'String'))*0.01;
    if slider_value<=slider_max && slider_value>=slider_min
        set(handles.slider2,'Value',slider_value);
        pause(0.001); %=>for the change to show up in gui.
        red_v=get(handles.slider1,'Value');
        green_v=get(handles.slider2,'Value');
        blue_v=get(handles.slider3,'Value');
        output=color(cell2mat(handles.output(1)),[red_v green_v blue_v]);
        set(handles.ok,'UserData',output);
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
set(handles.color_balance_figure,'Pointer','watch');
set(handles.edit3,'String',int2str(get(hObject,'Value')*100));
pause(0.001); %=>for the change to show up in gui.
red_v=get(handles.slider1,'Value');
green_v=get(handles.slider2,'Value');
blue_v=get(handles.slider3,'Value');
output=color(cell2mat(handles.output(1)),[red_v green_v blue_v]);
set(handles.ok,'UserData',output);
%==========================================================================
%=========================== EDIT 3 =======================================
function edit3_CreateFcn(hObject, eventdata, handles)
if ispc    set(hObject,'BackgroundColor','white');
else       set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
function edit3_Callback(hObject, eventdata, handles)
uiresume
set(handles.color_balance_figure,'Pointer','watch');
pause(0.001); %=>for the change to show up in gui.
if isfinite(str2double(get(hObject,'String')))
    slider_max=get(handles.slider3,'Max');
    slider_min=get(handles.slider3,'Min');
    slider_value=str2double(get(hObject,'String'))*0.01;
    if slider_value<=slider_max && slider_value>=slider_min
        set(handles.slider3,'Value',slider_value);
        pause(0.001); %=>for the change to show up in gui.
        red_v=get(handles.slider1,'Value');
        green_v=get(handles.slider2,'Value');
        blue_v=get(handles.slider3,'Value');
        output=color(cell2mat(handles.output(1)),[red_v green_v blue_v]);
        set(handles.ok,'UserData',output);
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
%======================== LOAD SETTINGS ===================================
function load_Callback(hObject, eventdata, handles)
uiresume
set(handles.color_balance_figure,'Pointer','watch');
pause(0.001); %=>for the change to show up in gui.
[FileName,PathName]=uigetfile({'*.mcs','MATLAB Color Settings (*.MCS)'}, 'Load');
if(PathName~=0)
file_link=[PathName FileName];
fid=fopen(file_link);
tline = fgetl(fid);
fclose(fid);
a=tline-46;
b=[];
for i=1:length(a)
    if a(i)==0    b=[b i];
    end
end
for i=1:3   settings(i)=((a(b(i)-1)-2)*100+(a(b(i)+1)-2)*10+a(b(i)+2)-2)*0.01;
end
if b(1)==3         settings(1)=-1*settings(1);
end
if b(2)-b(1)==5    settings(2)=-1*settings(2);
end
if b(3)-b(2)==5    settings(3)=-1*settings(3);
end
set(handles.slider1,'Value',settings(1));set(handles.edit1,'String',round(settings(1)*100));
set(handles.slider2,'Value',settings(2));set(handles.edit2,'String',round(settings(2)*100));
set(handles.slider3,'Value',settings(3));set(handles.edit3,'String',round(settings(3)*100));
set(handles.ok,'UserData',color(cell2mat(handles.output(1)),settings));
end
%==========================================================================
%======================== SAVE SETTINGS ===================================
function save_Callback(hObject, eventdata, handles)
uiresume
slider_positions=[get(handles.slider1,'Value') get(handles.slider2,'Value') get(handles.slider3,'Value')];
[FileName,PathName]=uiputfile({'*.mcs','MATLAB Color Settings (*.MCS)'}, 'Save');
if(PathName~=0)
file_link=[PathName FileName '.mcs'];
fid = fopen(file_link,'w');
fprintf(fid,'%0.2f',slider_positions);
fclose(fid);
end
%==========================================================================
%===================== GUI OUTPUT FUNCTION ================================
function varargout = color_balance_gui_OutputFcn(hObject, eventdata, handles)
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
delete(handles.color_balance_figure);
end
%==========================================================================
%##########################################################################
%---------------------------Extra Used Function(s)-------------------------
%**************************** COLOR ***************************************
function output_image=color(input_image,color_val_array)
input_image=double(input_image);
[m n r]=size(input_image);
for k=1:3
    cutoff=0;
    reqd_mean=color_val_array(k)*255;
    a=input_image(:,:,k);
    if(mean(mean(a))<reqd_mean)    cutoff=255;
    end
    output(:,:,k)=a+(reqd_mean*m*n-sum(sum(a)))*(cutoff-a)/sum(sum(cutoff-a));
end
output_image=uint8(output);
%##########################################################################