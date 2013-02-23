
@%plt:botonera%@

<div id="AccionesListado"><ul>
<li><a href="#" onclick="return onHRefClick('bo_inventario_articulos','accion_ejecutar','Agrupar');" class="agruparlocalizaciones" 
	><img src="images/pixel.png" class="icono" /><span>To group</span></a></li>
@%if:AllowedAction;Localizacion_articulos;new;%@
<li><a href="?seccion=bo_importar_articulos_seleccion" class="nuevalocalizacion" ><img src="images/pixel.png" class="icono" /><span>New Location</span></a></li>
@%end-if:%@
</ul></div>

<form name="bo_inventario_articulos" method="post" action="">
<input type="hidden" name="accion_ejecutar" value="Borrar_seleccion" />
<table class="full">
<thead>
<tr>
<td class="estado" ><img src="images/pixel.png" class="marcartodos" onclick="return formCheckAll('registro_borrar');"  /></td>
<td ><a href="?_search_sort=Localizacion_articulos.id_articulo">ID<img src="images/pixel.png" 
	class="@%func:class_searchsort;Localizacion_articulos.id_articulo;%@" /></a></td>
<td ><a href="?_search_sort=Articulos.codigo_barras">Bar code<img src="images/pixel.png" 
	class="@%func:class_searchsort;Articulos.codigo_barras;%@" /></a></td>
<td ><a href="?_search_sort=Articulos.nombre">Article<img src="images/pixel.png" class="@%func:class_searchsort;Articulos.nombre;%@" /></a></td>
<td ><a href="?_search_sort=Marcas.nombre">Brand<img src="images/pixel.png" class="@%func:class_searchsort;Marcas.nombre;%@" /></a></td>
<td ><a href="?_search_sort=Localizacion_articulos.fecha_caducidad">Use-by date<img src="images/pixel.png" 
	class="@%func:class_searchsort;Localizacion_articulos.fecha_caducidad;%@" /></a></td>
<td ><a href="?_search_sort=Localizacion_articulos.lote">Lot<img src="images/pixel.png" class="@%func:class_searchsort;Localizacion_articulos.lote;%@" /></a></td>
<td ><a href="?_search_sort=Localizacion_articulos.cantidad">Amount<img src="images/pixel.png" 
	class="@%func:class_searchsort;Localizacion_articulos.cantidad;%@" /></a></td>
<td ><a href="?_search_sort=Localizacion_articulos.planta">Floor<img src="images/pixel.png" class="@%func:class_searchsort;Localizacion_articulos.planta;%@" /></a></td>
<td ><a href="?_search_sort=Localizacion_articulos.pasillo">Corridor<img src="images/pixel.png" class="@%func:class_searchsort;Localizacion_articulos.pasillo;%@" /></a></td>
<td ><a href="?_search_sort=Localizacion_articulos.columna">Column<img src="images/pixel.png" class="@%func:class_searchsort;Localizacion_articulos.columna;%@" /></a></td>
<td ><a href="?_search_sort=Localizacion_articulos.fila">Row<img src="images/pixel.png" class="@%func:class_searchsort;Localizacion_articulos.fila;%@" /></a></td>
</tr></thead>

@%where:tabla|Localizacion_articulos;nombre|busc;contador|i;no_results|1;order|Almacenes_logicos.nombre, Marcas.nombre, Articulos.nombre ;%@

@%if:esta_vacio;st[id_alml];%@
<!-- @%set:_var_x = Almacenes_logicos.nombre;%@ -->
@%if:cambia_var_x;%@
<thead class="secundario" ><tr><td colspan="12">Warehouse Zone: @%db:Almacenes_logicos.nombre;%@</td></tr></thead>
@%end-if:%@
@%end-if:%@

