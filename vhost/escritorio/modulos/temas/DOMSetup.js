
var __AppContainer;
// Clase AppDoc :
function AppDoc(name) {
   // CheckBoxes seleccionadas en el documento Actual
   this.aCheckboxList = new Array();

   // Vector de Formularios a comprobar si han cambiado antes de ir a otro enlace cualquiera.
   this.aForms = new Array();
	this.AppName = name;

	__AppContainer = this.AppName;


   // Metodos Generales:
   this.linkEvent 				= linkEvent;

	// old?
   this.linkEventByType 		= linkEventByType;
   this.linkEventByIdWithTags = linkEventByIdWithTags;

	this.isTable = isTable;
	this.getTableRows = getTableRows;
	this.setElementAction = setElementAction;
	this.filterObjectsVector = filterObjectsVector;
	this.seekParentByType = seekParentByType;


   // Metodos sobre Formularios:
   this.trackFormById = setFormIDToCheck;

	// Este metodo se dispara cuando se lanza el onChange de un elemento de formulario bajo checkeo.
	//		Marca el formulario como modificado, y llama a la funcion que se le haya asociado.
   this.onChangeFormElement = onChangeFormElement;

}


/**
  * linkEvent(sEntidad,sEvento,fAccion,sId,sCondicion):
  * Este metodo se encarga de apilarnos la accion fAccion a la pila de funciones disparadas por el
  *	evento sEvento de las entidades de tipo sEntidad [ que cuelgan del arbol DOM del id sId | o
  *	de la entidad BODY ][y que los nodos padre de sEntidad cumplan la condicion sCondicion].
  *
  * @param sEntidad 		Entidad a la que se asocia la accion (A, INPUT, DIV ...)
  * @param sEvento		Evento al que se asocia la accion (onclick, onmouseover ...)
  * @param fAccion		_funcion_ que ha de ser asociada, no vale el nombre, la funcion sin convertir a string.
  * @param sId				[opt] DOMID a partir del cual se analizaran las ramas, sino se usa el BODY completo.
  * @param sCondicion	Condicion(s) que ha(n) de cumplirse en las ramas/nodos padre del elemento. Si null, todos los elementos encontrados.
  *
  *	La condicion tendra el siguiente formato:
  *		'COND1 [CONDN ..]'
  *
  *	Cada una de las condiciones sera evaluada por separado, y habra de cumplirse _todas_ ellas en algun(os) elemento(s) de bloque 
  *		superior(es)/contenedor(es) de la entidad deseada. El formato es el siguiente:
  *		ENTIDAD[:[!]class] 
  *	
  **/
function linkEvent(sEntidad,sEvento,fAccion,sId,sCondicion) {
	var oId;
	var aNodes;
	var oSearch;

	// alert(sEntidad + ' - ' + sEvento + ' ' + sId + ' ' + sCondicion);
	if (sId) oId = document.getElementById(sId);
	else oId = document.body;

	if (!oId) {
		alert('DOM Failure to obtain root element '+sId);
		return false;
	}

	oSearch = new DOMSearch();
	// aNodes = oSearch.search(sEntidad,sCondicion,oId);

	if (aNodes && aNodes.length) {
		for (i=0; i < aNodes.length; i++) {
			alert(aNodes[i].nodeName);
		}
	} else {
		// alert('None Found');
	   a = 1;
	}

}

// Metodo encargado de linkar una accion/funcion a un evento del tipo determinado
function linkEventByType(dom_type,ev,action,css_name,bOverride) {

	if (!bOverride) bOverride = false;
	else bOverride = true;

	// alert('event : ' + ev + '  len: '+document.links.length);
	// alert('first: '+document.anchors[0].length);
	if (dom_type == 'link') {
		for (i=0;i < document.links.length; i++) {
			this.setElementAction(document.links[i],ev,action,bOverride);
		}
	} else {
		alert(dom_type);
	}
}

function linkEventByIdWithTags(id,ev,action,tag,bOverride) {
	var Element = document.getElementById(id);
	var vItems = new Array();
	var i = 0;
	var j = 0;
	var sTag = new String(tag);
	var aTree = new Array();

	if (!Element) return false;

	var str = '';
	if (tag) {
		if (this.isTable(Element)) {
			aTree = sTag.split(' ');
			if (aTree.length) {
				var vRows = this.getTableRows(Element,aTree.shift());
			} else {
				var vRows = this.getTableRows(Element);
			}

			// var vRows = this.getTableRows(Element,'TBODY');
			for (i = 0; i < vRows.length; i++) {
				vItems.push(vRows[i]);
			}
		}
	}
	if (!vItems.length) {
		vItems.push(Element);
	}

	// Recorremos el vector con los elementos que han de ser procesados.
	for (i = 0; i < vItems.length; i++) {
		this.setElementAction(vItems[i],ev,action,bOverride);
	}
		
}

