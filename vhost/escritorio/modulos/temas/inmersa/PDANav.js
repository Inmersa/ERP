var TableBrowser = Class.create();
TableBrowser.prototype = {
	cssContentHidden: 'oculto',
	cssContentVisible: 'RowStd',
	defaultHandler: undefined,
	form_id: '',
/** 
  aDescendants ha de ser un array de 3 elementos con los siguientes valores:
  0 - Nombre de Etiqueta del descendiente.
  1 - ID, o substring inicial del id
  2 - Clase a construir y enlazar
  **/
	initialize: function TableBrowser(base,aDesc, methodSelect) {
		if (!base || !base.id) return false;

		var i;
		if (isObject(aDesc)) { var aDescendants = aDesc; } else { var aDescendants = {}; }

		this.nombre = base.id;
		this.domTable = base;
		this.aRealRows = new Array();
		this.iRowAct = 0;
		this.bBlockedKeys = false;
		this.oTbSwitch = null;
		this.oTbPos = null;

		this.aChildren = new Array();
		this.accSelect = methodSelect;
					
		for (i=0; i<this.domTable.childNodes.length; i++) {
			if (this.domTable.childNodes[i].nodeName == 'TBODY') {
				this.domTableBody = this.domTable.childNodes[i];
				break;
			}
		}
		// if (!this.domTableBody) return false;

		//Event.observe(document,'keydown',this.keyPress.bindAsEventListener(this),true);

		if (isUndefined(aDesc) || isEmpty(aDesc)) {
			if (this.domTableBody.hasChildNodes()) { aDescendants['list'] = this.domTableBody.childNodes; }
			// aDescendants['class'] = SonSwitchByCSS;
		} else {
			// alert("vamos a sacar los tag: " + aDescendants.tagname + " con clase: " + aDescendants['class']);
			aDescendants['list'] = this.findElement(this.domTableBody,aDescendants['tagname'],aDescendants['name']);
			// alert("La lista: " + aDescendants['list'] + " Con size: " + aDescendants['list'].length);
		}
		if (!(aDescendants['tagname'])) aDescendants['tagname'] = 'TR';

		// Primero Deshabilitamos todos los Items.
		if (isObject(aDescendants['list']) && aDescendants['list'] && aDescendants['list'].length) {
			for (i=0; i<aDescendants['list'].length;i++) {
				if (aDescendants['list'][i].nodeName==aDescendants['tagname']) {
					pos = this.aChildren.length;
					if (pos == -1) pos = 0;
					// alert("Vamos a contruir en " + pos + " con " + aDescendants['class'] + ' id: ' + aDescendants['list'][i].id);
					if (isUndefined(aDescendants['class']) || !isFunction(aDescendants['class'])) {
						// Clase por defecto
						this.aChildren[pos] = new SonSwitchByCSS(this,aDescendants['list'][i]);
					} else {
						this.aChildren[pos] = new aDescendants['class'](this,aDescendants['list'][i]);
					}
					this.aChildren[pos].blur();
				}
			}
			/** **
			alert("La lista contiene : " + this.aRealRows.length + " con valor 0: " + this.aRealRows[0] + " y ref: " 
						+ this.domTableBody.childNodes[this.aRealRows[0]] + ' valor(-1): ' + this.aRealRows[-1] + " su ref: "
						+ this.domTableBody.childNodes[this.aRealRows[-1]] );
			/** **/
			if (this.aChildren.length) {
				this.aChildren[0].glow();
				this.iRowAct = 0;
			}
			// alert("Hay un total de: " + this.aRealRows.length);
		} else {
			oFrm = this.findForm();
			var ss_name = $FLD(oFrm,'hidden','__iface_followup');
			if (ss_name && ss_name.length > 1) {
				var vname = $FLD(oFrm,'hidden','__iface_followup_setvar');
				var vvalue = $FLD(oFrm,'hidden','__iface_followup_setval');
				if (vname && vname.length && vvalue ) {
					sendForm(oFrm.name,vname,vvalue,ss_name);
				} else sendForm(oFrm.name,null,null,ss_name);
			}
		}

		// Buscamos los descendientes, para engancharlos:
		if (aDescendants) {
			if (aDescendants[0] && aDescendants[1] && aDescendants[2]) {
				aTList = this.domTable.getElementsByTagName(aDescendants[0]);
				if (aTList.length) {
					for (i=0;i<aTList.length;i++) {
						oItem = aTList.item(i);
						elid = oItem.id;
						if (elid.substr(0,aDescendants[1].length)) {
							// alert("Yiu ID: " + elid + " param: " + aDescendants[2]);
							// this.aChildren[this.aChildren.length] = new aDescendants[2].constructor(oItem,this)
						}
					}
				}
			}
		}
	},

	registerDefaultKeyHandler: function (fnc) {
		if (!isUndefined(fnc) && isFunction(fnc)) this.defaultHandler = fnc;
	},

	registerSwitch: function (oSWitch,pos) {
		this.oTbSwitch = oSWitch;
		this.oTbPos = pos;
	},

	focus: function () {
		//alert('Activando foco a '+this.domTable);
		this.domTable.className = this.cssContentVisible;
		if (this.aChildren.length>0) {
			for (var i = this.aChildren.length-1; i>=1; i--) {
				if (this.aChildren[i].blur) this.aChildren[i].blur();
			}
			if (this.aChildren[0].focus) this.aChildren[0].focus();
		}
	},

	blur: function () {
		//alert('De-Activando foco a .. '+this.domTable);
		if (!isUndefined(this.domTable)) 
			this.domTable.className = this.cssContentHidden;
	},

	keyPress: function (aT,evento) {
		var retval = false;

		//alert("TableBrowser::keyPress, con este: " + aT + " evento: " + evento);
		var self = this;
		if (!self) {
			alert("No he conseguido sacar la instancia listado");
			return true;
		}

		if (evento && isNumber(evento.keyCode)) {
			code = evento.keyCode;
			aTecla = KeyboardDriver.prototype.mapKeyCode(code);
		} else if (aT && isString(aT.strKey)) aTecla = aT;
		else if (aT && isNumber(aT.keyCode)) {
			code = aT.keyCode;
			aTecla = KeyboardDriver.prototype.mapKeyCode(code);
		} else aTecla = aT;

		if (!self.bBlockedKeys) {
			var tecla = aTecla.strKey;
			switch (tecla) {
				case "ESC":
					//alert("Escape en table broser ");
					if (this.oTbSwitch) {
						this.oTbSwitch.deactivate(this.oTbPos);
					}
					break;

				case "UP":
					self.moveUp();
					retval = true;
					break;

				case "DOWN":
					self.moveDown();
					retval = true;
					break;

				case "LEFT":
					self.moveUp();
					retval = true;
					break;

				case "RIGHT":
					self.moveDown();
					retval = true;
					break;

				case "INTRO":
					retval = self.selectItem();
					// alert("el rval de la seleccion: "+retval);
					break;

				default:
					if (!isUndefined(this.defaultHandler)) { this.defaultHandler(aT,evento); }
					break;
			}
		} else {
			//alert(self.iRowAct+" Pabajo ! ... "+self.aChildren[self.iRowAct]+" keyPress: "+self.aChildren[self.iRowAct].keyPress);
			retval = self.aChildren[self.iRowAct].keyPress(aTecla,evento);
		}
		//alert("retval del keypress general: " + retval);
		return retval;
	},

	moveUp: function () {
		var oI;
		if (this.aChildren.length) {
			/** **
			alert("Empezamos en: " + this.iRowAct + " con valor: " + this.aRealRows[this.iRowAct] + " y ref: " 
						+ this.domTableBody.childNodes[this.aRealRows[this.iRowAct]]);
			/** **/
			if (this.iRowAct > 0) {
				this.aChildren[this.iRowAct].blur();
				this.iRowAct--;
				this.aChildren[this.iRowAct].glow();
				oI = this.aChildren[this.iRowAct].getItem();
				// alert("llamando a scroll to 0,"+oI.offsetTop+ " Item id: " + oI.id + " tag: " + oI.tagName + " name: " + oI.getAttribute('name'));
				//if (!isUndefined(oI)) window.scrollTo(0,oI.offsetTop);
				Element.scrollTo(oI);
			}
		}
		return true;
	},

	moveDown: function () {
		var retval = true;
		if (this.aChildren.length) {
			if (this.iRowAct < (this.aChildren.length-1)) {
				this.aChildren[this.iRowAct].blur();
				this.iRowAct++;
				this.aChildren[this.iRowAct].glow();
				oI = this.aChildren[this.iRowAct].getItem();
				Element.scrollTo(oI);
				//window.scrollTo(0,oI.offsetTop);
			} else retval = false;
		} else retval = false;
		return retval;
	},

	selectItem: function () {
		rval = false;
		if (this.iRowAct < this.aChildren.length) {
			if (this.aChildren[this.iRowAct].activate && this.aChildren[this.iRowAct].keyPress) {
				if (this.aChildren[this.iRowAct].activate()) {
					this.bBlockedKeys = true;
				}
				rval = true;
			} else {
				this.aChildren[this.iRowAct].highLight();

				if (this.accSelect) {
					//alert("Accion del select: ");
					this.accSelect(this.aChildren[this.iRowAct]); 
				} else {
					//Ojo, en teoria, el metodo getInpust(),  tiene que recibir una instancia de form ulario. 
					//   pero nos aprovechamos de que no lo comprueba en prototype.js
					oInputs = inmForm.getInputs(this.aChildren[this.iRowAct].getItem(),'checkbox');
					if (oInputs.length) { for (i=0; i<oInputs.length; i++) { oInputs[i].checked = !oInputs[i].checked; } }

					oInputs = inmForm.getInputs(this.aChildren[this.iRowAct].getItem(),'radio');
					if (oInputs.length) { for (i=0; i<oInputs.length; i++) { oInputs[i].checked = !oInputs[i].checked; } }
				}
			}
		}
		return rval;
	},

	firstIdx: function firstIdx () {
		if (isArray(this.aChildren)) { for (var i in this.aChildren) { if (i.toInt().length) { return i; } } }
		return;
	},

	lastIdx: function lastIdx () {
		var retval;
		if (isArray(this.aChildren)) { for (var i in this.aChildren) { if (i.toInt().length) { retval = i; } } }
		return retval;
	},

	actualIdx: function actualIdx () {
		return this.iRowAct;
	},

	getRow: function getRow (idx) {
		return this.aChildren[this.iRowAct];
	},
	findForm: function () {
		var oFrm;
		// Buscamos el formulario.
		if (this.form_id && !isUndefined($(this.form_id))) return $(this.form_id);
		if (this.aChildren.length) {
			oEl = inmForm.findFirstElement(this.aChildren[0].getItem(),false,false);
			if (oEl && oEl.form) oFrm = oEl.form;
		} else {
			oEl = inmForm.findFirstElement(document,false,false);
			if (oEl && oEl.form) oFrm = oEl.form;
		}
		return oFrm;
	},

	findElement: function findElement(oBase,tag,name) {
		return mydom.findElements(oBase,tag,name);
	}
}

    
function mapKeyCode(code) {
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
			} else retval = '';
			break;
	}
	aRetVal['keyCode'] = code;
	aRetVal['strKey'] = retval;
	aRetVal['char'] = String.fromCharCode(code);
	return aRetVal;
}


