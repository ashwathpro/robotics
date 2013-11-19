function varargout = about_author(varargin)

%========================= INTIALISATION ==================================
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @about_author_OpeningFcn, ...
                   'gui_OutputFcn',  @about_author_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})    gui_State.gui_Callback = str2func(varargin{1});
end
if nargout    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else          gui_mainfcn(gui_State, varargin{:});
end
%==========================================================================
function about_author_OpeningFcn(hObject, eventdata, handles, varargin)
y=imread('about_author.jpg');
[a b c]=size(y);
axes(handles.axes1);imshow(y);
function varargout = about_author_OutputFcn(hObject, eventdata, handles)
%==========================================================================