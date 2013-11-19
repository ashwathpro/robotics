function varargout = fotoshop(varargin)

%========================= INTIALISATION ==================================
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fotoshop_OpeningFcn, ...
                   'gui_OutputFcn',  @fotoshop_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})    gui_State.gui_Callback = str2func(varargin{1});
end
if nargout    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else          gui_mainfcn(gui_State, varargin{:});
end
%==========================================================================
%=====================  GUI OPENING FUNCTION ==============================
function fotoshop_OpeningFcn(hObject, eventdata, handles, varargin)
%----------  DISABLE ALL ---------------------
set(handles.file_save,'Enable','off')
set(handles.file_saveas,'Enable','off')
set(handles.org_img_profile,'Enable','off')
set(handles.tools_image,'Enable','off')
set(handles.undo,'Enable','off')
set(handles.redo,'Enable','off')
%---------------------------------------------
%==========================================================================
%===================== GUI OUTPUT FUNCTION ================================
function varargout = fotoshop_OutputFcn(hObject, eventdata, handles)
%==========================================================================
%##########################################################################
%=========================== IMAGE ========================================
function image_Callback(hObject, eventdata, handles)
%---------------------- ORIGINAL IMAGE PROFILE ----------------------------
function org_img_profile_Callback(hObject, eventdata, handles)
image_info(1,handles.image_path);
%==========================================================================
%##########################################################################
%############################# HELP #######################################
function help_Callback(hObject, eventdata, handles)
function tutorial_Callback(hObject, eventdata, handles)
function gaussian_blur_help_Callback(hObject, eventdata, handles)
viewhelptxt('gaussian_blur_help.txt','Gaussian Blur Help');
function laplace_filter_help_Callback(hObject, eventdata, handles)
viewhelptxt('laplace_filter_help.txt','Laplace Filter Help');
function usm_filter_help_Callback(hObject, eventdata, handles)
viewhelptxt('usm_filter_help.txt','USM Filter Help');
function about_author_Callback(hObject, eventdata, handles)
about_author
function about_matfotoshop_Callback(hObject, eventdata, handles)
about_matlab_gui
%##########################################################################
%##########################################################################
%=========================== FILE =========================================
function file_Callback(hObject, eventdata, handles)
%--------------------------- FILE OPEN ------------------------------------
function file_open_Callback(hObject, eventdata, handles)
%-------------------------- Open image-------------------------------------
[FileName,PathName] = uigetfile('*.jpg','Select any image');
if PathName~=0
y= [PathName,FileName];
img=imread(y);
%-------------------- Enable stuffs --------------------------------------
set(handles.file_saveas,'Enable','on')
set(handles.org_img_profile,'Enable','on')
set(handles.tools_image,'Enable','on')
%---------------------Disable stuffs---------------------------------------
set(handles.file_save,'Enable','off')
set(handles.undo,'Enable','off')
set(handles.redo,'Enable','off')
%------------------------ if not rgb disable color tools-------------------
if ~isrgb(img)
    set(handles.colorb,'Enable','off')
    set(handles.hue_sat_light,'Enable','off')
    set(handles.rgb2gray,'Enable','off')
    set(handles.autocolor,'Enable','off')
    set(handles.posterize,'Enable','off')
    else
    set(handles.colorb,'Enable','on');
    set(handles.hue_sat_light,'Enable','on');
    set(handles.rgb2gray,'Enable','on')
    set(handles.autocolor,'Enable','on')
    set(handles.posterize,'Enable','on')
end
%----------------------- show up image-------------------------------------
axes(handles.axes1);imshow(img);
%-------------------------save image path,data & undo number--------
handles.image_path=y;
handles.image_data=img;
handles.undo_num=0;
guidata(hObject, handles);
end
%==========================================================================
%--------------------------- FILE SAVE ------------------------------------
function file_save_Callback(hObject, eventdata, handles)
imwrite(handles.image_data,handles.image_path);
%--------------------------- FILE SAVEAS ----------------------------------
function file_saveas_Callback(hObject, eventdata, handles)
[FileName,PathName,filterindex]=uiputfile( ...
       {'*.jpg','jpg files'; ...
        '*.bmp','bitmap files'}, ...
        'Save as');
if PathName~=0
    if filterindex==1
        FileName=[FileName '.jpg'];
    else
        FileName=[FileName '.bmp'];
    end