/** Esto, en realidad seria lo unico que se tendria que quedar aqui. (esto es, las clases propias del iface del almacen, Loczlizacion, etc .. **/
var TBItem_Location = Class.create();
//No soporta herencia:  Object.extend(TBItem_Location.prototype,TableBrowserItem.prototype);
TBItem_Location.inherits(SonSwitchByCSS);

// TBItem_Location.prototype.initialize = function TBItem_Location(oParent,oDomItem) 
var tmpMethods = {
		// oCodBarras : false,
		// oLoc : false,
		// oSKU : false,
		// oCnt : false,
		// bCodigoOK : false,
		// sActivo : false,
		// aIdx : {},
	initialize: function TBItem_Location(oParent,oDomItem) {
		this.uber('initialize',oParent,oDomItem);
		this.aIdx = {};
		this.sActivo = false;
		var oI = this.getItem();
		//alert('TBItem_Location.constructor->oItem ID: ' + oI.id + " Nombre: " + oI.getAttribute('nombre'));

		aICodBarras = this.oParent.findElement(oI,'div','CodigoBarras');
		if (aICodBarras.length) { this.oCodBarras = new CodigoBarras(this,aICodBarras.shift()); }

		aILoc = this.oParent.findElement(oI,'div','Localizacion');
		if (aILoc.length) { this.oLoc = new Localizacion(this,aILoc.shift()); }
		this.aIdx['Localizacion'] = this.oLoc;
		// this.oLoc.aLoc['planta'].addEventListener('change',this.oCodBarras.changedCode,true);
		// this.oCodBarras.oCodigoInput.addEventListener('change',this.oCodBarras.changedCode,true);

		aISKU = this.oParent.findElement(oI,'div','SKU');
		if (aISKU.length) { this.oSKU = new SKU(this,aISKU.shift()); }
		this.aIdx['SKU'] = this.oSKU;

		// alert("Las cantidades desde " + oI.tagName + " con id: " + oI.id + " y nombre: " + oI.getAttribute('name') );
		aICnt = this.oParent.findElement(oI,'div','Cantidades');
		if (aICnt.length) { this.oCnt = new Cantidad(this,aICnt.shift()); }
		this.aIdx['Cantidad'] = this.oCnt;
	},

	KBControl: function blockKB(bVal) {
		if (isUndefined(bVal)) { bVal = true; }
		this.oParent.bBlockedKeys = bVal;
	},

	keyPress: function TBItem_keyPress(aTecla,ev) {
		// alert("Apretaba tecla  en el hijito CB: " + this.oCodigoBarras);
		strKey = aTecla.strKey;
		retval = true;
//alert("strkey: " + strKey + " con barras: " + this.oCodBarras + "Codigo ok? " + this.bCodigoOK);
		if (!this.oCodBarras || this.oCodBarras.bCodigoOK) {
// alert("strkey: " + strKey + " con barras: " + this.oCodBarras + "Codigo ok? " + this.bCodigoOK);
			switch (strKey) {
				case "ESC":
					if (this.sActivo) {
						if (this.aIdx[this.sActivo] && this.aIdx[this.sActivo].blur) { this.aIdx[this.sActivo].blur(); }
						this.sActivo = false;
						this.glow();
					}
					this.oParent.bBlockedKeys = false;
					break;

				default:
					if (isObject(this.aIdx[this.sActivo]) && this.aIdx[this.sActivo].keyPress && isFunction(this.aIdx[this.sActivo].keyPress)) {
						retval = this.aIdx[this.sActivo].keyPress(aTecla,ev);
					} else {
						retval = this.defaultKeyPress(aTecla);
					}
					break;
			}
		} else {
			// alert("Codigo no bene, pal codbarras con : " + aTecla);
			if (this.oCodBarras.activo) retval = this.oCodBarras.keyPress(aTecla,ev);
		}
		return retval;
	},

	defaultKeyPress: function TBItem_keyPressLocal(aTecla) {
		strKey = aTecla.strKey;
		retval = false;
		switch (strKey) {
			case "INTRO":
				if (this.aIdx[this.sActivo] && this.aIdx[this.sActivo].blur) { this.aIdx[this.sActivo].blur(); }

				if (this.oParent.actualIdx() == this.oParent.lastIdx()) {
					oFrm = this.oParent.findForm();
					// Activamos los que esten ocultos, y mandamoslo
					if (oFrm) {
						inmForm.enable(oFrm);
						oFrm.submit();
					}
				}
				this.oParent.moveDown();
				this.oParent.selectItem();
				// retval = false;
				retval = true;
				break;

			case "UP":
				if (!this.sActivo) {
					this.oParent.bBlockedKeys = false;
					this.oParent.moveUp();
				} else {
					this.moveUp();
				}
				retval = true;
				break;

			case "DOWN":
				if (!this.sActivo) {
					this.oParent.bBlockedKeys = false;
					this.oParent.moveDown();
				} else {
					this.moveDown();
				}
				retval = true;
				break;
		}
		//alert("defaultKeypress de registro-TBItem. con retorno "+retval);
		return retval;
	},

	activate: function TBItem_activate() {
		var retval = true;
		if (this.oCodBarras && !this.oCodBarras.bCodigoOK) {
			this.sActivo = false;
			this.oParent.bBlockedKeys = true;
			this.oCodBarras.focus();
		} else {
		   	if (this.oCnt) {
				if (this.oCnt.focus) {
					if (this.oLoc && this.oLoc.blur) this.oLoc.blur();
					if (this.oSKU && this.oSKU.blur) this.oSKU.blur();
					if (this.oCnt.focus()) {
						this.sActivo = 'Cantidad';
					}
				} else {
					this.sActivo = 'Cantidad';
				}
			}  
			if (!this.sActivo && this.oSKU) {
			   // alert("La cantidad no existe, vamos a por el SKU ");
			} 
			if (!this.sActivo && this.oLoc) {
				if (this.oLoc.focus) {
					if (this.oCnt && this.oCnt.blur) this.oCnt.blur();
					if (this.oSKU && this.oSKU.blur) this.oSKU.blur();
					if (this.oLoc.focus()) this.sActivo = 'Localizacion';
				} else {
					this.sActivo = 'Localizacion';
				}
			}
			if (!this.sActivo) {
				// alert("Ningun campo coge foco en activacion, comprobando lo de las checkboxes. ");
				var oI = this.getItem();
				var oInputs = inmForm.getInputs(oI,'checkbox');
				if (oInputs.length) { for (i=0; i<oInputs.length; i++) { oInputs[i].checked = !oInputs[i].checked; oEl = oInputs[i]; break; } }
				else { this.submitForm(); }
				// No queremos bloquear esta entrada, no hay nada que hacer aqui.
				retval = false;
			}
		}
		return retval;
	},

	moveUp: function moveUp() {
		if (!this.sActivo) return;
		switch (this.sActivo) {
			case 'Cantidad':
				if (this.oCnt && this.oCnt.blur) this.oCnt.blur();
				if (this.oSKU) {
					this.oSKU.focus();
					this.sActivo = 'SKU';
				}
				break;
			case 'SKU':
				if (this.oSKU && this.oSKU.blur) this.oSKU.blur();
				if (this.oLoc) {
					this.oLoc.focus();
					this.sActivo = 'Localizacion';
				}
				break;
			case 'Localizacion':
				break;
		}
	},

	moveDown: function moveDown() {
		if (!this.sActivo) return;
		switch (this.sActivo) {
			case 'Localizacion':
				if (this.oLoc && this.oLoc.blur) this.oLoc.blur();
				if (this.oSKU && this.oSKU.focus) { if (this.oSKU.focus()) { this.sActivo = 'SKU'; } }
				if (this.sActivo == 'Localizacion') { if (this.oCnt && this.oCnt.focus) { if (this.oCnt.focus()) { this.sActivo = 'Cantidad'; } } }
				if (this.sActivo == 'Localizacion') { this.oParent.moveDown(); }
				break;
			case 'SKU':
				if (this.oSKU && this.oSKU.blur) this.oSKU.blur();
				if (this.oCnt) {
					if (this.oCnt.focus()) {
						this.sActivo = 'Cantidad';
					} else {
						alert("La cantidad no quiere el foco, alguna sugerencia? ");
					}
				}
				break;

			case 'Cantidad':
				break;
		}
	}
}
Object.extend(TBItem_Location.prototype,tmpMethods);
tmpMethods = null;

