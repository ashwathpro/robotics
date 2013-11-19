function varargout = image_info(varargin)


%========================= INTIALISATION ==================================
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @image_info_OpeningFcn, ...
                   'gui_OutputFcn',  @image_info_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})    gui_State.gui_Callback = str2func(varargin{1});
end
if nargout    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else          gui_mainfcn(gui_State, varargin{:});
end
%==========================================================================
%=====================  GUI OPENING FUNCTION ==============================
function image_info_OpeningFcn(hObject, eventdata, handles, varargin)
input_data=varargin;
path=cell2mat(input_data(2));
cell_array=cellimfinfo(path);
set(handles.listbox1,'String',cell_array);
%==========================================================================
%============================== LISTBOX 1 =================================
function listbox1_CreateFcn(hObject, eventdata, handles)
if ispc    set(hObject,'BackgroundColor','white');
else       set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
function listbox1_Callback(hObject, eventdata, handles)
%==========================================================================
%========================== OK BUTTON =====================================
function ok_Callback(hObject, eventdata, handles)
delete(handles.image_info_figure);
%=======================================================================
%===================== GUI OUTPUT FUNCTION ================================
function varargout = image_info_OutputFcn(hObject, eventdata, handles)
%==========================================================================
%##########################################################################
%---------------------------Extra Used Function(s)-------------------------
%************************** CELLIMFINFO ***********************************
function outout_cell_array=cellimfinfo(path)
info = imfinfo(path);
names=fieldnames(info);
ads='';
for i=1:length(names)
    ass=getfield(info,char(names(i)));
    if iscell(ass) 
        ass=char(ass)  ;
    end
    if ~ischar(ass)&&length(ass)<=1
        ass=int2str(ass);
    end
    if ischar(ass)
        ads=[ads;{[char(names(i)) ' : ' ass]}];
    end
end
outout_cell_array=ads;
%##########################################################################