<fieldset class="fsficha">
<legend>Recursos Artículos</legend>

<table class="full">
<thead>
<tr>
<td >Nombre</td>
<td >Tipo</td>
<td >Descripcción</td>
</tr>
</thead>
<tbody>
@%where:tabla|Articulos_recursos;where|Articulos_recursos.id_articulo = $id_articulo AND Articulos_recursos.id_empresa = $id_empresa;nolink|1;%@
<tr>
<td>
@%if:AllowedLink;ficha_recurso;%@
<a href="?seccion=ficha_recurso&id=@%db:Articulos_recursos.id_recurso;%@">@%db:Recursos.nombre;%@</a>
@%else:%@
@%db:Recursos.nombre;%@
@%end-if:%@
</td>
<td>@%db:Tipos_recurso.nombre;%@</td>
<td>@%db:Articulos_recursos.descripcion;%@</td>
</tr>
@%end-where:%@

</tbody>
</table>
</fieldset>
 
