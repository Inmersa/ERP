
@%plt:botonera%@

<div id="AccionesListado">
<ul>
@%if:AllowedLink;nuevo_marcas;%@
<li><a href="?seccion=nuevo_marcas" class="nuevo" ><img src="images/pixel.png" class="icono" /><span>Nuevo</span></a></li>
@%end-if:%@
<li><a href="#" onClick="return sendForm('modif_marcas');" class="borrar" ><img src="images/pixel.png" class="icono" /><span>Borrar seleccionados</span></a></li>
</ul></div>

<form name="modif_marcas" action="#" method="post">
<input type="hidden" name="estado" value="3" />
<table class="full">
<thead><tr>
<td></td>
<td ><a href="?_search_sort=Marcas.nombre" class="order" >Nombre<img src="images/pixel.png" class="@%func:class_searchsort;Marcas.nombre;%@" /></a></td>
<td ><a href="?_search_sort=Marcas.observaciones" class="order" >Observaciones<img src="images/pixel.png" class="@%func:class_searchsort;Marcas.observaciones;%@" /></a></td>
</tr></thead>
<tbody>
@%where:tabla|Marcas;nombre|busc;%@
<tr>
<td class="check"><input type="checkbox" name="registro_borrar[@%db:Marcas.id_marca;%@]" value="1" /></td>
<td class="etiqueta"><a href="?seccion=modif_marcas&id_marca=@%db:Marcas.id_marca;%@">@%db:Marcas.nombre;%@</a></td>
<td>@%db:Marcas.observaciones;%@ </td>
</tr>
@%end-where:%@

</tbody></table>
</form>
@%plt:botonera%@

