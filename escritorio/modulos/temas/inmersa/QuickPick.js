//var CBAjax = Class.create();
//CBAjax.inherits(SonSwitchByCSS);
var someMethods = {
	cssContentHidden: 'FrameSetBlur',
	cssContent: 'FrameSetStd',
	cssContentHighlight: 'FrameSetHi',
	bDisableForm: false,
	initialize: function ($super,parent,id,oChange) {
		$super(parent,id);
		this.oCodigoCheck = undefined;
		if (this.oItem) {
			aEl = inmForm.getElements(this.oItem);
			for (var i=0; i<aEl.length; i++) {
				// alert("Elemento: " + aEl[i].getAttribute('name') + " tipo: " + aEl[i].type );
				if (Element.hasClassName(aEl[i],'codigobarras') && aEl[i].type == 'text') {
					this.oCodigoInput = aEl[i];
					/** **
					if (isUndefined(oChange) || !isObject(oChange)) {
						Event.observe(this.oCodigoInput,'change',this.changedBarCode.bindAsEventListener(this));
					} else {
						Event.observe(this.oCodigoInput,'change',oChange.changedBarCode.bindAsEventListener(oChange));
					}
					/** **/
					//if (!isUndefined(bBlock) && bBlock) Event.observe(this.oCodigoInput,'blur',this.blockField.bindAsEventListener(this));
				} else if (aEl[i].type == 'hidden' && Element.hasClassName(aEl[i],'codigobarras')) {
					this.oCodigoCheck = aEl[i];
				}
			}
		}
	},

	keyPress: function(aT,ev) {
		rval = false;
		switch (aT.strKey) {
			case "ESC":
				this.oParent.blurItem(this);
				rval = true;
				break;

			case "INTRO":
				this.oParent.asyncGetRef();
				rval = this.oParent.moveDown();
				break;
		}
		return rval;
	},

	changedBarCode: function() {
		alert("Codigo barras cambiao ");
	},

	focus: function focus() {
		//oI = this.getItem();
		//oI.className = this.cssContent;
		this.activo = true;
		this.glow();
		this.highLight();
		if (this.oCodigoInput) {
			this.oCodigoInput.focus();
			this.oCodigoInput.select($F(this.oCodigoInput).length);
		}
	},

	getValue: function () {
		return $F(this.oCodigoInput);
	}
}
//Object.extend(CBAjax.prototype,someMethods);
var CBAjax = Class.create(SonSwitchByCSS,someMethods);
someMethods = undefined;

//var ExtendedLocalizacion = Class.create();
//ExtendedLocalizacion.inherits(Localizacion);
someMethods = {
	cssContentHidden: 'FrameSetBlur',
	cssContent: 'FrameSetStd',
	cssContentHighlight: 'FrameSetHi',
	bDisableForm: false,
	initialize: function ($super,parent,id) {
		//this.uber('initialize',parent,id);
		//alert("Llamando a padre joder "+parent+" el id: "+id);
		$super(parent,id);
        },
	keyPress: function ($super,aT,ev) {
		//this.uber('keyPress',aT,ev);
		var rval = $super(aT,ev);
		// alert("El de arriba rtona: "+rval);
		if (!rval) {
			switch (aT.strKey) {
				case "ESC":
					this.oParent.blurItem(this);
					rval = true;
					break;
			}
		}
		return rval;
	},

	lastField: function ($super,tg) {
		//alert("someMethods::lastField() ");
		this.oParent.moveDown();
		/** **
		//alert("someMethods::lastField() "+this);
		if (this.oParent.moveDown()) {
			alert(" selectItm: "+this.oParent.selectItem);
		} else {
			//alert("Falta enviar el formulario ");
			oFrm = tg.form;
			// Activamos los que esten ocultos, y mandamoslo
			if (oFrm) {
				inmForm.enable(oFrm);
				alert(oFrm.action+" oFrm.action ");
			}
		}
		/** **/
	}
}
//ExtendedLocalizacion.prototype = Object.extend(new ExtendedLocalizacion(),someMethods);
var ExtendedLocalizacion = Class.create(Localizacion,someMethods);

