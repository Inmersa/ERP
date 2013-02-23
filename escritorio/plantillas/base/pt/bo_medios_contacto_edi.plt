
@%plt:botonera%@
<form name="modif_medios_contacto" action="" method="post">
<input type="hidden" name="estado" value="3" />
<table class="full">
<tr>
<td></td>
<td class="caption">Nome</td>
<td class="caption">Descrição</td>
</tr>
@%where:tabla|Medios_contacto;nombre|busc;no_results|1;%@
<tr>
<td class="check"><input type="checkbox" name="registro_borrar[@%db:Medios_contacto.id_medio_cto;%@]" value="1" /></td>
<td ><a href="?seccion=modif_medios_contacto&id_medio_cto=@%db:Medios_contacto.id_medio_cto;%@">@%db:Medios_contacto.nombre;%@</a></td>
<td >@%db:Medios_contacto.descripcion;%@</td>
</tr>
@%end-where:%@

</table>
</form>
@%plt:botonera%@
<div class="enviar"><a href="#" onClick="return sendForm('modif_medios_contacto');">Eliminar Itens Seleccionados</a></div>