y=[PathName,FileName];
imwrite(handles.image_data,y);
end
%--------------------------- FILE EXIT ------------------------------------
function exit_Callback(hObject, eventdata, handles)
delete(handles.main_figure);
%==========================================================================
%##########################################################################
%%%%%%%%%%%%%%%%%%%%%%%%%   TOOLS  START  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%=========================== TOOLS ========================================
function tools_Callback(hObject, eventdata, handles)
%--------------------------- TOOLS IMAGE ----------------------------------
function tools_image_Callback(hObject, eventdata, handles)
%--------------------------- (1) ------------------------------------------
function rgb2gray_Callback(hObject, eventdata, handles)
%----------------------------------------------
set(handles.main_figure,'Pointer','watch');
%----------------------------------------------
I=rgb2gray(handles.image_data);
axes(handles.axes1);imshow(I);
%----------------------------------------------
set(handles.file_save,'Enable','on')
set(handles.undo,'Enable','on')
set(handles.redo,'Enable','off')
%----------------------------------------------
handles.undo_img_data=handles.image_data;
handles.image_data=I;
handles.undo_num=handles.undo_num+1; %---undo stage is advanced
guidata(hObject, handles);
%----------------disable color tools------------------------------
set(handles.colorb,'Enable','off')
set(handles.hue_sat_light,'Enable','off')
set(handles.rgb2gray,'Enable','off')
set(handles.autocolor,'Enable','off')
set(handles.posterize,'Enable','off')
%----------------------------------------------
set(handles.main_figure,'Pointer','arrow');
%--------------------------- (1) ------------------------------------------
%--------------------------- (2) ------------------------------------------
function colorb_Callback(hObject, eventdata, handles)
%-------------------------------------
img3=handles.image_data;
img2=img3;
slider_pos1=mean(mean(img3(:,:,1)))/255;
slider_pos2=mean(mean(img3(:,:,2)))/255;
slider_pos3=mean(mean(img3(:,:,3)))/255;
preview_status=1;
%-------------------------------------
while 1
[close_status image_output slider_pos1 slider_pos2 slider_pos3 ok_status cancel_status preview_status]=color_balance_gui(img3,slider_pos1,slider_pos2,slider_pos3,preview_status);
    if  cancel_status||ok_status||close_status, break, end
    if  ~isempty(image_output)     img2=image_output;
    end   
    if  preview_status                axes(handles.axes1);imshow(img2);
    else                              axes(handles.axes1);imshow(img3);
    end
end
%-------------------------------------
if ok_status
    if slider_pos1~=mean(mean(img3(:,:,1)))/255 ...
       || slider_pos2~=mean(mean(img3(:,:,2)))/255 ...
       || slider_pos3~=mean(mean(img3(:,:,3)))/255
    %-------------------------------------
    axes(handles.axes1);imshow(img2);
    %-------------------------------------
    set(handles.file_save,'Enable','on')
    set(handles.undo,'Enable','on')
    set(handles.redo,'Enable','off')
    %-------------------------------------
    handles.undo_img_data=img3;
    handles.image_data=img2;
    handles.undo_num=handles.undo_num+1;
    guidata(hObject, handles);
    %-------------------------------------
    end
else                                  
    axes(handles.axes1);imshow(img3);
end
%--------------------------- (2) ------------------------------------------
%--------------------------- (3) ------------------------------------------
function hue_sat_light_Callback(hObject, eventdata, handles)
%-------------------------------------
img3=handles.image_data;
img2=img3;
slider_pos1=0;slider_pos2=0;slider_pos3=0;preview_status=1;
%-------------------------------------
while 1
    [close_status image_output slider_pos1 slider_pos2 slider_pos3 ok_status cancel_status preview_status]=hue_sat_light_gui(img3,slider_pos1,slider_pos2,slider_pos3,preview_status);
    if  cancel_status||ok_status||close_status, break, end
    if  ~isempty(image_output)     img2=image_output;
    end   
    if  preview_status                axes(handles.axes1);imshow(img2);
    else                              axes(handles.axes1);imshow(img3);
    end
