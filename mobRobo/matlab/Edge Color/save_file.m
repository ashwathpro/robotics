function save_file%to save image.user UI
clc;
global color_image;
load color_image;

   prompt={''};
   %prompt is an cell array..
   dlgTitle='Enter the File Name';
   def={'Enter the File name'};
   i1=inputdlg(prompt,dlgTitle,1,def);
   i=i1{1,1};%search or cell command ..go to celldisp(i1)
   %i=input('Enter the File Name in the current directory\n','s');
   %ALSO USE UIGETFILE .INTESTING FUNCTION,POPS UP WINDOW TO BE USED 
   %FOR BROWSING AND GETTING THE DESIRED FILE
   %[FILE,PATHNAME]=UIGETFILE('*.*','UR TITLE ON THE WINDOW TOP LEFT');
  if(exist(i))
      a=warndlg('The File Already Exists');
     if(a)
         pause(2);
     end
     save_file;
  else      
      imwrite(color_image,i);
  end 