@%plt:botonera%@

 <form name="bo_almacenes_importar" method="post" action="">
<table class="full">
<tr>
<td></td>
<td class="caption">Nombre</td>
<td class="caption">Teléfono</td>
<td class="caption">e-mail</td>
<td class="caption">Persona de contacto</td>
</tr>

@%where:tabla|Almacenes;nombre|busc;no_results|1;%@
<tr><td class="check"><input type="checkbox" name="importar_almacenes[@%db:Almacenes.id_almacen;%@]" value="1" /></td>
<td class="etiqueta"> <a href="?seccion=modif_almacenes&id_almacen=@%db:Almacenes.id_almacen;%@">@%db:Almacenes.nombre;%@</a></td>
<td>@%db:Almacenes.telefono;%@</td>
<td>@%db:Almacenes.email;%@</td>
<td>@%db:Almacenes.persona_contacto;%@ (@%db:Almacenes.cargo_persona_contacto;%@)</td>
</tr>
@%end-where:%@


</table>
@%plt:botonera%@
<div class="enviar"><a href="javascript:document.forms['bo_almacenes_importar'].submit();">Importar</a></div>
</form>