end
%-------------------------------------
if ok_status     
    if slider_pos1||slider_pos2||slider_pos3
    %-------------------------------------
    axes(handles.axes1);imshow(img2);
    %-------------------------------------
    set(handles.file_save,'Enable','on')
    set(handles.undo,'Enable','on')
    set(handles.redo,'Enable','off')
    %-------------------------------------
    handles.undo_img_data=img3;
    handles.image_data=img2;
    handles.undo_num=handles.undo_num+1;
    guidata(hObject, handles);
    %-------------------------------------
    end
else                                  
    axes(handles.axes1);imshow(img3);
end
%--------------------------- (3) ------------------------------------------
%--------------------------- (4) ------------------------------------------
function brightness_Callback(hObject, eventdata, handles)
%-------------------------------------
img3=handles.image_data;
img2=img3;
slider_pos=0;preview_status=1;
%-------------------------------------
while 1
    [close_status image_output slider_pos ok_status cancel_status preview_status]=one_slider_gui(img3,slider_pos,preview_status,'Brightness');
    if  cancel_status||ok_status||close_status, break, end
    if  ~isempty(image_output)     img2=image_output;
    end   
    if  preview_status                axes(handles.axes1);imshow(img2);
    else                              axes(handles.axes1);imshow(img3);
    end
end
%-------------------------------------
if ok_status && slider_pos
    %-------------------------------------
    axes(handles.axes1);imshow(img2);
    %-------------------------------------
    set(handles.file_save,'Enable','on')
    set(handles.undo,'Enable','on')
    set(handles.redo,'Enable','off')
    %-------------------------------------
    handles.undo_img_data=img3;
    handles.image_data=img2;
    handles.undo_num=handles.undo_num+1;
    guidata(hObject, handles);
    %-------------------------------------
else                                  
    axes(handles.axes1);imshow(img3);
end
%--------------------------- (4) ------------------------------------------
%--------------------------- (5) ------------------------------------------
function contrast_Callback(hObject, eventdata, handles)
%-------------------------------------
img3=handles.image_data;
img2=img3;
slider_pos=0;preview_status=1;
%-------------------------------------
while 1
    [close_status image_output slider_pos ok_status cancel_status preview_status]=one_slider_gui(img3,slider_pos,preview_status,'Contrast');
    if  cancel_status||ok_status||close_status, break, end
    if  ~isempty(image_output)     img2=image_output;
    end   
    if  preview_status                axes(handles.axes1);imshow(img2);
    else                              axes(handles.axes1);imshow(img3);
    end
end
%-------------------------------------
if ok_status && slider_pos   
    %-------------------------------------
    axes(handles.axes1);imshow(img2);
    %-------------------------------------
    set(handles.file_save,'Enable','on')
    set(handles.undo,'Enable','on')
    set(handles.redo,'Enable','off')
    %-------------------------------------
    handles.undo_img_data=img3;
    handles.image_data=img2;
    handles.undo_num=handles.undo_num+1;
    guidata(hObject, handles);
    %-------------------------------------
else                                  
    axes(handles.axes1);imshow(img3);
end
%--------------------------- (5) ------------------------------------------
%--------------------------- (6) ------------------------------------------
function sketching_Callback(hObject, eventdata, handles)
%-------------------------------------------
set(handles.main_figure,'Pointer','watch');
%-------------------------------------------
img3=sketching(handles.image_data,0);
axes(handles.axes1);imshow(img3);
set(handles.main_figure,'Pointer','arrow');
%-------------------------------------------
img2=img3;
slider_pos=0;preview_status=1;
%-------------------------------------------
while 1
    [close_status image_output slider_pos ok_status cancel_status preview_status]=one_slider_gui(img3,slider_pos,preview_status,'Sketching');
    if  cancel_status||ok_status||close_status, break, end
    if  ~isempty(image_output)     img2=image_output;
    end   
    if  preview_status                axes(handles.axes1);imshow(img2);
    else                              axes(handles.axes1);imshow(img3);
    end
end
%-------------------------------------------
if ok_status    
    %-------------------------------------------
    axes(handles.axes1);imshow(img2);
    %-------------------------------------------
    set(handles.file_save,'Enable','on')
    set(handles.undo,'Enable','on')
    set(handles.redo,'Enable','off')
    %-------------------------------------------
    handles.undo_img_data=handles.image_data;
    handles.image_data=img2;
    handles.undo_num=handles.undo_num+1;
    guidata(hObject, handles);
    %-------------------------------------------
    set(handles.colorb,'Enable','off')
    set(handles.hue_sat_light,'Enable','off')
    set(handles.rgb2gray,'Enable','off')
    set(handles.posterize,'Enable','off')
    %-------------------------------------------
