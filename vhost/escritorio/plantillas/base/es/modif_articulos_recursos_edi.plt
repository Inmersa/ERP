<fieldset class="fsficha">
<legend>Recursos Artículos</legend>
<div class="AccionesFicha"><ul>
@%if:AllowedLink;recursos;%@
	@%if:AllowedAction;Articulos_recursos;new;%@
	<li><a href="?seccion=recursos&modo_seleccion=1&many=1" class="asociar"><img src="imag/pixel.png" class="icono" /><span>Añadir Recurso</span></a></li>
	@%end-if:%@
@%end-if:%@
@%if:AllowedAction;Articulos_recursos;del;%@
<li><a href="#" onClick="return onHRefClick('modif_articulos','accion_ejecutar','BorrarRecursos');" class="borrar" 
	><img src="imag/pixel.png" class="icono" /><span>Descartar Seleccionados</span></a></li>
@%set:permitir_selecciones=1;%@
@%end-if:%@
</ul></div>

<table class="full">
<thead>
<tr>
<td></td>
<td >Nombre</td>
<td >Tipo</td>
<td >Descripcción</td>
</tr>
</thead>
@%where:tabla|Articulos_recursos;where|Articulos_recursos.id_articulo = $id_articulo_promocion AND Articulos_recursos.id_empresa = $id_empresa;nolink|1;%@
<tr>
@%if:esta_vacio;permitir_selecciones;%@
<td></td>
@%else:%@
<td class="check"><input type="checkbox" name="articulos_recursos[@%db:Articulos_recursos.id_recurso;%@][id_recurso]" value="@%db:Recursos.id_recurso;%@" /></td>
@%end-if:%@
<td><a href="?seccion=ficha_recurso&id=@%db:Articulos_recursos.id_recurso;%@">@%db:Recursos.nombre;%@</a></td>
<td>@%db:Tipos_recurso.nombre;%@</td>
<td><textarea name="articulos_recursos[@%db:Articulos_recursos.id_recurso;%@][descripcion]" rows="5" cols="80" >@%db:Articulos_recursos.descripcion;%@</textarea></td>
</tr>
@%end-where:%@

</table>
</fieldset>
 
