
 @%plt:botonera%@

@%where:tabla|Articulos;nombre|busc;no_results|1;grupo|Articulos.id_articulo;cfunc|cf_escritorios;%@
<table class="full">

<thead>
<tr>
<td colspan="2" ><a href="?_search_sort=Articulos.nombre" >Nom<img src="imag/pixel.png" class="@%func:class_searchsort;Articulos.nombre;%@" /></a></td>
<td >Prix</td>
<td >Prix de vente Rec.</td>
<td >Stock Estim�e</td>
<td ><a href="?_search_sort=Tipos_IVA.porcentaje" >% TVA<img src="imag/pixel.png" class="@%func:class_searchsort;Tipos_IVA.porcentaje;%@" /></a></td>
</tr>
</thead>

<tbody>
<tr>
<td colspan="2" >
@%if:AllowedLink;modif_articulos;%@
<a href="?seccion=modif_articulos&id_articulo=@%db:Articulos.id_articulo;%@">@%db:not_empty{Articulos.nombre};%@</a>
@%else:%@
@%db:Articulos.nombre;%@
@%end-if:%@
</td>
<td>@%db:precio_tarifa;%@</td>
<td>@%db:precio_recomendado;%@</td>
<td >@%db:Empresas_articulos.stock_ficticio;%@</td>
<td>@%db:Tipos_IVA.porcentaje;%@</td>
</tr>
</tbody>

<thead class="secundario">
<tr>
<td ><a href="?_search_sort=Articulos.id_articulo" >ID<img src="imag/pixel.png" class="@%func:class_searchsort;Articulos.id_articulo;%@" /></a></td>
<td ><a href="?_search_sort=Familia_articulos.nombre" >Famille<img src="imag/pixel.png" class="@%func:class_searchsort;Familia_articulos.nombre;%@" /></a></td>
<td ><a href="?_search_sort=Marcas.nombre" >Marque<img src="imag/pixel.png" class="@%func:class_searchsort;Marcas.nombre;%@" /></a></td>
<td ><a href="?_search_sort=Empresas_articulos.unidades_bulto" >Unit�s bosse<img src="imag/pixel.png" class="@%func:class_searchsort;Empresas_articulos.unidades_bulto;%@" /></a></td>
<td colspan="2" >Promotion</td>
</tr>
</thead>

<tbody>
<tr>
<td>@%db:Articulos.id_articulo;%@</td>
<td >@%db:Familia_articulos.nombre;%@</td>
<td >@%db:Marcas.nombre;%@</td>
<td>@%db:Empresas_articulos.unidades_bulto;%@</td>
<td colspan="2" >@%func:promocion_articulo%@</td>
</tr>
</tbody>

</table>

@%end-where:%@

@%plt:botonera%@ 