else                                  
    axes(handles.axes1);imshow(handles.image_data);
end
%--------------------------- (6) ------------------------------------------
% --------------------------- BLUR ----------------------------------------
function blur_Callback(hObject, eventdata, handles)
% ---------------------------- (7-1) --------------------------------------
function blur1_Callback(hObject, eventdata, handles)
%-------------------------------------------
set(handles.main_figure,'Pointer','watch');
%-------------------------------------------
I=handles.image_data;
Blur = imfilter(I,fspecial('disk',1));
axes(handles.axes1);imshow(Blur);
%-------------------------------------------
set(handles.file_save,'Enable','on')
set(handles.undo,'Enable','on')
set(handles.redo,'Enable','off')
%-------------------------------------------
handles.undo_img_data=I;
handles.image_data=Blur;
handles.undo_num=handles.undo_num+1;
guidata(hObject, handles);
%-------------------------------------------
set(handles.main_figure,'Pointer','arrow');
% ---------------------------- (7-1) --------------------------------------
% ---------------------------- (7-2) --------------------------------------
function blur2_Callback(hObject, eventdata, handles)
%-------------------------------------------
set(handles.main_figure,'Pointer','watch');
%-------------------------------------------
I=handles.image_data;
Blur = imfilter(I,fspecial('disk',2));
axes(handles.axes1);imshow(Blur);
%-------------------------------------------
set(handles.file_save,'Enable','on')
set(handles.undo,'Enable','on')
set(handles.redo,'Enable','off')
%-------------------------------------------
handles.undo_img_data=I;
handles.image_data=Blur;
handles.undo_num=handles.undo_num+1;
guidata(hObject, handles);
%-------------------------------------------
set(handles.main_figure,'Pointer','arrow');
% ---------------------------- (7-2) --------------------------------------
%--------------------------- (8) ------------------------------------------
function sharpen_Callback(hObject, eventdata, handles)
%-------------------------------------------
set(handles.main_figure,'Pointer','watch');
%-------------------------------------------
I=handles.image_data;
Sharpen=imfilter(I,fspecial('unsharp',1.0));
axes(handles.axes1);imshow(Sharpen);
%-------------------------------------------
set(handles.file_save,'Enable','on')
set(handles.undo,'Enable','on')
set(handles.redo,'Enable','off')
%-------------------------------------------
handles.undo_img_data=I;
handles.image_data=Sharpen;
handles.undo_num=handles.undo_num+1;
guidata(hObject, handles);
%-------------------------------------------
set(handles.main_figure,'Pointer','arrow');
%--------------------------- (8) ------------------------------------------
%************************* (9)*****************************************
function autobrightness_Callback(hObject, eventdata, handles)
%----------------------------------------------
set(handles.main_figure,'Pointer','watch');
%----------------------------------------------
I=autobright(handles.image_data);
axes(handles.axes1);imshow(I);
%----------------------------------------------
set(handles.file_save,'Enable','on')
set(handles.undo,'Enable','on')
set(handles.redo,'Enable','off')
%----------------------------------------------
handles.undo_img_data=handles.image_data;
handles.image_data=I;
handles.undo_num=handles.undo_num+1;
guidata(hObject, handles);
%----------------------------------------------
set(handles.main_figure,'Pointer','arrow');
%****************************(9)**************************************
%*****************************(10)*************************************
function autocolor_Callback(hObject, eventdata, handles)
%----------------------------------------------
set(handles.main_figure,'Pointer','watch');
%----------------------------------------------
I=autocolor(handles.image_data);
axes(handles.axes1);imshow(I);
%----------------------------------------------
set(handles.file_save,'Enable','on')
set(handles.undo,'Enable','on')
set(handles.redo,'Enable','off')
%----------------------------------------------
handles.undo_img_data=handles.image_data;
handles.image_data=I;
handles.undo_num=handles.undo_num+1;
guidata(hObject, handles);
%----------------------------------------------
set(handles.main_figure,'Pointer','arrow');
%*****************************(10)*************************************
%*****************************(11)*************************************
function autocontrast_Callback(hObject, eventdata, handles)
%----------------------------------------------
set(handles.main_figure,'Pointer','watch');
%----------------------------------------------
I=autocontrast(handles.image_data);
axes(handles.axes1);imshow(I);
%----------------------------------------------
set(handles.file_save,'Enable','on')
set(handles.undo,'Enable','on')
set(handles.redo,'Enable','off')
%----------------------------------------------
handles.undo_img_data=handles.image_data;
handles.image_data=I;
handles.undo_num=handles.undo_num+1;
guidata(hObject, handles);
%----------------------------------------------
set(handles.main_figure,'Pointer','arrow');
%*******************************(11)***********************************
%================================(12)==========================================
function usm_filter_Callback(hObject, eventdata, handles)
%-------------------------------------------
img3=handles.image_data;
img2=img3;
slider_pos=0.1;preview_status=1;popup_value=1;
%-------------------------------------------
while 1
    [close_status image_output slider_pos popup_value ok_status cancel_status preview_status]=usm_filter_gui(img3,slider_pos,popup_value,preview_status);
    if  cancel_status||ok_status||close_status, break, end
    if  ~isempty(image_output)     img2=image_output;
    end   
    if  preview_status                axes(handles.axes1);imshow(img2);
    else                              axes(handles.axes1);imshow(img3);
    end
