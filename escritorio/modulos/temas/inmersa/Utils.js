
var SonSwitchByCSS = Class.create();
SonSwitchByCSS.prototype = {
	cssContentHidden: 'RowBlur',
	cssContent: 'RowStd',
	cssContentHighLight: 'RowHi',
	bDisableForm: false,
	oItem: null,
	initialize: function SonSwitchByCSS(oParent,oDomItem) {
		this.oItem = $(oDomItem);
		//.domBasethis.oParent = $(oParent);
		this.oParent = oParent;
		return this;
	},

	blur: function SonSwitchByCSS__blur() {
		oRow = this.getItem();
		if (this.bDisableForm) inmForm.disableDescendants(oRow);
		oRow.className = this.cssContentHidden;
		//alert("blur base (" +oRow.id+ ") para " + oRow.getAttribute('name') + " tipo: " + oRow + " poniendo clas: " + oRow.className);
	},

	glow: function SonSwitchByCSS__glow() {
		oRow = this.oItem;
		// alert("Glow sobre " + oRow + " nombre: " + oRow.getAttribute('name') + " css: " + this.cssContent);
		oRow.className = this.cssContent;
		if (this.bDisableForm) inmForm.enableDescendants(oRow);
	},

	highLight: function SonSwitchByCSS__highLight() {
		oRow = this.oItem;
		oRow.className = this.cssContentHighLight;
	},

	restore: function SonSwitchByCSS__restore() {
		oRow = this.oItem;
		oRow.className = this.cssContent;
	},

	getItem: function SonSwitchByCSS__getItem() {
		return this.oItem;
	},

	getRoot: function SonSwitchByCSS__getRoot() {
		if (this.oParent && this.oParent.getRoot) return this.oParent.getRoot();
		else if (this.oParent) return this.oParent;
		else return this;
	},

	submitForm: function SonSwitchByCSS__submitForm() {
		var oI = this.getItem();
		var aTmp, vname, vvalue, target, vtext, oFrm, oTarget, retval = false;
		var aInputs = inmForm.getInputs(oI,'hidden','__target');
		if (aInputs.length) {
			oRaiz = this.getRoot();
			aTmp = oRaiz.findElement(oI,'input','__target');
			if (aTmp && aTmp.length>0) {
				oTarget = aTmp.shift();
				target = $F(oTarget);
				oFrm = oTarget.form;
			}
			if (isObject(oFrm)) {
				aTmp = oRaiz.findElement(oI,'input','__target_setvar');
				if (aTmp && aTmp.length>0) vname = $F(aTmp.shift());
				aTmp = oRaiz.findElement(oI,'input','__target_setval');
				if (aTmp && aTmp.length>0) vvalue = $F(aTmp.shift());
				aTmp = oRaiz.findElement(oI,'input','__target_confirm');
				if (aTmp && aTmp.length>0) vtext = $F(aTmp.shift());
				// var vname = oRaiz.findElement(oI,'input','__target_followup_setvar');
				// var vvalue = $F('__target_followup_setval');
				// alert("Tenemos para mandar a " + target + " variable: " + vname + " con valor: " + vvalue);
				if (oFrm) {
					inmForm.enableDescendants(oFrm);
					sendForm(oFrm.getAttribute('name'),vname,vvalue,target,vtext);
					retval = true;
				}
			}
		}
		return retval;
	}
}

