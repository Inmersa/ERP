@%plt:botonera%@

<table class="full">
<tr>
<td></td>
<td class="caption">Type</td>
<td class="caption">Description</td>
<td class="caption">TVA</td>
<td class="caption">Reteneu équivalent </td>
 </tr>

 <form name="modif_tipo_cliente" action="" method="post">
 <input type="hidden" name="estado" value="3" />
@%where:tabla|Tipo_cliente;nombre|busc;%@ 
<tr>
<td class="check"><input type="checkbox" name="registro_borrar[@%db:Tipo_cliente.id_tipo_cliente;%@]" value="1" /></td>
<td class="etiqueta"><a href="?seccion=modif_tipo_cliente&id_tipo_cliente=@%db:Tipo_cliente.id_tipo_cliente;%@">@%db:Tipo_cliente.nombre;%@</a></td>
<td>@%db:Tipo_cliente.descripcion;%@</td>
<td>@%db:Tipo_cliente.aplicar_iva%@</td>
<td>@%db:Tipo_cliente.aplicar_recargo%@</td>
</tr>
@%end-where:%@

</table>
</form>
@%plt:botonera%@
<div class="enviar"><a href="javascript:document.forms['modif_tipo_cliente'].submit();">Elimier</a></div>
