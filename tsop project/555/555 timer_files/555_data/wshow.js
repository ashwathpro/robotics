var AWIN = AWIN || {};

AWIN.Widgeter = {};

AWIN.Widgeter.oWidget = {
	iId:        '25903',
	iWidth:     '120',
	iHeight:    '240',
	iAffiliate: '77139'
};
AWIN.Widgeter.sServerName = "www";
AWIN.Widgeter.iRandom     =  523753;



AWIN.Widgeter.sHookSrc    = decodeURI("http://www.awin1.com/wshow.js?s=108630");

AWIN.Widgeter.findHook = function() {
	var aScripts   = document.getElementsByTagName('script');
	
	this.iLinkId   = 0;
	this.sClickRef = '';
	
	
	for (var i=0; i<aScripts.length; i++) {
		if (aScripts[i].src == this.sHookSrc) {
			var aArguments = aScripts[i].src.substring(aScripts[i].src.lastIndexOf('?')+1).split('&');
			for (j=0; j<aArguments.length; j++)
			{
				var aPair = aArguments[j].split('=');
				if (aPair[0]=='s') this.iLinkId = aPair[1];
				if (aPair[0]=='clickref') this.sClickRef = aPair[1];
			}	
			this.oHook = aScripts[i];
			break;
		}
	}
};

// Render the widget.
AWIN.Widgeter.renderWidget = function() {
	this.findHook();
	
	if(!window.awinCats){
	   awinCats=''; 
	}
	
	if(!window.keyword){
	   keyword=''; 
	}
	
	var oIFrame               = document.createElement('iframe');
	oIFrame.src               = 'http://'+this.sServerName+'.awin1.com/wshow.php?'
	                          + 'i='+this.oWidget.iId+'&s='+this.iLinkId+'&r='+this.oWidget.iAffiliate+'&clickref='
	                          + this.sClickRef+'&rdm='+this.iRandom+'&referrer='+encodeURIComponent(window.location.href)
	                          +'&c='+awinCats+'&q='+keyword;
	oIFrame.width             = this.oWidget.iWidth;
	oIFrame.height            = this.oWidget.iHeight;
	oIFrame.allowTransparency = true;
	oIFrame.scrolling         = 'no';
	oIFrame.marginWidth       = 0;
	oIFrame.marginHeight      = 0;
	oIFrame.frameBorder       = 0;
	this.oHook.parentNode.insertBefore(oIFrame, this.oHook);
};
AWIN.Widgeter.renderWidget();