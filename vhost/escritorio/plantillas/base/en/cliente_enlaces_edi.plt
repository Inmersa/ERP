
<fieldset class="fsficha">
<legend>Client Links</legend>

<div class="AccionesFicha">
<ul>

@%if:AllowedAction;Cliente_enlaces;new;%@
<li><a href="?seccion=nuevo_enlace_interes" class="nuevo" ><img src="images/pixel.png" class="icono" /><span>New</span></a></li>
@%end-if:%@

@%if:AllowedAction;Cliente_enlaces;del;%@
<li><a href="#" onClick="return onHRefClick('modif_clientes','accion_ejecutar','BorrarEnlaces');" class="borrar" 
	><img src="images/pixel.png" class="icono" /><span>Delete selected</span></a></li>
@%end-if:%@
</ul>
</div>

<table class="full">
@%where:tabla|Cliente_enlaces;where|Cliente_enlaces.id_cliente = $id_cliente;order|Cliente_enlaces.nombre;%@
<tr>
@%if:AllowedAction;Cliente_enlaces;del;%@
<td class="check"><input type="checkbox" name="cliente_enlaces[@%db:Cliente_enlaces.id_enlace%@][id_enlace]" value="@%db:Cliente_enlaces.id_enlace;%@"> </td>
@%end-if:%@
<td>
@%if:AllowedAction;Cliente_enlaces;edit;%@
<a href="?seccion=ficha_enlace_interes&amp;id=@%db:Cliente_enlaces.id_enlace%@" 
	>@%db:Cliente_enlaces.nombre%@</a>
@%else:%@
@%db:Cliente_enlaces.nombre%@ 
@%end-if:%@
</td>
<td>
@%if:esta_vacio;Cliente_enlaces.url;%@
@%else:%@
<a href="http://@%db:Cliente_enlaces.url;%@" onClick="return !window.open('http://@%db:Cliente_enlaces.url%@');" >@%db:Cliente_enlaces.url;%@</a>
@%end-if:%@
</td>
</tr>
@%if:esta_vacio;Cliente_enlaces.descripcion;%@
@%else:%@
<tr><td colspan="3" >@%db:Cliente_enlaces.descripcion;%@</td></tr>
@%end-if:%@
@%end-where:%@

</table>
</fieldset>