<tr
@%if:!esta_vacio;Empresas_articulos.fecha_baja;%@
class="impropio"
@%end-if:%@
> 
<input type="hidden" name="registro[@%db:i;%@][id_articulo]" value="@%db:Localizacion_articulos.id_articulo;%@" />
<input type="hidden" name="registro[@%db:i;%@][id_almacen_logico]" value="@%db:Localizacion_articulos.id_almacen_logico;%@" />
<input type="hidden" name="oldrecord[@%db:i;%@][id_almacen_logico]" value="@%db:Localizacion_articulos.id_almacen_logico;%@" />
<input type="hidden" name="oldrecord[@%db:i;%@][id_articulo]" value="@%db:Localizacion_articulos.id_articulo;%@" />
<input type="hidden" name="oldrecord[@%db:i;%@][fecha_caducidad]" value="@%db:Localizacion_articulos.fecha_caducidad;%@" />
<input type="hidden" name="oldrecord[@%db:i;%@][lote]" value="@%db:Localizacion_articulos.lote;%@" />
<input type="hidden" name="oldrecord[@%db:i;%@][cantidad]" value="@%db:Localizacion_articulos.cantidad;%@" />
<input type="hidden" name="oldrecord[@%db:i;%@][planta]" value="@%db:Localizacion_articulos.planta;%@" />
<input type="hidden" name="oldrecord[@%db:i;%@][pasillo]" value="@%db:Localizacion_articulos.pasillo;%@" />
<input type="hidden" name="oldrecord[@%db:i;%@][fila]" value="@%db:Localizacion_articulos.fila;%@" />
<input type="hidden" name="oldrecord[@%db:i;%@][columna]" value="@%db:Localizacion_articulos.columna;%@" />
<td class="check"><input type="checkbox" name="registro_borrar[@%db:i;%@]" value="1" /></td>
<td >@%db:Localizacion_articulos.id_articulo;%@</td>
<td >@%db:Articulos.codigo_barras;%@</td>
<td><a href="?seccion=bo_localizacion_articulos&id_articulo=@%db:Localizacion_articulos.id_articulo;%@">@%db:Articulos.nombre;%@</a></td>
<td>@%db:Marcas.nombre;%@</td>
<td><input type="text" name="registro[@%db:i;%@][fecha_caducidad]" value="@%db:colocar_fecha{Localizacion_articulos.fecha_caducidad};%@" class="fecha" /></td>
<td><input type="text" name="registro[@%db:i;%@][lote]" value="@%db:Localizacion_articulos.lote;%@" class="num" /></td>
<td><input type="text" name="registro[@%db:i;%@][cantidad]" value="@%db:Localizacion_articulos.cantidad;%@" class="num" /></td>
<td><input type="text" name="registro[@%db:i;%@][planta]" value="@%db:Localizacion_articulos.planta;%@" class="mininum" /></td>
<td><input type="text" name="registro[@%db:i;%@][pasillo]" value="@%db:Localizacion_articulos.pasillo;%@" class="mininum" /></td>
<td><input type="text" name="registro[@%db:i;%@][columna]" value="@%db:Localizacion_articulos.columna;%@" class="mininum" /></td>
<td><input type="text" name="registro[@%db:i;%@][fila]" value="@%db:Localizacion_articulos.fila;%@" class="mininum" /></td>
</tr>
 @%end-where:%@

 
</table>
</form>
@%plt:botonera%@

<div class="AccionesEnvio"><ul>
<li><a href="#" onclick="return onHRefClick('bo_inventario_articulos','accion_ejecutar','Modificar');" class="guardar" ><img src="images/pixel.png" class="icono" /><span>Modify</span></a></li>
<li><a href="#" onclick="return SendFormToWindow('bo_inventario_articulos','nuevo_bajas_almacen','BajaLocalizacion',400);" class="causarbaja" ><img src="images/pixel.png" class="icono" /><span>Stock Down</span></a></li>
<li><a href="#" onclick="return onHRefClick('bo_inventario_articulos','accion_ejecutar','Borrar');" class="borrar" ><img src="images/pixel.png" class="icono" /><span>Delete selected</span></a></li>
</ul></div>

