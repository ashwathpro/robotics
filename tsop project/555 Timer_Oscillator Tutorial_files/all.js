

var SearchEngineEnum = {
  Scour:   0,
  Google:  1,
  Yahoo:   2,
  MSN:     3,
  YouTube: 4
};

var SortByEnum = {
  Scour:0,
  Google:1,
  Yahoo:2,
  MSN:3
};

var userSettings = {
  disabledSearchTypes: true,
  disableSafeSearch: false,
  googleWeight: 100,
  numYahooResults: 10,
  numGoogleResults: 8,
  yahooWeight: 100,
  msnWeight: 100,
  showSortingButtons: true,
  openLinksInVotingFrame: true,
  sortResultsBy: SortByEnum.Scour,
  username: '',
  userid: '',
  showflydown: true,
  showpostfirstsearchpopup: true,
  numMSNResults: 10,
  isSurveyVisited: false,
  showHomePageBox: true,
  introSearches: 0,
  showSearchPsst: true,
  showWebAwardBox: true,

  isLoggedIn: function()
  {
    return this.username != '';
  },

  restoreDefaults: function()
  {
    this.disabledSearchTypes = true;
    this.disableSafeSearch = false;
    this.googleWeight = 100;
    this.numYahooResults = 10;
    this.yahooWeight = 100;
    this.msnWeight = 100;
    this.showSortingButtons = true;
    this.openLinksInVotingFrame = true;
    this.numMSNResults = 10;
    this.numGoogleResults = 10;
    cookies.saveSettings();
  }
};
window.userSettings = userSettings;

function CookieManager() {}
CookieManager.prototype =
{
  getCookie: function(name, defaultValueP)
  {
    var nameEQ = name + "=";
    var ca = document.cookie.split(';');
    for(var i=0;i < ca.length;i++) {
	    var c = ca[i];
	    while (c.charAt(0)==' ') c = c.substring(1,c.length);
	    if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
    }
    return defaultValueP;
  },

  setCookie: function(name,value,days)
  {
    var expires;
    if (days) {
		  var date = new Date();
		  date.setTime(date.getTime()+(days*24*60*60*1000));
		  expires = "; expires="+date.toGMTString();
	  }
	  else expires = "";
	  document.cookie = name+"="+value+expires+"; path=/";
  },

  clearCookie: function(name)
  {
    this.setCookie(name, "");
  }
}

function AppCookies() {}

AppCookies.prototype = 
{
  load: function()
  {
    this.loadSettings(); 
  },

  loadSettings: function()
  {
    cm = new CookieManager();
    var u = userSettings;
    u.disabledSearchTypes = cm.getCookie('disabledSearchTypes', 'true') == 'true';
    u.disableSafeSearch = cm.getCookie('disableSafeSearch', 'true') == 'true';
    u.googleWeight = Number(cm.getCookie('googleWeight', 100));
    u.numYahooResults = Number(cm.getCookie('numYahooResults', 10));
    u.yahooWeight = Number(cm.getCookie('yahooWeight', 100));
    u.msnWeight = Number(cm.getCookie('msnWeight', 100));
    u.showSortingButtons = cm.getCookie('showSortingButtons', 'true') == 'true';
    u.showSU = cm.getCookie('showSU', 'false') == 'true';
    u.sortResultsBy = cm.getCookie('sortResultsBy', SortByEnum.Scour);
    u.username = cm.getCookie('username', '');
    u.userid = cm.getCookie('userid', '');
    u.openLinksInVotingFrame = cm.getCookie('openLinksInVotingFrame', 'true') == 'true';
    u.showflydown = cm.getCookie('showflydown', 'true') == 'true';
    u.showpostfirstsearchpopup = cm.getCookie('showpostfirstsearchpopup', 'true') == 'true';
    u.numMSNResults = Number(cm.getCookie('numMSNResults', 10));
    u.isSurveyVisited = cm.getCookie('isSurveyVisited', 'false') == 'true';
    u.showHomePageBox = cm.getCookie('showHomePageBox', 'true') == 'true';
    u.introSearches = Number(cm.getCookie('introSearches', 0));
    u.showSearchPsst = cm.getCookie('showSearchPsst', 'true') == 'true';
    u.showWebAwardBox = cm.getCookie('showWebAwardBox', 'true') == 'true';
    u.numGoogleResults = cm.getCookie('numGoogleResults', 8);
  },

  saveSettings: function()
  {
    cm = new CookieManager();
    var u = userSettings;
    var days = 365;
    cm.setCookie('disabledSearchTypes', u.disabledSearchTypes, days);
    cm.setCookie('disableSafeSearch', u.disableSafeSearch, days);
    cm.setCookie('googleWeight', u.googleWeight, days);
    cm.setCookie('numYahooResults', u.numYahooResults, days);
    cm.setCookie('yahooWeight', u.yahooWeight, days);
    cm.setCookie('msnWeight', u.msnWeight, days);
    cm.setCookie('showSortingButtons', u.showSortingButtons, days);
    cm.setCookie('sortResultsBy', SortByEnum.Scour, days);
    cm.setCookie('showflydown', u.showflydown, days);
    cm.setCookie('openLinksInVotingFrame', u.openLinksInVotingFrame, days);
    cm.setCookie('showpostfirstsearchpopup', u.showpostfirstsearchpopup, days);
    cm.setCookie('numMSNResults', u.numMSNResults, days);
    cm.setCookie('isSurveyVisited', u.isSurveyVisited, days);
    cm.setCookie('showHomePageBox', u.showHomePageBox, days);
    cm.setCookie('introSearches', u.introSearches, days);
    cm.setCookie('showSearchPsst', u.showSearchPsst, days);
    cm.setCookie('showWebAwardBox', u.showWebAwardBox, days);    
    cm.setCookie('numGoogleResults', u.numGoogleResults, days);    
  },

  setSurveyVisisted:function()
  {
    userSettings.isSurveyVisited = true;

    this.saveSettings();
  },

  setShowedSearchPsst:function()
  {
    userSettings.isSurveyVisited = true;

    this.saveSettings();
  }

}

var cookies = new AppCookies();
cookies.load();

/*
 * jQuery 1.2.6 - New Wave Javascript
 *
 * Copyright (c) 2008 John Resig (jquery.com)
 * Dual licensed under the MIT (MIT-LICENSE.txt)
 * and GPL (GPL-LICENSE.txt) licenses.
 *
 * $Date: 2008-05-24 14:22:17 -0400 (Sat, 24 May 2008) $
 * $Rev: 5685 $
 */
