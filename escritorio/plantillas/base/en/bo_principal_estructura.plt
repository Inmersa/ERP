
<form name="sessionids" action="?@%get:_krn_ss_querystring;%@" method="post" >
Sessions
<select name="sessid" >
@%where:nodb|_nodb_session_list;contador|i;%@
@%if:esta_vacio;sessid;%@
<option value="" >None</option>
@%else:%@
<option value="@%db:sessid;%@" 
@%if:!esta_vacio;ignore_link;%@
selected="selected"
@%end-if:%@
>@%db:nombre;%@ @%db:colocar_fecha{alta};%@</option>
@%end-if:%@
@%end-where:@

</select>
<a href="#" onClick="return SeleccionarSession('sessionids','sessid');" >To use</a>
<a href="?__create_session=1" >New</a>
</form>

<div>
@%plt:cabecera%@ 
</div>

<div id="MenuHorizontal">
@%plt:menu%@ 
</div>

<div id="BuscadorGeneral">
@%plt:buscador%@
</div>

<div id="cuerpo">
<div id="contenido" class="IconosYTexto" >
@%plt:bo_seccion%@ 
</div>
</div>
@%plt:mensajero%@