var KeyboardDriver = Class.create();
KeyboardDriver.prototype = {
	debug: false,
	initialize: function KeyboardDriver(doc) {
		if (doc) {
			Event.observe(doc,'keydown',this.keyPress.bindAsEventListener(this),true);
			// Event.observe(doc,'keydown',function (ev) { alert("Tecla: "+ev); return true;},true);
		}
		this.aEvents = new HashMap();
		this.aEvents.put('DOWN',new Array());
		this.aEvents.put('UP',new Array());
		this.aEvents.put('RIGHT',new Array());
		this.aEvents.put('LEFT',new Array());
		this.aEvents.put('ESC',new Array());
		this.aEvents.put('INTRO',new Array());
		this.aEvents.put('TAB',new Array());
		this.aEvents.put('NUM_0',new Array());
		this.aEvents.put('NUM_1',new Array());
		this.aEvents.put('NUM_2',new Array());
		this.aEvents.put('NUM_3',new Array());
		this.aEvents.put('NUM_4',new Array());
		this.aEvents.put('NUM_5',new Array());
		this.aEvents.put('NUM_6',new Array());
		this.aEvents.put('NUM_7',new Array());
		this.aEvents.put('NUM_8',new Array());
		this.aEvents.put('NUM_9',new Array());
		this.aEvents.put('LET_A',new Array());
		this.aEvents.put('ALL',new Array());
	},

	abc: "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
	mapKeyCode: function mapKeyCode(code) {
		var retval;
		if (!code) return null;

		aRetVal = {};
		switch (code) {
			case 40:
				retval = "DOWN";
				break;
			case 38:
				retval = "UP";
				break;
			case 39:
				retval = "RIGHT";
				break;
			case 37:
				retval = "LEFT";
				break;
			case 27:
				retval = "ESC";
				break;
			case 13:
				retval = "INTRO";
				break;
			case 9:
				retval = "TAB";
				break;
			default:
				if (code >= 48 && code <= 57) {
					retval = 'NUM_' + (code-48);
				} else if (code >= 96 && code <= 105) {
					retval = 'NUM_' + (code-96);
				} else if (code >= 65 && code <= 90) {
					retval = 'LET_' + this.abc[code-65];
					//alert("Codigo REconocido: "+retval);
				} else {
					retval = '';
					//alert("Codigo desconocido: "+code);
				}
				break;
		}
		aRetVal['keyCode'] = code;
		aRetVal['strKey'] = retval;
		aRetVal['char'] = String.fromCharCode(code);
		return aRetVal;
	},

	register: function registerKey (tecla,method,instance) {
		var aK = this.aEvents.keys();
		for (i=0;i<aK.length;i++) {
			if (tecla==aK[i] || tecla=="all") {
				aL = this.aEvents.get(aK[i]);
				pos = aL.length;
				if (instance && instance != 'undefined') aL[pos] = method.bind(instance);
				else aL[pos] = method;
			}
		}
	},

	keyPress: function (evento) {
		var retval = true;
		var evList = null;

		var targ;
		if (!evento) var evento = window.event;
		// alert("KeyboardDriver::keyPress, con este: " + this + " evento: " + evento);
		var self = this;
		if (!self) {
			alert("No he conseguido sacar la instancia listado");
			return true;
		}

		if (evento && isNumber(evento.keyCode)) code = evento.keyCode;
		aTecla = this.mapKeyCode(code);
		// if (aTecla.strKey=="UP") alert(" KeyboardDriver:: keypress UP ");

		var tecla = aTecla.strKey;
		evList = this.aEvents.get(tecla);
		//alert("keyPress, con este: " + tecla + " y eventos: " + evList.length);
		if (evList && evList.length) {
			var rval;
			for (var i=0; i<evList.length; i++) {
				if (isUndefined(evList[i])==true) { continue; }
				if (isUndefined(evList[i])) {
					alert("Siguienteeeeeeeee");
					continue;
				}
				rval = false;
				//PaBorrar: if (evList[i][1].call(evList[i][0],aTecla,evento)) break;
				// alert("Llamar a: " + evList[i]);
				//alert("fnc: "+(evList[i])+" rval is "+rval+" con tipo: "+typeof evList[i]+" El is: "+isUndefined(evList[i]));
				//alert("fnc: "+(evList[i])+" evento: "+evento+" target: "+evento.target+" src: "+evento.srcElement);
				rval = evList[i](aTecla,evento);
				//if (evList[i](aTecla,evento)==true) 
				if (false && !isFunction(evList[i])) {
					//alert(" putaaAaAaAaaAaaAAaaAaAaaAaaaa "+i+" de tot: "+evList.length);
					continue;
				}
				//alert("El rval: "+rval)
				if (rval) {
					//alert("Ya tenemos quien se encarge. no permea ");
					if (evento.preventDefault) {
						// alert("CANCELANDO el evento "+evento+" rval: "+rval);
						evento.preventDefault();
					}
					retval = false;
					// alert("Un break ... ");
					break;
				} 
			}
		}
		// alert(" keyPress rval "+retval);
		//pause(100);
		return retval;
	}
}

/** FIN de para desplzara a una extension de prototipos **/