(function(){var _jQuery=window.jQuery,_$=window.$;var jQuery=window.jQuery=window.$=function(selector,context){return new jQuery.fn.init(selector,context);};var quickExpr=/^[^<]*(<(.|\s)+>)[^>]*$|^#(\w+)$/,isSimple=/^.[^:#\[\.]*$/,undefined;jQuery.fn=jQuery.prototype={init:function(selector,context){selector=selector||document;if(selector.nodeType){this[0]=selector;this.length=1;return this;}if(typeof selector=="string"){var match=quickExpr.exec(selector);if(match&&(match[1]||!context)){if(match[1])selector=jQuery.clean([match[1]],context);else{var elem=document.getElementById(match[3]);if(elem){if(elem.id!=match[3])return jQuery().find(selector);return jQuery(elem);}selector=[];}}else
return jQuery(context).find(selector);}else if(jQuery.isFunction(selector))return jQuery(document)[jQuery.fn.ready?"ready":"load"](selector);return this.setArray(jQuery.makeArray(selector));},jquery:"1.2.6",size:function(){return this.length;},length:0,get:function(num){return num==undefined?jQuery.makeArray(this):this[num];},pushStack:function(elems){var ret=jQuery(elems);ret.prevObject=this;return ret;},setArray:function(elems){this.length=0;Array.prototype.push.apply(this,elems);return this;},each:function(callback,args){return jQuery.each(this,callback,args);},index:function(elem){var ret=-1;return jQuery.inArray(elem&&elem.jquery?elem[0]:elem,this);},attr:function(name,value,type){var options=name;if(name.constructor==String)if(value===undefined)return this[0]&&jQuery[type||"attr"](this[0],name);else{options={};options[name]=value;}return this.each(function(i){for(name in options)jQuery.attr(type?this.style:this,name,jQuery.prop(this,options[name],type,i,name));});},css:function(key,value){if((key=='width'||key=='height')&&parseFloat(value)<0)value=undefined;return this.attr(key,value,"curCSS");},text:function(text){if(typeof text!="object"&&text!=null)return this.empty().append((this[0]&&this[0].ownerDocument||document).createTextNode(text));var ret="";jQuery.each(text||this,function(){jQuery.each(this.childNodes,function(){if(this.nodeType!=8)ret+=this.nodeType!=1?this.nodeValue:jQuery.fn.text([this]);});});return ret;},wrapAll:function(html){if(this[0])jQuery(html,this[0].ownerDocument).clone().insertBefore(this[0]).map(function(){var elem=this;while(elem.firstChild)elem=elem.firstChild;return elem;}).append(this);return this;},wrapInner:function(html){return this.each(function(){jQuery(this).contents().wrapAll(html);});},wrap:function(html){return this.each(function(){jQuery(this).wrapAll(html);});},append:function(){return this.domManip(arguments,true,false,function(elem){if(this.nodeType==1)this.appendChild(elem);});},prepend:function(){return this.domManip(arguments,true,true,function(elem){if(this.nodeType==1)this.insertBefore(elem,this.firstChild);});},before:function(){return this.domManip(arguments,false,false,function(elem){this.parentNode.insertBefore(elem,this);});},after:function(){return this.domManip(arguments,false,true,function(elem){this.parentNode.insertBefore(elem,this.nextSibling);});},end:function(){return this.prevObject||jQuery([]);},find:function(selector){var elems=jQuery.map(this,function(elem){return jQuery.find(selector,elem);});return this.pushStack(/[^+>] [^+>]/.test(selector)||selector.indexOf("..")>-1?jQuery.unique(elems):elems);},clone:function(events){var ret=this.map(function(){if(jQuery.browser.msie&&!jQuery.isXMLDoc(this)){var clone=this.cloneNode(true),container=document.createElement("div");container.appendChild(clone);return jQuery.clean([container.innerHTML])[0];}else
return this.cloneNode(true);});var clone=ret.find("*").andSelf().each(function(){if(this[expando]!=undefined)this[expando]=null;});if(events===true)this.find("*").andSelf().each(function(i){if(this.nodeType==3)return;var events=jQuery.data(this,"events");for(var type in events)for(var handler in events[type])jQuery.event.add(clone[i],type,events[type][handler],events[type][handler].data);});return ret;},filter:function(selector){return this.pushStack(jQuery.isFunction(selector)&&jQuery.grep(this,function(elem,i){return selector.call(elem,i);})||jQuery.multiFilter(selector,this));},not:function(selector){if(selector.constructor==String)if(isSimple.test(selector))return this.pushStack(jQuery.multiFilter(selector,this,true));else
selector=jQuery.multiFilter(selector,this);var isArrayLike=selector.length&&selector[selector.length-1]!==undefined&&!selector.nodeType;return this.filter(function(){return isArrayLike?jQuery.inArray(this,selector)<0:this!=selector;});},add:function(selector){return this.pushStack(jQuery.unique(jQuery.merge(this.get(),typeof selector=='string'?jQuery(selector):jQuery.makeArray(selector))));},is:function(selector){return!!selector&&jQuery.multiFilter(selector,this).length>0;},hasClass:function(selector){return this.is("."+selector);},val:function(value){if(value==undefined){if(this.length){var elem=this[0];if(jQuery.nodeName(elem,"select")){var index=elem.selectedIndex,values=[],options=elem.options,one=elem.type=="select-one";if(index<0)return null;for(var i=one?index:0,max=one?index+1:options.length;i<max;i++){var option=options[i];if(option.selected){value=jQuery.browser.msie&&!option.attributes.value.specified?option.text:option.value;if(one)return value;values.push(value);}}return values;}else
return(this[0].value||"").replace(/\r/g,"");}return undefined;}if(value.constructor==Number)value+='';return this.each(function(){if(this.nodeType!=1)return;if(value.constructor==Array&&/radio|checkbox/.test(this.type))this.checked=(jQuery.inArray(this.value,value)>=0||jQuery.inArray(this.name,value)>=0);else if(jQuery.nodeName(this,"select")){var values=jQuery.makeArray(value);jQuery("option",this).each(function(){this.selected=(jQuery.inArray(this.value,values)>=0||jQuery.inArray(this.text,values)>=0);});if(!values.length)this.selectedIndex=-1;}else
this.value=value;});},html:function(value){return value==undefined?(this[0]?this[0].innerHTML:null):this.empty().append(value);},replaceWith:function(value){return this.after(value).remove();},eq:function(i){return this.slice(i,i+1);},slice:function(){return this.pushStack(Array.prototype.slice.apply(this,arguments));},map:function(callback){return this.pushStack(jQuery.map(this,function(elem,i){return callback.call(elem,i,elem);}));},andSelf:function(){return this.add(this.prevObject);},data:function(key,value){var parts=key.split(".");parts[1]=parts[1]?"."+parts[1]:"";if(value===undefined){var data=this.triggerHandler("getData"+parts[1]+"!",[parts[0]]);if(data===undefined&&this.length)data=jQuery.data(this[0],key);return data===undefined&&parts[1]?this.data(parts[0]):data;}else
return this.trigger("setData"+parts[1]+"!",[parts[0],value]).each(function(){jQuery.data(this,key,value);});},removeData:function(key){return this.each(function(){jQuery.removeData(this,key);});},domManip:function(args,table,reverse,callback){var clone=this.length>1,elems;return this.each(function(){if(!elems){elems=jQuery.clean(args,this.ownerDocument);if(reverse)elems.reverse();}var obj=this;if(table&&jQuery.nodeName(this,"table")&&jQuery.nodeName(elems[0],"tr"))obj=this.getElementsByTagName("tbody")[0]||this.appendChild(this.ownerDocument.createElement("tbody"));var scripts=jQuery([]);jQuery.each(elems,function(){var elem=clone?jQuery(this).clone(true)[0]:this;if(jQuery.nodeName(elem,"script"))scripts=scripts.add(elem);else{if(elem.nodeType==1)scripts=scripts.add(jQuery("script",elem).remove());callback.call(obj,elem);}});scripts.each(evalScript);});}};jQuery.fn.init.prototype=jQuery.fn;function evalScript(i,elem){if(elem.src)jQuery.ajax({url:elem.src,async:false,dataType:"script"});else
jQuery.globalEval(elem.text||elem.textContent||elem.innerHTML||"");if(elem.parentNode)elem.parentNode.removeChild(elem);}function now(){return+new Date;}jQuery.extend=jQuery.fn.extend=function(){var target=arguments[0]||{},i=1,length=arguments.length,deep=false,options;if(target.constructor==Boolean){deep=target;target=arguments[1]||{};i=2;}if(typeof target!="object"&&typeof target!="function")target={};if(length==i){target=this;--i;}for(;i<length;i++)if((options=arguments[i])!=null)for(var name in options){var src=target[name],copy=options[name];if(target===copy)continue;if(deep&&copy&&typeof copy=="object"&&!copy.nodeType)target[name]=jQuery.extend(deep,src||(copy.length!=null?[]:{}),copy);else if(copy!==undefined)target[name]=copy;}return target;};var expando="jQuery"+now(),uuid=0,windowData={},exclude=/z-?index|font-?weight|opacity|zoom|line-?height/i,defaultView=document.defaultView||{};jQuery.extend({noConflict:function(deep){window.$=_$;if(deep)window.jQuery=_jQuery;return jQuery;},isFunction:function(fn){return!!fn&&typeof fn!="string"&&!fn.nodeName&&fn.constructor!=Array&&/^[\s[]?function/.test(fn+"");},isXMLDoc:function(elem){return elem.documentElement&&!elem.body||elem.tagName&&elem.ownerDocument&&!elem.ownerDocument.body;},globalEval:function(data){data=jQuery.trim(data);if(data){var head=document.getElementsByTagName("head")[0]||document.documentElement,script=document.createElement("script");script.type="text/javascript";if(jQuery.browser.msie)script.text=data;else
script.appendChild(document.createTextNode(data));head.insertBefore(script,head.firstChild);head.removeChild(script);}},nodeName:function(elem,name){return elem.nodeName&&elem.nodeName.toUpperCase()==name.toUpperCase();},cache:{},data:function(elem,name,data){elem=elem==window?windowData:elem;var id=elem[expando];if(!id)id=elem[expando]=++uuid;if(name&&!jQuery.cache[id])jQuery.cache[id]={};if(data!==undefined)jQuery.cache[id][name]=data;return name?jQuery.cache[id][name]:id;},removeData:function(elem,name){elem=elem==window?windowData:elem;var id=elem[expando];if(name){if(jQuery.cache[id]){delete jQuery.cache[id][name];name="";for(name in jQuery.cache[id])break;if(!name)jQuery.removeData(elem);}}else{try{delete elem[expando];}catch(e){if(elem.removeAttribute)elem.removeAttribute(expando);}delete jQuery.cache[id];}},each:function(object,callback,args){var name,i=0,length=object.length;if(args){if(length==undefined){for(name in object)if(callback.apply(object[name],args)===false)break;}else
for(;i<length;)if(callback.apply(object[i++],args)===false)break;}else{if(length==undefined){for(name in object)if(callback.call(object[name],name,object[name])===false)break;}else
for(var value=object[0];i<length&&callback.call(value,i,value)!==false;value=object[++i]){}}return object;},prop:function(elem,value,type,i,name){if(jQuery.isFunction(value))value=value.call(elem,i);return value&&value.constructor==Number&&type=="curCSS"&&!exclude.test(name)?value+"px":value;},className:{add:function(elem,classNames){jQuery.each((classNames||"").split(/\s+/),function(i,className){if(elem.nodeType==1&&!jQuery.className.has(elem.className,className))elem.className+=(elem.className?" ":"")+className;});},remove:function(elem,classNames){if(elem.nodeType==1)elem.className=classNames!=undefined?jQuery.grep(elem.className.split(/\s+/),function(className){return!jQuery.className.has(classNames,className);}).join(" "):"";},has:function(elem,className){return jQuery.inArray(className,(elem.className||elem).toString().split(/\s+/))>-1;}},swap:function(elem,options,callback){var old={};for(var name in options){old[name]=elem.style[name];elem.style[name]=options[name];}callback.call(elem);for(var name in options)elem.style[name]=old[name];},css:function(elem,name,force){if(name=="width"||name=="height"){var val,props={position:"absolute",visibility:"hidden",display:"block"},which=name=="width"?["Left","Right"]:["Top","Bottom"];function getWH(){val=name=="width"?elem.offsetWidth:elem.offsetHeight;var padding=0,border=0;jQuery.each(which,function(){padding+=parseFloat(jQuery.curCSS(elem,"padding"+this,true))||0;border+=parseFloat(jQuery.curCSS(elem,"border"+this+"Width",true))||0;});val-=Math.round(padding+border);}if(jQuery(elem).is(":visible"))getWH();else
jQuery.swap(elem,props,getWH);return Math.max(0,val);}return jQuery.curCSS(elem,name,force);},curCSS:function(elem,name,force){var ret,style=elem.style;function color(elem){if(!jQuery.browser.safari)return false;var ret=defaultView.getComputedStyle(elem,null);return!ret||ret.getPropertyValue("color")=="";}if(name=="opacity"&&jQuery.browser.msie){ret=jQuery.attr(style,"opacity");return ret==""?"1":ret;}if(jQuery.browser.opera&&name=="display"){var save=style.outline;style.outline="0 solid black";style.outline=save;}if(name.match(/float/i))name=styleFloat;if(!force&&style&&style[name])ret=style[name];else if(defaultView.getComputedStyle){if(name.match(/float/i))name="float";name=name.replace(/([A-Z])/g,"-$1").toLowerCase();var computedStyle=defaultView.getComputedStyle(elem,null);if(computedStyle&&!color(elem))ret=computedStyle.getPropertyValue(name);else{var swap=[],stack=[],a=elem,i=0;for(;a&&color(a);a=a.parentNode)stack.unshift(a);for(;i<stack.length;i++)if(color(stack[i])){swap[i]=stack[i].style.display;stack[i].style.display="block";}ret=name=="display"&&swap[stack.length-1]!=null?"none":(computedStyle&&computedStyle.getPropertyValue(name))||"";for(i=0;i<swap.length;i++)if(swap[i]!=null)stack[i].style.display=swap[i];}if(name=="opacity"&&ret=="")ret="1";}else if(elem.currentStyle){var camelCase=name.replace(/\-(\w)/g,function(all,letter){return letter.toUpperCase();});ret=elem.currentStyle[name]||elem.currentStyle[camelCase];if(!/^\d+(px)?$/i.test(ret)&&/^\d/.test(ret)){var left=style.left,rsLeft=elem.runtimeStyle.left;elem.runtimeStyle.left=elem.currentStyle.left;style.left=ret||0;ret=style.pixelLeft+"px";style.left=left;elem.runtimeStyle.left=rsLeft;}}return ret;},clean:function(elems,context){var ret=[];context=context||document;if(typeof context.createElement=='undefined')context=context.ownerDocument||context[0]&&context[0].ownerDocument||document;jQuery.each(elems,function(i,elem){if(!elem)return;if(elem.constructor==Number)elem+='';if(typeof elem=="string"){elem=elem.replace(/(<(\w+)[^>]*?)\/>/g,function(all,front,tag){return tag.match(/^(abbr|br|col|img|input|link|meta|param|hr|area|embed)$/i)?all:front+"></"+tag+">";});var tags=jQuery.trim(elem).toLowerCase(),div=context.createElement("div");var wrap=!tags.indexOf("<opt")&&[1,"<select multiple='multiple'>","</select>"]||!tags.indexOf("<leg")&&[1,"<fieldset>","</fieldset>"]||tags.match(/^<(thead|tbody|tfoot|colg|cap)/)&&[1,"<table>","</table>"]||!tags.indexOf("<tr")&&[2,"<table><tbody>","</tbody></table>"]||(!tags.indexOf("<td")||!tags.indexOf("<th"))&&[3,"<table><tbody><tr>","</tr></tbody></table>"]||!tags.indexOf("<col")&&[2,"<table><tbody></tbody><colgroup>","</colgroup></table>"]||jQuery.browser.msie&&[1,"div<div>","</div>"]||[0,"",""];div.innerHTML=wrap[1]+elem+wrap[2];while(wrap[0]--)div=div.lastChild;if(jQuery.browser.msie){var tbody=!tags.indexOf("<table")&&tags.indexOf("<tbody")<0?div.firstChild&&div.firstChild.childNodes:wrap[1]=="<table>"&&tags.indexOf("<tbody")<0?div.childNodes:[];for(var j=tbody.length-1;j>=0;--j)if(jQuery.nodeName(tbody[j],"tbody")&&!tbody[j].childNodes.length)tbody[j].parentNode.removeChild(tbody[j]);if(/^\s/.test(elem))div.insertBefore(context.createTextNode(elem.match(/^\s*/)[0]),div.firstChild);}elem=jQuery.makeArray(div.childNodes);}if(elem.length===0&&(!jQuery.nodeName(elem,"form")&&!jQuery.nodeName(elem,"select")))return;if(elem[0]==undefined||jQuery.nodeName(elem,"form")||elem.options)ret.push(elem);else
ret=jQuery.merge(ret,elem);});return ret;},attr:function(elem,name,value){if(!elem||elem.nodeType==3||elem.nodeType==8)return undefined;var notxml=!jQuery.isXMLDoc(elem),set=value!==undefined,msie=jQuery.browser.msie;name=notxml&&jQuery.props[name]||name;if(elem.tagName){var special=/href|src|style/.test(name);if(name=="selected"&&jQuery.browser.safari)elem.parentNode.selectedIndex;if(name in elem&&notxml&&!special){if(set){if(name=="type"&&jQuery.nodeName(elem,"input")&&elem.parentNode)throw"type property can't be changed";elem[name]=value;}if(jQuery.nodeName(elem,"form")&&elem.getAttributeNode(name))return elem.getAttributeNode(name).nodeValue;return elem[name];}if(msie&&notxml&&name=="style")return jQuery.attr(elem.style,"cssText",value);if(set)elem.setAttribute(name,""+value);var attr=msie&&notxml&&special?elem.getAttribute(name,2):elem.getAttribute(name);return attr===null?undefined:attr;}if(msie&&name=="opacity"){if(set){elem.zoom=1;elem.filter=(elem.filter||"").replace(/alpha\([^)]*\)/,"")+(parseInt(value)+''=="NaN"?"":"alpha(opacity="+value*100+")");}return elem.filter&&elem.filter.indexOf("opacity=")>=0?(parseFloat(elem.filter.match(/opacity=([^)]*)/)[1])/100)+'':"";}name=name.replace(/-([a-z])/ig,function(all,letter){return letter.toUpperCase();});if(set)elem[name]=value;return elem[name];},trim:function(text){return(text||"").replace(/^\s+|\s+$/g,"");},makeArray:function(array){var ret=[];if(array!=null){var i=array.length;if(i==null||array.split||array.setInterval||array.call)ret[0]=array;else
while(i)ret[--i]=array[i];}return ret;},inArray:function(elem,array){for(var i=0,length=array.length;i<length;i++)if(array[i]===elem)return i;return-1;},merge:function(first,second){var i=0,elem,pos=first.length;if(jQuery.browser.msie){while(elem=second[i++])if(elem.nodeType!=8)first[pos++]=elem;}else
while(elem=second[i++])first[pos++]=elem;return first;},unique:function(array){var ret=[],done={};try{for(var i=0,length=array.length;i<length;i++){var id=jQuery.data(array[i]);if(!done[id]){done[id]=true;ret.push(array[i]);}}}catch(e){ret=array;}return ret;},grep:function(elems,callback,inv){var ret=[];for(var i=0,length=elems.length;i<length;i++)if(!inv!=!callback(elems[i],i))ret.push(elems[i]);return ret;},map:function(elems,callback){var ret=[];for(var i=0,length=elems.length;i<length;i++){var value=callback(elems[i],i);if(value!=null)ret[ret.length]=value;}return ret.concat.apply([],ret);}});var userAgent=navigator.userAgent.toLowerCase();jQuery.browser={version:(userAgent.match(/.+(?:rv|it|ra|ie)[\/: ]([\d.]+)/)||[])[1],safari:/webkit/.test(userAgent),opera:/opera/.test(userAgent),msie:/msie/.test(userAgent)&&!/opera/.test(userAgent),mozilla:/mozilla/.test(userAgent)&&!/(compatible|webkit)/.test(userAgent)};var styleFloat=jQuery.browser.msie?"styleFloat":"cssFloat";jQuery.extend({boxModel:!jQuery.browser.msie||document.compatMode=="CSS1Compat",props:{"for":"htmlFor","class":"className","float":styleFloat,cssFloat:styleFloat,styleFloat:styleFloat,readonly:"readOnly",maxlength:"maxLength",cellspacing:"cellSpacing"}});jQuery.each({parent:function(elem){return elem.parentNode;},parents:function(elem){return jQuery.dir(elem,"parentNode");},next:function(elem){return jQuery.nth(elem,2,"nextSibling");},prev:function(elem){return jQuery.nth(elem,2,"previousSibling");},nextAll:function(elem){return jQuery.dir(elem,"nextSibling");},prevAll:function(elem){return jQuery.dir(elem,"previousSibling");},siblings:function(elem){return jQuery.sibling(elem.parentNode.firstChild,elem);},children:function(elem){return jQuery.sibling(elem.firstChild);},contents:function(elem){return jQuery.nodeName(elem,"iframe")?elem.contentDocument||elem.contentWindow.document:jQuery.makeArray(elem.childNodes);}},function(name,fn){jQuery.fn[name]=function(selector){var ret=jQuery.map(this,fn);if(selector&&typeof selector=="string")ret=jQuery.multiFilter(selector,ret);return this.pushStack(jQuery.unique(ret));};});jQuery.each({appendTo:"append",prependTo:"prepend",insertBefore:"before",insertAfter:"after",replaceAll:"replaceWith"},function(name,original){jQuery.fn[name]=function(){var args=arguments;return this.each(function(){for(var i=0,length=args.length;i<length;i++)jQuery(args[i])[original](this);});};});jQuery.each({removeAttr:function(name){jQuery.attr(this,name,"");if(this.nodeType==1)this.removeAttribute(name);},addClass:function(classNames){jQuery.className.add(this,classNames);},removeClass:function(classNames){jQuery.className.remove(this,classNames);},toggleClass:function(classNames){jQuery.className[jQuery.className.has(this,classNames)?"remove":"add"](this,classNames);},remove:function(selector){if(!selector||jQuery.filter(selector,[this]).r.length){jQuery("*",this).add(this).each(function(){jQuery.event.remove(this);jQuery.removeData(this);});if(this.parentNode)this.parentNode.removeChild(this);}},empty:function(){jQuery(">*",this).remove();while(this.firstChild)this.removeChild(this.firstChild);}},function(name,fn){jQuery.fn[name]=function(){return this.each(fn,arguments);};});jQuery.each(["Height","Width"],function(i,name){var type=name.toLowerCase();jQuery.fn[type]=function(size){return this[0]==window?jQuery.browser.opera&&document.body["client"+name]||jQuery.browser.safari&&window["inner"+name]||document.compatMode=="CSS1Compat"&&document.documentElement["client"+name]||document.body["client"+name]:this[0]==document?Math.max(Math.max(document.body["scroll"+name],document.documentElement["scroll"+name]),Math.max(document.body["offset"+name],document.documentElement["offset"+name])):size==undefined?(this.length?jQuery.css(this[0],type):null):this.css(type,size.constructor==String?size:size+"px");};});function num(elem,prop){return elem[0]&&parseInt(jQuery.curCSS(elem[0],prop,true),10)||0;}var chars=jQuery.browser.safari&&parseInt(jQuery.browser.version)<417?"(?:[\\w*_-]|\\\\.)":"(?:[\\w\u0128-\uFFFF*_-]|\\\\.)",quickChild=new RegExp("^>\\s*("+chars+"+)"),quickID=new RegExp("^("+chars+"+)(#)("+chars+"+)"),quickClass=new RegExp("^([#.]?)("+chars+"*)");jQuery.extend({expr:{"":function(a,i,m){return m[2]=="*"||jQuery.nodeName(a,m[2]);},"#":function(a,i,m){return a.getAttribute("id")==m[2];},":":{lt:function(a,i,m){return i<m[3]-0;},gt:function(a,i,m){return i>m[3]-0;},nth:function(a,i,m){return m[3]-0==i;},eq:function(a,i,m){return m[3]-0==i;},first:function(a,i){return i==0;},last:function(a,i,m,r){return i==r.length-1;},even:function(a,i){return i%2==0;},odd:function(a,i){return i%2;},"first-child":function(a){return a.parentNode.getElementsByTagName("*")[0]==a;},"last-child":function(a){return jQuery.nth(a.parentNode.lastChild,1,"previousSibling")==a;},"only-child":function(a){return!jQuery.nth(a.parentNode.lastChild,2,"previousSibling");},parent:function(a){return a.firstChild;},empty:function(a){return!a.firstChild;},contains:function(a,i,m){return(a.textContent||a.innerText||jQuery(a).text()||"").indexOf(m[3])>=0;},visible:function(a){return"hidden"!=a.type&&jQuery.css(a,"display")!="none"&&jQuery.css(a,"visibility")!="hidden";},hidden:function(a){return"hidden"==a.type||jQuery.css(a,"display")=="none"||jQuery.css(a,"visibility")=="hidden";},enabled:function(a){return!a.disabled;},disabled:function(a){return a.disabled;},checked:function(a){return a.checked;},selected:function(a){return a.selected||jQuery.attr(a,"selected");},text:function(a){return"text"==a.type;},radio:function(a){return"radio"==a.type;},checkbox:function(a){return"checkbox"==a.type;},file:function(a){return"file"==a.type;},password:function(a){return"password"==a.type;},submit:function(a){return"submit"==a.type;},image:function(a){return"image"==a.type;},reset:function(a){return"reset"==a.type;},button:function(a){return"button"==a.type||jQuery.nodeName(a,"button");},input:function(a){return/input|select|textarea|button/i.test(a.nodeName);},has:function(a,i,m){return jQuery.find(m[3],a).length;},header:function(a){return/h\d/i.test(a.nodeName);},animated:function(a){return jQuery.grep(jQuery.timers,function(fn){return a==fn.elem;}).length;}}},parse:[/^(\[) *@?([\w-]+) *([!*$^~=]*) *('?"?)(.*?)\4 *\]/,/^(:)([\w-]+)\("?'?(.*?(\(.*?\))?[^(]*?)"?'?\)/,new RegExp("^([:.#]*)("+chars+"+)")],multiFilter:function(expr,elems,not){var old,cur=[];while(expr&&expr!=old){old=expr;var f=jQuery.filter(expr,elems,not);expr=f.t.replace(/^\s*,\s*/,"");cur=not?elems=f.r:jQuery.merge(cur,f.r);}return cur;},find:function(t,context){if(typeof t!="string")return[t];if(context&&context.nodeType!=1&&context.nodeType!=9)return[];context=context||document;var ret=[context],done=[],last,nodeName;while(t&&last!=t){var r=[];last=t;t=jQuery.trim(t);var foundToken=false,re=quickChild,m=re.exec(t);if(m){nodeName=m[1].toUpperCase();for(var i=0;ret[i];i++)for(var c=ret[i].firstChild;c;c=c.nextSibling)if(c.nodeType==1&&(nodeName=="*"||c.nodeName.toUpperCase()==nodeName))r.push(c);ret=r;t=t.replace(re,"");if(t.indexOf(" ")==0)continue;foundToken=true;}else{re=/^([>+~])\s*(\w*)/i;if((m=re.exec(t))!=null){r=[];var merge={};nodeName=m[2].toUpperCase();m=m[1];for(var j=0,rl=ret.length;j<rl;j++){var n=m=="~"||m=="+"?ret[j].nextSibling:ret[j].firstChild;for(;n;n=n.nextSibling)if(n.nodeType==1){var id=jQuery.data(n);if(m=="~"&&merge[id])break;if(!nodeName||n.nodeName.toUpperCase()==nodeName){if(m=="~")merge[id]=true;r.push(n);}if(m=="+")break;}}ret=r;t=jQuery.trim(t.replace(re,""));foundToken=true;}}if(t&&!foundToken){if(!t.indexOf(",")){if(context==ret[0])ret.shift();done=jQuery.merge(done,ret);r=ret=[context];t=" "+t.substr(1,t.length);}else{var re2=quickID;var m=re2.exec(t);if(m){m=[0,m[2],m[3],m[1]];}else{re2=quickClass;m=re2.exec(t);}m[2]=m[2].replace(/\\/g,"");var elem=ret[ret.length-1];if(m[1]=="#"&&elem&&elem.getElementById&&!jQuery.isXMLDoc(elem)){var oid=elem.getElementById(m[2]);if((jQuery.browser.msie||jQuery.browser.opera)&&oid&&typeof oid.id=="string"&&oid.id!=m[2])oid=jQuery('[@id="'+m[2]+'"]',elem)[0];ret=r=oid&&(!m[3]||jQuery.nodeName(oid,m[3]))?[oid]:[];}else{for(var i=0;ret[i];i++){var tag=m[1]=="#"&&m[3]?m[3]:m[1]!=""||m[0]==""?"*":m[2];if(tag=="*"&&ret[i].nodeName.toLowerCase()=="object")tag="param";r=jQuery.merge(r,ret[i].getElementsByTagName(tag));}if(m[1]==".")r=jQuery.classFilter(r,m[2]);if(m[1]=="#"){var tmp=[];for(var i=0;r[i];i++)if(r[i].getAttribute("id")==m[2]){tmp=[r[i]];break;}r=tmp;}ret=r;}t=t.replace(re2,"");}}if(t){var val=jQuery.filter(t,r);ret=r=val.r;t=jQuery.trim(val.t);}}if(t)ret=[];if(ret&&context==ret[0])ret.shift();done=jQuery.merge(done,ret);return done;},classFilter:function(r,m,not){m=" "+m+" ";var tmp=[];for(var i=0;r[i];i++){var pass=(" "+r[i].className+" ").indexOf(m)>=0;if(!not&&pass||not&&!pass)tmp.push(r[i]);}return tmp;},filter:function(t,r,not){var last;while(t&&t!=last){last=t;var p=jQuery.parse,m;for(var i=0;p[i];i++){m=p[i].exec(t);if(m){t=t.substring(m[0].length);m[2]=m[2].replace(/\\/g,"");break;}}if(!m)break;if(m[1]==":"&&m[2]=="not")r=isSimple.test(m[3])?jQuery.filter(m[3],r,true).r:jQuery(r).not(m[3]);else if(m[1]==".")r=jQuery.classFilter(r,m[2],not);else if(m[1]=="["){var tmp=[],type=m[3];for(var i=0,rl=r.length;i<rl;i++){var a=r[i],z=a[jQuery.props[m[2]]||m[2]];if(z==null||/href|src|selected/.test(m[2]))z=jQuery.attr(a,m[2])||'';if((type==""&&!!z||type=="="&&z==m[5]||type=="!="&&z!=m[5]||type=="^="&&z&&!z.indexOf(m[5])||type=="$="&&z.substr(z.length-m[5].length)==m[5]||(type=="*="||type=="~=")&&z.indexOf(m[5])>=0)^not)tmp.push(a);}r=tmp;}else if(m[1]==":"&&m[2]=="nth-child"){var merge={},tmp=[],test=/(-?)(\d*)n((?:\+|-)?\d*)/.exec(m[3]=="even"&&"2n"||m[3]=="odd"&&"2n+1"||!/\D/.test(m[3])&&"0n+"+m[3]||m[3]),first=(test[1]+(test[2]||1))-0,last=test[3]-0;for(var i=0,rl=r.length;i<rl;i++){var node=r[i],parentNode=node.parentNode,id=jQuery.data(parentNode);if(!merge[id]){var c=1;for(var n=parentNode.firstChild;n;n=n.nextSibling)if(n.nodeType==1)n.nodeIndex=c++;merge[id]=true;}var add=false;if(first==0){if(node.nodeIndex==last)add=true;}else if((node.nodeIndex-last)%first==0&&(node.nodeIndex-last)/first>=0)add=true;if(add^not)tmp.push(node);}r=tmp;}else{var fn=jQuery.expr[m[1]];if(typeof fn=="object")fn=fn[m[2]];if(typeof fn=="string")fn=eval("false||function(a,i){return "+fn+";}");r=jQuery.grep(r,function(elem,i){return fn(elem,i,m,r);},not);}}return{r:r,t:t};},dir:function(elem,dir){var matched=[],cur=elem[dir];while(cur&&cur!=document){if(cur.nodeType==1)matched.push(cur);cur=cur[dir];}return matched;},nth:function(cur,result,dir,elem){result=result||1;var num=0;for(;cur;cur=cur[dir])if(cur.nodeType==1&&++num==result)break;return cur;},sibling:function(n,elem){var r=[];for(;n;n=n.nextSibling){if(n.nodeType==1&&n!=elem)r.push(n);}return r;}});jQuery.event={add:function(elem,types,handler,data){if(elem.nodeType==3||elem.nodeType==8)return;if(jQuery.browser.msie&&elem.setInterval)elem=window;if(!handler.guid)handler.guid=this.guid++;if(data!=undefined){var fn=handler;handler=this.proxy(fn,function(){return fn.apply(this,arguments);});handler.data=data;}var events=jQuery.data(elem,"events")||jQuery.data(elem,"events",{}),handle=jQuery.data(elem,"handle")||jQuery.data(elem,"handle",function(){if(typeof jQuery!="undefined"&&!jQuery.event.triggered)return jQuery.event.handle.apply(arguments.callee.elem,arguments);});handle.elem=elem;jQuery.each(types.split(/\s+/),function(index,type){var parts=type.split(".");type=parts[0];handler.type=parts[1];var handlers=events[type];if(!handlers){handlers=events[type]={};if(!jQuery.event.special[type]||jQuery.event.special[type].setup.call(elem)===false){if(elem.addEventListener)elem.addEventListener(type,handle,false);else if(elem.attachEvent)elem.attachEvent("on"+type,handle);}}handlers[handler.guid]=handler;jQuery.event.global[type]=true;});elem=null;},guid:1,global:{},remove:function(elem,types,handler){if(elem.nodeType==3||elem.nodeType==8)return;var events=jQuery.data(elem,"events"),ret,index;if(events){if(types==undefined||(typeof types=="string"&&types.charAt(0)=="."))for(var type in events)this.remove(elem,type+(types||""));else{if(types.type){handler=types.handler;types=types.type;}jQuery.each(types.split(/\s+/),function(index,type){var parts=type.split(".");type=parts[0];if(events[type]){if(handler)delete events[type][handler.guid];else
for(handler in events[type])if(!parts[1]||events[type][handler].type==parts[1])delete events[type][handler];for(ret in events[type])break;if(!ret){if(!jQuery.event.special[type]||jQuery.event.special[type].teardown.call(elem)===false){if(elem.removeEventListener)elem.removeEventListener(type,jQuery.data(elem,"handle"),false);else if(elem.detachEvent)elem.detachEvent("on"+type,jQuery.data(elem,"handle"));}ret=null;delete events[type];}}});}for(ret in events)break;if(!ret){var handle=jQuery.data(elem,"handle");if(handle)handle.elem=null;jQuery.removeData(elem,"events");jQuery.removeData(elem,"handle");}}},trigger:function(type,data,elem,donative,extra){data=jQuery.makeArray(data);if(type.indexOf("!")>=0){type=type.slice(0,-1);var exclusive=true;}if(!elem){if(this.global[type])jQuery("*").add([window,document]).trigger(type,data);}else{if(elem.nodeType==3||elem.nodeType==8)return undefined;var val,ret,fn=jQuery.isFunction(elem[type]||null),event=!data[0]||!data[0].preventDefault;if(event){data.unshift({type:type,target:elem,preventDefault:function(){},stopPropagation:function(){},timeStamp:now()});data[0][expando]=true;}data[0].type=type;if(exclusive)data[0].exclusive=true;var handle=jQuery.data(elem,"handle");if(handle)val=handle.apply(elem,data);if((!fn||(jQuery.nodeName(elem,'a')&&type=="click"))&&elem["on"+type]&&elem["on"+type].apply(elem,data)===false)val=false;if(event)data.shift();if(extra&&jQuery.isFunction(extra)){ret=extra.apply(elem,val==null?data:data.concat(val));if(ret!==undefined)val=ret;}if(fn&&donative!==false&&val!==false&&!(jQuery.nodeName(elem,'a')&&type=="click")){this.triggered=true;try{elem[type]();}catch(e){}}this.triggered=false;}return val;},handle:function(event){var val,ret,namespace,all,handlers;event=arguments[0]=jQuery.event.fix(event||window.event);namespace=event.type.split(".");event.type=namespace[0];namespace=namespace[1];all=!namespace&&!event.exclusive;handlers=(jQuery.data(this,"events")||{})[event.type];for(var j in handlers){var handler=handlers[j];if(all||handler.type==namespace){event.handler=handler;event.data=handler.data;ret=handler.apply(this,arguments);if(val!==false)val=ret;if(ret===false){event.preventDefault();event.stopPropagation();}}}return val;},fix:function(event){if(event[expando]==true)return event;var originalEvent=event;event={originalEvent:originalEvent};var props="altKey attrChange attrName bubbles button cancelable charCode clientX clientY ctrlKey currentTarget data detail eventPhase fromElement handler keyCode metaKey newValue originalTarget pageX pageY prevValue relatedNode relatedTarget screenX screenY shiftKey srcElement target timeStamp toElement type view wheelDelta which".split(" ");for(var i=props.length;i;i--)event[props[i]]=originalEvent[props[i]];event[expando]=true;event.preventDefault=function(){if(originalEvent.preventDefault)originalEvent.preventDefault();originalEvent.returnValue=false;};event.stopPropagation=function(){if(originalEvent.stopPropagation)originalEvent.stopPropagation();originalEvent.cancelBubble=true;};event.timeStamp=event.timeStamp||now();if(!event.target)event.target=event.srcElement||document;if(event.target.nodeType==3)event.target=event.target.parentNode;if(!event.relatedTarget&&event.fromElement)event.relatedTarget=event.fromElement==event.target?event.toElement:event.fromElement;if(event.pageX==null&&event.clientX!=null){var doc=document.documentElement,body=document.body;event.pageX=event.clientX+(doc&&doc.scrollLeft||body&&body.scrollLeft||0)-(doc.clientLeft||0);event.pageY=event.clientY+(doc&&doc.scrollTop||body&&body.scrollTop||0)-(doc.clientTop||0);}if(!event.which&&((event.charCode||event.charCode===0)?event.charCode:event.keyCode))event.which=event.charCode||event.keyCode;if(!event.metaKey&&event.ctrlKey)event.metaKey=event.ctrlKey;if(!event.which&&event.button)event.which=(event.button&1?1:(event.button&2?3:(event.button&4?2:0)));return event;},proxy:function(fn,proxy){proxy.guid=fn.guid=fn.guid||proxy.guid||this.guid++;return proxy;},special:{ready:{setup:function(){bindReady();return;},teardown:function(){return;}},mouseenter:{setup:function(){if(jQuery.browser.msie)return false;jQuery(this).bind("mouseover",jQuery.event.special.mouseenter.handler);return true;},teardown:function(){if(jQuery.browser.msie)return false;jQuery(this).unbind("mouseover",jQuery.event.special.mouseenter.handler);return true;},handler:function(event){if(withinElement(event,this))return true;event.type="mouseenter";return jQuery.event.handle.apply(this,arguments);}},mouseleave:{setup:function(){if(jQuery.browser.msie)return false;jQuery(this).bind("mouseout",jQuery.event.special.mouseleave.handler);return true;},teardown:function(){if(jQuery.browser.msie)return false;jQuery(this).unbind("mouseout",jQuery.event.special.mouseleave.handler);return true;},handler:function(event){if(withinElement(event,this))return true;event.type="mouseleave";return jQuery.event.handle.apply(this,arguments);}}}};jQuery.fn.extend({bind:function(type,data,fn){return type=="unload"?this.one(type,data,fn):this.each(function(){jQuery.event.add(this,type,fn||data,fn&&data);});},one:function(type,data,fn){var one=jQuery.event.proxy(fn||data,function(event){jQuery(this).unbind(event,one);return(fn||data).apply(this,arguments);});return this.each(function(){jQuery.event.add(this,type,one,fn&&data);});},unbind:function(type,fn){return this.each(function(){jQuery.event.remove(this,type,fn);});},trigger:function(type,data,fn){return this.each(function(){jQuery.event.trigger(type,data,this,true,fn);});},triggerHandler:function(type,data,fn){return this[0]&&jQuery.event.trigger(type,data,this[0],false,fn);},toggle:function(fn){var args=arguments,i=1;while(i<args.length)jQuery.event.proxy(fn,args[i++]);return this.click(jQuery.event.proxy(fn,function(event){this.lastToggle=(this.lastToggle||0)%i;event.preventDefault();return args[this.lastToggle++].apply(this,arguments)||false;}));},hover:function(fnOver,fnOut){return this.bind('mouseenter',fnOver).bind('mouseleave',fnOut);},ready:function(fn){bindReady();if(jQuery.isReady)fn.call(document,jQuery);else
jQuery.readyList.push(function(){return fn.call(this,jQuery);});return this;}});jQuery.extend({isReady:false,readyList:[],ready:function(){if(!jQuery.isReady){jQuery.isReady=true;if(jQuery.readyList){jQuery.each(jQuery.readyList,function(){this.call(document);});jQuery.readyList=null;}jQuery(document).triggerHandler("ready");}}});var readyBound=false;function bindReady(){if(readyBound)return;readyBound=true;if(document.addEventListener&&!jQuery.browser.opera)document.addEventListener("DOMContentLoaded",jQuery.ready,false);if(jQuery.browser.msie&&window==top)(function(){if(jQuery.isReady)return;try{document.documentElement.doScroll("left");}catch(error){setTimeout(arguments.callee,0);return;}jQuery.ready();})();if(jQuery.browser.opera)document.addEventListener("DOMContentLoaded",function(){if(jQuery.isReady)return;for(var i=0;i<document.styleSheets.length;i++)if(document.styleSheets[i].disabled){setTimeout(arguments.callee,0);return;}jQuery.ready();},false);if(jQuery.browser.safari){var numStyles;(function(){if(jQuery.isReady)return;if(document.readyState!="loaded"&&document.readyState!="complete"){setTimeout(arguments.callee,0);return;}if(numStyles===undefined)numStyles=jQuery("style, link[rel=stylesheet]").length;if(document.styleSheets.length!=numStyles){setTimeout(arguments.callee,0);return;}jQuery.ready();})();}jQuery.event.add(window,"load",jQuery.ready);}jQuery.each(("blur,focus,load,resize,scroll,unload,click,dblclick,"+"mousedown,mouseup,mousemove,mouseover,mouseout,change,select,"+"submit,keydown,keypress,keyup,error").split(","),function(i,name){jQuery.fn[name]=function(fn){return fn?this.bind(name,fn):this.trigger(name);};});var withinElement=function(event,elem){var parent=event.relatedTarget;while(parent&&parent!=elem)try{parent=parent.parentNode;}catch(error){parent=elem;}return parent==elem;};jQuery(window).bind("unload",function(){jQuery("*").add(document).unbind();});jQuery.fn.extend({_load:jQuery.fn.load,load:function(url,params,callback){if(typeof url!='string')return this._load(url);var off=url.indexOf(" ");if(off>=0){var selector=url.slice(off,url.length);url=url.slice(0,off);}callback=callback||function(){};var type="GET";if(params)if(jQuery.isFunction(params)){callback=params;params=null;}else{params=jQuery.param(params);type="POST";}var self=this;jQuery.ajax({url:url,type:type,dataType:"html",data:params,complete:function(res,status){if(status=="success"||status=="notmodified")self.html(selector?jQuery("<div/>").append(res.responseText.replace(/<script(.|\s)*?\/script>/g,"")).find(selector):res.responseText);self.each(callback,[res.responseText,status,res]);}});return this;},serialize:function(){return jQuery.param(this.serializeArray());},serializeArray:function(){return this.map(function(){return jQuery.nodeName(this,"form")?jQuery.makeArray(this.elements):this;}).filter(function(){return this.name&&!this.disabled&&(this.checked||/select|textarea/i.test(this.nodeName)||/text|hidden|password/i.test(this.type));}).map(function(i,elem){var val=jQuery(this).val();return val==null?null:val.constructor==Array?jQuery.map(val,function(val,i){return{name:elem.name,value:val};}):{name:elem.name,value:val};}).get();}});jQuery.each("ajaxStart,ajaxStop,ajaxComplete,ajaxError,ajaxSuccess,ajaxSend".split(","),function(i,o){jQuery.fn[o]=function(f){return this.bind(o,f);};});var jsc=now();jQuery.extend({get:function(url,data,callback,type){if(jQuery.isFunction(data)){callback=data;data=null;}return jQuery.ajax({type:"GET",url:url,data:data,success:callback,dataType:type});},getScript:function(url,callback){return jQuery.get(url,null,callback,"script");},getJSON:function(url,data,callback){return jQuery.get(url,data,callback,"json");},post:function(url,data,callback,type){if(jQuery.isFunction(data)){callback=data;data={};}return jQuery.ajax({type:"POST",url:url,data:data,success:callback,dataType:type});},ajaxSetup:function(settings){jQuery.extend(jQuery.ajaxSettings,settings);},ajaxSettings:{url:location.href,global:true,type:"GET",timeout:0,contentType:"application/x-www-form-urlencoded",processData:true,async:true,data:null,username:null,password:null,accepts:{xml:"application/xml, text/xml",html:"text/html",script:"text/javascript, application/javascript",json:"application/json, text/javascript",text:"text/plain",_default:"*/*"}},lastModified:{},ajax:function(s){s=jQuery.extend(true,s,jQuery.extend(true,{},jQuery.ajaxSettings,s));var jsonp,jsre=/=\?(&|$)/g,status,data,type=s.type.toUpperCase();if(s.data&&s.processData&&typeof s.data!="string")s.data=jQuery.param(s.data);if(s.dataType=="jsonp"){if(type=="GET"){if(!s.url.match(jsre))s.url+=(s.url.match(/\?/)?"&":"?")+(s.jsonp||"callback")+"=?";}else if(!s.data||!s.data.match(jsre))s.data=(s.data?s.data+"&":"")+(s.jsonp||"callback")+"=?";s.dataType="json";}if(s.dataType=="json"&&(s.data&&s.data.match(jsre)||s.url.match(jsre))){jsonp="jsonp"+jsc++;if(s.data)s.data=(s.data+"").replace(jsre,"="+jsonp+"$1");s.url=s.url.replace(jsre,"="+jsonp+"$1");s.dataType="script";window[jsonp]=function(tmp){data=tmp;success();complete();window[jsonp]=undefined;try{delete window[jsonp];}catch(e){}if(head)head.removeChild(script);};}if(s.dataType=="script"&&s.cache==null)s.cache=false;if(s.cache===false&&type=="GET"){var ts=now();var ret=s.url.replace(/(\?|&)_=.*?(&|$)/,"$1_="+ts+"$2");s.url=ret+((ret==s.url)?(s.url.match(/\?/)?"&":"?")+"_="+ts:"");}if(s.data&&type=="GET"){s.url+=(s.url.match(/\?/)?"&":"?")+s.data;s.data=null;}if(s.global&&!jQuery.active++)jQuery.event.trigger("ajaxStart");var remote=/^(?:\w+:)?\/\/([^\/?#]+)/;if(s.dataType=="script"&&type=="GET"&&remote.test(s.url)&&remote.exec(s.url)[1]!=location.host){var head=document.getElementsByTagName("head")[0];var script=document.createElement("script");script.src=s.url;if(s.scriptCharset)script.charset=s.scriptCharset;if(!jsonp){var done=false;script.onload=script.onreadystatechange=function(){if(!done&&(!this.readyState||this.readyState=="loaded"||this.readyState=="complete")){done=true;success();complete();head.removeChild(script);}};}head.appendChild(script);return undefined;}var requestDone=false;var xhr=window.ActiveXObject?new ActiveXObject("Microsoft.XMLHTTP"):new XMLHttpRequest();if(s.username)xhr.open(type,s.url,s.async,s.username,s.password);else
xhr.open(type,s.url,s.async);try{if(s.data)xhr.setRequestHeader("Content-Type",s.contentType);if(s.ifModified)xhr.setRequestHeader("If-Modified-Since",jQuery.lastModified[s.url]||"Thu, 01 Jan 1970 00:00:00 GMT");xhr.setRequestHeader("X-Requested-With","XMLHttpRequest");xhr.setRequestHeader("Accept",s.dataType&&s.accepts[s.dataType]?s.accepts[s.dataType]+", */*":s.accepts._default);}catch(e){}if(s.beforeSend&&s.beforeSend(xhr,s)===false){s.global&&jQuery.active--;xhr.abort();return false;}if(s.global)jQuery.event.trigger("ajaxSend",[xhr,s]);var onreadystatechange=function(isTimeout){if(!requestDone&&xhr&&(xhr.readyState==4||isTimeout=="timeout")){requestDone=true;if(ival){clearInterval(ival);ival=null;}status=isTimeout=="timeout"&&"timeout"||!jQuery.httpSuccess(xhr)&&"error"||s.ifModified&&jQuery.httpNotModified(xhr,s.url)&&"notmodified"||"success";if(status=="success"){try{data=jQuery.httpData(xhr,s.dataType,s.dataFilter);}catch(e){status="parsererror";}}if(status=="success"){var modRes;try{modRes=xhr.getResponseHeader("Last-Modified");}catch(e){}if(s.ifModified&&modRes)jQuery.lastModified[s.url]=modRes;if(!jsonp)success();}else
jQuery.handleError(s,xhr,status);complete();if(s.async)xhr=null;}};if(s.async){var ival=setInterval(onreadystatechange,13);if(s.timeout>0)setTimeout(function(){if(xhr){xhr.abort();if(!requestDone)onreadystatechange("timeout");}},s.timeout);}try{xhr.send(s.data);}catch(e){jQuery.handleError(s,xhr,null,e);}if(!s.async)onreadystatechange();function success(){if(s.success)s.success(data,status);if(s.global)jQuery.event.trigger("ajaxSuccess",[xhr,s]);}function complete(){if(s.complete)s.complete(xhr,status);if(s.global)jQuery.event.trigger("ajaxComplete",[xhr,s]);if(s.global&&!--jQuery.active)jQuery.event.trigger("ajaxStop");}return xhr;},handleError:function(s,xhr,status,e){if(s.error)s.error(xhr,status,e);if(s.global)jQuery.event.trigger("ajaxError",[xhr,s,e]);},active:0,httpSuccess:function(xhr){try{return!xhr.status&&location.protocol=="file:"||(xhr.status>=200&&xhr.status<300)||xhr.status==304||xhr.status==1223||jQuery.browser.safari&&xhr.status==undefined;}catch(e){}return false;},httpNotModified:function(xhr,url){try{var xhrRes=xhr.getResponseHeader("Last-Modified");return xhr.status==304||xhrRes==jQuery.lastModified[url]||jQuery.browser.safari&&xhr.status==undefined;}catch(e){}return false;},httpData:function(xhr,type,filter){var ct=xhr.getResponseHeader("content-type"),xml=type=="xml"||!type&&ct&&ct.indexOf("xml")>=0,data=xml?xhr.responseXML:xhr.responseText;if(xml&&data.documentElement.tagName=="parsererror")throw"parsererror";if(filter)data=filter(data,type);if(type=="script")jQuery.globalEval(data);if(type=="json")data=eval("("+data+")");return data;},param:function(a){var s=[];if(a.constructor==Array||a.jquery)jQuery.each(a,function(){s.push(encodeURIComponent(this.name)+"="+encodeURIComponent(this.value));});else
for(var j in a)if(a[j]&&a[j].constructor==Array)jQuery.each(a[j],function(){s.push(encodeURIComponent(j)+"="+encodeURIComponent(this));});else
s.push(encodeURIComponent(j)+"="+encodeURIComponent(jQuery.isFunction(a[j])?a[j]():a[j]));return s.join("&").replace(/%20/g,"+");}});jQuery.fn.extend({show:function(speed,callback){return speed?this.animate({height:"show",width:"show",opacity:"show"},speed,callback):this.filter(":hidden").each(function(){this.style.display=this.oldblock||"";if(jQuery.css(this,"display")=="none"){var elem=jQuery("<"+this.tagName+" />").appendTo("body");this.style.display=elem.css("display");if(this.style.display=="none")this.style.display="block";elem.remove();}}).end();},hide:function(speed,callback){return speed?this.animate({height:"hide",width:"hide",opacity:"hide"},speed,callback):this.filter(":visible").each(function(){this.oldblock=this.oldblock||jQuery.css(this,"display");this.style.display="none";}).end();},_toggle:jQuery.fn.toggle,toggle:function(fn,fn2){return jQuery.isFunction(fn)&&jQuery.isFunction(fn2)?this._toggle.apply(this,arguments):fn?this.animate({height:"toggle",width:"toggle",opacity:"toggle"},fn,fn2):this.each(function(){jQuery(this)[jQuery(this).is(":hidden")?"show":"hide"]();});},slideDown:function(speed,callback){return this.animate({height:"show"},speed,callback);},slideUp:function(speed,callback){return this.animate({height:"hide"},speed,callback);},slideToggle:function(speed,callback){return this.animate({height:"toggle"},speed,callback);},fadeIn:function(speed,callback){return this.animate({opacity:"show"},speed,callback);},fadeOut:function(speed,callback){return this.animate({opacity:"hide"},speed,callback);},fadeTo:function(speed,to,callback){return this.animate({opacity:to},speed,callback);},animate:function(prop,speed,easing,callback){var optall=jQuery.speed(speed,easing,callback);return this[optall.queue===false?"each":"queue"](function(){if(this.nodeType!=1)return false;var opt=jQuery.extend({},optall),p,hidden=jQuery(this).is(":hidden"),self=this;for(p in prop){if(prop[p]=="hide"&&hidden||prop[p]=="show"&&!hidden)return opt.complete.call(this);if(p=="height"||p=="width"){opt.display=jQuery.css(this,"display");opt.overflow=this.style.overflow;}}if(opt.overflow!=null)this.style.overflow="hidden";opt.curAnim=jQuery.extend({},prop);jQuery.each(prop,function(name,val){var e=new jQuery.fx(self,opt,name);if(/toggle|show|hide/.test(val))e[val=="toggle"?hidden?"show":"hide":val](prop);else{var parts=val.toString().match(/^([+-]=)?([\d+-.]+)(.*)$/),start=e.cur(true)||0;if(parts){var end=parseFloat(parts[2]),unit=parts[3]||"px";if(unit!="px"){self.style[name]=(end||1)+unit;start=((end||1)/e.cur(true))*start;self.style[name]=start+unit;}if(parts[1])end=((parts[1]=="-="?-1:1)*end)+start;e.custom(start,end,unit);}else
e.custom(start,val,"");}});return true;});},queue:function(type,fn){if(jQuery.isFunction(type)||(type&&type.constructor==Array)){fn=type;type="fx";}if(!type||(typeof type=="string"&&!fn))return queue(this[0],type);return this.each(function(){if(fn.constructor==Array)queue(this,type,fn);else{queue(this,type).push(fn);if(queue(this,type).length==1)fn.call(this);}});},stop:function(clearQueue,gotoEnd){var timers=jQuery.timers;if(clearQueue)this.queue([]);this.each(function(){for(var i=timers.length-1;i>=0;i--)if(timers[i].elem==this){if(gotoEnd)timers[i](true);timers.splice(i,1);}});if(!gotoEnd)this.dequeue();return this;}});var queue=function(elem,type,array){if(elem){type=type||"fx";var q=jQuery.data(elem,type+"queue");if(!q||array)q=jQuery.data(elem,type+"queue",jQuery.makeArray(array));}return q;};jQuery.fn.dequeue=function(type){type=type||"fx";return this.each(function(){var q=queue(this,type);q.shift();if(q.length)q[0].call(this);});};jQuery.extend({speed:function(speed,easing,fn){var opt=speed&&speed.constructor==Object?speed:{complete:fn||!fn&&easing||jQuery.isFunction(speed)&&speed,duration:speed,easing:fn&&easing||easing&&easing.constructor!=Function&&easing};opt.duration=(opt.duration&&opt.duration.constructor==Number?opt.duration:jQuery.fx.speeds[opt.duration])||jQuery.fx.speeds.def;opt.old=opt.complete;opt.complete=function(){if(opt.queue!==false)jQuery(this).dequeue();if(jQuery.isFunction(opt.old))opt.old.call(this);};return opt;},easing:{linear:function(p,n,firstNum,diff){return firstNum+diff*p;},swing:function(p,n,firstNum,diff){return((-Math.cos(p*Math.PI)/2)+0.5)*diff+firstNum;}},timers:[],timerId:null,fx:function(elem,options,prop){this.options=options;this.elem=elem;this.prop=prop;if(!options.orig)options.orig={};}});jQuery.fx.prototype={update:function(){if(this.options.step)this.options.step.call(this.elem,this.now,this);(jQuery.fx.step[this.prop]||jQuery.fx.step._default)(this);if(this.prop=="height"||this.prop=="width")this.elem.style.display="block";},cur:function(force){if(this.elem[this.prop]!=null&&this.elem.style[this.prop]==null)return this.elem[this.prop];var r=parseFloat(jQuery.css(this.elem,this.prop,force));return r&&r>-10000?r:parseFloat(jQuery.curCSS(this.elem,this.prop))||0;},custom:function(from,to,unit){this.startTime=now();this.start=from;this.end=to;this.unit=unit||this.unit||"px";this.now=this.start;this.pos=this.state=0;this.update();var self=this;function t(gotoEnd){return self.step(gotoEnd);}t.elem=this.elem;jQuery.timers.push(t);if(jQuery.timerId==null){jQuery.timerId=setInterval(function(){var timers=jQuery.timers;for(var i=0;i<timers.length;i++)if(!timers[i]())timers.splice(i--,1);if(!timers.length){clearInterval(jQuery.timerId);jQuery.timerId=null;}},13);}},show:function(){this.options.orig[this.prop]=jQuery.attr(this.elem.style,this.prop);this.options.show=true;this.custom(0,this.cur());if(this.prop=="width"||this.prop=="height")this.elem.style[this.prop]="1px";jQuery(this.elem).show();},hide:function(){this.options.orig[this.prop]=jQuery.attr(this.elem.style,this.prop);this.options.hide=true;this.custom(this.cur(),0);},step:function(gotoEnd){var t=now();if(gotoEnd||t>this.options.duration+this.startTime){this.now=this.end;this.pos=this.state=1;this.update();this.options.curAnim[this.prop]=true;var done=true;for(var i in this.options.curAnim)if(this.options.curAnim[i]!==true)done=false;if(done){if(this.options.display!=null){this.elem.style.overflow=this.options.overflow;this.elem.style.display=this.options.display;if(jQuery.css(this.elem,"display")=="none")this.elem.style.display="block";}if(this.options.hide)this.elem.style.display="none";if(this.options.hide||this.options.show)for(var p in this.options.curAnim)jQuery.attr(this.elem.style,p,this.options.orig[p]);}if(done)this.options.complete.call(this.elem);return false;}else{var n=t-this.startTime;this.state=n/this.options.duration;this.pos=jQuery.easing[this.options.easing||(jQuery.easing.swing?"swing":"linear")](this.state,n,0,1,this.options.duration);this.now=this.start+((this.end-this.start)*this.pos);this.update();}return true;}};jQuery.extend(jQuery.fx,{speeds:{slow:600,fast:200,def:400},step:{scrollLeft:function(fx){fx.elem.scrollLeft=fx.now;},scrollTop:function(fx){fx.elem.scrollTop=fx.now;},opacity:function(fx){jQuery.attr(fx.elem.style,"opacity",fx.now);},_default:function(fx){fx.elem.style[fx.prop]=fx.now+fx.unit;}}});jQuery.fn.offset=function(){var left=0,top=0,elem=this[0],results;if(elem)with(jQuery.browser){var parent=elem.parentNode,offsetChild=elem,offsetParent=elem.offsetParent,doc=elem.ownerDocument,safari2=safari&&parseInt(version)<522&&!/adobeair/i.test(userAgent),css=jQuery.curCSS,fixed=css(elem,"position")=="fixed";if(elem.getBoundingClientRect){var box=elem.getBoundingClientRect();add(box.left+Math.max(doc.documentElement.scrollLeft,doc.body.scrollLeft),box.top+Math.max(doc.documentElement.scrollTop,doc.body.scrollTop));add(-doc.documentElement.clientLeft,-doc.documentElement.clientTop);}else{add(elem.offsetLeft,elem.offsetTop);while(offsetParent){add(offsetParent.offsetLeft,offsetParent.offsetTop);if(mozilla&&!/^t(able|d|h)$/i.test(offsetParent.tagName)||safari&&!safari2)border(offsetParent);if(!fixed&&css(offsetParent,"position")=="fixed")fixed=true;offsetChild=/^body$/i.test(offsetParent.tagName)?offsetChild:offsetParent;offsetParent=offsetParent.offsetParent;}while(parent&&parent.tagName&&!/^body|html$/i.test(parent.tagName)){if(!/^inline|table.*$/i.test(css(parent,"display")))add(-parent.scrollLeft,-parent.scrollTop);if(mozilla&&css(parent,"overflow")!="visible")border(parent);parent=parent.parentNode;}if((safari2&&(fixed||css(offsetChild,"position")=="absolute"))||(mozilla&&css(offsetChild,"position")!="absolute"))add(-doc.body.offsetLeft,-doc.body.offsetTop);if(fixed)add(Math.max(doc.documentElement.scrollLeft,doc.body.scrollLeft),Math.max(doc.documentElement.scrollTop,doc.body.scrollTop));}results={top:top,left:left};}function border(elem){add(jQuery.curCSS(elem,"borderLeftWidth",true),jQuery.curCSS(elem,"borderTopWidth",true));}function add(l,t){left+=parseInt(l,10)||0;top+=parseInt(t,10)||0;}return results;};jQuery.fn.extend({position:function(){var left=0,top=0,results;if(this[0]){var offsetParent=this.offsetParent(),offset=this.offset(),parentOffset=/^body|html$/i.test(offsetParent[0].tagName)?{top:0,left:0}:offsetParent.offset();offset.top-=num(this,'marginTop');offset.left-=num(this,'marginLeft');parentOffset.top+=num(offsetParent,'borderTopWidth');parentOffset.left+=num(offsetParent,'borderLeftWidth');results={top:offset.top-parentOffset.top,left:offset.left-parentOffset.left};}return results;},offsetParent:function(){var offsetParent=this[0].offsetParent;while(offsetParent&&(!/^body|html$/i.test(offsetParent.tagName)&&jQuery.css(offsetParent,'position')=='static'))offsetParent=offsetParent.offsetParent;return jQuery(offsetParent);}});jQuery.each(['Left','Top'],function(i,name){var method='scroll'+name;jQuery.fn[method]=function(val){if(!this[0])return;return val!=undefined?this.each(function(){this==window||this==document?window.scrollTo(!i?val:jQuery(window).scrollLeft(),i?val:jQuery(window).scrollTop()):this[method]=val;}):this[0]==window||this[0]==document?self[i?'pageYOffset':'pageXOffset']||jQuery.boxModel&&document.documentElement[method]||document.body[method]:this[0][method];};});jQuery.each(["Height","Width"],function(i,name){var tl=i?"Left":"Top",br=i?"Right":"Bottom";jQuery.fn["inner"+name]=function(){return this[name.toLowerCase()]()+num(this,"padding"+tl)+num(this,"padding"+br);};jQuery.fn["outer"+name]=function(margin){return this["inner"+name]()+num(this,"border"+tl+"Width")+num(this,"border"+br+"Width")+(margin?num(this,"margin"+tl)+num(this,"margin"+br):0);};});})();

/**
 * jQuery.ScrollTo - Easy element scrolling using jQuery.
 * Copyright (c) 2007-2008 Ariel Flesler - aflesler(at)gmail(dot)com | http://flesler.blogspot.com
 * Dual licensed under MIT and GPL.
 * Date: 9/11/2008
 * @author Ariel Flesler
 * @version 1.4
 *
 * http://flesler.blogspot.com/2007/10/jqueryscrollto.html
 */
;(function(h){var m=h.scrollTo=function(b,c,g){h(window).scrollTo(b,c,g)};m.defaults={axis:'y',duration:1};m.window=function(b){return h(window).scrollable()};h.fn.scrollable=function(){return this.map(function(){var b=this.parentWindow||this.defaultView,c=this.nodeName=='#document'?b.frameElement||b:this,g=c.contentDocument||(c.contentWindow||c).document,i=c.setInterval;return c.nodeName=='IFRAME'||i&&h.browser.safari?g.body:i?g.documentElement:this})};h.fn.scrollTo=function(r,j,a){if(typeof j=='object'){a=j;j=0}if(typeof a=='function')a={onAfter:a};a=h.extend({},m.defaults,a);j=j||a.speed||a.duration;a.queue=a.queue&&a.axis.length>1;if(a.queue)j/=2;a.offset=n(a.offset);a.over=n(a.over);return this.scrollable().each(function(){var k=this,o=h(k),d=r,l,e={},p=o.is('html,body');switch(typeof d){case'number':case'string':if(/^([+-]=)?\d+(px)?$/.test(d)){d=n(d);break}d=h(d,this);case'object':if(d.is||d.style)l=(d=h(d)).offset()}h.each(a.axis.split(''),function(b,c){var g=c=='x'?'Left':'Top',i=g.toLowerCase(),f='scroll'+g,s=k[f],t=c=='x'?'Width':'Height',v=t.toLowerCase();if(l){e[f]=l[i]+(p?0:s-o.offset()[i]);if(a.margin){e[f]-=parseInt(d.css('margin'+g))||0;e[f]-=parseInt(d.css('border'+g+'Width'))||0}e[f]+=a.offset[i]||0;if(a.over[i])e[f]+=d[v]()*a.over[i]}else e[f]=d[i];if(/^\d+$/.test(e[f]))e[f]=e[f]<=0?0:Math.min(e[f],u(t));if(!b&&a.queue){if(s!=e[f])q(a.onAfterFirst);delete e[f]}});q(a.onAfter);function q(b){o.animate(e,j,a.easing,b&&function(){b.call(this,r,a)})};function u(b){var c='scroll'+b,g=k.ownerDocument;return p?Math.max(g.documentElement[c],g.body[c]):k[c]}}).end()};function n(b){return typeof b=='object'?b:{top:b,left:b}}})(jQuery);

(function($) {
  $.scour = $.scour || {};
  $.scour.consts =
  {
    domain: 'scour.com'
  };
  $.scour.util = {
    addSearchProvider: function()
    {
      if (window.external && ('AddSearchProvider' in window.external)) 
        window.external.AddSearchProvider('http://'+$.scour.consts.domain+'/searchplugins/scour.xml');
      else if (window.sidebar && ("addSearchEngine" in window.sidebar))
        window.sidebar.addSearchEngine ('http://'+$.scour.consts.domain+'/searchplugins/scour.src', 'http://'+$.scour.consts.domain+'/searchplugins/scour.gif', 'scour', 'The Social Search Engine');
      else
        alert("No search engine plugin support detected (FireFox or IE 7 required)");      
      return false;
    }
  };
  $.scour.homepage =
  {
    escapeSearch: function(searchP)
    {
      searchP = searchP.replace(/\//g, ' ');
      var result = encodeURIComponent(searchP);

      result = result.replace(/'/gi, '%27');

      return result;
    },
    getActiveTab: function(postfixP)
    {
      if (postfixP == undefined) postfixP = '';
      if ($('#tabWeb'+postfixP).hasClass("activetab"))
        return 'web';
      else if ($('#tabImages'+postfixP).hasClass("activetab"))
        return 'images';
      else if ($('#tabVideo'+postfixP).hasClass("activetab"))
        return 'video';
      else
        return 'web';
    },
    search: function(postfixP)
    {
      if (postfixP == undefined) postfixP = '';
      var txt = $('#txtSearch'+postfixP).get(0).value;
      var url = '/search/' + this.getActiveTab(postfixP) + '/' + this.escapeSearch(txt);
      if (gSubID != undefined && gSubID == 1)
        url += '/abc/';
      if (txt != '')
        window.location.href = url;      

      return false;
    },
    setActiveTab: function(tabID, postfixP)
    {
      if (postfixP == undefined) postfixP = '';
      if (tabID == "tabWeb"+postfixP) $('#tabWeb'+postfixP).addClass("activetab"); else $('#tabWeb'+postfixP).removeClass("activetab");
      if (tabID == "tabImages"+postfixP) $('#tabImages'+postfixP).addClass("activetab"); else $('#tabImages'+postfixP).removeClass("activetab");
      if (tabID == "tabVideo"+postfixP) $('#tabVideo'+postfixP).addClass("activetab"); else $('#tabVideo'+postfixP).removeClass("activetab");

      return false;
    }
  }
})(jQuery);;

function closeDrop()
{   
  $("#dropout").slideToggle();
  userSettings.showflydown = false;
  cookies.saveSettings();
}

function showHide(idP)
{
  $("#"+idP).slideToggle("slow");
}

function doVoteFrame(index, url, title, domain)
{
  $.ajax({
    url: '/services/resultClick/',
    data: {
      'query': searcher.search_query,
      'click_url' : url, 
      'search_type' : searcher.searchType
    },
    type: 'post',
    cache: false,
    dataType: 'json',
    success: function (data) {
      if (userSettings.openLinksInVotingFrame)
      {
        var encoded_url = Base64.encode(url);
        title = Base64.encode(stripBolding(title));
        var query = encodeURIComponent(searcher.search_query);
        window.location.href = '/view/result/' + query + '/' + title + '/' + encoded_url + '/?URL=' + url;
      }
      else
      {
        window.location.href = url;
      }
    }
  });  

  return false;
}

function searchOnDomain(domain)
{
  var qry = searcher.search_query;
  var site_search_index = qry.indexOf("site:");
  if (site_search_index >=0)
    qry = qry.substr(0, qry.indexOf("site:"));
  window.location.href = "/search/web/" + qry + " site:" + domain;
}

function resultClickThru(url)
{
  $.ajax({
    url: '/services/resultClick/',
    data: {
      'query': searcher.search_query,
      'click_url' : url,
      'search_type' : searcher.searchType
    },
    type: 'post',
    cache: false,
    dataType: 'json',
    success: function (data) {    }
  });

  return false;
}


function clearComment(txtP)
{
  if (txtP && txtP.defaultValue==txtP.value)
  {
    txtP.value = "";
  }
}

function vote(index, button)
{
  if (!userSettings.isLoggedIn())
  {
    if (window.confirm("You must be logged in to vote.  Would you like to login now?"))
    {
      window.location.href = "/login/";
    }
    return false;
  }
  button.blur();
  button.onclick = dummy;

  $.ajax({
    url: '/services/addPosVote/',
    data: {
      'query': searcher.search_query,
      'url' : searcher.aggSearchResults.list[index].getFirstUrl()
    },
    type: 'post',
    cache: false,
    dataType: 'json',
    success: function (data) {
      getUserPoints();
    }
  });  

  //$('#vote' + index).removeClass('l_voteplus');
  //$('#vote' + index).addClass('votedup');
  //$('#voteup_link' + index).removeClass('l_voteplus');
  $('#voteup_link' + index).addClass('resultVoteUpComplete');
  $('#voteup_link' + index).attr({'title': "Voted Up. Thanks!"});
  $('#votedown_link'+index).fadeOut("slow");
  $('#votedown_link_frame'+index).fadeOut("slow");

  return false;
}

function votedown(index, button)
{
  if (!userSettings.isLoggedIn())
  {
    if (window.confirm("You must be logged in to vote.  Would you like to login now?"))
    {
      window.location.href = "/login/";
    }
    return false;
  }
  button.blur();
  button.onclick = dummy;

  //$('#vote_down' + index).removeClass('l_voteminus');
  $('#votedown_link' + index).addClass('resultVoteDownComplete');
  $('#votedown_link' + index).attr({'title': "Voted Down. Thanks!"});
  $('#voteup_link'+index).fadeOut("slow");
  $('#voteup_link_frame'+index).fadeOut("slow");

  $.ajax({
    url: '/services/addNegVote/',
    data: {
      'query': searcher.search_query,
      'url' : searcher.aggSearchResults.list[index].getFirstUrl()
    },
    type: 'post',
    cache: false,
    dataType: 'json',
    success: function (data) {
      getUserPoints()
    }
  });  

  return false;
}

function dummy() {}

function showFeedbackForm(data){
  document.getElementById('feedback-name').value = userSettings.username;
  document.getElementById('feedback-section').value = window.location.href;
  
  // create a modal dialog with the data
  $("#feedbackform").modal({
    close: false,
    overlayId: 'feedback-overlay',
    containerId: 'feedback-container',
    onOpen: feedback.open,
    onShow: feedback.show,
    onClose: feedback.close
  });
  return false;
};

function toogleVotingFrame()
{
  if (userSettings.openLinksInVotingFrame)
    userSettings.openLinksInVotingFrame = false;
  else
    userSettings.openLinksInVotingFrame = true;
  cookies.saveSettings();
  var text = "on";
  if (!userSettings.openLinksInVotingFrame)
    text = "off";
  $("#toogleVotingFrameStatus").text(text);
}

function hideHomePageBox()
{
  userSettings.showHomePageBox = false;
  cookies.saveSettings();
  $("#homepage_explination").fadeOut("slow");
  $("#learnmore").fadeOut("slow");
  $("#homepageMoreInfo").fadeIn("slow");
}

function showHomepageBox()
{
  userSettings.showHomePageBox = true;
  cookies.saveSettings();
  $("#homepage_explination").fadeIn("slow");
  $("#learnmore").fadeIn("slow");
  $("#homepageMoreInfo").fadeOut("slow");
}

function closeComment(indexP)
{
  $("#l_comments" + indexP).slideToggle();
}

function getUserPoints()
{
  var id = userSettings.userid;
  if (userSettings.userid > 0)
  {
    $.get('/services/getPoints/' + new Date().getTime() + '/', null, 
      function(data)
    {
      var user_searches = Number(data.user_searches);       if (user_searches == NaN) user_searches=0;
      var user_votes = Number(data.user_votes);             if (user_votes == NaN) user_votes=0;
      var user_comments = Number(data.user_comments);       if (user_comments == NaN) user_comments=0;
      var user_bonus = Number(data.user_bonus);             if (user_bonus == NaN) user_bonus=0;
      var user_points = Number(data.user_points);           if (user_points == NaN) user_points=0;
      var friend_searches = Number(data.friend_searches);   if (friend_searches == NaN) friend_searches=0;
      var friend_votes = Number(data.friend_votes);         if (friend_votes == NaN) friend_votes=0;
      var friend_comments = Number(data.friend_comments);   if (friend_comments == NaN) friend_comments=0;
      var friend_points = Number(data.friend_points);       if (friend_points == NaN) friend_points=0;
      $("#mypoints_usersearches").text(user_searches);
      $("#mypoints_comments").text(user_comments);
      $("#mypoints_votes").text(user_votes);
      $("#mypoints_bonus").text(user_bonus);
      $("#mypoints_total").text(user_points);
      $("#mypoints_friend_searches").text(friend_searches);
      $("#mypoints_friend_comments").text(friend_comments);
      $("#mypoints_friend_votes").text(friend_votes);
      $("#mypoints_friend_total").text(friend_points);      
      $("#mypoints_usertotal").text(user_points);
      $("#mypoints_total").text(friend_points+user_points);
      $("#mypoints_total_s").text(friend_points+user_points);
      //$("#mypoints_total").fadeIn("fast");
      //$("#mypoints_total_s").fadeIn("fast");
      $("#mypoints_total").fadeIn("false");
      $("#mypoints_total_s").fadeIn("fast");
   }
    , "json");
  }
}

function addComment(comment, url, positive, txt, btn)
{
  if (userSettings.isLoggedIn())
  {
    var par = txt.parent().parent();
    $.ajax({
      url: '/services/addComment/',
      data: {
        'query': searcher.search_query,
        'comment': comment,
        'url': url,
        'positive': positive
      },
      type: 'post',
      cache: false,
      dataType: 'json',
      success: function (result) {
        if (result.success)
        {
          var avatar = result.avatar;
          txt.attr("disabled", "disabled");
          par.find('.addCommentPosted').text('Comment Posted, thanks!');
          par.find('.addCommentPosted').show();
          par.find('.addCommentErrors').hide();
          par.find('.addCommentPostNeg').hide();
          par.find('.addCommentPostPos').hide();

          //update the user's points
          getUserPoints();

          // add comment to current display
          var container = par.parent().find('.resultCommentsBox');
          var result='';

          result += '<div class="comMyComment" >';
          result += '  <div class="comAvatarBar">';
          result += '    <a href="/profile/user/'+(userSettings.username)+'" class="comAvatar">';
          if (avatar != '')
            result += '      <img src="'+avatar+'" alt="" />';
          else
            result += '      <img src="/panel/img/fakeavatarsmall.png" alt="" />';
          result += '    </a>';
          result += '    <div class="comBoxTip"></div>';
          result += '  </div>';
          result += '  <div class="comMain" id="justaddedcomment" style="display:none">';
          result += '    <div class="comInfo">';
          result += '      <a href="/profile/user/'+(userSettings.username)+'/" class="comUsername">'+userSettings.username.toString()+'</a>';
          result += '      <span class="comTime">Just added</span>';
          result += '      <div class="comReport" title="Report comment abuse"></div>';
          result += '      <div class="comVoting">';
//          result += '        <div class="comVoteDown" title="Vote comment down"></div>';
//          result += '        <div class="comVoteUp" title="Vote comment up"></div>';
          result += '        <div class="comPoints"> 0</div>';
          result += '        <div class="comID" style="display:none">'+(result.commentid)+'</div>';
          result += '      </div>';
          result += '    </div>';
          result += '    <div class="comBody">'+(comment)+'</div>';
          //result += '    <div class="comReply">reply</div>';
          result += '  </div>';
          result += '</div>';
          container.append(result);
          $('#justaddedcomment').fadeIn('slow');
        }
        else
        {
          par.find('.addCommentErrors').text(result.error);
          par.find('.addCommentPosted').hide();
          par.find('.addCommentErrors').show();
          btn.show();
        }
      }
    });
  }
  else
  {
    if (window.confirm("You must be logged in to comment.  Would you like to login now?"))
    {
      showLoginModal();
    }
  }    
}

function goodieView(gid, state) {
  if(state=="s") {
    document.getElementById(gid).style.display="block";
  } else {
    document.getElementById(gid).style.display="none";
  }
}

function recommendComment(id, positive, btn)
{
  $.ajax({
    url: '/services/recommendComment/',
    data: {
      'comment': id,
      'positive' : positive
    },
    type: 'post',
    cache: false,
    dataType: 'json',
    success: function (result) 
    {
      $(btn).parent().find('.comPoints').text(result['num']);
    }
  });
}

function adClickThru(url, bid)
{
  $.ajax({
    url: '/services/addClickThru/',
    data: {
      'query': searcher.search_query,
      'url' : url,
      'search_type' : searcher.searchType,
      'bid': bid
    },
    type: 'post',
    cache: false,
    dataType: 'json',
    complete: function (result) {
      window.location.href = url;
    }
  });  
}


function addslashes( str ) {
  str=str.replace(/\\/g,'\\\\');
  str=str.replace(/\'/g,'\\\'');
  str=str.replace(/\"/g,'\\"');
  str=str.replace(/\0/g,'\\0');
  str=str.replace(/&#39;/g,'\\\'');

  return str;
}

function scourPointsClick()
{
  if (!userSettings.isLoggedIn())
  {
    window.location.href = "/login/";
  }
  else
  {
    window.location.href = "/profile/points/";
  }
}

function checkPaste(e){
  if($(this).val().length > searcher.addCommentTextboxValue.length+2) {
    e.stopPropagation();
    $(this).val(searcher.addCommentTextboxValue);
    var par = $(this).parent(); 
    par.find('.addCommentErrors').text('Sorry, no pasting, we want the details from you! :-)');
    par.find('.addCommentErrors').show();
    par.find('.addCommentPosted').hide();
  } else {
    searcher.addCommentTextboxValue = $(this).val();
  }
}

function boldText(strP, searchP) 
{
  if (strP)
  {
    return strP.replace(new RegExp(searchP, "gi"), "<strong>" + searchP + "</strong>");
  }
  else
  {
    return strP;
  }
}

function boldTextSplit(strP, searchTermsP)
{
  var terms = searchTermsP.split(/\s/);
  var stripped = new Array();
  for(var i=0; i<terms.length; i++)
  {
    terms[i] = terms[i].replace(/^[\+'"~]|['"]$/, "");

    if (terms[i].length >= 3)
      stripped.push((new RegExp(terms[i])).toString().slice(1, -1));
  }
  if (stripped.length==0) return strP;

  var keyword_regex = new RegExp(stripped.join('|'), "i");
  var result = '';
  var source = strP;
  var match;

  while(source.length > 0)
  {
    if (match = keyword_regex.exec(source) )
    {
      result += source.slice(0, match.index);
      result += ('<strong>'+match[0]+'</strong>' || '').toString();
      source = source.slice(match.index + match[0].length);      
    }
    else
    {
      result += source;
      source = '';
    }
  }
  return result;
}

function stripBolding(inputP)
{
  inputP = inputP.replace(/<strong>/gim, "");
  inputP = inputP.replace(/<\/strong>/gim, "");
  inputP = inputP.replace(/<b>/gim, "");
  inputP = inputP.replace(/<\/b>/gim, "");
  return inputP;  
}

/*
 * SimpleModal 1.1.1 - jQuery Plugin
 * http://www.ericmmartin.com/projects/simplemodal/
 * http://plugins.jquery.com/project/SimpleModal
 * http://code.google.com/p/simplemodal/
 *
 * Copyright (c) 2007 Eric Martin - http://ericmmartin.com
 *
 * Dual licensed under the MIT (MIT-LICENSE.txt)
 * and GPL (GPL-LICENSE.txt) licenses.
 *
 * Revision: $Id: jquery.simplemodal.js 93 2008-01-15 16:14:20Z emartin24 $
 *
 */
(function($){$.modal=function(data,options){return $.modal.impl.init(data,options);};$.modal.close=function(){$.modal.impl.close(true);};$.fn.modal=function(options){return $.modal.impl.init(this,options);};$.modal.defaults={overlay:50,overlayId:'modalOverlay',overlayCss:{},containerId:'modalContainer',containerCss:{},close:true,closeTitle:'Close',closeClass:'modalClose',persist:false,onOpen:null,onShow:null,onClose:null};$.modal.impl={opts:null,dialog:{},init:function(data,options){if(this.dialog.data){return false;}this.opts=$.extend({},$.modal.defaults,options);if(typeof data=='object'){data=data instanceof jQuery?data:$(data);if(data.parent().parent().size()>0){this.dialog.parentNode=data.parent();if(!this.opts.persist){this.dialog.original=data.clone(true);}}}else if(typeof data=='string'||typeof data=='number'){data=$('<div>').html(data);}else{if(console){console.log('SimpleModal Error: Unsupported data type: '+typeof data);}return false;}this.dialog.data=data.addClass('modalData');data=null;this.create();this.open();if($.isFunction(this.opts.onShow)){this.opts.onShow.apply(this,[this.dialog]);}return this;},create:function(){this.dialog.overlay=$('<div>').attr('id',this.opts.overlayId).addClass('modalOverlay').css($.extend(this.opts.overlayCss,{opacity:this.opts.overlay/100,height:'100%',width:'100%',position:'fixed',left:0,top:0,zIndex:3000})).hide().appendTo('body');this.dialog.container=$('<div>').attr('id',this.opts.containerId).addClass('modalContainer').css($.extend(this.opts.containerCss,{position:'fixed',zIndex:3100})).append(this.opts.close?'<a class="modalCloseImg '+this.opts.closeClass
+'" title="'+this.opts.closeTitle+'"></a>':'').hide().appendTo('body');if($.browser.msie&&($.browser.version<7)){this.fixIE();}this.dialog.container.append(this.dialog.data.hide());},bindEvents:function(){var modal=this;$('.'+this.opts.closeClass).click(function(e){e.preventDefault();modal.close();});},unbindEvents:function(){$('.'+this.opts.closeClass).unbind('click');},fixIE:function(){var wHeight=$(document.body).height()+'px';var wWidth=$(document.body).width()+'px';this.dialog.overlay.css({position:'absolute',height:wHeight,width:wWidth});this.dialog.container.css({position:'absolute'});this.dialog.iframe=$('<iframe src="javascript:false;">').css($.extend(this.opts.iframeCss,{opacity:0,position:'absolute',height:wHeight,width:wWidth,zIndex:1000,width:'100%',top:0,left:0})).hide().appendTo('body');},open:function(){if(this.dialog.iframe){this.dialog.iframe.show();}if($.isFunction(this.opts.onOpen)){this.opts.onOpen.apply(this,[this.dialog]);}else{this.dialog.overlay.show();this.dialog.container.show();this.dialog.data.show();}this.bindEvents();},close:function(external){if(!this.dialog.data){return false;}if($.isFunction(this.opts.onClose)&&!external){this.opts.onClose.apply(this,[this.dialog]);}else{if(this.dialog.parentNode){if(this.opts.persist){this.dialog.data.hide().appendTo(this.dialog.parentNode);}else{this.dialog.data.remove();this.dialog.original.appendTo(this.dialog.parentNode);}}else{this.dialog.data.remove();}this.dialog.container.remove();this.dialog.overlay.remove();if(this.dialog.iframe){this.dialog.iframe.remove();}this.dialog={};}this.unbindEvents();}};})(jQuery);

var searcher = {
  rawSearchResults : new Collection(),
  aggSearchResults : new SResult(),
  votes : new VoteCollection(),
  _searchResultContainer : null, 
  _pagerResultContainer : null,
  _searchingContainer : null,
  _timeResultContainer : null,
  _spellCheckContainer : null,
  finishedSearches : [],
  startTime: null,
  endTime: null,
  _finshedOPSIScores : [],
  search_query : "",
  searchType : "web",
  numPages : 0,
  currentPage : 0,   
  _totalResultsAvailable : 0, // currently only used for image
  _requestedPage : 0,
  _spellCheckValue : "",
  _videoResults : new Collection(),
  haveGoogle: false,
  haveMSN: false,
  haveYahoo: false,
  haveScour: false,
  haveRendered: false,
  commentCounts: [],
  ads: [],
  addCommentTextboxValue: '',
  
  addResult: function(newResult)
  {
    this.rawSearchResults.add(newResult);
  },

  addVoteResult: function(newResult){
    this.votes.add(newResult);
  },

  calculateResults: function()
  {
    this.aggSearchResults.clear();
    
    var result;
    for(var index=0; index<this.rawSearchResults.count(); index++)
    {
      var item = this.rawSearchResults.list[index];
      result = this.aggSearchResults.getByUrl(item.link);

      var vote = this.votes.getByUrl(item.link);
      if (result != null)
      {
        result.add(item);
        
        if (vote != null)
        {
          result.addVote(vote);
        }
      }
      else
      {
        var new_result = new AggSResult(item);
        if (vote != null)
        {
          new_result.addVote(vote);
        }
        
        this.aggSearchResults.add(new_result);
      }
    }
    this.aggSearchResults.rankScores();
  },

  callbackSpellCheck: function(result)
  {
    this._spellCheckValue = result;
    var spellcheck = $("#spellcheck");
    if (result != "")
    {
      var div = $('#spellcheckterm');
      div.html('<a href="/search/' + this.searchType + "/" + result + '/related/" class="spellCheckLink">' + result + '</a>&nbsp;&nbsp;</span>');
      spellcheck.fadeIn('fast');
    }
    else
    {
      spellcheck.hide();
    }
  },

  callbackRelatedTerms: function(result)
  {
    var div = $('#spellcheckrelated');
    var len = result.length;
    var term, url;
    if (len > 5) len = 5;
    for(var i=0; i<len; i++)
    {
      term = result[i];
      url = "/search/" + this.searchType + "/" + encodeURIComponent(term) + "/related/";
      if (window.gSubID && window.gSubID == 1) url += "abc/";
      div.append("<a href='" + url + "'>" + boldTextSplit(term, this.search_query) + "</a>");
    }
    var related = $("#relatedterms")
    if (len > 0)
    {
      related.fadeIn('fast');
    }
    else
    {
      related.hide();
    }
  },

  callbackImageSearch: function()
  {
  },

  callbackEngineWebSearchComplete: function(engineTypeP)
  {
    this._finishedSearches.push(engineTypeP);

    if (!this.haveScour && !this.haveMSN && !this.haveYahoo && !this.haveGoogle)
      this.endTime = (new Date()).getTime();

    if (engineTypeP == SearchEngineEnum.Google)
      this.haveGoogle = true;
    if (engineTypeP == SearchEngineEnum.Yahoo)
      this.haveYahoo = true;
    if (engineTypeP == SearchEngineEnum.MSN)
      this.haveMSN = true;
    if (engineTypeP == SearchEngineEnum.Scour)
      this.haveScour = true;

    //if (!this.haveScour && this.haveMSN && this.haveYahoo && this.haveGoogle)
    if ((!this.haveRendered && engineTypeP != SearchEngineEnum.Scour && this.rawSearchResults > 0) || this._finishedSearches.length >= 4)
    {
      this.haveRendered = true;
      this.calculateResults();      
      this.renderResults();
      this.setSearchTime();      
      this.hideSearching(); 
      this.showSortByButtons();
      this.showBottomSearch();
    }
  },

  clearSearch : function()
  {
    this.aggSearchResults.clear();
    this._finishedSearches = [];
    this._finshedOPSIScores = [];
    this._searchResultContainer.html("");
    this._pagerResultContainer.html("");
    this.rawSearchResults.clear();
    this.votes.clear();    
    this.numPages = 0;
    this.clearSpellCheck();
    this._spellCheckValue = "";
    this._videoResults.clear();
  },

  clearSpellCheck: function()
  {
    $("#spellcheckterm").html('');
    $("#spellcheckrelated").html('');
  },   

  createDelegate: function (instance, method) { return function () { return method.apply(instance, arguments); } },

  displayCommentCounts: function()
  {
    if (this.haveRendered)
    {
      this.renderResults();
    }
  },

  doImageSearch: function(qry) 
  {
    $('#rightsidecell').hide('fast');
    //adUpdater.updateAds(qry);
    $('#searchingflickr').show('fast');
    this._imageWrapper = new FlickrImageWrapper(this, searcher.createDelegate(this.callbackImageSearch));
    this._imageWrapper.setSearchPage(this._requestedPage);
    this._imageWrapper.search(qry, this._callback);
    spellCheckerWrapper.search(qry, this.createDelegate(this, this.callbackSpellCheck));
    relatedSearchWrapper.search(qry, this.createDelegate(this, this.callbackRelatedTerms));
  },

  doWebSearch: function(qry) 
  {      
    this.showSearching();
    var search_query = qry;
    if (userSettings.disabledSearchTypes)
    {
      search_query += " -filetype:pdf -filetype:doc -filetype:ppt";
    }

    if (userSettings.numGoogleResults>0)
      googleWrapper.search(search_query, this, this.createDelegate(this, this.callbackEngineWebSearchComplete));
    else
      this.callbackEngineWebSearchComplete(SearchEngineEnum.Google);
    
    if (userSettings.numYahooResults>0)
      yahooWrapper.websearch(search_query, this, this.createDelegate(this, this.callbackEngineWebSearchComplete));
    else
      this.callbackEngineWebSearchComplete(SearchEngineEnum.Yahoo);
    
    if (userSettings.numMSNResults>0)
    {
      var a = new LiveSearchClass();
      a.search(search_query, this);
    }
    else
      this.callbackEngineWebSearchComplete(SearchEngineEnum.MSN);

    this.doVoteCheck(qry, this, this.createDelegate(this, this.callbackEngineWebSearchComplete));

    adUpdater.updateAds(qry);
//    msnWrapper.search(search_query, this, this.createDelegate(this, this.callbackEngineWebSearchComplete));


    spellCheckerWrapper.search(qry, this.createDelegate(this, this.callbackSpellCheck));
    relatedSearchWrapper.search(qry, this.createDelegate(this, this.callbackRelatedTerms));

  },

  doVideoSearch: function(qry) {
    //adUpdater.updateAds(qry);
    youtubeVideoSearch(qry);
    spellCheckerWrapper.search(qry, this.createDelegate(this, this.callbackSpellCheck));
    relatedSearchWrapper.search(qry, this.createDelegate(this, this.callbackRelatedTerms));
  },

  doVoteCheck: function(qry, engine, callback)
  {
    $.ajax({
      url: '/services/getsearchdata/',
      data: {
        'query': qry
      },
      type: 'post',
      cache: false,
      dataType: 'json',
      complete: function(){
        callback(SearchEngineEnum.Scour);
      },
      success: function (data) {
        // handle votes
        var votes = data.votes;
        var len = votes.length;
        for(var i=0; i<len; i++)
        {
          engine.addVoteResult(new VoteResult(votes[i].Url, votes[i].NumVotes));
        }
        // handle comment counts
        engine.commentCounts = data.comments;
        engine.displayCommentCounts();
      }
    });
    setTimeout("handleVoteCheckTimeout()", 6000);
  },

  getFeaturedAdDisplayCode: function(ad)
  {
    var title = boldTextSplit(ad.title, this.search_query);
    var desc = boldTextSplit(ad.description, this.search_query);
    var html = '<div class="v2result" onclick="adClickThru(\'' + ad.redirect + '\', ' + ad.bid + '); return false;" style="cursor:pointer"><a href="'+ad.redirect+'" class="resultTitle">'+title+'</a>';
    html += '<a href="#" class="resultNewWindow" title="Open result in new window"></a>';
    html += '<div class="resultSponsored">Sponsored Link</div>';
    html += '<div class="resultMain">';
    html += '<div class="resultMainBorder">';
    html += ' <div class="resultContent">';
    html += '    <div class="resultSummary">'+desc+ '<div class="resultDomain">';
    html += '			  <a href="'+ad.redirect+'" class="resultDomainLink">'+ad.url+'</a>';
    html += '		  </div>';
    html += '    </div>';
    html += '	</div>';
    html += '</div>';
    html += '</div>';
    html += '</div>';
    return html;
  },

  getNoResultsDisplay: function()
  {
    var display = "<p style='font-size:120%' class='clear'>No results found containing your search.</p>";
    display += "<p style='font-size:110%'>Suggestions:<br />";
    display += "  <ul style='margin-left:10px'>";
    display += "    <li style='margin-left:20px;font-size:130%'>Make sure your spelling is correct.</li>";
    display += "    <li style='margin-left:20px;font-size:130%'>Try more general keywords.</li>";
    display += "    <li style='margin-left:20px;font-size:130%'>Try different keywords.</li>";
    display += "    <li style='margin-left:20px;font-size:130%'>Give up on this search probably doesn't exist.</li>";
    display += "  </ul>";
    return display;
  },

  getSearchTime: function()
  {
    return (this.endTime - this.startTime) / 1000;
  },

  hideSearching : function()
  {
    $('#results').show();
    $('#pager').show();
    $('#searching').hide();
  },

  isSiteSearch: function()
  {
    if (!this.search_query) return false;
    else return this.search_query.indexOf('site:') != -1;
  },


  loadElements: function()
  {
    this._searchResultContainer = $('#results');
    this._pagerResultContainer = $('#pager');
    this._searchingContainer = $('#searching');
    this._timeResultContainer = $('#time');
    this._spellCheckContainer = $('#spellcheck');
  },

  renderResults : function()
  {
    var results = $('#results');
    results.empty();
    $('#pager').empty();
    var display = "";
    if (this.aggSearchResults.count() == 0)
    {
      results.html(this.getNoResultsDisplay());
    }
    else
    {
      this.showPage(this._requestedPage);
    }
    
    this.setupWebPager();    
  },

  search: function(queryP)
  {
    
    this.clearSearch();
    this.search_query = queryP;
    this.startTime = (new Date()).getTime();

    if(this.searchType == "web")
      this.doWebSearch(queryP);
    else if(this.searchType == "images")
      this.doImageSearch(queryP);
    else if (this.searchType == "video")
      this.doVideoSearch(queryP);
    else
      this.doWebSearch(queryP);
  },
  
  setFontWeight: function(id, weight){
    var e  = $(id).get(0);    
    if (e) e.style.fontWeight = weight;    
  },

  setSearchTime : function()
  { 
    var start;
    var end;
    if (this.searchType == "web")
    {   
      start = Math.max((this.currentPage)*12, 0) + 1;
      end = Math.min(start + 11, this.aggSearchResults.count());
    }
    else
    {
      start = this._requestedPage * 50 + 1;
      end = start + 49;
    }

    $('#time').html("Page " + (this.currentPage+1) + " - Results " + (start) + "-" + end + " for " + this.search_query + "(" + this.getSearchTime() + " seconds)");
  },

  setSearchType: function(value)
  {
    if (value != 'images' && value != 'video')
    {
      this.searchType = 'web';
      $.scour.homepage.setActiveTab('tabWeb');
    }
    else
    {
      this.searchType = value;
      if (value == 'images')
        $.scour.homepage.setActiveTab('tabImages');
      else
        $.scour.homepage.setActiveTab('tabVideo');
    }
  },

  setTotalResultsAvailable: function(val)
  {
    alert('setTotalResultsAvailable needs to be written');
  },

  setupWebPager: function()
  {
    if (this.aggSearchResults.count() > 12)
    {
      this.numPages = Math.ceil(this.aggSearchResults.count()/12);
      var page = this.currentPage + 1;
      var pager = "";
      if (page > 1)
      {
        pager += '<a href="#" onclick="javascript:searcher.showPrevPage()" id="pagerPrev" title="Previous Page">Prev</a>';      
      }
      else
      {
        pager += '<span id="pagerPrev" class="nextprev">Prev</span>';
      }
      for(var index=1; index<=this.numPages; index++)
      {
        pager += '<a href="#" onclick="javascript:searcher.showPage(' + (index-1).toString() + ')" title="View Page ' + index + '">' + index + '</a>';
      }
      if (page < this.numPages)
      {
        pager += '<a href="#" onclick="javascript:searcher.showNextPage()" id="pagerNext" title="Next Page">Next</a>';      
      }
      else
      {
        pager += '<span id="pageNext" class="nextprev">Next</span>';
      }
      $('#pager').html(pager);
    }
  },  

  showBottomSearch: function()
  {
    $('#bottomseearch').show();
  },

  showPage: function(pageIndex)
  {
    $('#results').empty();
    var display = "";
    this.currentPage = pageIndex;
    this._searchResultContainer = $('#results').get(0);
    var container = $('#results');
    container.empty();
    //todo - wire in current page for back button searching
    //window.userSettings._PersistentDataManager.set("page", pageIndex+1);
    var start = Math.max((pageIndex)*12, 0);
    var end = Math.min(start + 12, this.aggSearchResults.count());
    
    for(var index = start; index<end; index++)
    {      
      /*if (index == 6)
      {
        var ad_code = '';
        if (this.ads && this.ads.length > 0)
          ad_code = this.getFeaturedAdDisplayCode(this.ads[0]);

        container.append('<div id="featuredAdd1">'+ad_code+'</div>');
        ad_code = '';
        if (this.ads && this.ads.length > 1)
          ad_code = this.getFeaturedAdDisplayCode(this.ads[1]);
        container.append('<div id="featuredAdd2">'+ad_code+'</div>');
      } */
      var div = document.createElement("div");
      var a = this.aggSearchResults.list[index].getDisplayHTML(index);
      try { div.innerHTML = a;  }catch(e){}
      //container.append(this.aggSearchResults.list[index].getDisplayHTML(index));
      this._searchResultContainer.appendChild(div);
    }
    this.wireResults();
    this.setupWebPager();
    this.setSearchTime();
    this.updateAdditionalInfo();
    //this.engineOSPIScoreCompleted(AV.OSPIValueEnum.EngineScore);
  },

  showNextPage: function()
  {
    this.showPage(this.currentPage + 1);
  },

  showPrevPage: function()
  {
    this.showPage(this.currentPage - 1);
  },

  showSearching : function()
  {
    this._searchingContainer.show();
    this._searchResultContainer.hide();
    this._pagerResultContainer.hide();
  },

  showSortByButtons : function()
  {  
    var e = $('#submenuTitle');
    if (userSettings.showSortingButtons)
    {
      e.show();
      var by = userSettings.sortResultsBy;
      if (by == SortByEnum.Scour) $('#sortByScour').addClass('sortByScour_selected'); else $('#sortByScour').removeClass('sortByScour_selected');
      if (by == SortByEnum.Google) $('#sortByGoogle').addClass('sortByGoogle_selected'); else $('#sortByGoogle').removeClass('sortByGoogle_selected');
      if (by == SortByEnum.Yahoo) $('#sortByYahoo').addClass('sortByYahoo_selected'); else $('#sortByYahoo').removeClass('sortByYahoo_selected');
      if (by == SortByEnum.MSN) $('#sortByLive').addClass('sortByLive_selected'); else $('#sortByLive').removeClass('sortByLive_selected');
    }
    else
      e.hide();
  },

  sortBy : function(by)
  {
    if (by != userSettings.sortResultsBy)
    {
      this.currentPage = 0;
      this.aggSearchResults._sortyBy = by;
      userSettings.sortResultsBy = by;
      cookies.saveSettings();
      this.aggSearchResults.rankScores();
      this.renderResults();
      this.updateAdditionalInfo();
      this.showSortByButtons();
    }
  },

  updateAdditionalInfo: function()
  {
  },

  wireResults: function()
  {
    // show/hide new window icon
    $(".resultTitleRow").hover(
      function () {
        $(this).find(".resultNewWindow").show();
      },
      function () {
        $(this).find(".resultNewWindow").hide();
      }
    );

    $('.addCommentComment').focus(function()
    {
      var txt = $(this);
      if (txt.val() == "Be the first to Comment!")
        txt.val('');
    });

    // Add textarea event
    $('.addCommentComment').each(function(){
      watchTextarea($(this));
    });
    
    $('.addCommentComment').blur(function()
    {
      var comment_count = new Number($(this).parent().parent().find('.commentCount').text());
      var txt = $(this);
      if (txt.val() == '' && comment_count==0)
        txt.val('Be the first to Comment!');
    });

    // toggle comment display button
    $('.resultComments').click(function(){
      var par = $(this).parent();
      var parpar = par.parent();
      par.find('.resultCommentsArrow').toggleClass('arrowUp');
      parpar.children('.resultCommentsContainer').slideToggle();
      var ac = parpar.find('.addCommentPanel')
      ac.each(function(){
        $(this).find('.addCommentComment').width($(this).width()-250+"px");
      });

      var tx = ac.find('.addCommentComment');
      searcher.addCommentTextboxValue = tx.val();
      $(tx).keyup(checkPaste).keydown(checkPaste).click(checkPaste).blur(checkPaste).focus(checkPaste);

      var visible = par.find('.resultCommentsArrow').hasClass('arrowUp');


      if (visible)
      {       
        var parparpar = parpar.parent();
        var comment_count = new Number(parparpar.find('.commentCount').text());
        parparpar.find('.comCurPage').text(0);
        var cur_page = 0;

        if (comment_count > 0)
        {
          var url = parparpar.find('.resultUrl').text();
          var container = parparpar.find('.resultCommentsBox');
          container.empty();
          // load comments
          $.ajax({
            url: '/services/getComments/',
            data: {
              'query': searcher.search_query,
              'url' : url,
              'page' : cur_page,
              'sort' : parparpar.find('.comCurPage').val()
            },
            type: 'post',
            cache: false,
            dataType: 'json',
            success: function (comments) {
            parparpar.find('.comCurPage').text(++cur_page);
             var len = comments.length;
             var result = '';
             for(var i=0; i<len; i++)
             {
               var c = comments[i];

               result += '<div class="';
               //comCommentSingle/comFriendComment/comMyComment
               if (c.id == userSettings.userid)
                 result += 'comMyComment';
               else if (c.positive == 1)
                 result += 'comCommentSinglePos';
               else if (c.positive == 0)
                 result += 'comCommentSingleNeg';
               else
                 result += 'comCommentSingle';

               result += '">';
               result += '  <div class="comAvatarBar">';
               result += '    <a href="/profile/user/'+c.username.toString()+'" class="comAvatar">';
               if (c.avatar != '')
                 result += '      <img src="'+c.avatar+'" alt="" />';
               else
                 result += '      <img src="/panel/img/fakeavatarsmall.png" alt="" />';
               result += '    </a>';
               result += '    <div class="comBoxTip"></div>';
               result += '  </div>';
               result += '  <div class="comMain" style="display:none">';
               result += '    <div class="comInfo">';
               result += '      <a href="/profile/user/'+(c.username.toString())+'/" class="comUsername">'+c.username.toString()+'</a>';
               result += '      <span class="comTime">'+ c.time.toString() +'</span>';
               result += '      <div class="comReport" title="Report comment abuse"></div>';
               result += '      <div class="comVoting">';
               result += '        <div class="comVoteDown" title="Vote comment down"></div>';
               result += '        <div class="comVoteUp" title="Vote comment up"></div>';
               result += '        <div class="comPoints"> '+(c.rec.toString())+'</div>';
               result += '        <div class="comID" style="display:none">'+(c.id.toString())+'</div>';
               result += '      </div>';
               result += '    </div>';
               result += '    <div class="comBody">'+(c.comment.toString())+'</div>';
               //result += '    <div class="comReply">reply</div>';
               result += '  </div>';
               result += '</div>';
              }
              container.append(result);
              container.find('.comMain').fadeIn('slow');

              var pager = container.parent().find('.commentLoadMore');
              if (comment_count > (cur_page)*10)
              {
                var start = (cur_page*10)+1;
                var end = (cur_page*10)+10;
                if (end > comment_count)
                  end = comment_count;
                pager.text('Load Comments ' + start + '-' + end + ' of ' + comment_count);
                pager.show();
                pager.css("visibility", "visible");
              }
              else
              {                
                pager.css("visibility", "hidden");
              }

              // wire up comment controls
              container.find('.comVoteUp').bind("click.custom", function(){
                var id = $(this).parent().find('.comID').text();
                recommendComment(id, 1, this);
                $(this).unbind("click.custom");
                $(this).addClass('comVotedUp');
                $(this).parent().find('.comVoteDown').animate({'opacity':'0', 'width': '0px'});
              });

              container.find('.comVoteDown').bind("click.custom", function(){
                var id = $(this).parent().find('.comID').text();
                recommendComment(id, 0, this);
                $(this).unbind("click.custom");
                $(this).addClass('comVotedDown');
                $(this).parent().find('.comVoteUp').animate({'opacity':'0', 'width': '0px'});
              });

              container.find('.comReport').click(function(){
                var id = $(this).parent().find('.comID').text();
                var username = $(this).parent().parent().find('.comUsername').text();
                var comment = $(this).parent().parent().find('.comBody').text();

                $('#reportform-commentid').text(id);
                $('#report-form-author').val(username);
                $('#abusetype1').attr("checked", "checked");
                $('#report-form-comment').val(comment);

                $("#reportmodal").modal({
                    close: false,
                    overlayId: 'report-overlay',
                    containerId: 'report-container'
                  });
              });

              container.find('.comReply').click(function(){
                alert('We will wire this up when we have main comment functions down.\n  It will be a clone of that short of an indent for display.');
              });
            }
          });
        }
      }
    });

    $('.commentLowerClose').click(function(){
      var par = $(this).parent();
      var parpar = par.parent();
      par.find('.resultCommentsArrow').toggleClass('arrowUp');
      parpar.children('.resultCommentsContainer').slideToggle('slow', function(){
        $.scrollTo(parpar.parent().parent(), 450, {offset:-10});
      });
    });

    // add comment buttons
    $('.addCommentButton').click(function(){

      if (userSettings.isLoggedIn())
      {
        var ac = $(this).parent().find('.addCommentPanel');

        ac.show();

        // set textarea size;
        var tx = ac.find('.addCommentComment');
        tx.width(ac.width()-250+"px");
      }
      else
      {
        var gc = $(this).parent().find('.guestCommentPanel');
        gc.show();
        $.scrollTo(gc,450,{offset:-100});
      }
    })

    // login link to overlay
    $('.guestCommentLink').click(function(){
      showLoginModal();
    });

    $('.commentLoadMore').click(function(){
      var par = $(this).parent();
      var parpar = par.parent();
      var parparpar = parpar.parent();
      var comment_count = new Number(parparpar.find('.commentCount').text());
      var cur_page = new Number(parparpar.find('.comCurPage').text());

      if (comment_count > 0)
      {
        var url = parparpar.find('.resultUrl').text();
        var container = parparpar.find('.resultCommentsBox');
        //container.empty();
        // load comments
        $.ajax({
          url: '/services/getComments/',
          data: {
            'query': searcher.search_query,
            'url' : url,
            'page' : cur_page,
            'sort' : parparpar.find('.comSortSelect').val()
          },
          type: 'post',
          cache: false,
          dataType: 'json',
          success: function (comments) {
           parparpar.find('.comCurPage').text(++cur_page);
           var len = comments.length;
           for(var i=0; i<len; i++)
           {
             var c = comments[i];

             var result = '<div class="';
             //comCommentSingle/comFriendComment/comMyComment
             if (c.id == userSettings.userid)
               result += 'comMyComment';
             else if (c.positive == 1)
               result += 'comCommentSinglePos';
             else if (c.positive == 0)
               result += 'comCommentSingleNeg';
             else
               result += 'comCommentSingle';

             result += '">';
             result += '  <div class="comAvatarBar">';
             result += '    <a href="/profile/user/'+c.username.toString()+'" class="comAvatar">';
             if (c.avatar != '')
               result += '      <img src="'+c.avatar+'" alt="" />';
             else
               result += '      <img src="/panel/img/fakeavatarsmall.png" alt="" />';
             result += '    </a>';
             result += '    <div class="comBoxTip"></div>';
             result += '  </div>';
             result += '  <div class="comMain" style="display:none">';
             result += '    <div class="comInfo">';
             result += '      <a href="/user/'+c.username+'/" class="comUsername">'+c.username+'</a>';
             result += '      <span class="comTime">'+ c.time +'</span>';
             result += '      <div class="comReport"></div>';
             result += '      <div class="comVoting">';
             result += '        <div class="comVoteDown"></div>';
             result += '        <div class="comVoteUp"></div>';
             result += '        <div class="comPoints"> '+c.rec+'</div>';
             result += '        <div class="comID" style="display:none">'+c.id+'</div>';
             result += '      </div>';
             result += '    </div>';
             result += '    <div class="comBody">'+c.comment+'</div>';
             //result += '    <div class="comReply">reply</div>';
             result += '  </div>';
             result += '</div>';

             container.append(result);
            }
            container.find('.comMain').fadeIn('slow');

            if (comment_count > (cur_page)*10)
            {
              var pager = container.parent().find('.commentLoadMore');
              var start = (cur_page*10)+1;
              var end = (cur_page*10)+10;
              if (end > comment_count)
                end = comment_count;
              pager.text('Load Comments ' + start + '-' + end + ' of ' + comment_count);
              pager.show();
              pager.css("visibility", "visible");
            }
            else
            {
              var pager = container.parent().find('.commentLoadMore');
              pager.css("visibility", "hidden");
            }

            // wire up comment controls
            container.find('.comVoteUp').bind("click.custom", function(){
              var id = $(this).parent().find('.comID').text();
              recommendComment(id, 1, this);
              $(this).unbind("click.custom");
              $(this).addClass('comVotedUp');
              $(this).parent().find('.comVoteDown').animate({'opacity':'0', 'width': '0px'});
            });

            container.find('.comVoteDown').bind("click.custom", function(){
              var id = $(this).parent().find('.comID').text();
              recommendComment(id, 0, this);
              $(this).unbind("click.custom");
              $(this).addClass('comVotedUp');
              $(this).parent().find('.comVoteDown').animate({'opacity':'0', 'width': '0px'});
            });

            container.find('.comReport').click(function(){
              var id = $(this).parent().find('.comID').text();
              var username = $(this).parent().parent().find('.comUsername').text();
              var comment = $(this).parent().parent().find('.comBody').text();

              $('#reportform-commentid').text(id);
              $('#report-form-author').val(username);
              $('#abusetype1').attr("checked", "checked");
              $('#report-form-comment').val(comment);

              $("#reportmodal").modal({
                  close: false,
                  overlayId: 'report-overlay',
                  containerId: 'report-container'
                });

            });

            container.find('.comReply').click(function(){
              alert('We will wire this up when we have main comment functions down.\n  It will be a clone of that short of an indent for display.');
            });
          }
        });
      }

    });

    $('.comSortSelect').change(function(){
      var par = $(this).parent();
      var parpar = par.parent();
      par.find('.resultCommentsArrow').toggleClass('arrowUp')
      parpar.children('.resultCommentsContainer').slideToggle();
      var parparpar = parpar.parent();
      var comment_count = new Number(parparpar.find('.commentCount').text());
      parparpar.find('.comCurPage').text(0);
      var cur_page = 0;

      if (comment_count > 0)
      {
        var url = parparpar.find('.resultUrl').text();
        var container = parparpar.find('.resultCommentsBox');
        container.find('.comMain').fadeOut('slow');
        // load comments
        $.ajax({
          url: '/services/getComments/',
          data: {
            'query': searcher.search_query,
            'url' : url,
            'page' : 0,
            'sort' : $(this).val()
          },
          type: 'post',
          cache: false,
          dataType: 'json',
          success: function (comments) {
           container.empty();
           parparpar.find('.comCurPage').text(++cur_page);
           var len = comments.length;
           for(var i=0; i<len; i++)
           {
             var c = comments[i];

             var result = '<div class="';
             //comCommentSingle/comFriendComment/comMyComment
             if (c.id == userSettings.userid)
               result += 'comMyComment';
             else if (c.positive == 1)
               result += 'comCommentSinglePos';
             else if (c.positive == 0)
               result += 'comCommentSingleNeg';
             else
               result += 'comCommentSingle';


             result += '">';
             result += '  <div class="comAvatarBar">';
             result += '    <a href="/profile/user/'+c.username.toString()+'" class="comAvatar">';
             if (c.avatar != '')
               result += '      <img src="'+c.avatar+'" alt="" />';
             else
               result += '      <img src="/panel/img/fakeavatarsmall.png" alt="" />';
             result += '    </a>';
             result += '    <div class="comBoxTip"></div>';
             result += '  </div>';
             result += '  <div class="comMain" style="display:none">';
             result += '    <div class="comInfo">';
             result += '      <a href="/user/'+c.username+'/" class="comUsername">'+c.username+'</a>';
             result += '      <span class="comTime">'+ c.time +'</span>';
             result += '      <div class="comReport"></div>';
             result += '      <div class="comVoting">';
             result += '        <div class="comVoteDown"></div>';
             result += '        <div class="comVoteUp"></div>';
             result += '        <div class="comPoints"> '+c.rec+'</div>';
             result += '        <div class="comID" style="display:none">'+c.id+'</div>';
             result += '      </div>';
             result += '    </div>';
             result += '    <div class="comBody">'+c.comment+'</div>';
             //result += '    <div class="comReply">reply</div>';
             result += '  </div>';
             result += '</div>';

             container.append(result);
            }
            $('.comMain').fadeIn('slow');


            if (comment_count > (cur_page)*10)
            {
              var pager = container.parent().find('.commentLoadMore');
              var start = (cur_page*10)+1;
              var end = (cur_page*10)+10;
              if (end > comment_count)
                end = comment_count;
              pager.text('Load Comments ' + start + '-' + end + ' of ' + comment_count);
              pager.show();
              pager.css("visibility", "visible");
            }
            else
            {
              var pager = container.parent().find('.commentLoadMore');
              pager.css("visibility", "hidden");
            }

            // wire up comment controls
            container.find('.comVoteUp').bind("click.custom", function(){
              var id = $(this).parent().find('.comID').text();
              recommendComment(id, 1, this);
              $(this).unbind("click.custom");
              $(this).addClass('comVotedUp');
              $(this).parent().find('.comVoteDown').animate({'opacity':'0', 'width': '0px'});
            });

            container.find('.comVoteDown').bind("click.custom", function(){
              var id = $(this).parent().find('.comID').text();
              recommendComment(id, 0, this);
              $(this).unbind("click.custom");
              $(this).addClass('comVotedUp');
              $(this).parent().find('.comVoteDown').animate({'opacity':'0', 'width': '0px'});
            });

            container.find('.comReport').click(function(){
              var id = $(this).parent().find('.comID').text();
              var username = $(this).parent().parent().find('.comUsername').text();
              var comment = $(this).parent().parent().find('.comBody').text();

              $('#reportform-commentid').text(id);
              $('#report-form-author').val(username);
              $('#abusetype1').attr("checked", "checked");
              $('#report-form-comment').val(comment);

              $("#reportmodal").modal({
                  close: false,
                  overlayId: 'report-overlay',
                  containerId: 'report-container'
                });

            });

            container.find('.comReply').click(function(){
              alert('We will wire this up when we have main comment functions down.\n  It will be a clone of that short of an indent for display.');
            });
          }
        });
      }

    });
  }
}  /* end searcher*/

var adUpdater = {
  error: function() {},
  updateAds: function(qry)
  {
    $.ajax({
      url: '/services/getabcf/',
      data: {
        subid: gSubID,
        term: qry
      },
      type: 'post',
      cache: false,
      dataType: 'json',
      success: function (ads) {
        var div = $('#featuredAds');
        div.empty();
        div.show();
        var len = ads.length;
        // to disply turn <0 to < len
        if (len > 0)
        {
          for (var i=0; i<ads.length; i++)
          {
            var ad_code = searcher.getFeaturedAdDisplayCode(ads[i]);
            $('#featuredAds').append(ad_code);
          }
          $('#featuredAds').fadeIn('slow');
        }
      },
      error: adUpdater.error
    });

    $.ajax({
      url: '/services/getabc/',
      data: {
        subid: gSubID,
        term: qry
      },
      type: 'post',
      cache: false,
      dataType: 'json',
      success: function (ads) {
        searcher.ads = ads;
        var len = ads.length;
        /*var div = $('#featuredAds');
        div.show();
        div.empty();

        var title;
        // to disply turn <0 to < len
        if (ads.length > 0)
        {
          var ad_code = '';
          if (searcher.ads && searcher.ads.length > 0)
            ad_code = searcher.getFeaturedAdDisplayCode(searcher.ads[0]);
          $('#featuredAdd1').append(ad_code);
          if (searcher.ads && searcher.ads.length > 1)
            ad_code = searcher.getFeaturedAdDisplayCode(searcher.ads[1]);
          $('#featuredAdd2').append(ad_code);
        } */
        if (len > 0)
        {
          var div = $('#adsbar');
          div.empty();
          div.append('<h2 class="sl f" style="font-size:90%">Sponsored Links</h2><div class="clear"></div>');
          if (len>8) len=8; // if (len>10) len=10;
          //for(var i=0;i<len; i++)
          for(var i=0;i<len; i++)
          {
            var title = boldTextSplit(ads[i].title, searcher.search_query);
            var desc = boldTextSplit(ads[i].description, searcher.search_query);

            if (desc.length > 200)
              desc = desc.substring(0, 200) + '...';
            var url = ads[i].url;
            if (url.length > 30)
              url = url.substring(0, 30) + "...";
            div.append(
              '<div class="adbarad" onclick="adClickThru(\'' + ads[i].redirect + '\', ' + ads[i].bid + '); return false;" style="cursor:pointer;display:none"><div class="clear"><a href="' + ads[i].redirect + '" onmouseover="return true">' + title + '</a></div><div class="clear">' + desc + '</div><span class="a">' + url + '</span><br></div><br />'
            );
          }
          div.append('<div class="clear adreferrer"><a href="http://www.abcsearch.com/cgi-bin/referadvfree.pl?referrerId=SCOUR" onmouseover="return true">Advertise on Scour</a></div>');
          $('.adbarad').fadeIn('slow');
        }
      },
      error: adUpdater.error    
    });
  }
}

var msnWrapper = {
  search: function (qry, engine, callback)
  {
    $.getJSON("/search/getmsn/" + encodeURIComponent(qry) + "/" + userSettings.numMSNResults + '/' + (new Date()).getTime() + '/',
      function(data)
      {
        var weight = userSettings.msnWeight/100;        
        var len = data.length;
        var r = data;
        var new_result;
        for(var i=0; i<len; i++)
        {
          new_result = new SearchResult(r[i].Url, r[i].Title, r[i].Description, SearchEngineEnum.MSN, i+1, r[i].DisplayUrl, r[i].CacheUrl, -1, "");
          new_result.score = (Math.pow(1.3,(10-i)) * weight);  
          engine.addResult(new_result);
        }
        callback(SearchEngineEnum.MSN);
      }
    );    
  }
}

function SearchResult(linkP, titleP, descP, engineP, rankP, displayUrlP, cacheUrlP, cacheSizeP, mimeTypeP, isDefaultP)
{
  this.link = linkP;
  this.title = titleP;
  this.desc = descP;
  this.engine = engineP;
  this.rank = rankP;
  this.displayUrl = displayUrlP;
  this.cacheUrl = cacheUrlP;
  this.cacheSize = cacheSizeP;
  this.mimeType = mimeTypeP;
  this.isDefault = isDefaultP;
  this.score = null;

  this.bold = function(strP, searchP) 
  {
    if (strP)
    {
      return strP.replace(new RegExp(searchP, "gi"), "<strong>" + searchP + "</strong>");
    }
    else
    {
      return "";
    }
  };

  this.displayHtml = function() {
    return '<p><a href="' + this.link + '">' + this.title + '</a><br /><div>' + this.desc + '</div><br />' + this.displayUrl + '</p>';
  };

  this.getDomain = function()
  {
    var url = this.normalizeURL();
    var index = url.indexOf("/");
    if (index == -1)
    {
      return url;
    }
    else
    {
      return url.substring(0, index);
    }    
  };

  this.normalizeLink = function()
  {
    var linkP = this.link;
      
    if (linkP.startsWith("http://www."))
      return linkP.substring(11);
    else if (linkP.startsWith("https://www."))
      return linkP.substring(12);
    else if (linkP.startsWith("http://"))
      return linkP.substring(7);
    else if (linkP.startsWith("https://"))
      return linkP.substring(8);
    else if (linkP.startsWith("www"))
      return linkP.substring(3);
    else
      return linkP;
  };

  this.normalizeURL = function() 
  {
    var url = this.displayUrl;
    var match = url.match(/^https?:\/\/(www\.)?(.*?)(\/?|\/(index|default)(\.\w*))$/i);
    return (match && match[2] ? match[2] : url).toLowerCase();
  };

  this.toString = function()
  {
    return this.normalizeLink();
  }
}

VoteResult = function(urlP, votesP)
{
  this.url = urlP;
  this.numVotes = votesP;
}

var spellCheckerWrapper = {
  buildSearchUri: function(query)
  {
    var api_key = this.getYahooApplicationID();    
    
    var adult_ok = ''; // set to 1 for allow
    if (userSettings.disableSafeSearch) adult_ok = '1';
    return 'http://api.search.yahoo.com/WebSearchService/V1/spellingSuggestion?appid=' + api_key + '&output=json&query=' + encodeURIComponent(query) + '&callback=?&adult_ok=' + adult_ok;
  },
  
  getYahooApplicationID: function()
  {
    return 'rf4H64XV34F4l8UUfGVbsRCjyRzxcMxiJwNc4fnW01kBr3HxbkHE7UuYGIrq9V.otUPFZSM-';
  },

  search: function (qry, callback)
  {
    this.searchstarttime = (new Date()).getTime();

    $.getJSON(this.buildSearchUri(qry),
     function (data) {
        this._searchEndTime = (new Date()).getTime();
        if (data && data.ResultSet && data.ResultSet.Result)
        {
          callback(data.ResultSet.Result);
        }        
      }
    );
  }  
}

var relatedSearchWrapper = {
  buildSearchUri: function(query)
  {
    var api_key = this.getYahooApplicationID();    
    
    var adult_ok = ''; // set to 1 for allow
    if (userSettings.disableSafeSearch) adult_ok = '1';
    return 'http://search.yahooapis.com/WebSearchService/V1/relatedSuggestion?appid=' + api_key + '&output=json&query=' + encodeURIComponent(query) + '&callback=?&adult_ok=' + adult_ok;
  },
  
  getYahooApplicationID: function()
  {
    return 'rf4H64XV34F4l8UUfGVbsRCjyRzxcMxiJwNc4fnW01kBr3HxbkHE7UuYGIrq9V.otUPFZSM-';
  },

  search: function (qry, callback)
  {
    this.searchstarttime = (new Date()).getTime();
    $.getJSON(this.buildSearchUri(qry),
     function (data) {
        if (data && data.ResultSet && data.ResultSet.Result)
        {
          callback(data.ResultSet.Result);
        }        
      }
    );
  }  
};

var googleWrapper = {
  callback: null,
  endTime: null,
  engine: null,
  searchStartTime:  null,
  webSearch: null,

  parseResult : function()
  {
    try
    {
      var weight = 1;    
      weight = userSettings.googleWeight / 100;
      
      var r = this.webSearch.results;
      var len = r.length;
      if (len > userSettings.numGoogleResults)
        len=userSettings.numGoogleResults;
      var new_result;
      for (var i = 0; i < len; i++) 
      {
        new_result = new SearchResult(r[i].unescapedUrl, r[i].titleNoFormatting, r[i].content, SearchEngineEnum.Google, i+1, r[i].visibleUrl, r[i].cacheUrl, -1, "");
        new_result.score = (Math.pow(1.3,(10-i)) * weight);  
        this.engine.addResult(new_result);  
      }

      this.endTime = (new Date()).getTime();      
    }
    catch (e)
    {
      alert("Failed to get google result with error: " + e.message);
    }
    searcher.havegoogle = true;
    if (this.callback)
    {
      this.callback(SearchEngineEnum.Google);
    }
  },

  search : function(qry, engine, callback)
  {
    this.webSearch = new GwebSearch();
    this.engine = engine;
    this.searchStartTime = (new Date()).getTime();
    this.webSearch.setResultSetSize(GSearch.LARGE_RESULTSET);
    this.webSearch.setNoHtmlGeneration()
    this.webSearch.setSearchCompleteCallback(this, this.parseResult);
    this.callback = callback;
    this.webSearch.execute(qry);
    setTimeout("handleGoogleTimeout()", 6000);
  }
}

var yahooWrapper = {
  searchstarttime: null,

  buildSearchUri: function(query)
  {
    var api_key = this.getYahooApplicationID();  
    var num_results = userSettings.numYahooResults;  // max 100
    var adult_ok = ''; // set to 1 for allow
    if (userSettings.disableSafeSearch)
      adult_ok = '1';
    return 'http://api.search.yahoo.com/WebSearchService/V1/webSearch?appid=' + api_key + '&output=json&results='+num_results+'&query=' + encodeURIComponent(query) + '&callback=?&adult_ok=' + adult_ok;
  },
  
  getYahooApplicationID: function() { return 'rf4H64XV34F4l8UUfGVbsRCjyRzxcMxiJwNc4fnW01kBr3HxbkHE7UuYGIrq9V.otUPFZSM-'; },

  parseResult : function(resultP) 
  {
    if (resultP && resultP.ResultSet && resultP.ResultSet.Result)
    {
      var weight = 1;
      
      weight = userSettings.yahooWeight / 100;
      
      // get the result 
      var results = resultP.ResultSet.Result;
      var num = results.length;
      for(var index=0;index<num; index++)
      {
        var new_result = new SearchResult(results[index].Url, results[index].Title, results[index].Summary, SearchEngineEnum.Yahoo, index+1, results[index].DisplayUrl);
        if (results[index].Cache)
        {
          new_result._cacheUrl = results[index].Cache.Url;
          new_result._cacheSize = results[index].Cache.Size;
        }  
        
        new_result.score = (Math.pow(1.3,(10-index)) * weight);  
        
        this.engine.addResult(new_result);
      }
    }
  },

  websearch: function (qry, engine, callback)
  {
    this.engine = engine;
    this.searchstarttime = (new Date()).getTime();
      
    $.getJSON(this.buildSearchUri(qry),
      function (data) 
      {
        yahooWrapper.parseResult(data);
        this._searchEndTime = (new Date()).getTime();
        callback(SearchEngineEnum.Yahoo);
        searcher.haveYahoo = true;
      });
    setTimeout("handleYahooTimeout()", 6000);    
  }  
}

function SResult()
{
  this.list=[];

  this.add = function(value) { this.list[this.list.length] = value; };
  this.aggSearchResults = function() { };
  this.clear = function() {  this.list = [];  };
  this.count = function() { return this.list.length; };
  this.sort = function(sortMethodP)
  {
    var sortMethod = sortMethodP;
    if (sortMethodP == undefined)
    {
      sortMethodP = searcher.createDelegate(this, this.sortByNumber);
    }
    // update scores
    for(var i=0; i<this.list.length; i++)
      this.list[i].updateScore();

    this.list.sort(sortMethodP);
  };

  this.sortByNumber = function(a, b)
  {
    return a - b;
  };

  this.getByDomain = function(domainP) 
  {
    for(var index = 0; index<this.count(); index++)
    {
      if (this.list[index].domain == domainP)
      {
        return this.list[index];
      }
    } 
    return null;
  };
  this.getByUrl = function(urlP)
  {
    for(var index = 0; index<this.count(); index++)
    {
      if (this.list[index].getFirstUrl() == urlP)
      {
        return this.list[index];
      }
    } 
    return null;
  };
  
  this.get_Score = function(indexP)
  {
    return this.list[index].score;
  },
  
  this.rankScores = function ()
  {
    var sort_by = userSettings.sortResultsBy;
    if (sort_by == SortByEnum.Scour)
      this.sort(this._sortCallbackScour);
    else if(sort_by == SortByEnum.Google)
      this.sort(this._sortCallbackGoogle);
    else if(sort_by == SortByEnum.Yahoo)
      this.sort(this._sortCallbackYahoo);
    else if(sort_by == SortByEnum.MSN)
      this.sort(this._sortCallbackMSN);
    else
      this.sort(this._sortCallbackScour);
  };
  
  this._sortCallbackScour = function(a, b)
  {
    return b._score - a._score;
  };
  
  this._sortCallbackGoogle= function(a, b)
  {
    return a.getGoogleRank() - b.getGoogleRank();
  };
  
  this._sortCallbackYahoo= function(a, b)
  {
    return a.getYahooRank() - b.getYahooRank();
  };

  this._sortCallbackMSN= function(a, b)
  {
    return a.getMSNRank() - b.getMSNRank();
  };
}

function Collection()
{
  this.list=[];
  this.add = function(newGuy) { this.list[this.list.length] = newGuy; };
  this.clear = function() { this.list=[]; };
  this.count = function() { return this.list.length; };
};

function VoteCollection()
{
  this.list=[];
  this.add = function(newGuy) { this.list[this.list.length] = newGuy; };
  this.clear = function() { this.list=[]; };
  this.count = function() { return this.list.length; };
  this.getByUrl = function(url) 
  {
    for(var i=0; i<this.count(); i++)
    {
      if (this.list[i].url == url)
      {
        return this.list[i];
      }
    }
    return null;
  }
}

function AggSResult(searchResultP)
{
  this.list = [];
  this.votes = new VoteCollection();
  this.index = -1;
  this.domain = searchResultP.getDomain();
  this._score = -1;
  this._comments = null;

  this.add = function(value)
  {
    this.list[this.list.length] = value;
  };
  this.add(searchResultP);
  this.addVote = function(vote)
  {
    this.votes.add(vote);
  };
  this.count = function() { return this.list.length; };

  this.getResultByType = function(engineTypeP)
  {
    var num = this.count();
    for(var index = 0; index < num; index++)
    {
      if (this.list[index].engine == engineTypeP)
      {
        return this.list[index];
      }
    }
    return this.getDefaultResult();
  };
  
  this.getYahooResult = function()
  {
    return this.getResultByType(SearchEngineEnum.Yahoo);
  };

  this.getGoogleResult = function()
  {    
    return this.getResultByType(SearchEngineEnum.Google);
  };
  
  this.getMSNResult = function()
  {
    return this.getResultByType(SearchEngineEnum.MSN);
  };

  this.getDefaultResult = function(typeP)
  {
    var r = new SearchResult('#', '', '', typeP, '-', '#', '', '-', '', true);    
    r.score = 0;
    
    return r;
  };

  this.getDisplayLink = function(google, yahoo, msn)
  {
    if (google.displayUrl != "#" && google.displayUrl)
    {
      return google.displayUrl;
    }
    else if (yahoo.displayUrl != "#" && yahoo.displayUrl)
    {
      return yahoo.displayUrl;
    }
    else if(msn.displayUrl != "#" && msn.displayUrl)
    {
      return msn.displayUrl;
    } 
    else
    {
      return "";
    }         
  };

  this.getTitle = function(google, yahoo, msn)
  {
    if (google.title.trim() != "")
    {
      return google.title;
    }
    else if (yahoo.title != "")
    {
      return yahoo.title;
    }
    else if(msn.title != null)
    {
      return msn.title;
    } 
    else
    {
      return "";
    }   
  };

  this.getUrl = function(google, yahoo, msn)
  {
    if (google.link != "#" && google.link)
    {
      return google.link;
    }
    else if (yahoo.link != "#" && yahoo.link)
    {
      return yahoo.link;
    }
    else if(msn.link != "#" && msn.link)
    {
      return msn.link;
    } 
    else
    {
      return "";
    }       
  };

  this.getGoogleRank = function()
  {
    var r = this.getGoogleResult().rank;
    if (isNaN(r)) r = 1000;
    return r;
  };

  this.getYahooRank = function()
  {
    var r = this.getYahooResult().rank;
    if (isNaN(r)) r = 1000;
    return r;
  };

  this.getMSNRank = function()
  {
    var r = this.getMSNResult().rank;
    if (isNaN(r)) r = 1000;
    return r;
  };

  this.getSummary = function(google, yahoo, msn)
  {
    if (google.desc != "")
    {
      return google.desc;
    }
    else if (yahoo.desc != "")
    {
      return yahoo.desc;
    }
    else if(msn.desc != null)
    {
      return msn.desc;
    } 
    else
    {
      return "";
    }       
  };

  this.getFirstUrl = function()
  {
    var google_result = this.getGoogleResult();
    var yahoo_result = this.getYahooResult();
    var msn_result = this.getMSNResult();

    return this.getUrl(google_result, yahoo_result, msn_result);
  };

  this.getDisplayHTML = function(indexP)
  {
    this.index = indexP;
    var google_result = this.getGoogleResult();
    var have_google = google_result.toString() != "#" &&  google_result.toString();
    var yahoo_result = this.getYahooResult();
    var have_yahoo = yahoo_result.toString() != "#" && yahoo_result.toString();
    var msn_result = this.getMSNResult();
    var have_msn = msn_result.toString() != "#" && msn_result.toString();    
    var title = this.getTitle(google_result, yahoo_result, msn_result);
    var org_title = title;
    var url = this.getUrl(google_result, yahoo_result, msn_result);
    var summary = this.getSummary(google_result, yahoo_result, msn_result);
    var display_link = this.getDisplayLink(google_result, yahoo_result, msn_result);
    var domain = this.domain;

    // remove strong/b
    title = stripBolding(title);

    // shorten them
    summary = stripBolding(summary);
    if (title.length > 80)
      title = title.substring(0, 60) + "...";

    display_link = url;
    if (display_link.length > 75)
      display_link = display_link.substring(0, 75) + "...";

    // bold keywords
    title = boldTextSplit(title, searcher.search_query);
    summary = boldTextSplit(summary, searcher.search_query);
    display_link = boldTextSplit(display_link, searcher.search_query);

    var comment_count = '';
    if (searcher.commentCounts[url] != undefined)
      comment_count = searcher.commentCounts[url]; 

    var link_url = url;
    if (userSettings.openLinksInVotingFrame)
    {
      var encoded_url = Base64.encode(url);
      var encoded_title = Base64.encode(stripBolding(title));
      var encoded_query = encodeURIComponent(searcher.search_query);
      link_url = '/view/result/' + encoded_query + '/' + encoded_title + '/' + encoded_url + '/?URL=' + url;
    }

    var search_query = searcher.search_query;
    search_query = addslashes(search_query);

    var result = "";

    result += '<div class="v2result clear" id="result'+indexP+'">';
    result += '  <div class="resultTitleRow">';
    result += '    <a href="'+link_url+'" class="resultTitle" onclick="return doVoteFrame(' + indexP + ',\'' + url + '\', \'' + addslashes(title) + '\',\'' + domain + '\');">'+title+'</a>';
    result += '    <a href="'+link_url+'" class="resultNewWindow" title="Open result in new window" target="_blank" onclick="resultClickThru(\'' + url + '\')"></a>';
    result += '  </div>';
    result += '  <div class="resultMain">';
    result += '    <div class="resultRank" title="">';
    var search_encoded = encodeURIComponent(searcher.search_query);
		if (have_google)
      result += '      <a href="http://www.google.com/search?q=' + search_encoded + '" title="This represents the search listing rank on Google #'+google_result.rank+' - Click to search Google for '+search_query+'" target="_blank" class="resultGoogleRank"><span></span>'+google_result.rank+'</a>';
    else
      result += '      <a href="http://www.google.ca/search?q=' + search_encoded + '" title="This represents the search listing rank on Google(Not In Top Results) - Click to search Google for '+search_query+'" target="_blank" class="resultGoogleRankNone"><span></span>-</a>';
    if (window.gIsAussie)
      if (have_yahoo)
        result += '      <a href="http://au.search.yahoo.com/search?p=' + search_encoded + '" title="This represents the search listing rank on Yahoo #'+yahoo_result.rank+' - Click to search Yahoo for '+search_query+'" target="_blank" class="resultYahooauRank"><span></span> '+yahoo_result.rank+'</a>';
      else
        result += '      <a href="http://au.search.yahoo.com/search?p==' + search_encoded + '" title="This represents the search listing rank on Yahoo(Not In Top Results) - Click to search Yahoo for '+search_query+'" target="_blank" class="resultYahooauRankNone"><span></span>-</a>';
    else
      if (have_yahoo)
        result += '      <a href="http://search.yahoo.com/search?p=' + search_encoded + '" title="This represents the search listing rank on Yahoo #'+yahoo_result.rank+' - Click to search Yahoo for '+search_query+'" target="_blank" class="resultYahooRank"><span></span>' + yahoo_result.rank +'</a>';
      else
        result += '      <a href="http://search.yahoo.com/search?p=' + search_encoded + '" title="This represents the search listing rank on Yahoo(Not In Top Results) - Click to search Yahoo for '+search_query+'" target="_blank" class="resultYahooRankNone"><span></span>-</a>';
    if (have_msn)
      result += '      <a href="http://search.msn.com/results.aspx?q=' + search_encoded +'" title="This represents the search listing rank on MSN #'+yahoo_result.rank+' - Click to search MSN for '+search_query+'" target="_blank" class="resultLiveRank"><span></span>' + msn_result.rank + '</a>';
    else
      result += '      <a href="http://search.msn.com/results.aspx?q=' + search_encoded +'" title="This represents the search listing rank on MSN(Not In Top Results) - Click to search MSN for '+search_query+'" target="_blank" class="resultLiveRankNone"><span></span>-</a>';

    result += '    </div>';
    result += '    <div class="resultMainBorder">';
    result += '      <div class="resultContent">';
    result += '        <div class="resultSummary">'+summary+'</div>';
    result += '        <div class="resultDomain">';
    result += '          <a href="'+url+'" class="resultDomainLink" onclick="return doVoteFrame(' + indexP + ',\'' + url + '\', \'' + addslashes(org_title) + '\',\'' + domain + '\');">'+display_link+'</a>';
    result += '          <a href="#" class="resultDomainSearch" onclick="return searchOnDomain(\'' + domain + '\');">Search this Site</a>';
    result += '        </div>';
    result += '        <a href="#" class="resultVoteUp" onclick="vote(' + indexP + ', this); return false;" id="voteup_link' + indexP + '"></a>';
    result += '        <a href="#" class="resultVoteDown" onclick="votedown(' + indexP + ', this); return false;" id="votedown_link' + indexP + '"></a>';
    result += '        <div class="resultComments">';
    result += '          <span></span> ' + comment_count.toString() +' comments';
    result += '          <div class="resultCommentsArrow"></div>';
    result += '        </div>';
    result += '      </div>';
    result += '      <div class="resultCommentsContainer" style="display:none;">';
    if (comment_count != '')
      result += '        <div class="addCommentButton" onclick="$(\'#addComment'+indexP+',#commentClose'+indexP+'\').fadeIn(\'slow\');">Add Comment</div>';
    result += '          <div class="commentLowerCloseTop" id="commentClose'+indexP+'" style="display:none" onclick="$(\'#addComment'+indexP+',#commentClose'+indexP+'\').fadeOut(\'slow\');">Discard</div>';
    result += '        <div class="comSort">';
    result += '          <select class="comSortSelect">';
    result += '            <option value="newest">Newest</option>';
    result += '            <option value="oldest">Oldest</option>';
    result += '            <option value="positive">Positive</option>';
    result += '            <option value="negative">Negative</option>';
    result += '            <option value="recommended">Recommended</option>';
    result += '          </select>';
    result += '        </div>';


    result += '        <h2 class="resultCommentsTitle">'
    if (comment_count != '')
      result += comment_count + ' Comments';
    else
      result += '&nbsp;';
    result += '</h2>';
    result += '        <div class="addCommentPanel" style="display:none" id="addComment'+indexP +'">';
    result += '          <textarea id="addCommentComment" class="addCommentComment" rows="4" cols="50" oncontextmenu="return false;">';
    if (userSettings.isLoggedIn() && (comment_count == '' || comment_count == 0))
      result += 'Be the first to Comment!';
    result += '</textarea>';
    result += '          <a href="#" class="addCommentPostNeg"></a>';
    result += '          <a href="#" class="addCommentPostPos"></a>';
    result += '          <div class="addCommentErrors" style="display:none">';
    result += '            <div class="addCommentErrorsIcon"></div>';
    result += '            <span class="addCommentErrorsText"></span>';
    result += '          </div>';
    result += '          <div class="addCommentPosted" style="display:none">';
    result += '            <span class="addCommentPostedText">Comment Posted, thanks!</span>';
    result += '          </div>';
    result += '          <div class="addCommentCharacters">';
    result += '            <span class="currentCharacters">0</span>/500 characters';
    result += '          </div>';
    result += '        </div>';

    result += '<div class="resultCommentsBox">';
    if (!userSettings.isLoggedIn())
    {
      result += '        <div class="noCommentsHeader">Be the first to Comment!';
      result += '&nbsp;&nbsp;<a href="#" class="guestCommentLink">Login</a> or <a href="/signup/" target="_blank">Join Now</a>!';
      result += '        </div>';
    }
    result += '</div>';
    result += '<div class="commentLowerClose">Close</div>';

/*    result += '        <div class="addCommentButton" '
    if (comment_count == '' || comment_count == 0)
      result += 'style="display:none"';

    result += '>Add Comment</div>';*/
    result += '        <div class="commentLoadMore" style="visibility: hidden"></div>';
    result += '        <div class="addCommentPanel"';
    if (!userSettings.isLoggedIn())
      result += ' style="display:none"';
    result += '         >';
    result += '          <textarea id="addCommentComment" class="addCommentComment" rows="4" cols="50" oncontextmenu="return false;">';
    if (userSettings.isLoggedIn() && (comment_count == '' || comment_count == 0))
      result += 'Be the first to Comment!';   
    result += '</textarea>';
    result += '          <a href="#" class="addCommentPostNeg"></a>';
    result += '          <a href="#" class="addCommentPostPos"></a>';
    result += '          <div class="addCommentErrors" style="display:none">';
    result += '            <div class="addCommentErrorsIcon"></div>';
    result += '            <span class="addCommentErrorsText"></span>';
    result += '          </div>';
    result += '          <div class="addCommentPosted" style="display:none">';
    result += '            <span class="addCommentPostedText">Comment Posted, thanks!</span>';
    result += '          </div>';
    result += '          <div class="addCommentCharacters">';
    result += '            <span class="currentCharacters">0</span>/500 characters';
    result += '          </div>';
    result += '        </div>';
    if (!userSettings.isLoggedIn())
    {
      result += '        <div class="guestCommentPanel" style="display:none">';
      result += '           Please <a href="#" class="guestCommentLink">Login</a> to Comment.<br>';
      result += '           If you don\'t have an account, <a href="/signup/" target="_blank">sign up now</a>!';
      result += '        </div>';
    }
    result += '        <span class="commentCount" style="display:none">' + comment_count.toString() + '</span>';
    result += '        <span class="comCurPage" style="display:none">0</span>';
    result += '        <span class="resultUrl" style="display:none">' + url + '</span>';
    result += '        <span class="currentlyDisplayedCommentCount" style="display:none">0</div>';
    result += '      </div>';
    result += '    </div>';
    result += '  </div>';
    result += '</div>';
    return result;
  };

  this.updateScore = function()
  {
    var score = 0;
    for(var i=0; i<this.list.length; i++)
      score += this.list[i].score;

    for(var i=0; i<this.votes.list.length; i++)
      score += (this.votes.list[i].numVotes)/50;

    this._score = score;
  }
}
Array.prototype.contains = function(value)
{
  for(var index=0; index<this.length; index++)
  {
    if (this[index] == value) return true;    
  }
  return false;
}

String.prototype.startsWith = function(s) { return this.indexOf(s)==0; }

String.prototype.trim = function() 
{ 
  var s = this;
  while (s.substring(0,1) == ' ')
  {
    s = s.substring(1, s.length);
  }
  while (s.substring(s.length-1, s.length) == ' ')
  {
    s = s.substring(0,s.length-1);
  }
  return s;
}


FlickrImageWrapper = function(engineP, onCompleteCallbackP)
{
  this._searchPage = 1;
}
FlickrImageWrapper.prototype =
{
  completedCallback : function(data)
  {
    this.parseResult(data);
  },

  buildSearchUri: function(query)
  {
    var safe_search = '1';
    if (!userSettings.disableSafeSearch)
      safe_search = '3';
    return 'http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=' + this.getApiKey() + '&format=json&text=' + encodeURIComponent(query) + '&privacy_filter=interestingness-desc&safe_search='+safe_search+'&per_page=50&page=' + this._searchPage + '&jsoncallback=?&owner_name%2C+icon_server%2C+views';
  },

  getApiKey: function()
  {
    return '58fa746f5973b117b63051c3b3d197be';
  },

  search : function(qry, callbackP)
  {
    this.startTime = (new Date()).getTime();
    $.getJSON(this.buildSearchUri(qry),
      function(data)
      {
        $('#searchingflickr').hide('fast');
        if (data && data.photos && data.photos.photo && data.photos.photo.length > 0)
        {
          searcher._imageWrapper.parseResult(data.photos.photo);

          // setup pager?
          if (data.photos.pages > 0)
          {          
            searcher._imageWrapper.displayPager(data.photos.pages);
          }
        }
        else
        {
          $('#results').html(searcher.getNoResultsDisplay());
        }
      }
    );
 },

 displayPager: function(numPagesP)
  {
    var page = this._searchPage;
    var pager = "";
    if (page > 1)
    {
      pager += '<a href="#" onclick="javascript:searcher._imageWrapper.prevPage()" id="pagerPrev" title="Previous Page">Prev</a>';      
    }
    else
    {
      pager += '<span id="pagerPrev" class="nextprev">Prev</span>';
    }
    var pages_shown = 0;
    var start_index = Math.max(1, page-5);
    for(var index=start_index; index<=numPagesP; index++)
    {
      if (page == index)
      {
        pager += '<span href="#" title="Current Page" class="nextprev">' + index + '</span>';
      }
      else
      {
        pager += '<a href="#" onclick="javascript:searcher._imageWrapper.loadPage(' + (index).toString() + ')" title="View Page ' + index + '">' + index + '</a>';
      }
      pages_shown++;
      if (pages_shown >= 10)
      {
        break;
      }
    }
    if (page < numPagesP)
    {
      pager += '<a href="#" onclick="javascript:searcher._imageWrapper.nextPage()" id="pagerNext" title="Next Page">Next</a>';      
    }
    else
    {
      pager += '<span id="pageNext" class="nextprev">Next</span>';
    }
    $('#pager').html(pager);
  },

  setSearchPage: function(valueP)
  {
    this._searchPage = valueP;
  },

  parseResult : function(resultP)
  {
    this.endTime = (new Date()).getTime();
    $('#time').html("Search for " + searcher.search_query + "(" + (this.endTime - this.startTime) / 1000 + " seconds)");

    if (resultP)
    {
      var results = resultP;
      var num = results.length;
      searcher.hideSearching();
      var div = $('#results');
      div.empty();
      $('#pager').empty();
      var photo;
      for(var index=0;index<num; index++)
      {
        photo = results[index];
        var thumb_url = 'http://farm'+photo.farm+'.static.flickr.com/'+photo.server+'/'+photo.id+'_'+photo.secret+'_m.jpg'
        var image_page_url = 'http://www.flickr.com/photos/' + photo.owner + '/' + photo.id;
        div.append('<div class="imagedisplay"><a href="'+image_page_url+'" target="_blank"><img src="'+thumb_url+'" border="0" align="top" /><br />'+results[index].title+'</a></div>');
      }
    }
  },

  prevPage: function()
  {
    $('#results').empty();
    $('#pager').empty();
    searcher._imageWrapper._searchPage--;
    searcher._imageWrapper.search(searcher.search_query);
  },

  nextPage: function()
  {
    $('#results').empty();
    $('#pager').empty();
    searcher._imageWrapper._searchPage++;
    searcher._imageWrapper.search(searcher.search_query);
  },

  loadPage: function(pageP)
  {
    $('#results').empty();
    $('#pager').empty();
    searcher._imageWrapper._searchPage = pageP;
    searcher._imageWrapper.search(searcher.search_query);
  }


}

function youtubeVideoSearch(query)
{
  $.ajax({
    url: '/services/getVideos/',
    data: {
      'query': searcher.search_query,
      'page' : searcher.currentPage + 1
    },
    type: 'post',
    cache: false,
    dataType: 'json',
    success: function (result) {
      if (result)
      {
        var vids = result.videos; 
        var len = vids.length;
        searcher.hideSearching();
        var div = $('#results');
        div.empty();
        var pager = $('#pager');
        pager.empty();
        for (var i=0; i<len; i++)
        {
          div.append('<div class="imagedisplay" style="text-align:center"><a href="'+vids[i].url+'" class="imagedisplay" target="_blank">  <img src="'+vids[i].thumbnail+'" border="0"> <br>  '+vids[i].title+'<br />'+vids[i].length+' min </a></div>');
        }

        if (result.total_videos > 50)
        {
          this.numPages = Math.ceil(result.total_videos/50);
          if (this.numPages > 20)
          {
            this.numPages = 20;
          }
          var page = this.currentPage + 1;
          var pager = "";
          if (page > 1)
          {
            pager += '<a href="/search/video/' + searcher.search_query + '/' + (page-1) + '/" id="pagerPrev" title="Previous Page">Prev</a>';      
          }
          else
          {
            pager += '<span id="pagerPrev" class="nextprev">Prev</span>';
          }
          for(var index=1; index<=this.numPages; index++)
          {
            pager += '<a href="/search/video/' + searcher.search_query + '/' + (index-1).toString() + '/" title="View Page ' + index + '">' + index + '</a>';
          }
          if (page < this.numPages)
          {
            pager += '<a href="/search/video/' + searcher.search_query + '/' +(page+1) +'/" id="pagerPrev" title="Previous Page">Prev</a>';      
          }
          else
          {
            pager += '<span id="pageNext" class="nextprev">Next</span>';
          }
          $('#pager').append(pager);
        }
      }
    }
  });  
}

function LiveSearchClass() { };

LiveSearchClass.prototype.search = function(query, engine) 
{
    // Returns search results from search.live.com
    //
    // query: The query term for the search engine (default=cheese)
    // count: The number of results returned from the search engine (default=10)
    // first: The offset result for the query (default=0)
    //  lang: The UI culture language (default=en-us)
    // adult: The adult settings [off/strict/moderate] (default=off)
    var trimQuery = this.__trimParamValue(query); 
    if (trimQuery == "") throw "You must provide a query!";
    var count = userSettings.numMSNResults;
    var adult = 'strict';
    if (userSettings.disableSafeSearch)
      adult = 'off';

    var url = "http://search.live.com/json.aspx?q=" + escape(trimQuery);
    url += "&lang=en-us&adlt=strict&count=" + parseInt(count);
    url += "&first=0&sourcetype=web&form=popfly&adult="+adult;

    $.getScript(url, 
      function(data)  
      {
        try
        {
          var data = LiveSearchGetResponse();
          if (data && data.web)
          {
            data = data.web.results;

            var weight = userSettings.msnWeight/100;        
            var len = data.length;
            var r = data;
            var new_result;
            for(var i=0; i<len; i++)
            {
              new_result = new SearchResult(r[i].url, r[i].title, r[i].description, SearchEngineEnum.MSN, i+1, r[i].displayUrl, r[i].cacheUrl, -1, "");
              new_result.score = (Math.pow(1.3,(10-i)) * weight);  
              engine.addResult(new_result);
            }
          }
          searcher.callbackEngineWebSearchComplete(SearchEngineEnum.MSN);
        }
        catch (e)
        {
          searcher.callbackEngineWebSearchComplete(SearchEngineEnum.MSN);
        }
        searcher.havemsn = true;
      }
    );
    setTimeout("handleMSNTimeout()", 6000);

    return;
};

// function to trim parameters
LiveSearchClass.prototype.__trimParamValue = function(paramValue)
{   
    if(!paramValue)
    {
        return "";
    }
    else if (!isNaN(paramValue))
    {
        return paramValue;
    }
    
    return paramValue.trim();
};

// function to get the user language
LiveSearchClass.prototype.__getUserLanguage = function()
{   
    var lang = "";
    if (navigator.userAgent.indexOf("Firefox") != -1)
        lang = navigator.language;
    else if (navigator.userAgent.indexOf("MSIE") != -1)
        lang = navigator.browserLanguage;
    else
        lang = "en-us";
	
    return lang;
}

function handleVoteCheckTimeout()
{
  if (!searcher.haveScour)
    searcher.callbackEngineWebSearchComplete(SearchEngineEnum.Scour);
}

function handleGoogleTimeout()
{
  if (!searcher.haveGoogle)
    searcher.callbackEngineWebSearchComplete(SearchEngineEnum.Google);
}
function handleYahooTimeout()
{
  if (!searcher.haveYahoo)
    searcher.callbackEngineWebSearchComplete(SearchEngineEnum.Yahoo);
}
function handleMSNTimeout()
{
  if (!searcher.haveMSN)
    searcher.callbackEngineWebSearchComplete(SearchEngineEnum.MSN);
}

var feedback = {
	message: null,
	open: function (dialog) {
		// add padding to the buttons in firefox/mozilla
		if ($.browser.mozilla) {
			$('#feedback-container .feedback-button').css({
				'padding-bottom': '2px'
			});
		}
		// input field font size
		if ($.browser.safari) {
			$('#feedback-container .feedback-input').css({
				'font-size': '.9em'
			});
		}

		var title = $('#feedback-container .feedback-title').html();
		$('#feedback-container .feedback-title').html('Loading...');
		dialog.overlay.fadeIn(200, function () {
			dialog.container.fadeIn(200, function () {
				dialog.data.fadeIn(200, function () {
					$('#feedback-container .feedback-content').animate({
						height: 450
					}, function () {
						$('#feedback-container .feedback-title').html(title);
						$('#feedback-container form').fadeIn(200, function () {
							$('#feedback-container #feedback-name').focus();

							// fix png's for IE 6
							if ($.browser.msie && $.browser.version < 7) {
								$('#feedback-container .feedback-button').each(function () {
									if ($(this).css('backgroundImage').match(/^url[("']+(.*\.png)[)"']+$/i)) {
										var src = RegExp.$1;
										$(this).css({
											backgroundImage: 'none',
											filter: 'progid:DXImageTransform.Microsoft.AlphaImageLoader(src="' +  src + '", sizingMethod="crop")'
										});
									}
								});
							}
						});
					});
				});
			});
		});
	},
	show: function (dialog) {
		$('#feedback-container .feedback-send').click(function (e) {
			e.preventDefault();
			// validate form
			if (feedback.validate()) {
				$('#feedback-container .feedback-message').fadeOut(function () {
					$('#feedback-container .feedback-message').removeClass('feedback-error').empty();
				});
				$('#feedback-container .feedback-title').html('Sending...');
				$('#feedback-container form').fadeOut(200);
				$('#feedback-container .feedback-content').animate({
					height: '80px'
				}, function () {
					$('#feedback-container .feedback-loading').fadeIn(200, function () {
						$.ajax({
							url: '/feedback/send',
							data: $('#feedback-container form').serialize(),
							type: 'post',
							cache: false,
							dataType: 'json',
							complete: function (xhr) {
								$('#feedback-container .feedback-loading').fadeOut(200, function () {
									$('#feedback-container .feedback-title').html('Thank you!');
									$('#feedback-container .feedback-message').html(xhr.responseText).fadeIn(200);
								});
							},
							error: feedback.error
						});
					});
				});
			}
			else {
				if ($('#feedback-container .feedback-message:visible').length > 0) {
					var msg = $('#feedback-container .feedback-message div');
					msg.fadeOut(200, function () {
						msg.empty();
						feedback.showError();
						msg.fadeIn(200);
					});
				}
				else {
					$('#feedback-container .feedback-message').animate({
						height: '30px'
					}, feedback.showError);
				}
				
			}
		});
	},
	close: function (dialog) {
		$('#feedback-container .feedback-message').fadeOut();
		$('#feedback-container .feedback-title').html('Thanks!');
		$('#feedback-container form').fadeOut(200);
		$('#feedback-container .feedback-content').animate({
			height: 40
		}, function () {
			dialog.data.fadeOut(200, function () {
				dialog.container.fadeOut(200, function () {
					dialog.overlay.fadeOut(200, function () {
						$.modal.close();
					});
				});
			});
		});
	},
	error: function (xhr) {
//		alert(xhr.statusText);
	},
	validate: function () {
		feedback.message = '';
		if (!$('#feedback-container #feedback-name').val()) {
			feedback.message += 'Name is required. ';
		}

		var email = $('#feedback-container #feedback-email').val();
		if (!email) {
			feedback.message += 'Email is required. ';
		}
		else {
			if (!feedback.validateEmail(email)) {
				feedback.message += 'Email is invalid. ';
			}
		}

    if (!$('#feedback-container #feedback-section').val())
    {
      feedback.message += 'Topic is required.';
    }

		if (!$('#feedback-container #feedback-message').val()) {
			feedback.message += 'Message is required.';
		}

		if (feedback.message.length > 0) {
			return false;
		}
		else {
			return true;
		}
	},
	validateEmail: function (email) {
		var at = email.lastIndexOf("@");

		// Make sure the at (@) sybmol exists and  
		// it is not the first or last character
		if (at < 1 || (at + 1) === email.length)
			return false;

		// Make sure there aren't multiple periods together
		if (/(\.{2,})/.test(email))
			return false;

		// Break up the local and domain portions
		var local = email.substring(0, at);
		var domain = email.substring(at + 1);

		// Check lengths
		if (local.length < 1 || local.length > 64 || domain.length < 4 || domain.length > 255)
			return false;

		// Make sure local and domain don't start with or end with a period
		if (/(^\.|\.$)/.test(local) || /(^\.|\.$)/.test(domain))
			return false;

		// Check for quoted-string addresses
		// Since almost anything is allowed in a quoted-string address,
		// we're just going to let them go through
		if (!/^"(.+)"$/.test(local)) {
			// It's a dot-string address...check for valid characters
			if (!/^[-a-zA-Z0-9!#$%*\/?|^{}`~&'+=_\.]*$/.test(local))
				return false;
		}

		// Make sure domain contains only valid characters and at least one period
		if (!/^[-a-zA-Z0-9\.]*$/.test(domain) || domain.indexOf(".") === -1)
			return false;	

		return true;
	},
	showError: function () {
		$('#feedback-container .feedback-message')
			.html($('<div class="feedback-error">').append(feedback.message))
			.fadeIn(200);
	}
};

function showdemo(mypopurl,mypopname,sizew,sizeh,poppos,auFoyer){
  var fenetre;
  if(poppos=="center"){magauche=(screen.width)?(screen.width-sizew)/2:100;monhaut=(screen.height)?(screen.height-sizeh)/2:100;}
  else if((poppos!='center') || poppos==null){magauche=+0;monhaut=+0}
    reglages="width=" + sizew + ",height=" + sizeh + ",top=" + monhaut + ",left=" + magauche + ",scrollbars=yes,location=no,directories=no,status=no,menubar=no,toolbar=no,resizable=yes";fenetre=window.open(mypopurl,mypopname,reglages);
    fenetre.focus();
}

/**
*
*  Base64 encode / decode
*  http://www.webtoolkit.info/
*
**/

var Base64 = {

    // private property
    _keyStr : "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",

    // public method for encoding
    encode : function (input) {
        var output = "";
        var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
        var i = 0;

        input = Base64._utf8_encode(input);

        while (i < input.length) {

            chr1 = input.charCodeAt(i++);
            chr2 = input.charCodeAt(i++);
            chr3 = input.charCodeAt(i++);

            enc1 = chr1 >> 2;
            enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
            enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
            enc4 = chr3 & 63;

            if (isNaN(chr2)) {
                enc3 = enc4 = 64;
            } else if (isNaN(chr3)) {
                enc4 = 64;
            }

            output = output +
            this._keyStr.charAt(enc1) + this._keyStr.charAt(enc2) +
            this._keyStr.charAt(enc3) + this._keyStr.charAt(enc4);

        }

        return output;
    },

    // public method for decoding
    decode : function (input) {
        var output = "";
        var chr1, chr2, chr3;
        var enc1, enc2, enc3, enc4;
        var i = 0;

        input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");

        while (i < input.length) {

            enc1 = this._keyStr.indexOf(input.charAt(i++));
            enc2 = this._keyStr.indexOf(input.charAt(i++));
            enc3 = this._keyStr.indexOf(input.charAt(i++));
            enc4 = this._keyStr.indexOf(input.charAt(i++));

            chr1 = (enc1 << 2) | (enc2 >> 4);
            chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
            chr3 = ((enc3 & 3) << 6) | enc4;

            output = output + String.fromCharCode(chr1);

            if (enc3 != 64) {
                output = output + String.fromCharCode(chr2);
            }
            if (enc4 != 64) {
                output = output + String.fromCharCode(chr3);
            }

        }

        output = Base64._utf8_decode(output);

        return output;

    },

    // private method for UTF-8 encoding
    _utf8_encode : function (string) {
        string = string.replace(/\r\n/g,"\n");
        var utftext = "";

        for (var n = 0; n < string.length; n++) {

            var c = string.charCodeAt(n);

            if (c < 128) {
                utftext += String.fromCharCode(c);
            }
            else if((c > 127) && (c < 2048)) {
                utftext += String.fromCharCode((c >> 6) | 192);
                utftext += String.fromCharCode((c & 63) | 128);
            }
            else {
                utftext += String.fromCharCode((c >> 12) | 224);
                utftext += String.fromCharCode(((c >> 6) & 63) | 128);
                utftext += String.fromCharCode((c & 63) | 128);
            }

        }

        return utftext;
    },

    // private method for UTF-8 decoding
    _utf8_decode : function (utftext) {
        var string = "";
        var i = 0;
        var c = c1 = c2 = 0;

        while ( i < utftext.length ) {

            c = utftext.charCodeAt(i);

            if (c < 128) {
                string += String.fromCharCode(c);
                i++;
            }
            else if((c > 191) && (c < 224)) {
                c2 = utftext.charCodeAt(i+1);
                string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
                i += 2;
            }
            else {
                c2 = utftext.charCodeAt(i+1);
                c3 = utftext.charCodeAt(i+2);
                string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
                i += 3;
            }

        }

        return string;
    }
}

/* Validation */

var errorMsg = {
  'length':'Please enter a longer comment, a minimum of 30 characters.',
  'repeatlines':'Your comment plays like a broken record. Please update your comment.',
  'repeatletters':'What is "#offense#"? Please update your comment, thanks!',
  'sparsevowels':'What is "#offense#"? Please update your comment, thanks!',
  'wordrepeat':'Woah, too much repetition, please be more detailed',
  'manysymbols':'That\'s a lot of symbols. Please update your comment, thanks!',
  'repeatsymbols':'What is "#offense#"? Please update your comment, thanks!',
  'repeatnumbers':'What is "#offense#"? Please update your comment, thanks!',
  'linebreaks':'That is a lot of lines for that much content.',
  'manylinks':'You\'re posting too many links.',
  'wordlengthtoolong': 'What is "#offense#"? Please update your comment, thanks!',
  'urllengthtoolong': 'Very sorry but we do not allow urls longer than 100 characters.'
};




function watchTextarea(el) {
  var par = el.parent();
  var txt = el;  

  par.find('.addCommentPostPos').click(function(e){
    e.preventDefault();
    $(this).hide();
    var comment = txt.val();
    if (!validateComment(comment))
    {
      $(this).show();
      return false;
    }

    var url = (par.parent().parent().find(".resultUrl").text());

    var commentLength = comment.replace(/ /g, '').length;
    if (commentLength < 30 || commentLength > 500)
    {
      par.find('.addCommentErrorsText').text('Your comment must be between 30 and 500 characters.');
      par.find('.addCommentErrors').show();
      $(this).show();
    }
    else
    {
      par.find('.addCommentErrorsText').text('');
      par.find('.addCommentErrors').hide();
      addComment(comment, url, 1, txt, $(this));
    }
  });

  par.find('.addCommentPostNeg').click(function(e){
    e.preventDefault();
    $(this).hide();
    var comment = txt.val();
    if (!validateComment(comment)) {
      $(this).show();
      return false;
    }

    var url = (par.parent().parent().find(".resultUrl").text());

    var commentLength = comment.replace(/ /g, '').length;
    if (commentLength < 30 || commentLength > 500)
    {
      par.find('.addCommentErrorsText').text('Your comment must be between 30 and 500 characters.');
      par.find('.addCommentErrors').show();
      $(this).show();
    }
    else
    {
      par.find('.addCommentErrorsText').text('');
      par.find('.addCommentErrors').hide();
      addComment(comment, url, 0, txt, $(this));
    }    
  });

  function triggerError(errorKey, offense) {
    var err
    if(offense!=undefined) {
      err = errorMsg[errorKey].replace(/#offense#/g,offense);
    } else {
      err = errorMsg[errorKey];
    }
    par.find('.addCommentErrorsText').text(err);
    par.find('.addCommentErrors').show();
  }

  function clearError() {

    par.find('.addCommentErrorsText').text('');
    par.find('.addCommentErrors').hide();
    par.find('.addCommentPosted').hide();    
  }

  function validateComment(comment)
  {
    var commentLines = comment.split('\n').length;
    var commentLength = comment.replace(/ /g, '').length;
    // Extract URLs
    var commentUrls = comment.match(/http[^ ]+/gi);
    // Remove URLs from data we'll be testing
    comment = comment.replace(/http[^ ]+/gi,' ');
    var commentWords = comment.split(' ');
    for(var i=0; i<commentWords.length; i++)
      commentWords[i] = commentWords[i].toString();

    clearError();   

    // Comment length between 30-500
    par.find('.currentCharacters').text(commentLength.toString());
    if(commentLength < 30 || commentLength > 500) {
      par.find('.addCommentCharacters').removeClass('addCommentCharactersGood');
      par.parent().find('.addCommentPostNeg').removeClass('addCommentPostNegGood');
      par.parent().find('.addCommentPostPos').removeClass('addCommentPostPosGood');
    }
    else {
      par.find('.addCommentCharacters').addClass('addCommentCharactersGood');
      par.parent().find('.addCommentPostNeg').addClass('addCommentPostNegGood');
      par.parent().find('.addCommentPostPos').addClass('addCommentPostPosGood');
    }
        
    // check url lengths
    for(var x in commentUrls)
    {
      if (commentUrls[x].length > 100)
      {
        triggerError('urllengthtoolong',commentUrls[x]);
        return false;
      }
    }

    // check word lengths
    for (var x in commentWords)
    {
      if (commentWords[x].length > 35)
      {
         triggerError('wordlengthtoolong',commentWords[x]);
        return false;
      }
    }

    // Update Comment Length Counter
    par.find('.currentCharacters').text(commentLength.toString());

    // Repetitive Characters - 4 in a row
    var repetitiveChars = comment.match(/([^ ])\1\1\1/g);
    if(repetitiveChars) {
      for(var x in commentWords) {
        if(commentWords[x].toString().indexOf(repetitiveChars[0])>=0) {
          var letOffense = commentWords[x];
          if(letOffense != undefined) {
            break;
          }
        }
      }
      if(letOffense!=undefined) {
        triggerError('repeatletters',letOffense);
        return false;
      }
    }

    // Repetitive Numbers - Including spaces
    var repetitiveNumbers = comment.replace(/ /g,'').match(/[0-9 ]{6,}/g);
    if(repetitiveNumbers) {
      var numOffense = repetitiveNumbers[0];
      triggerError('repeatnumbers',numOffense);
      return false;
    }

    // Repetitive Words
    // Remove all spaces and then check
    if(comment.replace(/ /g,'').match(/([a-z]{2,})\1\1/gi)) {
      triggerError('wordrepeat');
      return false;
    }

    // Repeating Consonants
    var repeatConsonants = comment.match(/([qwrtplkjhgfdszxcvbnm]{5,})/gi);
    if(repeatConsonants) {
      for(var x in commentWords) {
        if(commentWords[x].toString().indexOf(repeatConsonants[0])>=0) {
          var vowelOffense = commentWords[x];
          break;
        }
      }
      triggerError('sparsevowels',vowelOffense);
      return false;
    }

    // More than 10 non-punctuation symbols
    if(comment.replace(/[a-z0-9 \.\,\?\!\(\)\;\:\/]/gi,'').length>10) {
      triggerError('manysymbols');
      return false;
    }

    // 4+ Repeating Symbols
    var repeatingSymbols = comment.replace(/ /g,'').match(/([^a-z0-9\/\.\,\?\!\(\)\;\:\\\n/]{4,})/i);
    if(repeatingSymbols) {
      var symbolOffense = repeatingSymbols[0];
      triggerError('repeatsymbols',symbolOffense);
      return false;
    }

    // More than 3 links
    if(commentUrls) {
      if(commentUrls.length>3) {
        triggerError('manylinks');
        return false;
      }
    }

    // Too many line breaks
    // Must average 15 characters per line
    if(commentLines > 3 && (commentLength/commentLines)<15) {
      triggerError('linebreaks');
      return false;
    }

    // Repetitive Lines
    var repeatLines = comment.match(/^(.*)\n\1\n\1/gm);
    if(repeatLines) {
      triggerError('repeatlines');
      return false;
    }
    return true;
  }

  $(el).keydown(function(e){
    if ((e.which != 86 && !e.ctrlKey) || !e.ctrlKey)
      validateComment($(this).val());
    });
}

// filter tool wiring
$(document).ready(function(){
  var searchbar = $('#txtSearch');
  $('#filter').css('opacity',0.90)

  // Set a flag so we can't open a filter while filtering
  var filterShown = false;
  $('#results').dblclick(function(e){
    if(filterShown) {
      return;
    }
    var clickPosition = {x:e.pageX,y:e.pageY};

    // Get the word they selected
    var word = $.trim(getSelected());

    // If they selected a bunch of words, abort mission
    if(word.match(/\s+/g)) {
      return;
    }

    // If their word is less than 3 characters, abort mission
    if(word.length < 3) {
      return;
    }

    var top = clickPosition.y + 9;
    
    var left = clickPosition.x - 88;
    if (left <= 20)
      left = 20;

    $('#filter').css({
      'top': top+"px",
      'left': left+"px"

    })

    $('#filterKeyword').val(word);

    $('#filter').show('fast');
    filterShown = true;
  })

  $(document).click(function(e){
    if(!filterShown) {
      return;
    }

    if(e.target.id=='filter' || e.target.parentNode.id=='filter') {
      return;
    }

    hideFilter();
  })

  $('#filterInclude').click(function(e){
    e.preventDefault();
    var kw = $('#filterKeyword').val();

    // Check and make sure keyword doesn't already exist, or is excluded
    var q = searchbar.val();
    var qbits = q.split(' ');
    var nq = [];
    var added = false;
    for(var i=0;i<qbits.length; i++) {
      var qb = qbits[i];
      if(qb.toLowerCase()==kw.toLowerCase()) {
        return;
      }
      if(qb.toLowerCase()=="-"+kw.toLowerCase()) {
        nq.push(kw);
        added = true;
      } else {
        nq.push(qb);
      }
    }

    if(!added) {
      nq.push(kw);
    }

    searchbar.val(nq.join(' '));
    hideFilter();
    $("#btnSearch").click();
  })

  $('#filterExclude').click(function(e){
    e.preventDefault();
    var kw = $('#filterKeyword').val();

    // Check and make sure keyword doesn't already exist, or is excluded
    var q = searchbar.val();
    var qbits = q.split(' ');
    var nq = [];
    var added = false;
    for(var i=0;i<qbits.length; i++) {
      var qb = qbits[i];
      if(qb.toString().toLowerCase()=="-"+kw.toLowerCase()) {
        return;
      }
      if(qb.toString().toLowerCase()==kw.toLowerCase()) {
        nq.push("-"+kw);
        added = true;
      } else {
        nq.push(qb);
      }
    }

    if(!added) {
      nq.push("-"+kw);
    }

    searchbar.val(nq.join(' '));
    hideFilter();
    $("#btnSearch").click();
  })

  function hideFilter() {
    filterShown = false;
    $('#filter').hide('fast');
  }

  $("#filterKeyword").hover(
      function () {
        $(this).css("borderColor", "#f0f0f0");
      },
      function () {
        $(this).css("borderColor", "#fff");
      }
    );
  $("#filterKeyword").focus(
      function () {
        $(this).css("borderColor", "#f0f0f0");
      },
      function () {
        $(this).css("borderColor", "#fff");
      }
    );
  $('#filterClose').click(function(){
    hideFilter();
  })
  
});

//report comment
$(document).ready(function(){
  $('#reportform-submit').click(function(){
    $.ajax({
      url: '/services/reportcomment/',
      data: {
        'commentid': $('#reportform-commentid').text(),
        'reportcomment-type' : $("input[@name='abusetype']:checked").val(),
        'message' : $('#report-form-info').val()
      },
      type: 'post',
      cache: false,
      dataType: 'json',
      success: function (data) {
        $.modal.close();
      }
    });         
  });
});

//login form
$(document).ready(function(){
  $('#loginform-join').click(function(){
    window.location.href = '/signup/';
  });

  $('#header_signin').click(function(e){
    e.preventDefault();
    showLoginModal();
  });

  $('#loginform-login').click(function(e){
    e.preventDefault();
    $.ajax({
      url: '/services/login/',
      data: {
        'username': $('#login-username').val(),
        'password' : $("#login-password").val()
      },
      type: 'post',
      cache: false,
      dataType: 'json',
      success: function (data) {
        if (data.success)
        {
          userSettings.userid = data.id;
          userSettings.username = data.username;
          cookies.saveSettings();
          $("#sign_in_user").hide();
          $("#new_user").hide();
          $("#welcome_user_name").html(userSettings.username);
          $("#welcome_user").show();
          $("#points_logout").show();
          getUserPoints();
          searcher.loadElements();
          searcher.search(gTerm);

          $.modal.close();
        }
        else
          $('#loginform-error').text(data.message);
      }
    });
  });

  // handle enter/esc
  $('#login-username, #login-password').keydown(function(e){
    if(e.keyCode == 27)
      $.modal.close()
    else if (e.keyCode == 13)
      $('#loginform-login').click();
  });
});

function showLoginModal()
{
  $("#loginmodal").modal({
      close: false,
      overlayId: 'login-overlay',
      containerId: 'login-container',
      onOpen: login_screen.open
    });

    $('#login-username').focus();
}

var login_screen = {
  open: function(dialog)
  {
    dialog.overlay.fadeIn(300, function () {
        dialog.container.fadeIn(300, function () {
          dialog.data.fadeIn(300, function () { });
        });
    });
  }
}


function getSelected() {
  var word
  if($.browser.msie) {
    word = document.selection.createRange().text;
    document.selection.empty();
    return word;
  } else {
    return window.getSelection()+'';
    /*var selection = window.getSelection();

    if(selection.anchorNode == null || typeof(selection.anchorNode)=="undefined") {
      return;
    }

    var text = selection.anchorNode.nodeValue;

    if(text == null || typeof(text)=="undefined" || text == "") {
      return;
    }

    word = text.substring(selection.anchorOffset, selection.focusOffset);

    // Deselect the word
    selection.collapse(document.body,0);
    return word;*/
  }
}
