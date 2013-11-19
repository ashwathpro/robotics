function varargout = one_slider_gui(varargin)

%============================== Example ====================================
% [close_status image_output slider_pos ok_status cancel_status preview_status]=one_slider_gui(img3,slider_pos,preview_status,'Contrast');
%==========================================================================
%========================= INTIALISATION ==================================
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @one_slider_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @one_slider_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})    gui_State.gui_Callback = str2func(varargin{1});
end
if nargout    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else          gui_mainfcn(gui_State, varargin{:});
end
%==========================================================================
%=====================  GUI OPENING FUNCTION ==============================
function one_slider_gui_OpeningFcn(hObject, eventdata, handles, varargin)
set(handles.slider1,'Value',cell2mat(varargin(2)));
set(handles.edit1,'String',round(cell2mat(varargin(2))*100));
set(handles.preview,'Value',cell2mat(varargin(3)));
handles.output =varargin;
guidata(hObject, handles);
set(handles.one_slider_figure,'Name',cell2mat(varargin(4)));
%==========================================================================
%======================== SLIDER 1 ========================================
function slider1_CreateFcn(hObject, eventdata, handles)
usewhitebg = 1;
if usewhitebg    set(hObject,'BackgroundColor',[.9 .9 .9]);
else             set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
function slider1_Callback(hObject, eventdata, handles)
uiresume
set(handles.one_slider_figure,'Pointer','watch');
set(handles.edit1,'String',int2str(get(hObject,'Value')*100));
pause(0.001); %=>for the change to show up in gui.
switch cell2mat(handles.output(4))
   case 'Brightness' 
       set(handles.ok,'UserData',brightness(cell2mat(handles.output(1)),get(hObject,'Value')));
   case 'Contrast'   
       set(handles.ok,'UserData',contrast_control(cell2mat(handles.output(1)),get(hObject,'Value')));
   case 'Sketching'
       set(handles.ok,'UserData',sketching(cell2mat(handles.output(1)),get(hObject,'Value')));
end
%==========================================================================
%=========================== EDIT 1 =======================================
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc  set(hObject,'BackgroundColor','white');
else     set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
function edit1_Callback(hObject, eventdata, handles)
uiresume
set(handles.one_slider_figure,'Pointer','watch');
pause(0.001); %=>for the change to show up in gui.
if isfinite(str2double(get(hObject,'String')))
    slider_max=get(handles.slider1,'Max');
    slider_min=get(handles.slider1,'Min');
    slider_value=str2double(get(hObject,'String'))*0.01;
    if slider_value<=slider_max && slider_value>=slider_min
        set(handles.slider1,'Value',slider_value);
        switch cell2mat(handles.output(4))
            case 'Brightness' 
                set(handles.ok,'UserData',brightness(cell2mat(handles.output(1)),str2double(get(hObject,'String'))*0.01));
            case 'Contrast'   
                set(handles.ok,'UserData',contrast_control(cell2mat(handles.output(1)),str2double(get(hObject,'String'))*0.01));
            case 'Sketching'
                set(handles.ok,'UserData',sketching(cell2mat(handles.output(1)),str2double(get(hObject,'String'))*0.01));
        end
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
function varargout = one_slider_gui_OutputFcn(hObject, eventdata, handles)
uiwait
%--------------------------------------------------------------------------
varargout{1} =~ishandle(handles.ok);%=> When delete button is pressed all handles are removed(my guess).
%--------------------------------------------------------------------------
varargout{2}=[];
%--------------------------------------------------------------------------
varargout{3} = cell2mat(handles.output(2));
varargout{4} =0;varargout{5} =0;
varargout{6} =cell2mat(handles.output(3));
%--------------------------------------------------------------------------
if ~varargout{1}
varargout{2} =get(handles.ok,'UserData');
varargout{3} =get(handles.slider1,'Value');
varargout{4} =get(handles.ok,'Value');
varargout{5} =get(handles.cancel,'Value');
varargout{6} =get(handles.preview,'Value');
delete(handles.one_slider_figure);
end
%==========================================================================
%##########################################################################
%---------------------------Extra Used Function(s)-------------------------
%************************** BRIGHTNESS ************************************
function output_image=brightness(input_image,value)
%value ranges from -1 to 1.
[m n r]=size(input_image);
if r==3 img=rgb2ntsc(input_image);
else     img=double(input_image)./255;
end
img(:,:,1)=img(:,:,1)+value;
if r==3  img=ntsc2rgb(img);
end
output_image=uint8(img.*255);
%**************************************************************************
%************************** CONTRAST **************************************
function output_image=contrast_control(input_image,value)
%value ranges from -1 to 1.
value=value+1;%to make the range of value=[-1,1], but originally range was [0,2].
[m n r]=size(input_image);
input_image=double(input_image);
res_image=input_image;
for i = 2:m-1
     for j = 2:n-1
         for k=1:r
              if abs(input_image(i,j,k) - std(input_image(i-1:i+1,j-1:j+1,k))) > 20
                 res_image(i,j,k) =input_image(i,j,k)*value ; % this factor decides the contrast
              end  
          end
      end
end
res_image(:,1,:)=(res_image(:,2,:)-input_image(:,2,:))+res_image(:,1,:);
res_image(:,n,:)=(res_image(:,n-1,:)-input_image(:,n-1,:))+res_image(:,n,:);
res_image(1,:,:)=(res_image(2,:,:)-input_image(2,:,:))+res_image(1,:,:);
res_image(m,:,:)=(res_image(m-1,:,:)-input_image(m-1,:,:))+res_image(m,:,:);
output_image=uint8(res_image);
%**************************************************************************
%************************* SKETCHING ***************************************
function output_image=sketching(input_image,value)
%value ranges from -1 to 1.
value=(value+1)/2; %to make the range of value=[-1,1], but originally range was [0,1].
if ~isgray(input_image)  input_image=rgb2gray(input_image);
end
input_image=double(input_image);
[m n]=size(input_image);
for(num=2:255)
   inv=255-edge(input_image,'prewitt',num).*255;
   count_black=0;
   for(i=1:m)
       for(j=1:n)
            if ~inv(i,j)    count_black=count_black+1;
            end
       end
   end
   ratio=(m*n-count_black)/count_black;
   if(ratio>value*35)    break,end
end
output_image=uint8(inv);
%##########################################################################