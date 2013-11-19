function varargout = IProcessing(varargin)

%IPROCESSING M-file for IProcessing.fig
%      IPROCESSING, by itself, creates a new IPROCESSING or raises the existing
%      singleton*.
%
%      H = IPROCESSING returns the handle to a new IPROCESSING or the handle to
%      the existing singleton*.
%
%      IPROCESSING('Property','Value',...) creates a new IPROCESSING using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to IProcessing_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      IPROCESSING('CALLBACK') and IPROCESSING('CALLBACK',hObject,...) call the
%      local function named CALLBACK in IPROCESSING.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help IProcessing

% Last Modified by GUIDE v2.5 20-Jun-2005 11:32:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @IProcessing_OpeningFcn, ...
    'gui_OutputFcn',  @IProcessing_OutputFcn, ...
    'gui_LayoutFcn',  [], ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before IProcessing is made visible.
function IProcessing_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)
clc;
% Choose default command line output for IProcessing
handles.output = hObject;
handles.gray = 0;  %on-off grayscale image
handles.lg = 1;    %Grayscale image Slider Lower limit value
handles.hg = 255;  %Grayscale image Slider upper limit value

handles.glbx = 1;  %Global X-Coordinate of the Marker
handles.glby = 1;  %Global Y-Coordinate of the Marker

handles.mx = 0;     %Marker Box x-coordinate
handles.my = 0;     %Marker Box y-coordinate
handles.pop = 1;   %Popup menu item

handles.s2 = 0;  %Lower_in of image adjuster slider
handles.s3 = 1;    %Upper_in of image adjuster slider
handles.s4 = 0;    %Lower_out of image adjuster slider
handles.s5 = 1;    %Upper_out of image adjuster slider

handles.first = 0; %checks if it is the first time that user open a file.

set(handles.slider2,'Value',handles.s2);
set(handles.slider3,'Value',handles.s3);
set(handles.slider4,'Value',handles.s4);
set(handles.slider5,'Value',handles.s5);

handles.rl = 1;     %Red Lower limit value
handles.rh = 255;   %Red Upper limit value
handles.gl = 1;     %Green Lower limit value
handles.gh = 255;   %Green Upper limit value
handles.bl = 1;     %Blue Lower limit value
handles.bh = 255;   %Blue Upper limit value
handles.marker = 0; %Marker Number
handles.st = 1;
handles.en = 1;

handles.path = 1;  % Number of traced path to be shown
handles.Centroid_Flag = true;
handles.manual_check_flag = true;
set(handles.Centroid,'Value',handles.Centroid_Flag);
set(handles.manual_check,'Value',handles.manual_check_flag);
%set(handles.manual_check_value,'Visible',handles.manual_check_flag);

set(handles.red_high,'Value',1);
set(handles.green_high,'Value',1);
set(handles.blue_high,'Value',1);
set(handles.gray_high,'Value',1);

handles.Originx = 1;
handles.Originy = 1;
handles.Scalex = 100;
handles.Scaley = 100;
handles.Scalefx = 1;
handles.Scalefy = 1;


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes IProcessing wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = IProcessing_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.s2 = get(handles.slider2,'Value')
guidata(hObject, handles);
imageupdate(hObject,handles)




% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.s3 = get(handles.slider3,'Value')
guidata(hObject, handles);
imageupdate(hObject,handles)

% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.s4 = get(handles.slider4,'Value')
guidata(hObject, handles);
imageupdate(hObject,handles)


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.s5 = get(handles.slider5,'Value')
guidata(hObject, handles);
imageupdate(hObject,handles)


% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider6_Callback(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function Frame_NO_Callback(hObject, eventdata, handles)
% hObject    handle to Frame_NO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Frame_NO as text
%        str2double(get(hObject,'String')) returns contents of Frame_NO as a double
handles.n = round(str2double(get(handles.Frame_NO,'String')));
if handles.n>max(size(handles.mov))
    handles.n = max(size(handles.mov))
    set(handles.Frame_NO,'String',handles.n);
end
set(handles.slider1,'Value',handles.n/max(size(handles.mov)));
[I,Map] = frame2im(handles.mov(1,handles.n));
if handles.gray==1; I=rgb2gray(I); end
%axes(handles.axes1);
%hold on,imshow(I)
guidata(hObject, handles);
imageupdate(hObject,handles);

% --- Executes during object creation, after setting all properties.
function Frame_NO_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Frame_NO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

sv = get(handles.slider1,'Value');
handles.n=round(sv*max(size(handles.mov)));
if handles.n ==0, handles.n=1;end
set(handles.Frame_NO,'String',handles.n);
guidata(hObject, handles);
imageupdate(hObject,handles);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in Start_Process.
function Start_Process_Callback(hObject, eventdata, handles)
pack
handles.glbx(1:handles.nof) = NaN;
handles.glby(1:handles.nof) = NaN;
tolx = round((handles.w2-handles.w)/2);
toly = round((handles.h2-handles.h)/2);
yu = toly;
yd = toly;
xl = tolx;
xr = tolx;
vel = 0;
velflag = false;
ist = 0.4;   %Image Intensity Adjustment
handles.x = handles.mx;
handles.y = handles.my;
%handles.pop = get(handles.popupmenu2,'Value');
%pop=handles.pop;
if handles.gray==1
    handles.pop = 2;
else
    handles.pop = 1;
end
flag = handles.x*handles.y;   % if any marker is selected
if flag~=0
    defaultanswer={num2str(handles.nof)};
    en=inputdlg('Last Frame to process','Input',1,defaultanswer);
    if size(en)

        handles.en = eval(char(en));

        h = waitbar(0,'Please wait...');
        handles.I=[];
        clear If1;
        [handles.I,Map] = frame2im(handles.mov(1,handles.n));
        handles.I = imadjustment(handles);
        guidata(hObject, handles);
        If1 = handles.I(handles.y:handles.y+handles.h,handles.x:handles.x+handles.w,:);

        sz = size(handles.I);
        handles.st = handles.n;
        st = handles.st;
        en = handles.en;
        if st>=en
            warndlg('Your selected range of frames is incorrect');
            st = en+1;
        end

        for i = st:en
            waitbar((i-st)/(en-st),h)
            clear I
            %if (vel>10) & velflag
            %[I1,Map] = frame2im(handles.mov(1,i-1));
            %[I2,Map] = frame2im(handles.mov(1,i));
            %I = I2-I1;
            %else
            [I,Map] = frame2im(handles.mov(1,i));
            %end

            x1 = handles.x-xl;
            x2 = handles.x+handles.w+xr;
            y1 = handles.y-yu;
            y2 = handles.y+handles.h+yd;
            %a = [x1,y1,x2-x1,y2-y1]
            if y1<1, y1=1, end
            if x1<1, x1=1, end
            if y2+1>sz(1), y2=sz(1)-1, end
            if x2+1>sz(2), x2=sz(2)-1, end
            handles.I=[];
            handles.I = I(y1:y2,x1:x2,:);
            handles.I = imadjustment(handles);
            guidata(hObject, handles);
            %*************************

            switch handles.pop
                case 1
                    [ey,ex,val] = fndc(handles.I,If1,1);
                case 2
                    [ey,ex,val] = fnd(handles.I,If1,1);
            end

            k=1;
            v(i-st+1) = val;
            handles.x = ex(k) + handles.x - xl - 1;
            handles.y = ey(k) + handles.y - yu - 1;

            if handles.y<1, break, end
            if handles.x<1, break, end
            if (handles.y+handles.h+1)>sz(1), break, end
            if (handles.x+handles.w+1)>sz(2), break, end

            clear If1
            If1 = I(handles.y:handles.y+handles.h,handles.x:handles.x+handles.w,:);

            clear fy
            clear fx

            %******************************************************************
            if handles.Centroid_Flag==true;
                for ina = [ist:0.01:0.99]
                    mean_point_flag = true;
                    clear Ia;
                    clear ce;
                    Ia = imadjust(If1,[ina; 1],[0; 1]);
                    L1 = bwlabel(rgb2gray(Ia));
                    stats = regionprops(L1,'Centroid','Area');
                    ssz = size(stats);
                    if ssz(1)==1 & stats.Area<30
                        ce = stats.Centroid;
                        fx = ce(1);
                        fy = ce(2);
                        ist = ina-0.1;
                        if ist<0.1, ist = 0.1;end
                        mean_point_flag = false;
                        break
                    end
                end
                if mean_point_flag
                    szif1 =size(If1(:,:,1));
                    fx = szif1(1)/2;
                    fy = szif1(2)/2;
                end
            else
                mx = max(max(If1(:,:,1)));
                [fy,fx] = find(If1(:,:,1) == mx);
            end

            %*********************** Manual Check subroutine ******************
            value_check=false;
            if (i-st)>1
                mean_val = mean(v(1:i-st));
                crit1 = max((val/v(i-st)), (val/v(i-st)));
                crit2 = max((val/mean_val), (val/mean_val));
                crit3 = vel/8;
                crit = max([crit1,crit2,crit3]);
                if crit>str2num(get(handles.manual_check_value,'string'));
                    value_check=true;
                end
                %[i crit1 crit2 value_check]
            end
            if handles.manual_check_flag & value_check
                set(handles.text31,'Visible','on');
                %             if handles.Centroid_Flag==false
                %                 for ina = [ist:0.01:0.99]
                %                     clear Ia
                %                     Ia = imadjust(If1,[ina; 1],[0; 1]);
                %                     L1 = bwlabel(rgb2gray(Ia));
                %                     stats = regionprops(L1,'Centroid','Area');
                %                     ssz = size(stats);
                %                     if ssz(1)==1 & stats.Area<30, break, end
                %                 end
                %             end
                %clear Ia
                %clear stats
                %clear ce
                %clear a
                %Ia = imadjust(handles.I,[ina; 1],[0; 1]);
                %L1 = bwlabel(rgb2gray(Ia));
                %stats = regionprops(L1,'Centroid','Area');
                %nom = max(size(stats));      %Number of Markers
                %if nom > 1
                %             s = 'Choose the appropriate Marker? ';
                %             ButtonName=questdlg(s, ...
                %                 'Markers interference', ...
                %                 'OK','Cancel','OK');
                close(h)

                [handles.I2,Map] = frame2im(handles.mov(1,i));
                szi = size(handles.I2);
                sh = szi(1);
                sw = szi(2);
                axes(handles.axes1)
                cla
                hold on,
                dd = 2*vel + 50;
                y3 = y1 - dd;
                y4 = y2 + dd;
                x3 = x1 - dd;
                x4 = x2 + dd;
                if y3<1, y3 = 1;end
                if y4>sh, y4 = sh;end
                if x3<1, x3 = 1;end
                if x4>sw, x4 = sw;end
                handles.I3 = handles.I2(y3:y4,x3:x4,:);
                imshow(handles.I3);
                %hold on,
                dx = x4-x3;
                dy = y4-y3;
                rectangle('Position',[1,1,dx-1,dy-1],'Curvature',[0,0],'EdgeColor','g')
                %rectangle('Position',[2,2,dx-2,dy-2],'Curvature',[0,0],'EdgeColor','g')
                %rectangle('Position',[3,3,dx-3,dy-3],'Curvature',[0,0],'EdgeColor','g')
                set(handles.Frame_NO,'String',i);
                set(handles.slider1,'Value',i/max(size(handles.mov)));


                %            switch ButtonName
                %                case 'OK'
                [x,y] = ginput(1);
                x = x+x3;
                y = y+y3;
                handles.x = x-round(handles.w/2);
                handles.y = y-round(handles.h/2);
                Iff = I(y-round(handles.h/2):y+round(handles.h/2),x-round(handles.w/2):x+round(handles.w/2),:);
                if handles.Centroid_Flag==true;
                    for ina = [ist:0.01:0.99]
                        mean_point_flag = true;
                        clear Ia;
                        clear ce;
                        Ia = imadjust(Iff,[ina; 1],[0; 1]);
                        L1 = bwlabel(rgb2gray(Ia));
                        stats = regionprops(L1,'Centroid','Area');
                        ssz = size(stats);
                        if ssz(1)==1 & stats.Area<30
                            ce = stats.Centroid;
                            fx = ce(1);
                            fy = ce(2);
                            ist = ina-0.1;
                            if ist<0.1, ist = 0.1;end
                            mean_point_flag = false;
                            break
                        end
                    end
                    if mean_point_flag
                        szif1 =size(Iff(:,:,1));
                        fx = szif1(1)/2;
                        fy = szif1(2)/2;
                    end
                else
                    mx = max(max(Iff(:,:,1)));
                    [fy,fx] = find(Iff(:,:,1) == mx);
                end
                %               case 'Cancel'
                %end


                %          end
                h = waitbar(0,'Please wait...');
                waitbar((i-st)/(en-st),h)
            end
            set(handles.text31,'Visible','off');
            %******************************************************************



            handles.glbx(i) = handles.x + round(fx(1)) - 1;
            handles.glby(i) = handles.y + round(fy(1)) - 1;
            clear If1;
            handles.x = handles.glbx(i) - round(handles.w/2);
            handles.y = handles.glby(i) - round(handles.h/2);
            if handles.y<1, break, end
            if handles.x<1, break, end
            if (handles.y+handles.h+1)>sz(1), break, end
            if (handles.x+handles.w+1)>sz(2), break, end
            If1 = I(handles.y:handles.y+handles.h,handles.x:handles.x+handles.w,:);


            if (i-st)>0
                dx = round(handles.glbx(i) - handles.glbx(i-1));
                dy = round(handles.glby(i) - handles.glby(i-1));
                if dx>0
                    xl = tolx + dx;
                    xr = tolx;
                else
                    xr = tolx - dx;
                    xl = tolx;
                end
                if dy>0
                    yu = toly + dy;
                    yd = toly;
                else
                    yd = toly - dy;
                    yu = toly;
                end
                vel = round(sqrt(dy^2+dx^2));
            end


            %         [handles.I2,Map] = frame2im(handles.mov(1,i));
            %         axes(handles.axes1)
            %         hold on,
            %         imshow(handles.I2);
            %         hold on,
            %         rectangle('Position',[x1,y1,x2-x1,y2-y1],'Curvature',[0.2,0.2],'EdgeColor','g')
            %         ButtonName=questdlg('dfgh', ...
            %             'Markers interference', ...
            %             'Previous','OK','Next','OK');

        end
    close(h)
    handles.en = i-1;
    end

else
    warndlg('Before start the process you must select a marker');
end
cla reset
imageupdate(hObject,handles);
guidata(hObject, handles);


% --- Executes on slider movement.
function gray_low_Callback(hObject, eventdata, handles)
% hObject    handle to gray_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
lg = get(handles.gray_low,'Value');
handles.lg=round(lg*255);
guidata(hObject, handles);
imageupdate(hObject,handles)


% --- Executes during object creation, after setting all properties.
function gray_low_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gray_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in grayscale.
function grayscale_Callback(hObject, eventdata, handles)
% hObject    handle to grayscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function gray_high_Callback(hObject, eventdata, handles)
% hObject    handle to gray_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
hg = get(handles.gray_high,'Value');
handles.hg=round(hg*255);
guidata(hObject, handles);
imageupdate(hObject,handles)


% --- Executes during object creation, after setting all properties.
function gray_high_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gray_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in Gray_scale.
function Gray_scale_Callback(hObject, eventdata, handles)
% hObject    handle to Gray_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Gray_scale
if (get(hObject,'Value') == get(hObject,'Max'))
    % then rsdio button is selected-take approriate action
    handles.gray = 1
else
    % radio button is not selected-take approriate action
    handles.gray = 0;
end
guidata(hObject, handles);
imageupdate(hObject,handles)



% --- Executes on slider movement.
function red_low_Callback(hObject, eventdata, handles)
% hObject    handle to red_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
rl = get(handles.red_low,'Value');
handles.rl=round(rl*255);
guidata(hObject, handles);
imageupdate(hObject,handles);



% --- Executes during object creation, after setting all properties.
function red_low_CreateFcn(hObject, eventdata, handles)
% hObject    handle to red_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function red_high_Callback(hObject, eventdata, handles)
% hObject    handle to red_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
rh = get(handles.red_high,'Value');
handles.rh=round(rh*255);
guidata(hObject, handles);
imageupdate(hObject,handles)

% --- Executes during object creation, after setting all properties.
function red_high_CreateFcn(hObject, eventdata, handles)
% hObject    handle to red_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function green_low_Callback(hObject, eventdata, handles)
% hObject    handle to green_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
gl = get(handles.green_low,'Value');
handles.gl=round(gl*255);
guidata(hObject, handles);
imageupdate(hObject,handles)


% --- Executes during object creation, after setting all properties.
function green_low_CreateFcn(hObject, eventdata, handles)
% hObject    handle to green_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function green_high_Callback(hObject, eventdata, handles)
% hObject    handle to green_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
gh = get(handles.green_high,'Value');
handles.gh=round(gh*255);
guidata(hObject, handles);
imageupdate(hObject,handles)


% --- Executes during object creation, after setting all properties.
function green_high_CreateFcn(hObject, eventdata, handles)
% hObject    handle to green_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function blue_low_Callback(hObject, eventdata, handles)
% hObject    handle to blue_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
bl = get(handles.blue_low,'Value');
handles.bl=round(bl*255);
guidata(hObject, handles);
imageupdate(hObject,handles)


% --- Executes during object creation, after setting all properties.
function blue_low_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blue_low (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function blue_high_Callback(hObject, eventdata, handles)
% hObject    handle to blue_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
bh = get(handles.blue_high,'Value');
handles.bh=round(bh*255);
guidata(hObject, handles);
imageupdate(hObject,handles)


% --- Executes during object creation, after setting all properties.
function blue_high_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blue_high (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function imageupdate(hObject,handles)
[handles.I,Map] = frame2im(handles.mov(1,handles.n));
guidata(hObject, handles);
handles.I = imadjustment(handles);

axes(handles.axes1)
hold on,
imshow(handles.I);



if handles.path == 1
    hold on
    plot(handles.glbx(handles.st:handles.en),handles.glby(handles.st:handles.en),'color','g')
    if ~isnan(handles.glbx(handles.n))
        hold on,plot(handles.glbx(handles.n),handles.glby(handles.n),'o')
    end
end

if handles.path == 2
    for i = 1:handles.marker
        clear px;
        clear px;
        px=handles.posx(i,:)';
        py=handles.posy(i,:)';
        hold on,axes(handles.axes1)
        py
        plot(px,py,'color','g')
        if ~isnan(handles.posx(handles.n))
            pxm=handles.posx(i,handles.n)';
            pym=handles.posy(i,handles.n)';
            hold on,plot(pxm,pym,'o')
        end
    end
end

%set(handles.hp,'Position',[150 280 300 20]);
guidata(hObject, handles);

% --- Executes on button press in select_marker.
function select_marker_Callback(hObject, eventdata, handles)
% hObject    handle to select_marker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.marker==0
    warndlg('To Continue First Enter The Marker Name');
else
    %set(IProcessing,'Pointer','crosshair')
    %k = waitforbuttonpress;
    %point1 = get(gca,'CurrentPoint');    % button down detected
    %p = point1(1,1:2);                   % extract x and y
    %x = p(1); y = p(2);
    [x,y] = ginput(1);
    handles.h = round(str2double(get(handles.Marker_Height,'String')));
    handles.w = round(str2double(get(handles.Marker_Width,'String')));
    handles.h2 = round(str2double(get(handles.Marker_Height2,'String')));
    handles.w2 = round(str2double(get(handles.Marker_Width2,'String')));
    handles.mx = fix(x) - round(handles.w/2)+1;
    handles.my = fix(y) - round(handles.h/2)+1;
    handles.posi(handles.marker) = handles.n;
    axes(handles.axes1);
    tolx = round((handles.w2-handles.w)/2);
    toly = round((handles.h2-handles.h)/2);
    rectangle('Position',[handles.mx,handles.my,handles.w,handles.h],'Curvature',[0.2,0.2],'EdgeColor','g')
    rectangle('Position',[handles.mx-tolx,handles.my-toly,handles.w2,handles.h2],'Curvature',[0.2,0.2],'EdgeColor','r')
    %set(IProcessing,'Pointer','arrow')
    guidata(hObject, handles);
end

% --- Executes on button press in Auto_adjust.
function Auto_adjust_Callback(hObject, eventdata, handles)
% hObject    handle to Auto_adjust (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[I,Map] = frame2im(handles.mov(1,handles.n));
If1 = I(handles.y:handles.y+handles.h,handles.x:handles.x+handles.w,:);
clear I;
red = ((If1(:,:,1)>handles.rl) & (If1(:,:,1)<handles.rh))*1;
I = uint8(red).*If1(:,:,1);

%I=rgb2gray(If1);
%I=If1(:,:,1);
%figure,imshow(I),title('original image');
BWs = edge(I, 'sobel', (graythresh(I) * .1));
%figure, imshow(BWs), title('binary gradient mask');
se90 = strel('line', 2, 90);
se0 = strel('line', 2, 0);
BWsdil = imdilate(BWs, [se90 se0]);
%figure, imshow(BWsdil), title('dilated gradient mask');
BWdfill = imfill(BWsdil, 'holes');
figure, imshow(BWdfill);title('binary image with filled holes');
%  item = {If1};
%  label = {'BWdfill'};
%  def = {'B'};
%  export2wsdlg(label, def, item, 'Export to Workspace');

%g = size(If1);
sz = sum(sum(BWdfill))

r = sum(sum(If1(:,:,1).*uint8(BWdfill)))/sz
g = sum(sum(If1(:,:,2).*uint8(BWdfill)))/sz
b = sum(sum(If1(:,:,3).*uint8(BWdfill)))/sz
z=1;
dr = sqrt(sum(sum((If1(:,:,1).*uint8(BWdfill) - r).^2)))/z
dg = sqrt(sum(sum((If1(:,:,2).*uint8(BWdfill) - g).^2)))/z
db = sqrt(sum(sum((If1(:,:,3).*uint8(BWdfill) - b).^2)))/z

handles.rl = r - dr;
handles.rh = r + dr;
handles.gl = g - dg;
handles.gh = g + dg;
handles.bl = b - db;
handles.bh = b + db;
if handles.rl<1, handles.rl=1; end
if handles.gl<1, handles.gl=1; end
if handles.bl<1, handles.bl=1; end
if handles.rh>255, handles.rh=255; end
if handles.gh>255, handles.gh=255; end
if handles.bh>255, handles.bh=255; end
set(handles.red_low,'Value',handles.rl/255);
set(handles.red_high,'Value',handles.rh/255);
set(handles.green_low,'Value',handles.gl/255);
set(handles.green_high,'Value',handles.gh/255);
set(handles.blue_low,'Value',handles.bl/255);
set(handles.blue_high,'Value',handles.bh/255);
guidata(hObject, handles);
imageupdate(hObject,handles)


% --- Executes on button press in De_select_marker.
function De_select_marker_Callback(hObject, eventdata, handles)
% hObject    handle to De_select_marker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imageupdate(hObject,handles)
handles.mx=0;
handles.my=0;
guidata(hObject, handles);


% --- Executes on button press in move_up.
function move_up_Callback(hObject, eventdata, handles)
% hObject    handle to move_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imageupdate(hObject,handles)
handles.mx = handles.mx;
handles.my = handles.my - 1;
axes(handles.axes1)
tolx = round((handles.w2-handles.w)/2);
toly = round((handles.h2-handles.h)/2);
rectangle('Position',[handles.mx,handles.my,handles.w,handles.h],'Curvature',[0.2,0.2],'EdgeColor','g')
rectangle('Position',[handles.mx-tolx,handles.my-toly,handles.w2,handles.h2],'Curvature',[0.2,0.2],'EdgeColor','r')
guidata(hObject, handles);


% --- Executes on button press in move_right.
function move_right_Callback(hObject, eventdata, handles)
% hObject    handle to move_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imageupdate(hObject,handles)
handles.mx = handles.mx + 1;
handles.my = handles.my;
axes(handles.axes1)
tolx = round((handles.w2-handles.w)/2);
toly = round((handles.h2-handles.h)/2);
rectangle('Position',[handles.mx,handles.my,handles.w,handles.h],'Curvature',[0.2,0.2],'EdgeColor','g')
rectangle('Position',[handles.mx-tolx,handles.my-toly,handles.w2,handles.h2],'Curvature',[0.2,0.2],'EdgeColor','r')
guidata(hObject, handles);


% --- Executes on button press in move_down.
function move_down_Callback(hObject, eventdata, handles)
% hObject    handle to move_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imageupdate(hObject,handles)
handles.mx = handles.mx;
handles.my = handles.my + 1;
axes(handles.axes1)
tolx = round((handles.w2-handles.w)/2);
toly = round((handles.h2-handles.h)/2);
rectangle('Position',[handles.mx,handles.my,handles.w,handles.h],'Curvature',[0.2,0.2],'EdgeColor','g')
rectangle('Position',[handles.mx-tolx,handles.my-toly,handles.w2,handles.h2],'Curvature',[0.2,0.2],'EdgeColor','r')
guidata(hObject, handles);


% --- Executes on button press in move_left.
function move_left_Callback(hObject, eventdata, handles)
% hObject    handle to move_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imageupdate(hObject,handles)
handles.mx = handles.mx - 1;
handles.my = handles.my;
axes(handles.axes1)
tolx = round((handles.w2-handles.w)/2);
toly = round((handles.h2-handles.h)/2);
rectangle('Position',[handles.mx,handles.my,handles.w,handles.h],'Curvature',[0.2,0.2],'EdgeColor','g')
rectangle('Position',[handles.mx-tolx,handles.my-toly,handles.w2,handles.h2],'Curvature',[0.2,0.2],'EdgeColor','r')
guidata(hObject, handles);



function Marker_Height_Callback(hObject, eventdata, handles)
% hObject    handle to Marker_Height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Marker_Height as text
%        str2double(get(hObject,'String')) returns contents of Marker_Height as a double


% --- Executes during object creation, after setting all properties.
function Marker_Height_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Marker_Height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Marker_Width_Callback(hObject, eventdata, handles)
% hObject    handle to Marker_Width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Marker_Width as text
%        str2double(get(hObject,'String')) returns contents of Marker_Width as a double


% --- Executes during object creation, after setting all properties.
function Marker_Width_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Marker_Width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Database.
function Database_Callback(hObject, eventdata, handles)
% hObject    handle to Database (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.marker==0
    warndlg('To Continue First Enter The Marker Name');
else
    prompt={'From frame #:','To frame #:'};
    name='Range of frames to save';
    numlines=1;
    defaultanswer={num2str(handles.st),num2str(handles.en)};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    st = eval(char(answer(1)));
    en = eval(char(answer(2)));
    handles.posx(handles.marker,st:en) = handles.glbx(1,st:en);
    handles.posy(handles.marker,st:en)= handles.glby(1,st:en);
    guidata(hObject, handles);
end
imageupdate(hObject,handles);

% --- Executes on button press in Marker_name.
function Marker_name_Callback(hObject, eventdata, handles)
% hObject    handle to Marker_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.marker = handles.marker+1;
prompt={'Enter a title for the new marker'};
name='Marker Title';
numlines=1;
s = ['Marker_No_' , num2str(handles.marker)];
defaultanswer={s};
name=inputdlg(prompt,name,numlines,defaultanswer);
if size(name)
    handles.name(handles.marker,1:max(size(name))) = name;
    handles.posx(handles.marker,1:handles.nof) = NaN;
    handles.posy(handles.marker,1:handles.nof) = NaN;
    handles.glbx(1:handles.nof) = NaN;
    handles.glby(1:handles.nof) = NaN;
    guidata(hObject, handles);
end



function Marker_Height2_Callback(hObject, eventdata, handles)
% hObject    handle to Marker_Height2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Marker_Height2 as text
%        str2double(get(hObject,'String')) returns contents of Marker_Height2 as a double


% --- Executes during object creation, after setting all properties.
function Marker_Height2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Marker_Height2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Marker_width2_Callback(hObject, eventdata, handles)
% hObject    handle to Marker_width2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Marker_width2 as text
%        str2double(get(hObject,'String')) returns contents of Marker_width2 as a double


% --- Executes during object creation, after setting all properties.
function Marker_width2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Marker_width2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Marker_Width2_Callback(hObject, eventdata, handles)
% hObject    handle to Marker_Width2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Marker_Width2 as text
%        str2double(get(hObject,'String')) returns contents of Marker_Width2 as a double


% --- Executes during object creation, after setting all properties.
function Marker_Width2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Marker_Width2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function File_menu_Callback(hObject, eventdata, handles)
% hObject    handle to File_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function load_workspace_Callback(hObject, eventdata, handles)
% hObject    handle to load_workspace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp(' please wait ... ');
disp(' Loading data from Workspace ... ');
handles.mov = [];
handles.glbx = [];
handles.glby = [];
handles.glbx = 1;  %Global X-Coordinate of the Marker
handles.glby = 1;  %Global Y-Coordinate of the Marker

handles.mov = evalin('base','F');

handles.nof = max(size(handles.mov));
handles.n = handles.nof;
set(handles.slider1,'Value',1);
set(handles.Frame_NO,'String',handles.n);
[handles.I,Map] = frame2im(handles.mov(1,handles.n));
disp(' Loading Process completed ');
[handles.I,Map] = frame2im(handles.mov(1,handles.n));
guidata(hObject, handles);
handles.I = imadjustment(handles);
set(handles.slider1,'SliderStep',[1/handles.nof;.1])

axes(handles.axes1)
cla
hold on,
imshow(handles.I);
% if handles.first == 0
%     handles.hp = impixelinfo;
%     set(handles.hp,'Position',[150 280 300 20]);
%     handles.first = 1;
% end
guidata(hObject, handles);

% --------------------------------------------------------------------
function Open_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Open_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clc;
[filename, pathname] = uigetfile('*.avi', 'Pick an avi-file');
if isequal(filename,0)
    disp('User selected Cancel')
else
    file = fullfile(pathname, filename)
    disp(['User selected', file])
    name = ['Iprocessing - ' file];
    set(IProcessing,'Name',name)
    pack
    handles.I = [];
    handles.mov = [];
    handles.glbx = [];
    handles.glby = [];
    handles.glbx = 1;  %Global X-Coordinate of the Marker
    handles.glby = 1;  %Global Y-Coordinate of the Marker

    handles.mov = aviread(file);
    handles.nof = max(size(handles.mov));
    handles.n = handles.nof;
    set(handles.slider1,'Value',1);
    set(handles.Frame_NO,'String',handles.n);
    [handles.I,Map] = frame2im(handles.mov(1,handles.n));
    guidata(hObject, handles);
    handles.I = imadjustment(handles);
    axes(handles.axes1)
    cla
    hold on,imshow(handles.I);
    set(handles.slider1,'SliderStep',[1/handles.nof;.1])
    handles.glbx(1:handles.nof) = NaN;
    handles.glby(1:handles.nof) = NaN;
    guidata(hObject, handles);
end
% --------------------------------------------------------------------
function Open_excel_Callback(hObject, eventdata, handles)
% hObject    handle to Open_excel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
[filename, pathname] = uigetfile('*.xls', 'Pick an xls-file');
if isequal(filename,0)
    disp('User selected Cancel')
else
    file = fullfile(pathname, filename)
    disp(['User selected', file])
    [N T] = xlsread(file);
    Nsz = size(N);
    handles.marker = (Nsz(2)-2)/2;
    handles.posy = [];
    handles.posx = [];
    %handles.name = {};
    handles.Originx = N(1,1);
    handles.Originy = N(1,2);
    handles.Scalex  = N(2,1);
    handles.Scaley  = N(2,2);
    handles.Scalefx = N(3,1);
    handles.Scalefy = N(3,2);
    guidata(hObject, handles);
    for i=1:handles.marker
        ss = T(1,2*i+1);
        handles.name(i,1:max(size(ss))) = ss;
        handles.posx(i,:) = round((N(6:end,2*i+1)*(handles.Scalex-handles.Originx)/handles.Scalefx)+handles.Originx);
        handles.posy(i,:) = round((N(6:end,2*i+2)*(handles.Scaley-handles.Originy)/handles.Scalefy)+handles.Originy);
        handles.posx(i,abs(handles.posx(i,:))>65535)=NaN;
        handles.posy(i,abs(handles.posy(i,:))>65535)=NaN;
    end
    hg = handles.posx;
    hg
    size(hg)
    handles.path = 2;
    set(handles.All_markers,'Value',1)
    guidata(hObject, handles);
    imageupdate(hObject,handles);

end

% --------------------------------------------------------------------
function Save_as_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Save_as_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uiputfile('*.xls', 'Save As...');
if isequal(filename,0) | isequal(pathname,0)
    disp('User selected Cancel')
else
    file = fullfile(pathname,filename);
    disp(['User selected: ',file])
    % open an Excel Server.
    e = actxserver('excel.application');

    % Insert a new workbook.
    eWorkbook = e.Workbooks.Add;
    e.Visible = 0;

    % Make the first sheet active.
    eSheets = e.ActiveWorkbook.Sheets;

    eSheet1 = eSheets.get('Item', 1);
    eSheet1.Activate;

    %     eActivesheetRange = e.Activesheet.get('Range', 'A1:A1');
    %     eActivesheetRange.Value = 'Origin X';
    %     eActivesheetRange = e.Activesheet.get('Range', 'B1:B1');
    %     eActivesheetRange.Value = 'Origin Y';
    %     eActivesheetRange = e.Activesheet.get('Range', 'C1:C1');
    %     eActivesheetRange.Value = 'Scale X';
    %     eActivesheetRange = e.Activesheet.get('Range', 'D1:D1');
    %     eActivesheetRange.Value = 'Scale Y';
    %     eActivesheetRange = e.Activesheet.get('Range', 'E1:E1');
    %     eActivesheetRange.Value = 'Scale FX';
    %     eActivesheetRange = e.Activesheet.get('Range', 'F1:F1');
    %     eActivesheetRange.Value = 'Scale FY';

    eActivesheetRange = e.Activesheet.get('Range', 'A1:A1');
    eActivesheetRange.Value = handles.Originx;
    eActivesheetRange = e.Activesheet.get('Range', 'B1:B1');
    eActivesheetRange.Value = handles.Originy;
    eActivesheetRange = e.Activesheet.get('Range', 'A2:A2');
    eActivesheetRange.Value = handles.Scalex;
    eActivesheetRange = e.Activesheet.get('Range', 'B2:B2');
    eActivesheetRange.Value = handles.Scaley;
    eActivesheetRange = e.Activesheet.get('Range', 'A3:A3');
    eActivesheetRange.Value = handles.Scalefx;
    eActivesheetRange = e.Activesheet.get('Range', 'B3:B3');
    eActivesheetRange.Value = handles.Scalefy;

    % Put a MATLAB array into Excel.
    eActivesheetRange = e.Activesheet.get('Range', 'A5:A5');
    eActivesheetRange.Value = 'Frame No';
    eActivesheetRange = e.Activesheet.get('Range', 'B5:B5');
    eActivesheetRange.Value = 'Time';
    nof = [1:handles.nof]';
    s = ['A6:A',num2str(handles.nof+5)];
    eActivesheetRange = e.Activesheet.get('Range', s);
    eActivesheetRange.Value = nof;
    handles.marker

    for i = 1:handles.marker
        s = [char(66+2*i-1),'4:',char(66+2*i-1),'4'];
        eActivesheetRange = e.Activesheet.get('Range', s);
        eActivesheetRange.Value = handles.name(i,:);

        s = [char(66+2*i-1),'5:',char(66+2*i-1),'5'];
        eActivesheetRange = e.Activesheet.get('Range', s);
        eActivesheetRange.Value = 'X';
        s = [char(66+2*i),'5:',char(66+2*i),'5'];
        eActivesheetRange = e.Activesheet.get('Range', s);
        eActivesheetRange.Value = 'Y';

        clear a;
        a=((handles.posx(i,:)-handles.Originx)*handles.Scalefx/(handles.Scalex-handles.Originx))';
        %s = [char(66+2*i-1),num2str(5+handles.posi(i)),':',char(66+2*i-1),num2str(handles.posi(i)+max(size(a))+5)]
        s = [char(66+2*i-1),num2str(6),':',char(66+2*i-1),num2str(handles.nof)]
        eActivesheetRange = e.Activesheet.get('Range', s);
        eActivesheetRange.Value = round(1000*a)/1000;

        clear a;
        a=((handles.posy(i,:)-handles.Originy)*handles.Scalefy/(handles.Scaley-handles.Originy))';
        %a=handles.posy(i,:)';
        %    s = [char(66+2*i),num2str(5+handles.posi(i)),':',char(66+2*i),num2str(handles.posi(i)+max(size(a))+5)]
        s = [char(66+2*i),num2str(6),':',char(66+2*i),num2str(handles.nof)];
        eActivesheetRange = e.Activesheet.get('Range', s);
        eActivesheetRange.Value = round(1000*a)/1000;
    end

    % Get back a range.  It will be a cell array, since the cell range
    % can contain different types of data.
    %    eRange = e.Activesheet.get('Range', 'A1:B2');
    %    B = eRange.Value;

    % Convert to a double matrix.  The cell array must contain only
    % scalars.
    %    B = reshape([B{:}], size(B));

    % Now, save the workbook.
    eWorkbook.SaveAs(file);

    % To avoid saving the workbook and being prompted to do so,
    % uncomment the following code.
    eWorkbook.Saved = 1;
    eWorkbook.Close;

    % Quit Excel and delete the server.
    e.Quit;
    e.delete;

end
% --------------------------------------------------------------------
function Save_jpeg_Callback(hObject, eventdata, handles)
% hObject    handle to Save_jpeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uiputfile('*.jpg', 'Save As...');
if isequal(filename,0) | isequal(pathname,0)
    disp('User selected Cancel')
else
    [handles.I,Map] = frame2im(handles.mov(1,handles.n));
    handles.I = imadjustment(handles);
    imwrite(handles.I,filename,'jpg')
    %guidata(hObject, handles);
end

% --------------------------------------------------------------------
function exit_menu_Callback(hObject, eventdata, handles)
% hObject    handle to exit_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close

% --------------------------------------------------------------------
function Help_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Help_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Help_contents_Callback(hObject, eventdata, handles)
% hObject    handle to Help_contents (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
HelpPath = which('improc.html');
web(HelpPath);
% --------------------------------------------------------------------
function about_Callback(hObject, eventdata, handles)
% hObject    handle to about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

str = sprintf(['Human Motion Tracer - Image Processing 1.1.1\n\n',...
    'Sharif University of Technology\n',...
    'Mechanical Engineering Department\n\n',...
    'Copyright 2004-2006 The Microjects, Inc.\n']);
msgbox(str,'About the Human Motion Tracer','modal');


% --- Executes on button press in last_marker.
function last_marker_Callback(hObject, eventdata, handles)
% hObject    handle to last_marker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of last_marker
handles.path = 1;%get (handles.last_marker,'Value');
guidata(hObject, handles);
imageupdate(hObject,handles);

% --- Executes on button press in All_markers.
function All_markers_Callback(hObject, eventdata, handles)
% hObject    handle to All_markers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of All_markers
handles.path = 2;%*get (handles.All_markers,'Value');
guidata(hObject, handles);
imageupdate(hObject,handles);


% --------------------------------------------------------------------
function Markers_path_Callback(hObject, eventdata, handles)
% hObject    handle to Markers_path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[handles.I,Map] = frame2im(handles.mov(1,handles.n));
guidata(hObject, handles);
handles.I = imadjustment(handles);


figure,imshow(handles.I);

hold on
if handles.path == 1
    plot(handles.glbx(handles.st:handles.en),handles.glby(handles.st:handles.en),'color','g')
    plot(handles.glbx(handles.n),handles.glby(handles.n),'o')
end

if handles.path == 2
    for i = 1:handles.marker
        clear px;
        clear px;
        px=handles.posx(i,:)';
        py=handles.posy(i,:)';
        pxm=handles.posx(i,handles.n)';
        pym=handles.posy(i,handles.n)';
        hold on
        plot(px,py,'color','g')
        plot(pxm,pym,'o')
    end
end
guidata(hObject, handles);


% --- Executes on button press in Centroid.
function Centroid_Callback(hObject, eventdata, handles)
% hObject    handle to Centroid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Centroid

handles.Centroid_Flag = get(handles.Centroid,'Value');
guidata(hObject, handles);


% --- Executes on button press in manual_check.
function manual_check_Callback(hObject, eventdata, handles)
% hObject    handle to manual_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of manual_check
handles.manual_check_flag = get(handles.manual_check,'Value');
if handles.manual_check_flag
    set(handles.manual_check_value,'Visible','on');
else
    set(handles.manual_check_value,'Visible','off');
end
guidata(hObject, handles);



function manual_check_value_Callback(hObject, eventdata, handles)
% hObject    handle to manual_check_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of manual_check_value as text
%        str2double(get(hObject,'String')) returns contents of manual_check_value as a double


% --- Executes during object creation, after setting all properties.
function manual_check_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to manual_check_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Origin.
function Origin_Callback(hObject, eventdata, handles)
% hObject    handle to Origin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[x,y] = ginput(1);
handles.Originx = round(x);
handles.Originy = round(y);
hold on;
plot(x,y,'o','color','g')
guidata(hObject, handles);


% --- Executes on button press in X_Scale.
function X_Scale_Callback(hObject, eventdata, handles)
% hObject    handle to X_Scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[x,y] = ginput(1);
handles.Scalex = round(x);
hold on;
plot(x,handles.Originy,'o','color','g')
defaultanswer={num2str(1)};
en=inputdlg('Enter The Scale Factor of your selected X-Axis','Input',1,defaultanswer);
handles.Scalefx = eval(char(en));
guidata(hObject, handles);


% --- Executes on button press in Y_Scale.
function Y_Scale_Callback(hObject, eventdata, handles)
% hObject    handle to Y_Scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[x,y] = ginput(1);
handles.Scaley = round(y);
hold on;
plot(handles.Originx,y,'o','color','g')
defaultanswer={num2str(1)};
en=inputdlg('Enter The Scale Factor of your selected Y-Axis','Input',1,defaultanswer);
handles.Scalefy = eval(char(en));
guidata(hObject, handles);