// Los hidden NUNCA se comprueban
function setFormIDToCheck(form_id,el_type,action) {
	var aTmp = new Array();

	if (!form_id) return ;
	if (el_type == 'all') el_type = false;

	// Obtenemos la instancia formulario
	form = document.getElementById(form_id);

	if (form) {
		// SI ya lo tenemos, salirse
		for (i=0; i < this.aForms.length; i++) 
			if (this.aForms[i][0] == form_id) return;

		aTmp[0] = form_id;
		aTmp[1] = false;
		if (action) aTmp[2] = action;
		this.aForms.push(aTmp);
		for (i=0; i < form.elements.length; i++) {
			if (form.elements[i].type != 'hidden') {
				if (!el_type || el_type == form.elements[i].type) {
					form.elements[i].onchange = onChangeFormElement;
				}
				// form.elements[i].disabled = true;
			}
		}
	} else {
		// alert('No form');
	}
}

function onChangeFormElement() {
	var Iface = AppIface;

	for (i=0; i < Iface.aForms.length; i++) {
		if (Iface.aForms[i][0] == this.form.id) {
			Iface.aForms[i][1] = true;
			if (Iface.aForms[i][2]) {
				Iface.aForms[i][2](Iface,this);
			}
			break;
		}
	}
}

function seekParentByType(Item,type_name) {
	cell = Item.parentNode;
	alert(cell.document);
	alert(cell.rows);
}

function filterObjectsVector(vector,type,method) {
	var aRetVal = new Array();
	var sClase = new String();
	var i;

	if (!method) method = 'Object';
	
	for (i=0; i < vector.length; i++) {
		sClase = typeof vector[i];
		if (sClase.search('Object')) {
			if (method == 'Object') {
				vectype = vector[i].toString();
			} else {
				vectype = new String(vector[i].nodeName);
			}
			if ( (type && vectype.search(type) != -1) || !type) {
				aRetVal.push(vector[i]);
			}
		}
	}
	return aRetVal;
}

/**
  Este metodo deberia asociar a la accion siempre los mismos metodos internos, y manetener
  referencias de las acciones que se han solicitado para cada DOMID, de tal forma que cuando se dispeare nuestro manejador interno
  se pueda tener una constancia de la accion a la que hay que llamar cuando se terminen de hacer las comprobaciones pertinentes. 
  Si el elemento que recibidmos no tiene id, generarlo y asignarselo.
  **/
function setElementAction(Element,ev,action,bOverride) {
	if (!action) return false;

	if (ev == 'onclick') {
		if ( bOverride || (!bOverride && !Element.onclick)) {
			Element.onclick = action;
		}
	}
}


function getTableRows(Element,section) {
	var i =0;
	var j =0;
	var vretval = new Array();
	var vRows; 

	/** **
	alert(Element.nodeName);
	for (i = 0; i < Element.childNodes.length; i++) { 
		alert(Element.childNodes[i].nodeName + ' ' + Element.childNodes[i].toString());
	}
	/* **/

	if (!section) {
		vRows = this.filterObjectsVector(Element.childNodes,'HTMLTableSection');
	} else {
		vRows = this.filterObjectsVector(Element.childNodes,section,'Name');
	}

	for (j = 0; j < vRows.length; j++) {
		for (i = 0; i < vRows[j].rows.length; i++ ) {
			// alert('Row: ' + vRows[j].toString() + ' : ' + vRows[j].rows[i].ch );
			vretval.push(vRows[j].rows[i]);
		}
	}

	return vretval;
}

function isTable(Item) {
	var retval = false;
	if (Item.toString().search('HTMLTableElement') != -1) retval = true;
	return retval;
}

/** Para que todas las instancias de una clase hereden una propiedad o metodo: **
  window.Image.prototype.myPrototypeMethod = myFunction2;

  window.Image.prototype.myPrototypeProperty = 'dlrow olleH';

/** **/



function catchevent(event) {
	alert(event.srcElement);
	eventSrcID=(event.srcElement)?event.srcElement.id:'undefined';
	eventtype=event.type;
	status=eventSrcID+' has received a '+eventtype+' event.';
	alert(status);
	window.status = status;
	return true;
}
//document.onClick = catchevent;

buttonname=new Array('Left','Right','','Middle');
function buttoninfo(event) {
	message='button : '+buttonname[event.button-1]+'\n';
	message+='altKey : '+event.altKey +'\n';
	message+='ctrlKey : '+event.ctrlKey +'\n';
	message+='shiftKey : '+event.shiftKey +'\n';
	alert(message);
}