//var CodigoBarras = Class.create();
//CodigoBarras.inherits(SonSwitchByCSS);
var tmpMethods = {
	actual_code: '',
	initialize: function CodigoBarras ($super,parent,id,oChange,bBlock) {
		//this.uber('initialize',parent,id);
		$super(parent,id);
		this.activo = true;
		this.bCodigoOK = false;
		if (isUndefined(bBlock)) bBlock = false; //FixMe: Cambiar esto a true
		if (this.oItem) {
			aEl = inmForm.getElements(this.oItem);
			for (var i=0; i<aEl.length; i++) {
				// alert("Elemento: " + aEl[i].getAttribute('name') + " tipo: " + aEl[i].type );
				if (Element.hasClassName(aEl[i],'codigobarras') && aEl[i].type == 'text') {
					this.oCodigoInput = aEl[i];
					if (isUndefined(oChange) || !isObject(oChange)) {
						Event.observe(this.oCodigoInput,'change',this.changedBarCode.bindAsEventListener(this));
					} else {
						Event.observe(this.oCodigoInput,'change',oChange.changedBarCode.bindAsEventListener(oChange));
					}
					if (!isUndefined(bBlock) && bBlock) Event.observe(this.oCodigoInput,'blur',this.blockField.bindAsEventListener(this));
				} else if (aEl[i].type == 'hidden' && Element.hasClassName(aEl[i],'codigobarras')) {
					this.oCodigoCheck = aEl[i];
				}
			}
		}
	},

	focus: function focus() {
		oI = this.getItem();
		oI.className = 'visible';
		this.activo = true;

		this.glow();
		this.highLight();
		if (this.oCodigoInput) {
			this.oCodigoInput.focus();
			this.oCodigoInput.select($F(this.oCodigoInput).length);
		}
	},

	blur: function blur($super) {
		//this.uber('blur');
		$super();
		this.getItem().className = 'oculto';
		this.activo = false;
	},

	keyPress: function keyPress(aT,ev) {
		retval = false;
		// alert("keycode: " + aT.keyCode);
		switch (aT.strKey) {
			case "ESC":
				this.oParent.oParent.bBlockedKeys = false;
				this.blur();
				break;

			/** SOBRA , ya se registra el evento onChange **/
			case "INTRO":
				// alert("INTRO En CodigoBarras " + this);
				if (!this.bCodigoOK) retval = this.changedBarCode();
				retval = false;
				break;
			/** **/
		}
		return retval;
	},

	changedBarCode: function changed(ev) {
		retval = true;
		if ($F(this.oCodigoInput) != $F(this.oCodigoCheck)) {
			// alert("Codigo de Barras Incorrecto " + $F(this.oCodigoInput) + ". Deberia ser: " + $F(this.oCodigoCheck));
			if ($F(this.oCodigoInput) == '..') {
				oCnt = this.oParent.oCnt;
				oCnt.set(0);
				this.oParent.oParent.bBlockedKeys = false;
				this.blur();
				this.oParent.oParent.moveDown();
				this.activo = false;
			}
		} else {
			// alert("changedCode con ok? " + this.bCodigoOK);
			this.bCodigoOK = true;
			this.blur();
			this.oParent.activate();
		}
		return retval;
	},

	blockField: function block(ev) {
		if (!this.bCodigoOK) {
			this.oCodigoInput.focus();
			this.oCodigoInput.select($F(this.oCodigoInput).length);
		}
	},

	get: function get() {
		return $F(this.oCodigoInput);
	},

	clean: function CodigoBarras__clean() {
		Element.setValue(this.oCodigoInput,'');
	}
}
//Object.extend(CodigoBarras.prototype,tmpMethods);
var CodigoBarras = Class.create(SonSwitchByCSS,tmpMethods);
tmpMethods = null;

