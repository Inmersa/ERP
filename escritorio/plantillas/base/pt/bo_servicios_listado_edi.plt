
@%plt:botonera%@
 <form name="bo_servicios" action="#" method="post">
 <input type="hidden" name="estado" value="3" />
<table class="full">

<tr>
<td></td>
<td class="caption">Nome</td>
<td class="caption">Duração</td>
<td class="caption">Prazo da Factura</td>
 </tr>
@%where:tabla|Servicios;nombre|busc;no_results|1;%@ 
<!--@%db:Servicios.id_servicio%@-->
<tr><td class="check"><input type="checkbox" name="registro_borrar[@%db:Servicios.id_servicio;%@]" value="1" /></td>
<td class="etiqueta"><a href="?seccion=modif_servicios&id_servicio=@%db:Servicios.id_servicio;%@">@%db:Servicios.nombre;%@</a></td>
<td>@%db:Servicios.duracion;%@ Dias</td>
<td>@%db:Servicios.plazo_factura;%@ Dias</td>
 </tr>
@%end-where:%@


 </table>
</form>
 @%plt:botonera%@
<div class="enviar"><a href="javascript:document.forms['bo_servicios'].submit();">Eliminar Itens Seleccionados</a></div>