end
%-------------------------------------------
if ok_status
    if slider_pos~=0.1 || popup_value~=1
    %-------------------------------------------
    axes(handles.axes1);imshow(img2);
    %-------------------------------------------
    set(handles.file_save,'Enable','on')
    set(handles.undo,'Enable','on')
    set(handles.redo,'Enable','off')
    %-------------------------------------------
    handles.undo_img_data=img3;
    handles.image_data=img2;
    handles.undo_num=handles.undo_num+1;
    guidata(hObject, handles);
    %-------------------------------------------
    end
else                                  
    axes(handles.axes1);imshow(img3);
end
%===============================(12)===========================================
%================================(13)==========================================
function laplace_filter_Callback(hObject, eventdata, handles)
%-------------------------------------------
img3=handles.image_data;
img2=img3;
slider_pos=0;preview_status=1;edit_value=1;
%-------------------------------------------
while 1
    [close_status image_output slider_pos edit_value ok_status cancel_status preview_status]=laplace_filter_gui(img3,slider_pos,edit_value,preview_status);
    if  cancel_status||ok_status||close_status, break, end
    if  ~isempty(image_output)     img2=image_output;
    end   
    if  preview_status                axes(handles.axes1);imshow(img2);
    else                              axes(handles.axes1);imshow(img3);
    end
end
%-------------------------------------------
if ok_status
    if slider_pos~=0 || edit_value~=1
    %-------------------------------------------
    axes(handles.axes1);imshow(img2);
    %-------------------------------------------
    set(handles.file_save,'Enable','on')
    set(handles.undo,'Enable','on')
    set(handles.redo,'Enable','off')
    %-------------------------------------------
    handles.undo_img_data=img3;
    handles.image_data=img2;
    handles.undo_num=handles.undo_num+1;
    guidata(hObject, handles);
    %-------------------------------------------
    end
else                                  
    axes(handles.axes1);imshow(img3);
end
%==================================(13)========================================
%===================================(14)=======================================
function motion_blur_Callback(hObject, eventdata, handles)
%-------------------------------------------
img3=handles.image_data;
img2=img3;
slider_pos=0;preview_status=1;edit_value=0;
%-------------------------------------------
while 1
    [close_status image_output slider_pos edit_value ok_status cancel_status preview_status]=motion_blur_gui(img3,slider_pos,edit_value,preview_status);
    if  cancel_status||ok_status||close_status, break, end
    if  ~isempty(image_output)     img2=image_output;
    end   
    if  preview_status                axes(handles.axes1);imshow(img2);
    else                              axes(handles.axes1);imshow(img3);
    end
end
%-------------------------------------------
if ok_status
    if slider_pos~=0 || edit_value~=0
    %-------------------------------------------
    axes(handles.axes1);imshow(img2);
    %-------------------------------------------
    set(handles.file_save,'Enable','on')
    set(handles.undo,'Enable','on')
    set(handles.redo,'Enable','off')
    %-------------------------------------------
    handles.undo_img_data=img3;
    handles.image_data=img2;
    handles.undo_num=handles.undo_num+1;
    guidata(hObject, handles);
    %-------------------------------------------
    end