var TableSwitcher = Class.create();
TableSwitcher.prototype = {
	cssContentHidden: 'oculto',
	cssContentVisible: 'full',
	defaultHandler: undefined,
	initialize: function TableSwitcher(domID) {
		if (!isUndefined(domID) && domID != null) {
			this.domLegend = domID;
		} else this.domLegend = undefined;
		this.current = -1;
		this.aTables = new Array();
		this.aKeys = new Array();
		document.bgColor = "#FFFFCC";
	},

	add: function add(oTb,strKey) {
		if (isUndefined(oTb) || isUndefined(oTb.registerSwitch)) return;
		var pos =  this.aTables.length;
		oTb.registerSwitch(this,pos);
		this.aTables[pos] = oTb;
		this.aKeys[pos] = strKey;
	},

	keyPress: function keyPress(aT,ev) {
		var retval;
		//alert('TableSwitcher::keypress() ');
		if (this.current!=-1) {
			//alert("Nuestro current es: "+this.current);
			// alert("El contenido es: "+this.aTables[this.current]);
			if (!isUndefined(this.aTables[this.current].keyPress)) {
				retval = this.aTables[this.current].keyPress(aT,ev);
			} else if (!isUndefined(this.defaultHandler)) { this.defaultHandler(aT,ev); }
		} else {
			// true, es en realidad "yo me encargo"
			retval = false;
			for (i=0;i<this.aKeys.length;i++) {
				if (aT.strKey==this.aKeys[i]) {
					this.activate(i);
					retval = true;
					//alert("Activando. "+i+" rv: "+retval);
					break;
				}
			}
			if (!retval && !isUndefined(this.defaultHandler)) { this.defaultHandler(aT,ev); }
		}
		return retval;
	},

	activate: function (pos) {
		//alert("Activando "+this.aTables[this.current]+" num: "+this.current);
		if (this.current != -1) {
			this.deactivate(this.current);
		}
		document.bgColor = "#FFFFFF";
		this.current = pos;
		if (!isUndefined(this.domLegend)) this.domLegend.className = this.cssContentHidden;
		if (this.aTables[this.current].focus) this.aTables[this.current].focus();
	},

	deactivate: function (pos) {
		//if (this.current != pos) return;
		// alert("DE-Activando "+this.aTables[pos]+" num: "+pos+" cur:"+this.current+" mnu: "+this.domLegend);
		document.bgColor = "#FFFFCC";
		this.aTables[pos].blur();
		this.current = -1;
		if (!isUndefined(this.domLegend)) this.domLegend.className = this.cssContentVisible;
	},

	registerDefaultKeyHandler: function (fnc) {
		if (!isUndefined(fnc) && isFunction(fnc)) this.defaultHandler = fnc;
	}
}