var ExtendedSKU = Class.create(SKU,someMethods);
//var ExtendedSKU = Class.create();
//ExtendedSKU.inherits(SKU);
//Object.extend(ExtendedSKU.prototype,someMethods);

someMethods.keyPress = function ($super,aT,ev) {
	//this.uber('keyPress',aT,ev);
	var rval = $super(aT,ev);
	//alert("El de arriba rtona: "+rval);
	if (!rval) {
		switch (aT.strKey) {
			case "ESC":
				this.oParent.blurItem(this);
				rval = true;
				break;
			case "INTRO":
				var val = this.get();
				if (val && !isUndefined(val) && val.length>0) {
					this.oParent.asyncSendForm();
				}
				rval = this.oParent.moveDown(true);
				break;
		}
	}
	return rval;
}


var ExtendedCantidad = Class.create(Cantidad,someMethods);
//var ExtendedCantidad = Class.create();
//ExtendedCantidad.inherits(Cantidad);
//ExtendedCantidad.prototype = Object.extend(new ExtendedCantidad(),someMethods);
//Object.extend(ExtendedCantidad.prototype,someMethods);
someMethods = undefined;

someMethods = {
	cssContentHidden: 'oculto',
	cssContent: 'RowStd',
	cssContentVisible: 'RowStd',
	initialize: function ($super,domItem) {
		$super(this,domItem);
	},
	registerSwitch: function (oMenu,pos) {
		this.oMenu = oMenu;
		this.menuPos = pos;
	},
	focus: function() {
		this.getItem().className = this.cssContentVisible;
	},
	blur: function(oItm) {
		this.getItem().className = this.cssContentHidden;
	},
	keyPress: function (aT,ev) {
		switch (aT.strKey) {
			case "ESC":
				if (this.oMenu) { this.oMenu.deactivate(this.menuPos); }
				break;
		}
	}
}
var ReferenceInfo = Class.create(SonSwitchByCSS,someMethods);


