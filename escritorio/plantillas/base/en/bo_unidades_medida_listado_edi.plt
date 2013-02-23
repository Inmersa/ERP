
@%plt:botonera%@

<div id="AccionesListado"><ul>
<li><a href="?seccion=nuevo_unidades_medida" class="nuevo" ><img src="images/pixel.png" class="icono" /><span>New</span></a></li>
<li><a href="#" onClick="return sendForm('modif_unidades_medida');" class="borrar" ><img src="images/pixel.png" class="icono" /><span>Delete selected</span></a></li>
</ul></div>

<table class="full">
<tr>
<td></td>
<td class="caption">Name</td>
<td class="caption">Type</td>
<td class="caption">Caption</td>
<td class="caption">User</td>
</tr>
<form name="modif_unidades_medida" action="" method="post">
<input type="hidden" name="accion" value="BorrarLista" />
@%where:tabla|Unidades_medida;nombre|busc;no_results|1;%@
<tr>
<td class="check"><input type="checkbox" name="registro_borrar[@%db:Unidades_medida.id_unidad_medida;%@]" value="1" /></td>
<td class="etiqueta"><a href="?seccion=modif_unidades_medida&id_unidad_medida=@%db:Unidades_medida.id_unidad_medida;%@">@%db:Unidades_medida.nombre;%@</a></td>
<td ><a href="?seccion=tipos_unidadmedida&ids=@%db:Unidades_medida.id_tipo_unidadmedida;%@">@%db:Tipos_UnidadMedida.nombre;%@</a></td>
<td>@%db:Unidades_medida.leyenda;%@</td>
<td >@%db:si_no_flag{Unidades_medida.user_defined};%@</td>
</tr>
 @%end-where:%@

 </table>
</form>
@%plt:botonera%@


