
@%plt:botonera%@

<form name="modif_series_facturacion" action="#" method="post">
<input type="hidden" name="estado" value="3" />

<table class="full">
<thead><tr>
<td ><a href="?_search_sort=Series_facturacion.nombre" class="order" >Nom<img src="imag/pixel.png" 
	class="@%func:class_searchsort;Series_facturacion.nombre;%@" /></a></td>
<td ><a href="?_search_sort=Series_facturacion.descripcion" class="order" >Description<img src="imag/pixel.png" 
	class="@%func:class_searchsort;Series_facturacion.descripcion;%@" /></a></td>
<td ><a href="?_search_sort=Series_facturacion.contador" class="order" >Compteurs<img src="imag/pixel.png" 
	class="@%func:class_searchsort;Series_facturacion.contador;%@" /></a></td>
<td ><a href="?_search_sort=Series_facturacion.ventas" class="order" >de<img src="imag/pixel.png" 
	class="@%func:class_searchsort;Series_facturacion.ventas;%@" /></a></td>
</tr></thead>
<tbody>
@%where:tabla|Series_facturacion;nombre|busc;%@
<tr>
<td class="etiqueta">
@%if:AllowedLink;modif_series_facturacion;%@
<a href="?seccion=modif_series_facturacion&id_serie=@%db:Series_facturacion.id_serie;%@">@%db:Series_facturacion.nombre;%@ </a>
@%else:%@
@%db:Series_facturacion.nombre;%@
@%end-if:%@
</td>
<td>@%db:Series_facturacion.descripcion;%@ </td>
<td>@%db:Series_facturacion.contador;%@</td>
<td>
@%if:esta_vacio;Series_facturacion.ventas;%@
D'achats
@%else:%@
En vente
@%end-if:%@
</td>
</tr>
@%end-where:%@

</tbody></table>
</form>

@%plt:botonera%@