var var1 = "uno";
var DeliveryEntry = Class.create();
DeliveryEntry.prototype = {
	cssContentHidden: 'oculto',
	cssContent: 'RowStd',
	cssContentVisible: 'RowStd',
	bBlockKeyboard: false,
	itemActivo: undefined,
	parkFocus: undefined,
	lastRequest: undefined,
	lastResponse: undefined,
	Locations: new HashMap(),
	SKUs: new HashMap(),
	nRefCacheLimit: 2,
	urlBase: 'index.php',
	ajaxRecCount: 1,
	ajaxInfoDiv: undefined,
	ajaxStockDiv: undefined,
	ajaxStatusDiv: undefined,
	ajaxLogDiv: undefined,
	dRecordRequests: new HashMap(),
	RecordForm: undefined,
	tpRecordRequest: new Template("ref #{cbarras} enviada .. "),
	tpRecordResponseUnknown: new Template("<b>Error</b> respuesta desconocida. HTTP: #{status} #{statusText} ; ReqID: #{request_id}"),
	tpRecordResponseStatus: new Template("Request #{token} Albaran #{albaran} Lineas (n/e/b) : #{ndet_new}/#{ndet_edi}/#{ndet_del}"),
	tpRecordResponse: new Template("ReqID #{token} Albaran #{albaran} nuevo #{ndet_new} editados #{ndet_edi} borrados #{ndet_del}"),
	tpRefRequest: new Template("buscando codigo de barras #{cbarras} .. "),
	tpRefFound: new Template("#{nombre} [#{marca}] encontrado. #{cantidad_pendiente} pendiente en #{albaran} "),
	tpRefNotFound: new Template("codigo #{cbarras} <b>no se encuentra</b> en este albaran."),
	tpStockNotFound: new Template("#{cbarras} <b>desconocido</b> en el stock."),
	tpStockFound: new Template("#{articulo} (#{id}) contiene #{nlocalizaciones} localizaciones y #{nskus} fechas en todo el Almacen."),
	initialize: function (base) {
		if (!base || !base.id) return false;
		this.domBase = base;
		this.oMenu = undefined;
		this.menuPos = -1;
		this.itemActivo = undefined;
		this.dItems = new HashMap();

		//aList = this.domBase.getElementsByTagName('DIV');
		aList = mydom.findElements(this.domBase,'DIV');
		for (var i=aList.length-1; i>=0; i--) {
			//alert("Los div son: "+aList[i].id+" o "+aList[i].getAttribute('name'));
			if (aList[i].parentNode==this.domBase) {
				switch (aList[i].getAttribute('name')) {
					case "Cantidad":
						this.dItems.put('Cantidad',new ExtendedCantidad(this,aList[i]));
						break;
					case "Localizacion":
						this.dItems.put('Localizacion',new ExtendedLocalizacion(this,aList[i]));
						break;
					case "SKU":
						this.dItems.put("SKU",new ExtendedSKU(this,aList[i]));
						break;
					case "CodigoBarras":
						this.dItems.put('CodigoBarras',new CBAjax(this,aList[i]));
						break;
				}
			}
		}
	},

	registerSwitch: function (oMenu,pos) {
		this.oMenu = oMenu;
		this.menuPos = pos;
	},

	focus: function() {
		this.domBase.className = this.cssContentVisible;
		if (isUndefined(this.itemActivo)) {
			this.itemActivo = "CodigoBarras";
			aKeys = this.dItems.keys();
			for (var k in aKeys) {
				if (isFunction(aKeys[k])) continue;
				//alert("Llamando al glow de: "+aKeys[k]);
				this.dItems.get(aKeys[k]).blur();
			}
		}
		tmp = this.dItems.get(this.itemActivo);
		tmp.glow();
		tmp.focus();
		this.bBlockKeyboard = true;
	},
	blur: function(oItm) {
		aTmp = this.dItems.keys();
		for (var i = aTmp.length-1; i>=0; i--) {
			var oI = this.dItems.get(aTmp[i]);
			oI.blur();
		}
		this.domBase.className = this.cssContentHidden;
	},

	blurItem: function(oItm) {
		aTmp = this.dItems.keys();
		for (var i = aTmp.length-1; i>=0; i--) {
			var oI = this.dItems.get(aTmp[i]);
			if (oI==oItm) {
				if (this.parkFocus) this.parkFocus.focus();
				oI.blur();
				this.bBlockKeyboard = false;
				break;
			}
		}
	},

	setParkingFocus: function (id,oKB) {
		//Event.observe($(id),'keydown',this.keyParking.bind(this),true);
		//Event.observe($(id),'keypress',this.keyParking.bind(this),true);
		this.parkFocus = $(id);
		this.oKB = oKB;
	},

	keyParking: function (ev) {
		var code;
		if (ev && isNumber(ev.keyCode)) code = ev.keyCode;
		// alert(" Tecla aparcada tronco! ");
		// this.keyPress(this.oKB.mapKeyCode(code),ev);
		// if (ev.preventDefault) { ev.preventDefault(); }
		return false;
	},

	keyPress: function(aT,ev) {
		rval = false;
		// alert("keypress y tal no ");
		if (!isUndefined(this.itemActivo) && this.itemActivo != null && this.bBlockKeyboard) {
			oItm = this.dItems.get(this.itemActivo);
			rval = oItm.keyPress(aT,ev);
			// alert("para este, el "+this.itemActivo+" dice: "+rval);
		} else {
			//alert("No hay activo nada ");
			switch (aT.strKey) {
				case "ESC":
					if (this.oMenu) {
						this.oMenu.deactivate(this.menuPos);
					}
					rval = true;
					break;

				case "UP":
					rval = this.moveUp();
					break;

				case "DOWN":
					rval = this.moveDown();
					break;

				case "INTRO":
					if (!isUndefined(this.itemActivo)) {
						this.bBlockKeyboard = true;
						this.dItems.get(this.itemActivo).focus();
						rval = true;
					} else rval = false;
					break;

				case "LEFT":
					if (!isUndefined(this.itemActivo)) {
						switch (this.itemActivo) {
							case "Localizacion":
								rval = this.prevLocation();
								break;
							case "SKU":
								rval = this.prevSKU();
								break;
							default:
								rval = false;
						}
					} else rval = false;
					break;

				case "RIGHT":
					if (!isUndefined(this.itemActivo)) {
						switch (this.itemActivo) {
							case "Localizacion":
								rval = this.nextLocation();
								break;
							case "SKU":
								rval = this.nextSKU();
								break;
							default:
								rval = false;
						}
					} else rval = false;
					break;
			}
		}
		return rval;
	},

	moveDown: function(bFocus) {
		if (isUndefined(bFocus) || bFocus==null) bFocus=false;
		var anterior = this.itemActivo;
		var actual = null;
		switch (this.itemActivo) {
			case "CodigoBarras":
				actual = 'Localizacion';
				break;
			case "Localizacion":
				actual = 'SKU';
				break;
			case "SKU":
				actual = 'Cantidad';
				break;
			case "Cantidad":
				actual = 'CodigoBarras';
				break;
			default:
				alert("No hay item activo reconocible. ");
				return false;
		}
		this.itemActivo = actual;
		nuevo = this.dItems.get(this.itemActivo);
		//alert("El item anterior es "+anterior+" el nuevo es: "+actual+" focus? "+bFocus);
		if (!bFocus) {
			this.bBlockKeyboard = false;
			nuevo.glow();
		} else nuevo.focus();
		if (!isUndefined(anterior) && anterior != null) {
			old = this.dItems.get(anterior);
			old.blur();
			if (this.parkFocus && this.parkFocus.focus && !bFocus) this.parkFocus.focus();
		}
		return true;
	},

	moveUp: function(bFocus) {
		if (isUndefined(bFocus) || bFocus==null) bFocus=false;
		var anterior = this.itemActivo;
		var actual = null;
		switch (this.itemActivo) {
			case "CodigoBarras":
				actual = 'Cantidad';
				break;
			case "Localizacion":
				actual = 'CodigoBarras';
				break;
			case "SKU":
				actual = 'Localizacion';
				break;
			case "Cantidad":
				actual = 'SKU';
				break;
			default:
				alert("No hay item activo reconocible. ");
				return;
		}
		if (!isUndefined(anterior) && anterior != null) {
			old = this.dItems.get(anterior);
			if (this.parkFocus) this.parkFocus.focus();
			old.blur();
		}
		this.itemActivo = actual;
		nuevo = this.dItems.get(this.itemActivo);
		if (!bFocus) {
			this.bBlockKeyboard = false;
			nuevo.glow();
		} else nuevo.focus();
		return true;
	},

	nextLocation: function() {
		if (isUndefined(this.lastResponse)) return true;
		rval = true;
		if (!isUndefined(this.lastResponse) && !isUndefined(this.lastResponse.referencia) && 
				!isUndefined(this.lastResponse.referencia.id_articulo)) {
			var locList = this.Locations.get(this.lastResponse.referencia.id_articulo);
			var oBase = this.dItems.get('Localizacion');
			var current = oBase.formatLocation();
			var aKeys = Object.keys(locList,true);
			var cnt = 0;
			for (var j in aKeys) {
				var k = aKeys[j];
				cnt++;
				if (isFunction(k)) continue;
				if (current == "00-:::" || current == "01-:::" ) {
					oBase.setLocationFromString(k);
					break;
				} else if (cnt == aKeys.length) {
					oBase.setLocationFromString(aKeys.first());
					break;
				} else if (current == k) current = "00-:::";
			}
		}
		return rval;
	},

	prevLocation: function() {
		if (isUndefined(this.lastResponse)) return true;
		rval = true;
		if (!isUndefined(this.lastResponse) && !isUndefined(this.lastResponse.referencia) && 
				!isUndefined(this.lastResponse.referencia.id_articulo)) {
			var locList = this.Locations.get(this.lastResponse.referencia.id_articulo);
			var oBase = this.dItems.get('Localizacion');
			var current = oBase.formatLocation();
			var aKeys = Object.keys(locList,true).reverse();
			var cnt = 0;
			for (var j in aKeys) {
				var k = aKeys[j];
				cnt++;
				if (isFunction(k)) continue;
				if (current == "00-:::" || current == "01-:::") {
					oBase.setLocationFromString(k);
					break;
				} else if ( cnt==(aKeys.length)) {
					oBase.setLocationFromString(aKeys.first());
					break;
				} else if (current == k) current = "00-:::";
			}
		}
		return rval;
	},

	nextSKU: function() {
		if (isUndefined(this.lastResponse)) return true;
		rval = true;
		if (!isUndefined(this.lastResponse) && !isUndefined(this.lastResponse.referencia) && 
				!isUndefined(this.lastResponse.referencia.id_articulo)) {
			var skuList = this.SKUs.get(this.lastResponse.referencia.id_articulo);
			var oBase = this.dItems.get('SKU');
			var current = oBase.formatSKU();
			var aKeys = Object.keys(skuList,true);
			var cnt = 0;
			for (var j in aKeys) {
				var k = aKeys[j];
				cnt++;
				//alert("claves.lng: "+aKeys.length+" estamos en "+cnt+" k es: "+k);
				if (isFunction(k)) continue;
				if (current == "--*") {
					oBase.setSKUFromArray(skuList[k]);
					break;
				} else if ( cnt==(aKeys.length)) {
					oBase.setSKUFromArray(skuList[aKeys.first()]);
				} else if (current == k) { current = "--*"; }
			}
		}
		return rval;
	},

	prevSKU: function() {
		if (isUndefined(this.lastResponse)) return true;
		var rval = true;
		if (!isUndefined(this.lastResponse) && !isUndefined(this.lastResponse.referencia) && 
				!isUndefined(this.lastResponse.referencia.id_articulo)) {
			var skuList = this.SKUs.get(this.lastResponse.referencia.id_articulo);
			var oBase = this.dItems.get('SKU');
			var current = oBase.formatSKU();
			var aKeys = Object.keys(skuList,true).reverse();
			var cnt = 0;
			for (var j in aKeys) {
				var k = aKeys[j];
				cnt++;
				if (isFunction(k)) continue;
				if (current == "--*") {
					oBase.setSKUFromArray(skuList[k]);
					break;
				} else if ( cnt==(aKeys.length)) {
					oBase.setSKUFromArray(skuList[aKeys.first()]);
					break;
				} else if (current == k) current = "--*";
			}
		}
		return rval;
	},

	addRefLocation: function(id,aLoc) {
		// Esta linea de inidizlizacion, es para borrar.
		if (isUndefined(this.Locations)) this.Locations = new HashMap();
		if (isUndefined(aLoc) || !aLoc.localizacion || !aLoc.localizacion.length) {
			alert("addRefLocation() - No hay localizacion ");
			for (var k in aLoc) {
				var strDebug = "Las claves: \n";
				if (!isFunction(k)) strDebug += k+"\n";
				alert(strDebug);
			}
			return;
		}
		var aRec = this.Locations.get(id);
		var aTmp = {};
		if (isUndefined(aRec)) {
			//Creamos contenedor para la primera. 
			aRec = {};
		} else {
			this.Locations.limitTo(this.nRefCacheLimit);
		} 
		//alert("El id: "+id);
		aTmp.localizacion = aLoc.localizacion;
		if (aLoc.zona) aTmp.zona = aLoc.zona;
		if (aLoc.id_almacen_logico) aTmp.zona = aLoc.id_almacen_logico;
		if (aLoc.planta) aTmp.planta = aLoc.planta;
		if (aLoc.pasillo) aTmp.pasillo = aLoc.pasillo;
		if (aLoc.columna) aTmp.columna = aLoc.columna;
		if (aLoc.fila) aTmp.fila = aLoc.fila;
		aRec[aTmp.localizacion] = aTmp;
		this.Locations.put(id,aRec);
	},

	addRefSKU: function(id,aSKU) {
		// Esta linea de inidizlizacion, es para borrar.
		if (isUndefined(this.SKUs)) this.SKUs = new HashMap();
		if (isUndefined(aSKU) || isUndefined(aSKU.sku) || !aSKU.sku.length) {
			alert("addRefLocation() - No hay SKU ");
			for (var k in aLoc) {
				var strDebug = "Las claves: \n";
				if (!isFunction(k)) strDebug += k+"\n";
				alert(strDebug);
			}
			return;
		}
		var aRec = this.SKUs.get(id);
		var aTmp = {};
		if (isUndefined(aRec)) {
			//Creamos contenedor para la primera. 
			aRec = {};
		} else {
			this.SKUs.limitTo(this.nRefCacheLimit);
		}
		aTmp.sku = aSKU.sku;
		if (aSKU.fecha_caducidad) aTmp.fecha_caducidad = aSKU.fecha_caducidad;
		if (aSKU.fecha) aTmp.fecha_caducidad = aSKU.fecha;
		if (aSKU.anyo) aTmp.anyo = aSKU.anyo;
		if (aSKU.mes) aTmp.mes = aSKU.mes;
		if (aSKU.dia) aTmp.dia = aSKU.dia;
		if (aSKU.lote) aTmp.lote = aSKU.lote;
		if ((!aTmp.anyo || !aTmp.mes || !aTmp.dia) && !isUndefined(aTmp.fecha_caducidad)) {
			var aTmp2 = aTmp.fecha_caducidad.split('-');
			if (aTmp2.length>2) {
				if (!aTmp.anyo) aTmp.anyo = aTmp2[0];
				if (!aTmp.mes) aTmp.mes = aTmp2[1];
				if (!aTmp.dia) aTmp.dia = aTmp2[2];
			}
		}
		aRec[aSKU.sku] = aTmp;
		this.SKUs.put(id,aRec);
	},

	findElement: function(el,tag,name) { return mydom.findElement(el,tag,name); },
	setAjaxInfo: function (id) { this.ajaxInfoDiv = $(id); },
	setAjaxStatus: function (id) { this.ajaxStatusDiv = $(id); },
	setAjaxStock: function (id) { this.ajaxStockDiv = $(id); },
	setAjaxLog: function (id) { this.ajaxLogDiv = $(id); },
	setRecordForm: function (id) { this.RecordForm = $(id); },

	asyncGetRef: function () {
		var dGet = new HashMap();
		var dPost = new HashMap();
		dGet.put('seccion','ajax_alb_cbarras');
		dPost.put('CodigoBarras',this.dItems.get('CodigoBarras').getValue());
		var myAjax = new Ajax.Updater(
			this.ajaxInfoDiv.id,
			this.urlBase+'?'+dGet.toQueryString(),
			{
				method: 'post',
				asynchronous: true,
				parameters: dPost.toQueryString(),
				onLoaded: this.showLoaded.bind(this),
				onComplete: this.showResponse.bind(this),
				evalScripts: true
			});
		oR = {cbarras: this.dItems.get('CodigoBarras').getValue()};
		this.loading(oR);
		this.lastRequest = oR;

	},

	asyncGetStock: function () {
		// Actualizanso asi... a veri si el inventario sale.
		var dGet = new HashMap();
		var dPost = new HashMap();
		dGet.put('seccion','pkg_inventario');
		dGet.put('__ajax_token','void');
		dPost.put('CodigoBarras',this.dItems.get('CodigoBarras').getValue());
		dPost.put('accion','SeleccionarCBarras');
		var InvRequest = new Ajax.Updater(
			this.ajaxStockDiv.id,
			this.urlBase+'?'+dGet.toQueryString(),
			{
				method: 'post',
				asynchronous: true,
				parameters: dPost.toQueryString(),
				onLoaded: this.showLoaded.bind(this),
				onComplete: this.storeStockInfo.bind(this),
				evalScripts: true
			});
	},

	asyncSendForm: function () {
		if (!isUndefined(this.RecordForm)) {
			//alert("Mandando el formulario. Y preparandose para registrar el log! "+this.RecordForm);
			var frm = new HashMap();
			var dGet = new HashMap();
			var flds = inmForm.getElements(this.RecordForm);
			for (var j=flds.length-1, i=0;j>=0;j--,i++) {
				if (flds[j].hasAttribute("name")) { 
					frm.put(flds[j].getAttribute("name"),Form.Element.getValue(flds[j])); 
				}
			}
			frm.put("__ajax_token",(this.ajaxRecCount++));
			var myAjax = new Ajax.Request(
				this.RecordForm.getAttribute('action'),
				{
					method: 'post',
					asynchronous: true,
					parameters: frm.toQueryString(),
					onLoaded: this.showLoaded.bind(this),
					onComplete: this.logResponse.bind(this)
				});
			this.RecordForm.reset();
			oR = {request_id: frm.get('__ajax_token'), hashForm: frm};
			oR.cbarras = this.dItems.get('CodigoBarras').getValue();
			this.loading(oR);
			//this.lastRequest = oR;
			this.lastRequest = undefined;
		}
	},

	loading: function (oReq) {
		if (!isObject(this.ajaxStatusDiv)) return;
		var strMsg = "";
		if (!isUndefined(oReq.request_id)) {
			strMsg = this.tpRecordRequest.evaluate(oReq);
			this.dRecordRequests.put(oReq.request_id,oReq);
		} else if (!isUndefined(oReq.cbarras)) {
			strMsg = this.tpRefRequest.evaluate(oReq);
		}
		this.ajaxStatusDiv.innerHTML = strMsg;
	},

	showLoaded: function (originalRequest) {
		//alert("Que deje de rodar la ruedecita ");
	},

	showResponse: function (originalRequest,oJSon) {
		//alert("ahora hay: "+$('Contenido').innerHTML);
		//$('Contenido').innerHTML = originalRequest.responseText;
		var strMsg = "", oRef;
		if (!isUndefined(this.lastRequest)) strMsg = this.tpRefNotFound.evaluate(this.lastRequest);
		if (!isUndefined(oJSon) && oJSon!=null) {
			this.lastResponse = oJSon;
			var strDebug = "las var del JSon son: \n";
			for (key in oJSon) { strDebug += key+"\n"; }
			if (!isUndefined(oJSon.referencia)) { 
				oRef = oJSon.referencia;
				oRef.albaran = oJSon.albaran;
				strMsg = this.tpRefFound.evaluate(oRef);
				if (this.lastResponse.localizaciones) {
					var aKeys = Object.keys(this.lastResponse.localizaciones,true);
					for (var j in aKeys) {
						var k = aKeys[j];
						if (isFunction(k) || isFunction(this.lastResponse.localizaciones[k])) continue;
						var tmp = this.lastResponse.localizaciones[k];
						tmp.localizacion = k;
						this.addRefLocation(oRef.id_articulo,tmp);
					}
				}
				if (this.lastResponse.skus) {
					var aKeys = Object.keys(this.lastResponse.skus,true);
					for (var j in aKeys) {
						var k = aKeys[j];
						if (isFunction(k) || isFunction(this.lastResponse.skus[k])) continue;
						var tmp = this.lastResponse.skus[k];
						tmp.sku = k;
						this.addRefSKU(oRef.id_articulo,tmp);
					}
				}
				//FixME: Consume demasiado en un cliente monohilo : this.asyncGetStock();
			} else {
				alert(strDebug);
			}
		} else this.lastResponse = undefined;
		this.ajaxStatusDiv.innerHTML = strMsg;
	},

	logResponse: function (originalRequest,oJSon) {
		var strMsg = "";
		var strLog;
		var doDebug = false;
		//if (!isUndefined(this.lastRequest)) strMsg = this.tpRefNotFound.evaluate(this.lastRequest);
		if (doDebug) alert("response seems ok. processing .. ");
		if (!isUndefined(oJSon) && oJSon!=null) {
			//this.lastResponse = oJSon;
			var strDebug = "las var del JSon son: \n";
			for (key in oJSon) { strDebug += key+"\n"; }
			if (doDebug) alert(strDebug);
			if (!isUndefined(oJSon.referencia)) { 
				strMsg = this.tpRefFound.evaluate(oJSon.referencia);
				strLog = this.tpRefFound.evaluate(oJSon.referencia);
			} else {
				//alert(strDebug);
				strMsg = this.tpRecordResponseStatus.evaluate(oJSon);
				strLog = this.tpRecordResponse.evaluate(oJSon);
			}
		} else {
			var tmpMsg = "";
			if (doDebug) alert(" las opts: "+originalRequest.request.options+"\n"+tmpMsg);
			if (isString(originalRequest.request.options.parameters['__ajax_token'])) {
				originalRequest.request_id = originalRequest.request.options.parameters.__ajax_token;
			}
			strMsg = this.tpRecordResponseUnknown.evaluate(originalRequest);
		}
		if (doDebug) {
			alert("stat-> "+strMsg);
			this.ajaxLogDiv.innerHTML = originalRequest.responseText+"<hr width='50%' /><br/>\n"+this.ajaxLogDiv.innerHTML;
		}
		this.ajaxStatusDiv.innerHTML = strMsg;
		this.logEvent(strMsg);
	},

	storeStockInfo: function (originalRequest,oJSon) {
		//alert("ahora hay: "+$('Contenido').innerHTML);
		//$('Contenido').innerHTML = originalRequest.responseText;
		var strMsg = "";
		if (!isUndefined(this.lastRequest)) strMsg = this.tpStockNotFound.evaluate(this.lastRequest);
		if (!isUndefined(oJSon) && oJSon!=null) {
			//TODO: Cambiar nombre a lastResponse. this.lastResponse = oJSon;
			var strDebug = "las var del JSon son: \n";
			var oRS = {}, aRec, aTmp;
			for (key in oJSon) { strDebug += key+"\n"; }
			//alert("vars: "+strDebug+" ln: "+oJSon.length);
			oRS.count = 0;
			oRS.id = null;
			oRS.articulo = null;
			oRS.marca = null;
			for (var i in Object.keys(oJSon)) {
				if (isFunction(oJSon[i]) || isFunction(i) || isUndefined(oJSon[i])) continue;
				oRS.count++;
				aRec = oJSon[i];
				if (!oRS.articulo) {
					oRS.id = aRec['id_articulo'];
					oRS.articulo = aRec['articulo'];
					oRS.marca = aRec['marca'];
				}
				//alert("rec en "+aRec.localizacion+" unit "+aRec.sku+" for: "+aRec.id_articulo);
				try {
					this.addRefLocation(aRec.id_articulo,aRec);
					this.addRefSKU(aRec.id_articulo,aRec);
				} catch (e) {
					alert("E: "+e);
				}
			}
			try {
				oRS.nlocalizaciones = oRS.count;
				oRS.nskus = oRS.count;
				strMsg = this.tpStockFound.evaluate(oRS);
			} catch (e) { alert("E: "+e); }
		} 
		this.logEvent(strMsg);
	},

	logEvent: function (msg) {
		var strMsg = "<div class=\"req_log_line\" >"+msg+"</div>";
		this.ajaxLogDiv.innerHTML = strMsg+"\n"+this.ajaxLogDiv.innerHTML;
	}
}