var Menu = Class.create({
	formID: undefined,
	initialize: function(frmID) {
		if (!isUndefined(frmID)) this.formID = frmID;
	},

	keyPress: function key(aT,ev) {
		if (isUndefined(this.formID)) { return false; }
		switch (aT.strKey) {
			case "NUM_0":
				oFrm = this.formID; 
				var ss_name = $FLD(oFrm,'hidden','__iface_key_0');
				if (!isUndefined(ss_name) && ss_name.length > 1) {
					var vname = $FLD(oFrm,'hidden','__iface_key_0_setvar');
					var vvalue = $FLD(oFrm,'hidden','__iface_key_0_setval');
					if (vname && vname.length && vvalue ) { sendForm(oFrm.name,vname,vvalue,ss_name);
					} else sendForm(oFrm.name,null,null,ss_name);
				}
				break;

			case "NUM_1":
				oFrm = this.formID; 
				var ss_name = $FLD(oFrm,'hidden','__iface_key_1');
				if (!isUndefined(ss_name) && ss_name.length > 1) {
					var vname = $FLD(oFrm,'hidden','__iface_key_1_setvar');
					var vvalue = $FLD(oFrm,'hidden','__iface_key_1_setval');
					if (vname && vname.length && vvalue ) { sendForm(oFrm.name,vname,vvalue,ss_name);
					} else sendForm(oFrm.name,null,null,ss_name);
				}
				break;

			case "NUM_2":
				oFrm = this.formID; 
				var ss_name = $FLD(oFrm,'hidden','__iface_key_2');
				if (!isUndefined(ss_name) && ss_name.length > 1) {
					var vname = $FLD(oFrm,'hidden','__iface_key_2_setvar');
					var vvalue = $FLD(oFrm,'hidden','__iface_key_2_setval');
					if (vname && vname.length && vvalue ) { sendForm(oFrm.name,vname,vvalue,ss_name);
					} else sendForm(oFrm.name,null,null,ss_name);
				}
				break;

			case "NUM_3":
				oFrm = this.formID; 
				var ss_name = $FLD(oFrm,'hidden','__iface_key_3');
				if (!isUndefined(ss_name) && ss_name.length > 1) {
					var vname = $FLD(oFrm,'hidden','__iface_key_3_setvar');
					var vvalue = $FLD(oFrm,'hidden','__iface_key_3_setval');
					if (vname && vname.length && vvalue ) { sendForm(oFrm.name,vname,vvalue,ss_name);
					} else sendForm(oFrm.name,null,null,ss_name);
				}
				break;

			case "NUM_4":
				oFrm = this.formID; 
				var ss_name = $FLD(oFrm,'hidden','__iface_key_4');
				if (!isUndefined(ss_name) && ss_name.length > 1) {
					var vname = $FLD(oFrm,'hidden','__iface_key_4_setvar');
					var vvalue = $FLD(oFrm,'hidden','__iface_key_4_setval');
					if (vname && vname.length && vvalue ) { sendForm(oFrm.name,vname,vvalue,ss_name);
					} else sendForm(oFrm.name,null,null,ss_name);
				}
				break;

			case "NUM_5":
				oFrm = this.formID; 
				var ss_name = $FLD(oFrm,'hidden','__iface_key_5');
				if (!isUndefined(ss_name) && ss_name.length > 1) {
					var vname = $FLD(oFrm,'hidden','__iface_key_5_setvar');
					var vvalue = $FLD(oFrm,'hidden','__iface_key_5_setval');
					if (vname && vname.length && vvalue ) { sendForm(oFrm.name,vname,vvalue,ss_name);
					} else sendForm(oFrm.name,null,null,ss_name);
				}
				break;

			case "NUM_6":
				oFrm = this.formID; 
				var ss_name = $FLD(oFrm,'hidden','__iface_key_6');
				if (!isUndefined(ss_name) && ss_name.length > 1) {
					var vname = $FLD(oFrm,'hidden','__iface_key_6_setvar');
					var vvalue = $FLD(oFrm,'hidden','__iface_key_6_setval');
					if (vname && vname.length && vvalue ) { sendForm(oFrm.name,vname,vvalue,ss_name);
					} else sendForm(oFrm.name,null,null,ss_name);
				}
				break;

			case "NUM_7":
				oFrm = this.formID; 
				var ss_name = $FLD(oFrm,'hidden','__iface_key_7');
				if (!isUndefined(ss_name) && ss_name.length > 1) {
					var vname = $FLD(oFrm,'hidden','__iface_key_7_setvar');
					var vvalue = $FLD(oFrm,'hidden','__iface_key_7_setval');
					if (vname && vname.length && vvalue ) { sendForm(oFrm.name,vname,vvalue,ss_name);
					} else sendForm(oFrm.name,null,null,ss_name);
				}
				break;
		}
	},

	selectItem: function select(oRow) {
		//if (isUndefined(this.formID)) { return false; }
		if (oRow.getItem) oI = oRow.getItem();
		else oI = oRow;
		aInputs = inmForm.getInputs(oI,'radio','target');
		var oFrm;
		if (aInputs.length) {
			for (i=0; i<aInputs.length; i++) {
				aInputs[i].checked = !aInputs[i].checked;
				if ($F(aInputs[i])) {
					oFrm = aInputs[i].form;
					sendForm(oFrm.getAttribute('name'),null,null,$F(aInputs[i]));
				}
			}
		} else {
			oEl = 0;
			oInputs = inmForm.getInputs(oI,'checkbox');
			if (oInputs.length) { for (i=0; i<oInputs.length; i++) { oInputs[i].checked = !oInputs[i].checked; oEl = oInputs[i]; break; } }

			if (!oEl) {
				oInputs = inmForm.getInputs(oI,'radio');
				if (oInputs.length) { for (i=0; i<oInputs.length; i++) { oInputs[i].checked = !oInputs[i].checked; oEl = oInputs[i]; break; } }
			}

			if (!oEl) { 
				if (oRow.getRoot) {
					var oR = oRow.getRoot();
					oFrm = oR.findForm();
					if (!oFrm) return true;
				} else {
					return true;
				}
			} else {
				oFrm = oEl.form;
			}

			inmForm.enableDescendants(oFrm);
			// pause(1000);
			sendForm(oFrm.getAttribute('name'));
		}
	}
});

