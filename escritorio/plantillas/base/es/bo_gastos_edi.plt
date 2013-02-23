@%plt:botonera%@
<table class="full">
<tr>
<td></td>
<td class="caption">Nombre</td>
<td class="caption">Descripción</td>
</tr>
 <form name="modif_gastos" action="#" method="post">
 <input type="hidden" name="estado" value="3" />
 @%where:tabla|Gastos;nombre|busc;no_results|1;%@
<tr>
<td class="check"><input type="checkbox" name="registro_borrar[@%db:Gastos.id_gasto;%@]" value="1" /></td>
<td><a href="?seccion=modif_gastos&id_gasto=@%db:Gastos.id_gasto;%@">@%db:Gastos.nombre;%@</a></td>
<td>@%db:Gastos.descripcion;%@</td>
</tr>
@%end-where:%@
 
</table>
</form>
@%plt:botonera%@
<div class="enviar"><a href="#" onClick="return sendForm('modif_gastos');">Borrar seleccionados</a></div>