//var Localizacion = Class.create();
//Localizacion.inherits(SonSwitchByCSS);
var tmpMethods = {
	cssContentHidden: 'FrameSetBlur',
	cssContent: 'FrameSetStd',
	cssContentHighlight: 'FrameSetHi',

	initialize: function Localizacion ($super,parent,id) {
		//this.uber('initialize',parent,id);
		$super(parent,id);
		this.aLoc = { zona: null, planta: null, pasillo: null, columna: null, fila: null };
		this.oCodBarras = null;
		this.fldActivo = false;
		oI = this.getItem();
		if (oI) {
			aEl = inmForm.getElements(oI);
			for (var i=0; i<aEl.length; i++) {
				for (css in this.aLoc) { if (!this.aLoc[css]) { if (Element.hasClassName(aEl[i],css)) { this.aLoc[css] = aEl[i]; } } }
			}
			// Buscando Input de localizacion por Codigo de Barras
			if (!isUndefined(this.oParent) && !isUndefined(this.oParent.oParent)) 
				aICodBarras = this.oParent.oParent.findElement(oI,'div','CBarras_localizacion');
			else aICodBarras = mydom.findElements(oI,'div','CBarras_localizacion');
			if (aICodBarras.length) { this.oCB = new CodigoBarras(this,aICodBarras.shift(),this,false); }
		}
	},

	changedBarCode: function keypress(ev) {
		var val = this.oCB.get();
		bDone = false;
		this.oCB.bCodigoOK = true;
		if (val) {
			if (val=='..') {
				this.oCB.clean();
				for (k in this.aLoc) { if (isObject(this.aLoc[k]) && !isFunction(this.aLoc[k])) { Element.setValue(this.aLoc[k],''); } } 
				this.oCB.bCodigoOK = false;
			} else {
				if (this.setLocationFromString(val)) {
					bDone = true;
					if (!isUndefined(this.oParent.sActivo)) {
						this.oParent.sActivo = false;
						this.oParent.bBlockedKeys = false;
					} else if (!isUndefined(this.oParent.moveDown)) {
						this.oParent.moveDown();
						bDone = false;
					}
				}
			}
		} 
		//if (bDone) { alert("this.submitForm()"); }
		if (bDone) { this.submitForm(); }
		return false;
	},

	setLocationFromString: function (strCode) {
		var rval = false;
		var aLoc = this.parseLocation(strCode);
		if (isObject(aLoc)) {
			//for (var k in aLoc) 
			var aTmp = Object.keys(aLoc);
			var k;
			for (var j=aTmp.length; j>=0; j--) {
				k = aTmp[j];
				if (!isFunction(k) && !isFunction(this.aLoc[k]) && !isObject(k) && this.aLoc[k]) { 
					Element.setValue(this.aLoc[k],aLoc[k]); 
					rval = true;
				}
			}
		} else rval = false;
		return rval;
	},

	parseLocation: function parseBarCode(strCode) {
		if (strCode.indexOf(':')==-1) return;
		aRetVal = {};
		if (strCode.indexOf('-') != -1) {
			aCod = strCode.split('-');
			aRetVal['zona'] = aCod[0];
			strCode = aCod[1];
		}
		aL = strCode.split(':');
		aRetVal['planta'] = aL[0];
		aRetVal['pasillo'] = aL[1];
		aRetVal['columna'] = aL[2];
		aRetVal['fila'] = aL[3];
		return aRetVal;
		return $H(aRetVal);
	},

	formatLocation: function () {
		var rval = '', tmp='';
		tmp = this.aLoc['zona'].getValue();
		if (tmp.length==1) tmp = '0'+tmp;
		rval += tmp+'-';
		tmp = this.aLoc['planta'].getValue();
		if (tmp.length==1) tmp = '0'+tmp;
		rval += tmp+':';
		tmp = this.aLoc['pasillo'].getValue();
		if (tmp.length==1) tmp = '0'+tmp;
		rval += tmp+':';
		tmp = this.aLoc['columna'].getValue();
		if (tmp.length==1) tmp = '0'+tmp;
		rval += tmp+':';
		tmp = this.aLoc['fila'].getValue();
		if (tmp.length==1) tmp = '0'+tmp;
		rval += tmp;
		return rval;
	},

	keyPress: function keypress(aTecla,ev) {
		retval = false;
		strKey = aTecla.strKey;
		switch (strKey) {
			case "ESC":
				this.done();
				retval = true;
				break;

			case "INTRO":
				if (this.oCB) {
					var val = this.oCB.get();
					if (val) return false;
				}
				// alert("Siguiente campo .. ");
				this.nextField(ev.element);
				retval = true;
				// alert("Intro de guay ... ");
				break;

		}
		return retval;
	},

	nextField: function next(tg) {
		switch (this.fldActivo) {
			case 'zona':
				this.aLoc['planta'].focus();
				this.fldActivo = 'planta';
				break;
			case 'planta':
				this.aLoc['pasillo'].focus();
				this.fldActivo = 'pasillo';
				break;
			case 'pasillo':
				this.aLoc['columna'].focus();
				this.fldActivo = 'columna';
				break;
			case 'columna':
				this.aLoc['fila'].focus();
				this.fldActivo = 'fila';
				break;
			case 'fila':
				this.fldActivo = false;
				if (this.oParent && this.oParent.oParent) {
					this.oParent.oParent.bBlockedKeys = false;
				}
				if (this.oParent.glow) this.oParent.glow();
				// this.aLoc['fila'].focus();
				if (isObject(this.oCB)) this.oCB.bCodigoOK = true;
				this.done();
				break;
			default:
				if (this.aLoc && this.aLoc['zona']) {
					this.aLoc['zona'].focus();
					this.fldActivo = 'zona';
				} else {
					var itm = this.getItem();
					aList = inmForm.getVisibleElements(itm).sortBy(function(el,pos) { return el.tabIndex; });
					if (aList.length) {
						if (!isUndefined(tg)) {
							for (i=0; i<aList.length; i++) {
								if (aList[i]==tg) {
									if (!isUndefined(aList[i+1])) {
										if (aList[i+1].type=="text") aList[i+1].select();
										aList[i+1].focus();
									} else {
										if (this.oParent.moveDown()) {
											this.oParent.selectItem();
										} else {
											//alert("Falta enviar el formulario ");
											oFrm = this.oParent.findForm();
											// Activamos los que esten ocultos, y mandamoslo
											if (oFrm) {
												inmForm.enable(oFrm);
												oFrm.submit();
											}
										}
									}
								}
							}
						}
					}
				}
				break;
		}
	},

	done: function Location__done() {
		if (this.glow) this.glow();
		// COmprobamos si hay campos que marquen envio de formulario.
		if (!this.submitForm()) {
			// Si no hay formulario que enviar, hay que seguir navegando.
			this.oParent.moveDown();
		} else {
			this.oParent.sActivo = false;
		}
	},

	blur: function blur($super) {
		if (this.oCB && this.oCB.blur) {
			this.oCB.blur();
		}
		//this.uber('blur');
		$super();
		this.fldActivo = false;
		return true;
	},

	focus: function focus() {
		this.highLight();
		this.oParent.bBlockedKeys = true;
		retval = true;
		if (isObject(this.oCB) && !isUndefined(this.oCB.focus)) {
			this.oCB.focus();
		} else {
			retval = true;
			if (this.aLoc && this.aLoc['zona']) {
				this.aLoc['zona'].focus();
				this.fldActivo = 'zona';
			} else { 
				var aItms = inmForm.getVisibleElements(this.getItem()).sortBy(function(el,pos) { return el.tabIndex; });
				if (aItms.length) {
					oTarget = aItms[0];
					if (oTarget.select) oTarget.select();
					oTarget.focus();
				}
			}
		}
		return retval;
	}
}
//Object.extend(Localizacion.prototype,tmpMethods);
var Localizacion = Class.create(SonSwitchByCSS,tmpMethods);
tmpMethods = null;

