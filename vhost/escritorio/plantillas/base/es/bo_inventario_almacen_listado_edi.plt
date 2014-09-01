

@%plt:botonera%@

<table class="full">
<thead>
<tr>
<td ><a href="?_search_sort=Localizacion_articulos.id_articulo" 
	>ID<img src="images/pixel.png" class="@%func:class_searchsort;Localizacion_articulos.id_articulo;%@" /></a> </td>
<td ><a href="?_search_sort=Articulos.codigo_barras" >Cod. de barras<img src="images/pixel.png" class="@%func:class_searchsort;Articulos.codigo_barras;%@" /></a> </td>
<td ><a href="?_search_sort=Empresas_articulos.referencia" 
	>Referencia<img src="images/pixel.png" class="@%func:class_searchsort;Empresas_articulos.referencia;%@" /></a></td>
<td ><a href="?_search_sort=Articulos.nombre" >Nombre art�culo<img src="images/pixel.png" class="@%func:class_searchsort;Articulos.nombre;%@" /></a> </td>
<td ><a href="?_search_sort=Marcas.nombre" >Marca<img src="images/pixel.png" class="@%func:class_searchsort;Marcas.nombre;%@" /></a> </td>
<td ><a href="?_search_sort=cantidad" >Stock<img src="images/pixel.png" class="@%func:class_searchsort;cantidad;%@" /></a></td>
<td ><a href="?_search_sort=caducidad" >Fecha caducidad menor<img src="images/pixel.png" class="@%func:class_searchsort;caducidad;%@" /></a></td>
<td ><a href="?_search_sort=caducidad_mayor" >Fecha Caducidad Mayor<img src="images/pixel.png" class="@%func:class_searchsort;caducidad_mayor;%@" /></a></td>
<td ><a href="?_search_sort=valor" >Valor<img src="images/pixel.png" class="@%func:class_searchsort;valor;%@" /></a></td>
</tr></thead>
@%where:tabla|Localizacion_articulos;nombre|busc;no_results|1;contador|i;%@

@%if:esta_vacio;st[id_alml];%@
	<!-- @%set:_var_x = Almacenes_logicos.nombre;%@ -->
	@%if:cambia_var_x;%@
	<thead class="secundario" ><tr><td colspan="5">Zona: @%db:Almacenes_logicos.nombre;%@</td>
	   @%if:!esta_vacio;st[precio];%@
		   <!-- @%set:totalizar_cond_campo[]=Localizacion_articulos,id_almacen_logico;%@ @%set:totalizar_cond_valor[]=Localizacion_articulos.id_almacen_logico;%@ -->
		   @%where:nodb|nodb_totalizar;nombre|TotalZona%@
			<td colspan="3" >@%db:nombre_campo;%@</td><td colspan="1" >@%db:lcmon{valor_campo};%@</td>
		   @%end-where:%@

	   @%else:%@
		   <td colspan="2" ></td>
	   @%end-if:%@

	</tr></thead><tbody>
	@%end-if:%@
@%else:%@
	@%if:equals;i;1;%@
	<tbody>
	@%end-if:%@
@%end-if:%@

<tr
@%if:!esta_vacio;Empresas_articulos.fecha_baja;%@
class="impropio"
@%end-if:%@
>
<td><a href="?seccion=bo_localizacion_articulos&id_articulo=@%db:Localizacion_articulos.id_articulo;%@">@%db:Localizacion_articulos.id_articulo;%@</a></td>
<td>@%db:Articulos.codigo_barras;%@</td>
<td>@%db:Empresas_articulos.referencia;%@</td>
<td><a href="?seccion=bo_localizacion_articulos&id_articulo=@%db:Localizacion_articulos.id_articulo;%@">@%db:Articulos.nombre;%@</a></td>
<td>@%db:Marcas.nombre;%@</td>
<td>@%db:cantidad;%@</td>
<td>@%db:colocar_fecha{caducidad};%@</td>
<td>@%db:colocar_fecha{caducidad_mayor};%@</td>
<td>@%db:valor;%@</td>
</tr>

@%end-where:%@

</tbody> 
</table>

@%plt:botonera%@


