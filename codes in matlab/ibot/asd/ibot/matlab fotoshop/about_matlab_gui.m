function varargout = about_matlab_gui(varargin)

%========================= INTIALISATION ==================================
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @about_matlab_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @about_matlab_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})    gui_State.gui_Callback = str2func(varargin{1});
end
if nargout    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else          gui_mainfcn(gui_State, varargin{:});
end
%==========================================================================
function about_matlab_gui_OpeningFcn(hObject, eventdata, handles, varargin)
y=imread('about_matlab_img.jpg');
[a b c]=size(y);
axes(handles.axes1);imshow(y);
function varargout = about_matlab_gui_OutputFcn(hObject, eventdata, handles)
%==========================================================================
%================== SHOW LICENSE ==========================================
function showl_Callback(hObject, eventdata, handles)
fid=fopen('license.txt');
cell_text='';
while 1
            tline = fgetl(fid);
            if ~ischar(tline), break, end
            cell_text=[cell_text;{tline}];
end
fclose(fid);
helpwin (cell_text,'MATLAB  LICENSE');
%==========================================================================
%=========================== OK ===========================================
function ok_Callback(hObject, eventdata, handles)
delete(handles.about_matlab_figure);
%==========================================================================