//var SKU = Class.create();
//SKU.inherits(SonSwitchByCSS);
var tmpMethods = {
	initialize: function SKU ($super,parent,id) {
		//this.uber('initialize',parent,id);
		$super(parent,id);

		this.cssContentHidden = 'FrameSetBlur';
		this.cssContent = 'FrameSetStd';
		this.cssContentHighlight = 'FrameSetHi';

		this.aSKU = { dia: null, mes: null, anyo: null, lote: null };
		if (this.oItem) {
			aEl = inmForm.getElements(this.oItem);
			for (var i=0; i<aEl.length; i++) {
				for (css in this.aSKU) { if (!this.aSKU[css]) { if (Element.hasClassName(aEl[i],css)) { this.aSKU[css] = aEl[i]; } } }
			}
		}
	}, 

	formatSKU: function () {
		var rval = '', tmp='';
		tmp = this.aSKU['anyo'].getValue();
		if (tmp.length==1) tmp = '0'+tmp;
		rval += tmp+'-';
		tmp = this.aSKU['mes'].getValue();
		if (tmp.length==1) tmp = '0'+tmp;
		rval += tmp+'-';
		tmp = this.aSKU['dia'].getValue();
		if (tmp.length==1) tmp = '0'+tmp;
		rval += tmp+'*';
		tmp = this.aSKU['lote'].getValue();
		rval += tmp;
		return rval;
	},

	setSKUFromArray: function (aRec) {
		var rval = false;
		if (isObject(aRec)) {
			for (k in aRec) { 
				if (!isFunction(k) && !isFunction(this.aSKU[k]) && !isObject(k) && this.aSKU[k]) { 
					Element.setValue(this.aSKU[k],aRec[k]); 
					rval = true;
				}
			}
		}
		return rval;
	},

	focus: function focus() {
		this.highLight();
		if (this.aSKU['dia']) {
			this.aSKU['dia'].focus();
			this.aSKU['dia'].select();
		}
	},

	keyPress: function keypress(aTecla,ev) {
		rval = false;
		strKey = aTecla.strKey;
		switch (strKey) {
			case "ESC":
				if (!isUndefined(this.oParent) && isFunction(this.oParent.moveDown)) {
					this.oParent.moveDown();
					rval = true;
				} else if (!isUndefined(this.oParent) && !isUndefined(this.oParent.oParent)) {
					this.oParent.oParent.bBlockedKeys = false;
					this.blur();
					rval = true;
				} else rval = false;
				break;

			case "INTRO":
				//alert("Intro sin guay ... " + ev + " en realidad: " + Event.element(ev));
				if (this.oCB) {
					var val = this.oCB.get();
					if (val) return false;
				}
				//alert("Next field de "+ev.element());
				this.nextField(ev.element());
				rval = true;
				break;

			case "UP":
				if (!isUndefined(ev.element()) && ev.element().type=='text') {
					var fld = this.findFieldName(ev);
					if (isString(fld) && fld.length>0) {
						var cnt = 1, orig=0;
						if (fld=='dia') cnt=7;
						orig = this.aSKU[fld].getValue()*1;
						this.aSKU[fld].setValue(orig+cnt);
					}
					rval = true;
				}
				break;

			case "DOWN":
				if (!isUndefined(ev.element()) && ev.element().type=='text') {
					var fld = this.findFieldName(ev);
					if (isString(fld) && fld.length>0) {
						var cnt = 1, orig=0;
						if (fld=='dia') cnt=7;
						orig = this.aSKU[fld].getValue()*1;
						this.aSKU[fld].setValue(orig-cnt);
					}
					rval = true;
				}
		}
		return rval;
	},

	findFieldName: function (ev) {
		var fld = '';
		for (var key in this.aSKU) {
			if (isFunction(key) || isFunction(this.aSKU[key])) continue;
			if (this.aSKU[key]==ev.element()) {
				fld = key;
				break;
			}
		}
		return fld;
	},

	nextField: function next(target) {
		//alert(this+" Siguiente a: "+target);
		inmForm.focusNextElement(this.getItem(),target,this.lastField.bind(this));
	},

	lastField: function (target) {
		if (this.oParent)
			if (this.oParent.moveDown()) {
				this.oParent.selectItem();
			} else {
				//alert("Falta enviar el formulario ");
				oFrm = this.oParent.findForm();
				// Activamos los que esten ocultos, y mandamoslo
				if (oFrm) {
					inmForm.enable(oFrm);
					oFrm.submit();
				}
			}
	}
}
//Object.extend(SKU.prototype,tmpMethods);
var SKU = Class.create(SonSwitchByCSS,tmpMethods);
tmpMethods = null;

