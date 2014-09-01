<fieldset class="fsficha">
<legend>Composição</legend>

<div class="AccionesFicha"><ul>
@%if:AllowedLink;bo_composicion_articulos;%@
	@%if:AllowedAction;Articulos_articulos;new;%@
	<li><a href="?seccion=bo_composicion_articulos" class="nuevo" ><img src="imag/pixel.png" class="icono" /><span>Adicionar Produto</span></a></li></td>
	@%end-if:%@
@%end-if:%@
@%if:AllowedAction;Articulos_articulos;del;%@
<li><a href="#" onClick="return onHRefClick('modif_articulos','accion_ejecutar','Borrar');" class="borrar" ><img src="imag/pixel.png" class="icono" /><span>Eliminar Itens Seleccionados</span></a></li>
@%set:permitir_selecciones=1;%@
@%end-if:%@
</ul></div>

<table class="full">
<thead>
<tr>
<td></td>
<td >Nome</td>
<td >Quantidade</td>
</tr>
</thead>
<tbody>
@%where:tabla|Articulos_articulos;where|Articulos_articulos.id_articulo = $id_articulo_promocion;nolink|1;%@
<tr>
@%if:esta_vacio;permitir_selecciones;%@
<td></td>
@%else:%@
<td class="check"><input type="checkbox" name="borrar_composicion[@%db:Articulos_articulos.id_materia_prima;%@]" value="1" /></td>
@%end-if:%@

@%where:tabla|Articulos;%@
<input type="hidden" name="registro3[@%db:Articulos.id_articulo;%@][id_unidad_medida]" value="@%db:Articulos.id_unidad_medida;%@" />
<td><a href="?seccion=modif_articulos&id_articulo=@%db:Articulos_articulos.id_materia_prima;%@">@%db:Articulos.nombre%@</a></td>
<td><input type="text" name="registro3[@%db:Articulos_articulos.id_materia_prima;%@][unidades]" value="@%db:Articulos_articulos.unidades;%@" class="cantidad" /></td>
@%end-where:%@

</tr>
@%end-where:%@

</tbody>
</table>
</fieldset>
 
