
@%plt:botonera%@
 <form name="bo_servicios" action="#" method="post">
 <input type="hidden" name="estado" value="3" />
<table class="full">

<tr>
<td></td>
<td class="caption">Nombre</td>
<td class="caption">Duraci�n</td>
<td class="caption">Plazo de factura</td>
 </tr>
@%where:tabla|Servicios;nombre|busc;no_results|1;%@ 
<!--@%db:Servicios.id_servicio%@-->
<tr><td class="check"><input type="checkbox" name="registro_borrar[@%db:Servicios.id_servicio;%@]" value="1" /></td>
<td class="etiqueta"><a href="?seccion=modif_servicios&id_servicio=@%db:Servicios.id_servicio;%@">@%db:Servicios.nombre;%@</a></td>
<td>@%db:Servicios.duracion;%@ D�as</td>
<td>@%db:Servicios.plazo_factura;%@ D�as</td>
 </tr>
@%end-where:%@


 </table>
</form>
 @%plt:botonera%@
<div class="enviar"><a href="javascript:document.forms['bo_servicios'].submit();">Borrar seleccionados</a></div>