//var Cantidad = Class.create();
//Cantidad.inherits(SonSwitchByCSS);
var tmpMethods = {
	initialize: function Cantidad ($super,parent,id) {
		this.aCnt = { cantidad: null };
		$super(parent,id);
		//this.uber('initialize',parent,id);

		this.cssContentHidden = 'FrameSetBlur';
		this.cssContent = 'FrameSetStd';
		this.cssContentHighlight = 'FrameSetHi';

		// alert("Constructor de Cantidad ");
		if (this.oItem) {
			aEl2 = inmForm.getElements(this.oItem);
			for (var i=0; i<aEl2.length; i++) {
				for (css in this.aCnt) { if (!this.aCnt[css]) { if (Element.hasClassName(aEl2[i],css)) { this.aCnt[css] = aEl2[i]; } } }
			}
		}
	},

	keyPress: function(aK,ev) {
		rval = false;
		switch (aK.strKey) {
			case "UP":
				cnt = this.get()*1;
				this.set(cnt+1);
				rval = true;
				break;
			case "DOWN":
				cnt = this.get()*1;
				this.set(cnt-1);
				rval = true;
				break;
		}
		return rval;
	},

	focus: function focus() {
		var retval;
		//alert("el retval del foco "+retval+" fld: "+this.aCnt['cantidad']);
		if (this.aCnt['cantidad'] && this.aCnt['cantidad'].focus) {
			this.glow();
			this.highLight();
			this.aCnt['cantidad'].focus();
			this.aCnt['cantidad'].select($F(this.aCnt['cantidad']).length);
			retval = true;
		} else {
			retval = false;
		}
		return retval;
	},

	get: function get() {
		return $F(this.aCnt['cantidad']);
	},

	set: function set(value) {
		if (!isUndefined(value)) {
			if (this.aCnt['cantidad']) {
				this.aCnt['cantidad'].value = value;
			}
		}
	}
}
//Object.extend(Cantidad.prototype,tmpMethods);
var Cantidad = Class.create(SonSwitchByCSS,tmpMethods);
tmpMethods = null;

