
 @%plt:botonera%@

@%if:!esta_vacio;modo_seleccion;%@
<div id="AccionesListado" ><ul>
<li ><a href="#" onClick="return sendForm('bo_articulos');" class="seleccionar" ><img src="imag/pixel.png" class="icono" /><span>Sélectionner</span></a></li>
</ul></div>
@%end-if:%@

<form name="bo_articulos" method="post" 
@%if:esta_vacio;form_target;%@
action="?seccion=@%get:_krn_ss_name;%@"
@%else:%@
action="?seccion=@%get:form_target;%@" 
@%end-if:%@
>

<input type="hidden" name="accion_ejecutar" value="0" />

@%where:tabla|Articulos;nombre|busc;no_results|1;grupo|Articulos.id_articulo;%@
<table class="full">

<thead>
<tr>
@%if:!esta_vacio;modo_seleccion;%@
<td ></td>
@%end-if:%@
<td colspan="3"><a href="?_search_sort=Articulos.nombre" >Nom<img src="imag/pixel.png" class="@%func:class_searchsort;Articulos.nombre;%@" /></a></td>
<td ><a href="?_search_sort=Empresas_articulos.unidades_bulto" >Unités bosse<img src="imag/pixel.png" 
	class="@%func:class_searchsort;Empresas_articulos.unidades_bulto;%@" /></a></td>
<td ><a href="?_search_sort=Tipos_IVA.porcentaje" >% TVA<img src="imag/pixel.png" class="@%func:class_searchsort;Tipos_IVA.porcentaje;%@" /></a></td>
<td colspan="2"><a href="?_search_sort=Empresas_articulos.stock_ficticio" >Stock Estimée<img src="imag/pixel.png" 
	class="@%func:class_searchsort;Empresas_articulos.stock_ficticio;%@" /></a></td>
<td colspan="2">Stoc réel</td>
</tr>
</thead>

<tbody>
<tr>
@%if:!esta_vacio;modo_seleccion;%@
<td class="check">
@%if:esta_vacio;modo_seleccion_varios;%@
<input type="radio" name="selecciones" value="@%db:Articulos.id_articulo;%@" />
@%else:%@
<input type="checkbox" name="selecciones[@%db:Articulos.id_articulo;%@]" value="@%db:Articulos.id_articulo;%@" />
@%end-if:%@
</td>
@%end-if:%@

<td colspan="3">
@%if:AllowedLink;modif_articulos;%@
<a href="?seccion=modif_articulos&id_articulo=@%db:Articulos.id_articulo;%@">@%db:not_empty{Articulos.nombre};%@</a>
@%else:%@
@%db:Articulos.nombre;%@
@%end-if:%@
</td>
<td>@%db:Empresas_articulos.unidades_bulto;%@</td>
<td>@%db:Tipos_IVA.porcentaje;%@</td>
<td colspan="2">@%db:Empresas_articulos.stock_ficticio;%@</td>
<td colspan="2">@%func:cantidad_total%@</td>
</tr>
</tbody>

<thead class="secundario" >
<tr>
<td ><a href="?_search_sort=Articulos.id_articulo" >ID<img src="imag/pixel.png" class="@%func:class_searchsort;Articulos.id_articulo;%@" /></a></td>
<td ><a href="?_search_sort=Marcas.nombre" >Marque<img src="imag/pixel.png" class="@%func:class_searchsort;Marcas.nombre;%@" /></a></td>
<td >Promotion</td>
<td ><a href="?_search_sort=Empresas_articulos.precio_costo" >Prix 1<img src="imag/pixel.png" class="@%func:class_searchsort;Empresas_articulos.precio_costo;%@" /></a></td>
<td ><a href="?_search_sort=Empresas_articulos.precio_standard" >Prix 2<img src="imag/pixel.png" 
	class="@%func:class_searchsort;Empresas_articulos.precio_standard;%@" /></a></td>
<td ><a href="?_search_sort=Empresas_articulos.precio_venta" >Prix 3<img src="imag/pixel.png" class="@%func:class_searchsort;Empresas_articulos.precio_venta;%@" /></a></td>
<td ><a href="?_search_sort=Empresas_articulos.precio_4" >Prix 4<img src="imag/pixel.png" class="@%func:class_searchsort;Empresas_articulos.precio_4;%@" /></a></td>
<td ><a href="?_search_sort=Empresas_articulos.precio_5" >Prix 5<img src="imag/pixel.png" class="@%func:class_searchsort;Empresas_articulos.precio_5;%@" /></a></td>
<td ><a href="?_search_sort=Empresas_articulos.precio_6" >Prix 6<img src="imag/pixel.png" class="@%func:class_searchsort;Empresas_articulos.precio_6;%@" /></a></td>
</tr>
</thead>

<tbody>
<tr>
<td>@%db:Articulos.id_articulo;%@</td>
<td>@%db:Marcas.nombre;%@</td>
<td>@%func:promocion_articulo%@</td>
<td>@%db:Empresas_articulos.precio_costo;%@</td>
<td>@%db:Empresas_articulos.precio_standard;%@</td>
<td>@%db:Empresas_articulos.precio_venta;%@</td>
<td>@%db:Empresas_articulos.precio_4;%@</td>
<td>@%db:Empresas_articulos.precio_5;%@</td>
<td>@%db:Empresas_articulos.precio_6;%@</td>
</tr>
</tbody>
</table>

@%end-where:%@

</form>
@%plt:botonera%@ 

