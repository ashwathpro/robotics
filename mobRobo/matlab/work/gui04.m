function gui04

  figure('MenuBar','none','Name','Gui04','NumberTitle','off','Position',[200,200,500,160]);

  p = uibuttongroup('Position',[.05,.05,.45,.45]);
  q = uibuttongroup('Position',[.5,.5,.45,.45]);

  uicontrol('Style','RadioButton','String','June','Position',[30,110,60,20],'Parent',p);
  uicontrol('Style','RadioButton','String','July','Position',[30,70,60,20],'Parent',q);
  uicontrol('Style','RadioButton','String','August','Position',[30,30,60,20],'Parent',p);

