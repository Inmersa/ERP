
@%plt:botonera%@

<form name="composicion_articulos" action="?seccion=modif_articulos" method="post">
<input type="hidden" name="accion_ejecutar" value="Modificar" />
<table class="full">
<thead>
<tr>
<td></td>
<td >Amount</td>
<td ><a href="?_search_sort=Articulos.nombre" >Name<img src="images/pixel.png" class="@%func:class_searchsort;Articulos.nombre;%@" /></a></td>
<td ><a href="?_search_sort=Marcas.nombre" >Brand<img src="images/pixel.png" class="@%func:class_searchsort;Marcas.nombre;%@" /></a></td>
<td ><a href="?_search_sort=Familia_articulos.nombre" >Products Family<img src="images/pixel.png" class="@%func:class_searchsort;Familia_articulos.nombre;%@" /></a></td>
<td ><a href="?_search_sort=Empresas_articulos.fecha_alta" 
	>Register date<img src="images/pixel.png" class="@%func:class_searchsort;Empresas_articulos.fecha_alta;%@" /></a></td>
<td ><a href="?_search_sort=Empresas_articulos.stock_ficticio" 
	>E. Stock<img src="images/pixel.png" class="@%func:class_searchsort;Empresas_articulos.stock_ficticio;%@" /></a></td>
</tr>
</thead>
<tbody>
@%where:tabla|Articulos;nombre|busc;no_results|1;%@
<tr >
<td class="check"><input type="checkbox" name="composicion_articulos[@%db:Articulos.id_articulo;%@]" value="1" /></td>
<td> 
@%if:!composicion_articulo;%@ 
<input type="text" name="registro3[@%db:Articulos.id_articulo;%@][unidades]" value="0" class="cantidad" />
<input type="hidden" name="registro3[@%db:Articulos.id_articulo;%@][id_unidad_medida]" value="@%db:Articulos.id_unidad_medida;%@" />
@%end-if:%@ 
</td>
<td class="etiqueta"><a href="?seccion=modif_articulos&id_articulo=@%db:Articulos.id_articulo;%@">@%db:Articulos.nombre;%@</a></td>
<td>@%db:Marcas.nombre;%@</td>
<td>@%db:Familia_articulos.nombre;%@</td>
<td>@%db:colocar_fecha{Empresas_articulos.fecha_alta};%@</td>
<td>@%db:Empresas_articulos.stock_ficticio;%@</td>
</tr>
 @%end-where:%@

</tbody></table>
</form>
 @%plt:botonera%@

<div class="AccionesEnvio"><ul>
<li><a href="#" onclick="return onHRefClick('composicion_articulos','accion_ejecutar','Modificar');" class="guardar" 
	><img src="images/pixel.png" class="icono" /><span>Modify Composition</span></a></li>
</ul></div>
 
