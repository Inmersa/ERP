
@%plt:botonera%@
 <form name="bo_servicios" action="#" method="post">
 <input type="hidden" name="estado" value="3" />
<table class="full">

<tr>
<td></td>
<td class="caption">Name</td>
<td class="caption">Length</td>
<td class="caption">Invoice period</td>
 </tr>
@%where:tabla|Servicios;nombre|busc;no_results|1;%@ 
<!--@%db:Servicios.id_servicio%@-->
<tr><td class="check"><input type="checkbox" name="registro_borrar[@%db:Servicios.id_servicio;%@]" value="1" /></td>
<td class="etiqueta"><a href="?seccion=modif_servicios&id_servicio=@%db:Servicios.id_servicio;%@">@%db:Servicios.nombre;%@</a></td>
<td>@%db:Servicios.duracion;%@ Days</td>
<td>@%db:Servicios.plazo_factura;%@ Days</td>
 </tr>
@%end-where:%@


 </table>
</form>
 @%plt:botonera%@
<div class="enviar"><a href="javascript:document.forms['bo_servicios'].submit();">Delete selected</a></div>