var Menu2 = Class.create();
Menu2.prototype = {
	initialize: function Menu() {
		var a = 0;
		this.bBlockedKeys = false;
	},

	selectItem: function select(oRow) {
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
	},

	// No se llama nunca a este metodo
	keyPress: function (evento) {
		var retval = true;

		// alert("keyPress, con este: " + this + " evento: " + evento);
		var self = this;
		if (!self) {
			alert("No he conseguido sacar la instancia listado");
			return true;
		}

		if (evento && isNumber(evento.keyCode)) code = evento.keyCode;
		aTecla = mapKeyCode(code);

		if (!self.bBlockedKeys) {
			var tecla = aTecla.strKey;
			switch (tecla) {
				case "NUM_3":
					oFrm = self.findForm();
					var ss_name = $F('__iface_key_3');
					if (ss_name && ss_name.length > 1) {
						var vname = $F('__iface_key_3_setvar');
						var vvalue = $F('__iface_key_3_setval');
						if (vname && vname.length && vvalue ) {
							sendForm(oFrm.name,vname,vvalue,ss_name);
						} else sendForm(oFrm.name,null,null,ss_name);
					} else {
						sendForm(oFrm.name,'accion','Confirmar','pkg_inicio');
					}
					retval = false;
					break;
			}
		} else {
			retval = true;
		}
		return retval;
	}
}


