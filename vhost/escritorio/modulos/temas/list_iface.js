

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
 nuevo.moveTo(140,140);
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

function sendForm(form) {
	document.forms[form].submit();
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

function SendFormToWindow(form_name,action,target,width,height,bClose) {
	options = 'menubar=1,scrollbars=1';
	if (width) options += ',width='+width;
	if (height) options += ',height='+height;
	if (action) document.forms[form_name].action = '?seccion='+action;
	if (target) {
		document.forms[form_name].target = target;
 		var nuevo = window.open('',target,options);
	}
	if (bClose) {
		nuevo.onunload = nuevo.close;
	}

	this.window.focus();
	document.forms[form_name].submit();
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
