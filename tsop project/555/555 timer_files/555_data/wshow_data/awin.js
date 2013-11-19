var AWIN = AWIN || {};
AWIN.Widgeter = AWIN.Widgeter || {};

AWIN.Widgeter.centerImages = function() {
	var aImgs = this.getElementsByClassName('aw_product_img');
	for (var i=0;i<aImgs.length;i++) {
		if (aImgs[i].offsetHeight!=70 && aImgs[i].offsetHeight!=0 && aImgs[i].offsetHeight!='') {
			aImgs[i].style.marginTop = Math.round((70-aImgs[i].offsetHeight)/2);
		}
	}
};

AWIN.Widgeter.walkTheDOM = function(oNode, fFunction) {
	fFunction(oNode);
	oNode = oNode.firstChild;
	while (oNode) {
		this.walkTheDOM(oNode, fFunction);
		oNode = oNode.nextSibling;
	}
}

AWIN.Widgeter.getElementsByClassName = function(sClassName) {
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
};

//AWIN.Widgeter.centerImages();
