var AWIN = AWIN || {};
AWIN.Widgeter = AWIN.Widgeter || {};

AWIN.Widgeter.Decorate = {
    cleanup : function() {
	    // hide empty image holders
	    var aImageHolders = this.getElementsByClassName('aw_product_image');
	    for (var i in aImageHolders) {
	        if (aImageHolders[i].innerHTML == '') {
	            aImageHolders[i].style.display = 'none';
	        }
	    }
	},
	
	walkTheDOM : function(oNode, fFunction) {
	    fFunction(oNode);
	    oNode = oNode.firstChild;
	    while (oNode) {
	        this.walkTheDOM(oNode, fFunction);
	        oNode = oNode.nextSibling;
	    }
    },

	getElementsByClassName : function(sClassName) {
	    var results = [];
	    this.walkTheDOM(document.body, function (oNode) {
	        var a, c = oNode.className, i;
	        if (c) {
	            a = c.split(' ');
	            for (i=0;i<a.length;i++) {
	                if (a[i]===sClassName) {
	                    results.push(oNode);
	                    break;
	                }
	            }
	        }
	    });
	    return results;
	}
};

AWIN.Widgeter.Decorate.cleanup();
