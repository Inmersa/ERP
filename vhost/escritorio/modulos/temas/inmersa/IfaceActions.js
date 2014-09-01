
function refCache () {
   this.aObjects = [];
   this.aObjectNames = [];
   this.aObjectGroups = [];

   this.base_url = window.location.href;
}

refCache.prototype.register = function (id,object,aGroups) {
   var i;

   if (this.aObjectNames.length)
      for ( i=0; i < this.aObjectNames.length; i++) {
	 if (id == this.aObjectNames[i]) { return false; }
      }
   i = this.aObjects.length;
   this.aObjectNames[i] = id;
   this.aObjects[i] = object;
   if (aGroups) {
      if (!isObject(aGroups) || aGroups.constructor != Array) {
	 aGroups = new Array(aGroups);
      }
      if (aGroups.length) {
	 this.aObjectGroups[id] = aGroups;
      }
   }
   return true;
}

refCache.prototype.search = function (id) {
   var i;

   for ( i=0; i < this.aObjectNames.length; i++) {
      if (this.aObjectNames[i] == id) {
	 return this.aObjects[i];
      }
   }
   return null;
}




function abrir_ayuda(direccion){
 var nuevo = window.open(direccion,'nueva_ventana',
 			'menubar=0,scrollbars=1,toolbar=0,resizable=1,location=0,height=400,width=500');
 nuevo.moveTo(140,140);
 return false;
}

function abrir_ventana(direccion,width,height){
 options = 'menubar=1,scrollbars=1';
 if (width) options += ',width='+width;
 if (height) options += ',height='+height;
 var nuevo = window.open(direccion,'nueva_ventana',options);
 if (width || height) nuevo.moveTo(140,140);
 return false;
}

function CatalogoImagenesSoloUna(tabla,campo,clave,imagen) {
	url = '?seccion=bo_cat_radio&arreguarda=1';
	if (tabla) url = url + '&tabla=' + tabla ;
	if (campo) url = url + '&campo_destino=' + campo ;
	if (clave) url = url + '&id_sub=' + clave ;
	if (imagen) url = url + '&id_imagen=' + imagen ;
	return abrir_ventana(url);
}

function onHRefClick(form,element,value,action,confirm_text)
{
   // alert(document.forms[form].action);
   //alert ( document.forms[form].elements[element].name + document.forms[0].elements[0].value );
   if (element && value) {
      document.forms[form].elements[element].value = value;
   }
   if (action) document.forms[form].action = '?seccion=' + action;
   //alert ( document.forms[form].action + " -- " + document.forms[form].elements[element].name + " -- " + document.forms[form].elements[element].value );
   if (confirm_text) {
      if (confirm(confirm_text)) document.forms[form].submit();
   } else {
      document.forms[form].submit();
   }
   return false;
}

function sendForm(form,element,value,action,confirm_text) {
	onHRefClick(form,element,value,action,confirm_text);
	return false;
}

function resetForm(form) {
	document.forms[form].reset();
	return false;
}

function confirmForm(form,texto) {
   if (confirm(texto)) document.forms[form].submit();
   return false;
}

function SendFormToWindow(form_name,action,target,element,value,width,height) {
	options = 'menubar=1,scrollbars=1';
	if (width) options += ',width='+width;
	else options += ',width='+document.width;

	if (height) options += ',height='+height;
	else options += ',height='+document.height;

	if (action) document.forms[form_name].action = '?seccion='+action;
	if (element) {
	   if (document.forms[form_name].elements[element])
	   	document.forms[form_name].elements[element].value = value;
	}
	if (target) {
		document.forms[form_name].target = target;
 		var nuevo = window.open('',target,options);
	}

	document.forms[form_name].submit();
	this.window.focus();
	return false;
}

function imprimir_directo(link) {
	if (parseInt(navigator.appVersion)>=4){ 
		ventana_actual = this.window;
		enlace = link + '&printit=1';
		ventana_print = window.open(enlace,'blank_','menubar=no,scroll=off,tools=0,toolbar=0');
		ventana_actual.focus();
	}
	return false;
}

function llamame() {
	alert('man llamao...');
}

function arrastre_paginado(form_id,pag_value) {
	var i=0;

	form = document.getElementById(form_id);
	pag_name = form.elements['nombre_variable_paginado'].value;
	form.elements[pag_name].value = pag_value;
	// alert(form.elements[pag_name].value);
	/** ** 
	if (aCheckboxList)
		while (aTmp = aCheckboxList.pop()) {
			// alert(aTmp.length + '  -> ' + aTmp[1] + ' = ' + aTmp[0]);
			form.elements['checked_boxes'].value = form.elements['checked_boxes'].value + ' ' + aTmp[1] + '=' + aTmp[0];
		}
	/** **/
	form.submit();
	
	return false;
}

function mostrar_valorbarra(elemento) {
	if (document.layers) {
		// document.layers[elemento].visibility="show";
		if (!elemento.visibility || elemento.visibility=="hide") {
			elemento.visibility="show";
			elemento.display="inline";
		} else {
			elemento.visibility="hide";
			elemento.display="none";
		}
	} else {
		// document.all[elemento].style.visibility="visible";
		// alert("display: "+elemento.style.display+" para ie: "+elemento.currentStyle.getAttribute('display') );
		if (!elemento.style.visibility || elemento.style.visibility=="hidden") {
			elemento.style.visibility="visible";
			// elemento.style.display="inline";
			// elemento.style.display="inline";
			// elemento.currentStyle.setAttribute('display','block',0);
		} else {
			elemento.style.visibility="hidden";
			// elemento.style.display="none";
			// elemento.currentStyle.setAttribute('display','none',0);
			// elemento.style.display="none";
		}
	}
	return true;
}

function formCheckAll(checkname) {
	var i;

	if (!checkname || !checkname.length) return false;

	aNodeCollector = document.getElementsByTagName('input');
	if (aNodeCollector) {
		for (i = 0; i < aNodeCollector.length; i++) {
			oNode = aNodeCollector.item(i);
			if (oNode.type == 'checkbox' && oNode.getAttribute('name').substr(0,checkname.length) == checkname ) {
				if (oNode.checked) oNode.checked = false;
				else oNode.checked = true;
			}
		}
	}

	return false;
}

function SeleccionarSession(form_name,element_name) {
	if (!form_name || !element_name) return false;
	window.location = '?__recover_session=' + document.forms[form_name].elements[element_name].value; 
	return false;
}