var SKU_Selection = Class.create();
//No soporta herencia:  Object.extend(TBItem_Location.prototype,TableBrowserItem.prototype);
SKU_Selection.inherits(SonSwitchByCSS);
// SKU_Selection.swiss(KeyboardDriver);
//SKU_Selection.inherits(KeyboardDriver);
var methodList = {
	cssContentHidden: 'RowBlur',
	cssContent: 'RowStd',
	cssContentHighLight: 'RowHi',
	oItem: null,
	oLastTArea: undefined,
	initialize: function SKU_Selection(oParent,oDomItem) {
		this.uber('initialize',oParent,oDomItem);
		var oI = this.getItem();
		this.oKb = new KeyboardDriver();
		this.oKb.register("ESC",this.deactivate.bind(this));
		this.oKb.register("INTRO",this.enter.bind(this));
		this.oKb.debug = true;
		//this.keyPress = this.oKb.keyPress.bind(this.oKb);
		// this.cssContentHidden = 'oculto';
	},

	keyPress: function (aT,e) {
		//alert("Letrita palla ke ");
		if (aT.strKey!="INTRO" && !isUndefined(this.oLastTArea)) {
			this.oLastTArea = undefined;
		}
		//KeyboardDrivers::keyPress retorna bool Seguir Propagando Evento
		// A este metodo se le pregunta bool Si Se ha Encargado del Evento
		rval = this.oKb.keyPress(e);
		//alert("SKULoc::keyPress - Evento: "+e+" rval: "+rval);
		//return rval;
		return !rval;
	},

	enter: function (aT,e) {
		var targ;
		if (e.target) targ = e.target;
		else if (e.srcElement) targ = e.srcElement;
		if (targ.type=="textarea") {
			if (isUndefined(this.oLastTArea)) {
				//alert("Es un text area .. ");
				this.oLastTArea = targ;
				return false;
			} 
		}
		var rval = true;
		//var itm = this.getRoot();
		var itm = this.getItem();
		aList = inmForm.getVisibleElements(itm).sortBy(function(el,pos) { return el.tabIndex; });
		if (aList.length) {
			for (i=0; i<aList.length; i++) {
				if (aList[i]==targ) {
					if (!isUndefined(aList[i+1])) {
						if (aList[i+1].type=="text") aList[i+1].select();
						aList[i+1].focus();
					} else {
						if (this.oParent.moveDown()) {
							this.oParent.selectItem();
						} else {
							//alert("Falta enviar el formulario ");
							oFrm = this.oParent.findForm();
							// Activamos los que esten ocultos, y mandamoslo
							if (oFrm) {
								inmForm.enable(oFrm);
								oFrm.submit();
							}
						}
					}
				}
			}
		} else rval = false;
		return rval;
	},

	deactivate: function () {
		//this.oParent.KBControl();
		this.oParent.bBlockedKeys = false;
		//oTmp = this.getRoot();
		//oR = oTmp.getItem();
		//alert("foc: "+oR.focus);
		//oR.focus();
		this.blur();
		//document.focus();
		return false;
	},

	activate: function () {
		this.highLight();
		//aItms = inmForm.getInputs(this.getItem(),'text');
		aItms = inmForm.getVisibleElements(this.getItem()).sortBy(function(el,pos) { return el.tabIndex; });
		if (aItms.length) {
			oTarget = aItms[0];
			if (oTarget.select) oTarget.select();
			if (oTarget.focus) oTarget.focus();
		}
		return true;
	},

	moveUp: function moveUp() {
		alert("SKU_Selection::moveUp()");
	},

	moveDown: function moveUp() {
		alert("SKU_Selection::moveDown()");
	}
}
Object.extend(SKU_Selection.prototype,methodList);
methodList = null;

