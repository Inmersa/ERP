<fieldset class="fsficha">
<legend>Composició</legend>

<table class="full">
<thead>
<tr>
<td >Nom</td>
<td >Quantitat</td>
</tr>
</thead>
<tbody>
@%where:tabla|Articulos_articulos;where|Articulos_articulos.id_articulo = $id_articulo;nolink|1;%@
<tr>
<td><a href="?seccion=modif_articulos&id_articulo=@%db:Articulos_articulos.id_materia_prima;%@">
@%where:tabla|Articulos;%@
@%db:Articulos.nombre%@
@%end-where:%@

</a></td>
<td>@%db:Articulos_articulos.unidades;%@</td>
</tr>
@%end-where:%@

</tbody>
</table>
</fieldset>
 
