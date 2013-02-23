<HTML>
<HEAD>
<TITLE>{{bo_hacer_tic{{bo_hacer_ticket_codbarras.plt58}}et_codbarras.plt0}}</TITLE>
<link rel="SHORTCUT ICON" href="imag/imagotipo.gif">
<META http-equiv="Content-Script-Type" content="text/javascript">
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript" >
var cerrando = 1;

function onHRefClick(form,element,value,action)
{
// alert(document.forms[form].action);
//alert ( document.forms[form].elements[element].name + document.forms[0].elements[0].value );
if (element && value) document.forms[form].elements[element].value = value;
if (action) document.forms[form].action = '?seccion=' + action;
 //alert ( document.forms[form].action + " -- " + document.forms[form].elements[element].name + " -- " + document.forms[form].elements[element].value );
document.forms[form].submit();
return false;
}

function sendForm(form) {
document.forms[form].submit();
cerrando = 0;
return false;
}

function SendFormToWindow(form,action,target) {
if (action) document.forms[form].action = '?seccion='+action;
if (target) document.forms[form].target = target;
document.forms[form].submit();
this.window.focus();
return false;
}

function ReloadOnClose() {
// alert('Es :'+cerrando);
if (cerrando) {
window.opener.location = window.opener.location;
}
}

function keypress_codigobarras(obj,keycode) {
if (obj.value.length==0) {
if (keycode == 13) {
enfoca('cantidad');
return;
}
} sendFormEnfocaOnIntro(keycode,1,'codbarras');
}

function sendFormEnfocaOnIntro(k,send,where) {
if (k == 13) {
cerrando = 0;
if (send) {
sendForm(where);
} else enfoca(where);
} else {
if (k == 9) {
if (!send) enfoca(where);
} else {
//alert(k);
}
}
}

function enfoca(nombre) {
var cb = document.getElementById(nombre);
// alert(cb.name);
cb.focus();
}

// window.close = ReloadOnClose;
// document.onkeydown = tst; 
</SCRIPT>

</SCRIPT>
<link rel="stylesheet" href="estilos.css" type="text/css" />
</HEAD>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="8" topmargin="5" marginwidth="5" marginheight="5" onUnload="ReloadOnClose();" onload="enfoca('codigo_barras');">

<table border="0" cellpadding="0" cellspacing="0" width="90%"
summary="This table charts the number of cups of coffee consumed by each senator, the type of coffee (decaf or regular), and whether taken with sugar.">
<CAPTION class="etiqueta">{{bo_hacer_ticket_codbarras.plt67}}</CAPTION>
<TR>
<TH>Article</TH>
<TH>EAN 13</TH>
</TR>
<tr><td class="texto">
@%get:nombre_articulo;%@
</td><td class="texto">
@%get:codigo_barras;%@
</td></tr>
<tr><td colspan="2" height="22"></tr>
</table>

<form name="codbarras" method="post" action="?seccion=hacer_ticket_codbarras">
<table border="0" cellpadding="0" cellspacint="0">
<tr><td class="etiqueta">
<input type="hidden" name="accion_ejecutar" value="mas">
<LABEL for="codigo_barras" >Code-barres:</LABEL>
<input type="text" size="13" maxlength="14" name="reg[cod_barras]" class="insertext" tabindex="1" id="codigo_barras"
onChange="sendForm('codbarras');" onKeyPress="keypress_codigobarras(this,event.keyCode);">
</td><td class="etiqueta">
<LABEL for="cantidad" >Quantite:</LABEL>
<input type="text" size="6" name="reg[cantidad]" class="insertext" value="1" tabindex="2" id="cantidad"
onFocus="this.select();" onChange="enfoca('codigo_barras');" onKeyPress="sendFormEnfocaOnIntro(event.keyCode,0,'codigo_barras');"
>
</td></tr>
<tr><td align="center">
<a href="javascript: sendForm('codbarras');" class="">Accepter</a><br>
</td><td align="center">
<a href="javascript: onHRefClick('codbarras','accion_ejecutar','Actualizar');" class="">Actualiser</a><br>
</td></tr>
</table>

</form>

</HTML>