else                                  
    axes(handles.axes1);imshow(img3);
end
%=====================================(14)=====================================
%=====================================(15)=====================================
function posterize_Callback(hObject, eventdata, handles)
%-------------------------------------------
img3=handles.image_data;
img2=img3;
slider_pos1=255;slider_pos2=255;slider_pos3=255;preview_status=1;
%-------------------------------------------
while 1
    [close_status image_output slider_pos1 slider_pos2 slider_pos3 ok_status cancel_status preview_status]=posterize_gui(img3,slider_pos1,slider_pos2,slider_pos3,preview_status);
    if  cancel_status||ok_status||close_status, break, end
    if  ~isempty(image_output)     img2=image_output;
    end   
    if  preview_status                axes(handles.axes1);imshow(img2);
    else                              axes(handles.axes1);imshow(img3);
    end
end
%-------------------------------------------
if ok_status     
    if slider_pos1~=255||slider_pos2~=255||slider_pos3~=255
    %-------------------------------------------
    axes(handles.axes1);imshow(img2);
    %-------------------------------------------
    set(handles.file_save,'Enable','on')
    set(handles.undo,'Enable','on')
    set(handles.redo,'Enable','off')
    %-------------------------------------------
    handles.undo_img_data=img3;
    handles.image_data=img2;
    handles.undo_num=handles.undo_num+1;
    guidata(hObject, handles);
    %-------------------------------------------
    end
else                                  
    axes(handles.axes1);imshow(img3);
end
%=====================================(15)=====================================
%==========================================================================
%##########################################################################
%%%%%%%%%%%%%%%%%%%%%%%%%   TOOLS  END  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%   EDIT   START  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%##########################################################################
%=========================== EDIT =========================================
function edit_Callback(hObject, eventdata, handles)
%***************************************************
%***************************************************
function undo_Callback(hObject, eventdata, handles)
%----------------------------------------------
set(handles.undo,'Enable','off')
set(handles.redo,'Enable','on')
%----------------------------------------------
handles.redo_img_data=handles.image_data;
%----------------------------------------------
handles.image_data=handles.undo_img_data;
handles.undo_num=handles.undo_num-1;
guidata(hObject, handles);
%----------------------------------------------
if ~handles.undo_num
    set(handles.file_save,'Enable','off')
end
%----------------------------------------------
%---------setting color tools -----------------
if ~isrgb(handles.undo_img_data)
    set(handles.colorb,'Enable','off')
    set(handles.hue_sat_light,'Enable','off')
    set(handles.rgb2gray,'Enable','off')
    set(handles.autocolor,'Enable','off')
    set(handles.posterize,'Enable','off')
    else
    set(handles.colorb,'Enable','on');
    set(handles.hue_sat_light,'Enable','on');
    set(handles.rgb2gray,'Enable','on')
    set(handles.autocolor,'Enable','on')
    set(handles.posterize,'Enable','on')
end
%----------------------------------------------
axes(handles.axes1);imshow(handles.undo_img_data);
%***************************************************
%***************************************************
function redo_Callback(hObject, eventdata, handles)
%----------------------------------------------
set(handles.file_save,'Enable','on')
%----------------------------------------------
set(handles.redo,'Enable','off')
set(handles.undo,'Enable','on')
%----------------------------------------------
handles.image_data=handles.redo_img_data;
handles.undo_num=handles.undo_num+1;
guidata(hObject, handles);
%----------------------------------------------
%---------setting color tools -----------------
if ~isrgb(handles.redo_img_data)
    set(handles.colorb,'Enable','off')
    set(handles.hue_sat_light,'Enable','off')
    set(handles.rgb2gray,'Enable','off')
    set(handles.autocolor,'Enable','off')
    set(handles.posterize,'Enable','off')
else
    set(handles.colorb,'Enable','on');
    set(handles.hue_sat_light,'Enable','on');
    set(handles.rgb2gray,'Enable','on')
    set(handles.autocolor,'Enable','on')
    set(handles.posterize,'Enable','on')
end
%----------------------------------------------
axes(handles.axes1);imshow(handles.redo_img_data);
%==========================================================================
%##########################################################################
%%%%%%%%%%%%%%%%%%%%%%%%%   EDIT   END  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%