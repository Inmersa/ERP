
@%plt:botonera%@
<table class="full">

<tr>
<td></td>
<td class="caption">Nombre</td>
<td class="caption">Descripción</td>
 </tr>
<form name="modif_tipo_agente" action="#" method="post">
 <input type="hidden" name="estado" value="3" />
 @%where:tabla|Tipo_agente;nombre|busc;%@
<tr>
<td class="check"><input type="checkbox" name="registro_borrar[@%db:Tipo_agente.id_tipo_agente;%@]" value="1" /></td>
<td class="etiqueta"> <a href="?seccion=modif_tipo_agente&id_tipo_agente=@%db:Tipo_agente.id_tipo_agente;%@">@%db:Tipo_agente.nombre;%@</a></td>
<td>@%db:Tipo_agente.descripcion;%@</td>
 </tr>
 @%end-where:%@

</form>
 </table>
 @%plt:botonera%@
<div class="enviar"><a href="javascript:document.forms['modif_tipo_agente'].submit();">Borrar seleccionados</a></div>
