
var sendForm; // Con esto, simpiamos la funcion sendForm
if (!sendForm || isUndefined(sendForm) || !isFunction(sendForm)) {
function sendForm(form,element,value,action,confirm_text) {
   // alert(document.forms[form].action);
   //alert ( document.forms[form].elements[element].name + document.forms[0].elements[0].value );
   if (element && value && form) {
      document.forms[form].elements[element].value = value;
   }
   if (action) document.forms[form].action = '?seccion=' + action;
   //alert ( document.forms[form].action + " -- " + document.forms[form].elements[element].name + " -- " + document.forms[form].elements[element].value );
   if (!isUndefined(confirm_text)) {
      if (confirm(confirm_text)) $(form).submit();
   } else {
      if (!isUndefined(form)) {
      	$(form).submit();
	}
   }
   return false;
}
}

/*
* This function will not return until (at least)
* the specified number of milliseconds have passed.
* It does a busy-wait loop.
*/
function pause(numberMillis) {
	var now = new Date();
	var exitTime = now.getTime() + numberMillis;
	while (true) {
		now = new Date();
		if (now.getTime() > exitTime) return;
	}
}

var inmForm = Class.create();
Object.extend(inmForm,Form);
inmForm.disableDescendants = function (id,whichElements,typeName,name) {
	oId = $(id);
	var oInputs = Form.getElements(oId);
	var oItem;
	if (oInputs.length) {
		for (i=0; i<oInputs.length; i++) {
			if (isObject(oInputs[i])) {
				oItem = oInputs[i];
				oItem.disabled = true;
			}
		}
	}
}
inmForm.enableDescendants = function (id,whichElements,typeName,name) {
	// alert("Form.disableDescendants .... ");
	oId = $(id);

	var oInputs = Form.getElements(oId);
	if (oInputs.length) {
		for (i=0; i<oInputs.length; i++) {
			var oItem = oInputs[i];
			if (oItem.glow) oItem.glow();
			oItem.disabled = false;
		}
	}
}
inmForm.findFirstElement = function (id,bCheckDisabled,bCheckHidden) {
	if (isUndefined(bCheckDisabled) || !isBoolean(bCheckDisabled)) bCheckDisabled = true;
	if (isUndefined(bCheckHidden) || !isBoolean(bCheckHidden)) bCheckHidden = true;
	if (bCheckDisabled && bCheckHidden) {
		var anonFunc = function(element) { return element.type != 'hidden' && !element.disabled && ['input', 'select', 'textarea'].include(element.tagName.toLowerCase()); }
	} else if (bCheckDisabled && !bCheckHidden) {
		var anonFunc = function(element) { return !element.disabled && ['input', 'select', 'textarea'].include(element.tagName.toLowerCase()); }
	} else if (!bCheckDisabled && bCheckHidden) {
		var anonFunc = function(element) { return element.type != 'hidden' && ['input', 'select', 'textarea'].include(element.tagName.toLowerCase()); }
	} else {
		var anonFunc = function(element) { return ['input', 'select', 'textarea'].include(element.tagName.toLowerCase()); }
	}
	return inmForm.getElements(id).find(anonFunc);
}
inmForm.getVisibleElements = function (id,bCheckDisabled,bCheckHidden) {
	if (isUndefined(bCheckDisabled) || !isBoolean(bCheckDisabled)) bCheckDisabled = true;
	if (isUndefined(bCheckHidden) || !isBoolean(bCheckHidden)) bCheckHidden = true;
	if (bCheckDisabled && bCheckHidden) {
		var anonFunc = function(element) { return element.type != 'hidden' && !element.disabled && ['input', 'select', 'textarea'].include(element.tagName.toLowerCase()); }
	} else if (bCheckDisabled && !bCheckHidden) {
		var anonFunc = function(element) { return !element.disabled && ['input', 'select', 'textarea'].include(element.tagName.toLowerCase()); }
	} else if (!bCheckDisabled && bCheckHidden) {
		var anonFunc = function(element) { return element.type != 'hidden' && ['input', 'select', 'textarea'].include(element.tagName.toLowerCase()); }
	} else {
		var anonFunc = function(element) { return ['input', 'select', 'textarea'].include(element.tagName.toLowerCase()); }
	}
	return inmForm.getElements(id).select(anonFunc);
}
inmForm.focusNextElement = function (rootEl,actualEl,funcLast) {
	if (isUndefined(rootEl) || !rootEl) return false;
	aList = inmForm.getVisibleElements(rootEl).sortBy(function(el,pos) { return el.tabIndex; });
	if (aList.length) {
		if (isUndefined(actualEl)) {
			if (aList[0].select) aList[0].select();
			aList[0].focus();
		} else {
			for (i=0; i<aList.length; i++) {
				if (aList[i]==actualEl) {
					if (!isUndefined(aList[i+1])) {
						if (aList[i+1].type=="text") aList[i+1].select();
						aList[i+1].focus();
						rval = true;
					} else {
						if (isFunction(funcLast)) {
							rval = funcLast(aList[i]);
						} else rval = false;
					}
					break;
				}
			}
		}
	} else rval = false;
	return rval;
}

