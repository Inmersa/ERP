
@%plt:botonera%@

<div id="AccionesListado"><ul>
@%if:AllowedLink;bo_importar_articulos_proveedor;%@
<li><a href="?seccion=bo_importar_articulos_proveedor" class="seleccionar" ><img src="images/pixel.png" class="icono" /><span>Recuperar Articles</span></a></li>
@%end-if:%@
<li><a href="" onclick="return onHRefClick('compra_articulos_proveedor','accion_ejecutar','Borrar');" class="borrar" 
	><img src="images/pixel.png" class="icono" /><span>Esborrar seleccionats</span></a></li>
</ul></div>

<form name="compra_articulos_proveedor" method="post" action="?seccion=@%get:_krn_ss_name;%@">
<input type="hidden" name="accion_ejecutar" value="j" />

<table class="full">
<thead>
<tr>
<td ><a href="?_search_sort=Empresas_articulos.referencia" class="order" 
	>Refer�ncia<img src="images/pixel.png" class="@%func:class_searchsort;Empresas_articulos.referencia;%@" /></a></td>
<td ><a href="?_search_sort=Compra_articulos.referencia" class="order" 
	>Ref. Prove�dor<img src="images/pixel.png" class="@%func:class_searchsort;Compra_articulos.referencia;%@" /></a></td>
<td class="estado" ><img src="images/pixel.png" class="marcartodos" onclick="return formCheckAll('proovedores_articulo_borrar');"  /></td>
<td ><a href="?_search_sort=Compra_articulos.id_articulo" class="order" 
	>IDs<img src="images/pixel.png" class="@%func:class_searchsort;Compra_articulos.id_articulo;%@" /></a></td>
<td ><a href="?_search_sort=Articulos.nombre" class="order" >Nom d�article<img src="images/pixel.png" class="@%func:class_searchsort;Articulos.nombre;%@" /></a></td>
<td ><a href="?_search_sort=Compra_articulos.PVP_oficial" class="order" 
	>Preu<img src="images/pixel.png" class="@%func:class_searchsort;Compra_articulos.PVP_oficial;%@" /></a></td>
<td ><a href="?_search_sort=Compra_articulos.PV_oficial" class="order" 
	>Preu Reven.<img src="images/pixel.png" class="@%func:class_searchsort;Compra_articulos.PV_oficial;%@" /></a></td>
<td ><a href="?_search_sort=Compra_articulos.precio" class="order" 
	>Preu<img src="images/pixel.png" class="@%func:class_searchsort;Compra_articulos.precio;%@" /></a></td>
<td ><a href="?_search_sort=Compra_articulos.descuento" class="order" 
	>Desc. %<img src="images/pixel.png" class="@%func:class_searchsort;Compra_articulos.descuento;%@" /></a></td>
<td ><a href="?_search_sort=Compra_articulos.dto_vol" class="order" 
	>Descomptes per volum<img src="images/pixel.png" class="@%func:class_searchsort;Compra_articulos.dto_vol;%@" /></a></td>
<td ><a href="?_search_sort=Compra_articulos.fabricante" class="order" 
	>Fabricat<img src="images/pixel.png" class="@%func:class_searchsort;Compra_articulos.fabricante;%@" /></a></td>
</tr>
</thead>
<tbody>
@%where:tabla|Compra_articulos;nombre|busc;no_results|1;cfunc|cf_almacenar_articulos;%@
<tr
@%if:!esta_vacio;Empresas_articulos.fecha_baja;%@
class="impropio"
@%end-if:%@
>
<td>@%db:Empresas_articulos.referencia;%@</td>
<td><input type="text" name="articulos_proveedor[@%db:Compra_articulos.id_articulo;%@][referencia]" value="@%db:Compra_articulos.referencia;%@" size="10" /></td>
<td class="check"><input type="checkbox" name="proovedores_articulo_borrar[@%db:Compra_articulos.id_articulo%@]" value="1" /></td>
<td>@%db:Compra_articulos.id_articulo;%@</td>
<td><a href="?seccion=modif_articulos&id_articulo=@%db:Compra_articulos.id_articulo%@">@%db:Articulos.nombre;%@</a></td>

<td><input type="text" name="articulos_proveedor[@%db:Compra_articulos.id_articulo;%@][PVP_oficial]" size="5" value="@%db:Compra_articulos.PVP_oficial;%@" /></td>
<td><input type="text" name="articulos_proveedor[@%db:Compra_articulos.id_articulo;%@][PV_oficial]" size="5" value="@%db:Compra_articulos.PV_oficial;%@" /></td>
<td><input type="text" name="articulos_proveedor[@%db:Compra_articulos.id_articulo;%@][precio]" size="5" value="@%db:Compra_articulos.precio;%@" /></td>
<td><input type="text" name="articulos_proveedor[@%db:Compra_articulos.id_articulo;%@][descuento]" value="@%db:Compra_articulos.descuento;%@" size="5" /></td>
<td><input type="text" name="articulos_proveedor[@%db:Compra_articulos.id_articulo;%@][dto_vol]"  value="@%db:Compra_articulos.dto_vol;%@" size="5" 
	/>X<input type="text" size="2" name="articulos_proveedor[@%db:Compra_articulos.id_articulo;%@][dto_vol_bultos]" value="@%db:Compra_articulos.dto_vol_bultos;%@" ></td>
<td class="check"><input type="checkbox" name="articulos_proveedor[@%db:Compra_articulos.id_articulo%@][fabricante]" value="1" 
	@%db:check_flag{Empresas_articulos.fabricante}%@ /></td>
</tr>
@%end-where:%@

</tbody>
</table>
</form>

@%plt:botonera%@

<div class="AccionesEnvio"><ul>
<li><a href="#" onclick="return onHRefClick('compra_articulos_proveedor','accion_ejecutar','Modificar');" 
	class="guardar" ><img src="images/pixel.png" class="icono" /><span>Modificar</span></a></li>
</ul></div>