var $FLD = function (frm,type,name) {
	var tmp = inmForm.getInputs(frm,type,name);
	if (!tmp || isUndefined(tmp)) return;
	var tmpid = tmp[0];
	if (!tmpid || isUndefined(tmpid)) return;
	return Form.Element.getValue(tmpid);
}

var HashMap = Class.create();
HashMap.prototype = {
	initialize: function HashMap() {
		this.aKeys = new Array();
		this.aVals = new Array();
	},
	put: function put (key,val) {
		pos = this.aKeys.length;
		for (var i=0; i<this.aKeys.length; i++) 
			if (this.aKeys[i]==key) {
				pos = i;
				break;
			}
		this.aKeys[pos] = key;
		this.aVals[pos] = val;
	},
	get: function get (key) {
		for (var i=0; i<this.aKeys.length; i++) {
			if (this.aKeys[i]==key) return this.aVals[i];
		}
	},
	remove: function remove (key) {
		for (i=0; i<this.aKeys.length; i++) {
			if (this.aKeys[i]==key) {
				this.aKeys[i] = null;
				this.aVals[i] = null;
				for (var j=i; j<(this.aKeys.length-1); j++) {
					this.aKeys[j]=this.aKeys[j+1];
					this.aVals[j]=this.aVals[j+1];
				}
				this.aKeys.length--;
				this.aVals.length--;
				return true;
			}
		}
		return false;
	},
	keys: function keys () {
		return this.aKeys;
	},
	toQueryString: function () {
		rval = '';
		for (i=0; i<this.aKeys.length; i++) {
			if (this.aVals[i] && !isUndefined(this.aVals[i]) && 
				(isNumber(this.aVals[i]) || this.aVals[i].length>0 ) ) {
				if (rval.length>0) rval += '&';
				rval += this.aKeys[i]+'='+this.aVals[i];
			}
		}
		return rval;
	},

	limitTo: function (n) {
		var strK="";
		//for (var k in this.aKeys) if (!isFunction(k) && !isFunction(this.aKeys[k])) strK+=" k: "+this.aKeys[k];
		//alert("limitTo "+n+" / "+this.aKeys.length+" que son: "+strK);
		if (this.aKeys.length>0 && this.aKeys.length>n) {
			this.remove(this.aKeys.first());
		}
	},

	count: function () {
		return this.aKeys.length;
	}
}

var mydom = Class.create();
mydom.findElements = function (oBase,tag,name) {
	var aRetVal = new Array();

	oId = $(oBase);
	if (!tag && !name) return;

	var bName = undefined;
	if (!isUndefined(tag)) { 
		bName = false;
		aTmpList = document.getElementsByTagName(tag); 
	} else { 
		// Antes estaba este primero. Pero getElementsByName, aunque existe en IE para WinCE, devuelve una lista vacia :(
		// Asi que, siempre vamos a hacer la busqueda con getElementsByTagName.
		aTmpList = document.getElementsByName(name); 
		bName = true;
	}
	if (!isUndefined(name)) bName = true;
	else bName = false;

	for (var i=0; i<aTmpList.length; i++) {
		// Comprobamos que es el tag que buscamos
		if (!isUndefined(tag) && aTmpList[i].tagName.toUpperCase() != tag.toUpperCase()) { continue; }
		if (!isUndefined(name) ) {
			try {
				tmp = Element.readAttribute(aTmpList[i],"name");
			} catch (e) { 
				tmp = undefined; 
			}
			if (isString(tmp) && tmp.toUpperCase() != name.toUpperCase()) { continue; }
		}
		// Comprobamos que sea descendiente de la base.
		for (var element = aTmpList[i]; element.parentNode; element = element.parentNode) {
			if (element == oBase) {
				//alert("OK!! ");
				aRetVal[aRetVal.length] = aTmpList[i];
			}
		}
	}
	return aRetVal;
}

