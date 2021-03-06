
 @%plt:botonera%@

<div id="AccionesListado">
<ul>
 @%if:!oModoSeleccion->isActive;%@
	 @%if:AllowedLink;bo_importar_articulos;%@
	 <li><a href="?seccion=bo_importar_articulos" class="recuperar"><img src="images/pixel.png" class="icono" /><span>Import articles</span></a></li>
	 @%end-if:&@
	 @%if:AllowedAction;Articulos;new;%@
	 <li><a href="?seccion=nuevo_articulos" class="nuevo"><img src="images/pixel.png" class="icono" /><span>New article</span></a></li>
	 @%end-if:&@
	 @%if:AllowedAction;Empresas_articulos;del;%@
	 <li><a href="#" onclick="return onHRefClick('bo_articulos','accion_ejecutar','Borrar');" class="borrar"
		><img src="images/pixel.png" class="icono" /><span>Outdate Selected</span></a></li>
	 @%end-if:%@
 @%else:%@
 	<li ><a href="#" onClick="return sendForm('bo_articulos');" class="seleccionar" ><img src="images/pixel.png" class="icono" /><span>Select</span></a></li>
 @%end-if:%@
 </ul>
</div>

<form name="bo_articulos" method="post" 
@%if:oModoSeleccion->isActive;%@
action="?seccion=@%func:oModoSeleccion->getFormTarget;%@" 
@%else:%@
action="?seccion=@%get:_krn_ss_name;%@"
@%end-if:%@
>

<input type="hidden" name="accion_ejecutar" value="0" />

@%where:tabla|Articulos;nombre|busc;no_results|1;grupo|Articulos.id_articulo;%@
<table class="full">

<thead>
<tr>
<td class="estado" ><img src="images/pixel.png" class="marcartodos" onclick="return formCheckAll('selecciones');"  /></td>
<td colspan="3"><a href="?_search_sort=Articulos.nombre" >Name<img src="images/pixel.png" class="@%func:class_searchsort;Articulos.nombre;%@" /></a></td>
<td ><a href="?_search_sort=Empresas_articulos.unidades_bulto" >Units by package<img src="images/pixel.png" 
	class="@%func:class_searchsort;Empresas_articulos.unidades_bulto;%@" /></a></td>
<td ><a href="?_search_sort=Tipos_IVA.porcentaje" >% VAT<img src="images/pixel.png" class="@%func:class_searchsort;Tipos_IVA.porcentaje;%@" /></a></td>
<td colspan="2"><a href="?_search_sort=Empresas_articulos.stock_ficticio" >Estimated Stock<img src="images/pixel.png" 
	class="@%func:class_searchsort;Empresas_articulos.stock_ficticio;%@" /></a></td>
<td colspan="2">Real Stock</td>
</tr>
</thead>

<tbody>
<tr>
<td class="check">
@%if:oModoSeleccion->isActive;%@
<input type="@%func:oModoSeleccion->getSelectionType;%@" name="@%func:oModoSeleccion->getSelectionName;%@" value="@%db:Articulos.id_articulo;%@" />
@%else:%@
<input type="checkbox" name="selecciones[@%db:Articulos.id_articulo;%@]" value="@%db:Articulos.id_articulo;%@" />
@%end-if:%@
</td>

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
<td ><a href="?_search_sort=Articulos.id_articulo" >ID<img src="images/pixel.png" class="@%func:class_searchsort;Articulos.id_articulo;%@" /></a></td>
<td ><a href="?_search_sort=Marcas.nombre" >Brand<img src="images/pixel.png" class="@%func:class_searchsort;Marcas.nombre;%@" /></a></td>
<td >Promotion</td>
<td ><a href="?_search_sort=Empresas_articulos.precio_costo" >Price 1<img src="images/pixel.png" class="@%func:class_searchsort;Empresas_articulos.precio_costo;%@" /></a></td>
<td ><a href="?_search_sort=Empresas_articulos.precio_standard" >Price 2<img src="images/pixel.png" 
	class="@%func:class_searchsort;Empresas_articulos.precio_standard;%@" /></a></td>
<td ><a href="?_search_sort=Empresas_articulos.precio_venta" >Price 3<img src="images/pixel.png" class="@%func:class_searchsort;Empresas_articulos.precio_venta;%@" /></a></td>
<td ><a href="?_search_sort=Empresas_articulos.precio_4" >Price 4<img src="images/pixel.png" class="@%func:class_searchsort;Empresas_articulos.precio_4;%@" /></a></td>
<td ><a href="?_search_sort=Empresas_articulos.precio_5" >Price 5<img src="images/pixel.png" class="@%func:class_searchsort;Empresas_articulos.precio_5;%@" /></a></td>
<td ><a href="?_search_sort=Empresas_articulos.precio_6" >Price 6<img src="images/pixel.png" class="@%func:class_searchsort;Empresas_articulos.precio_6;%@" /></a></td>
</tr>
</thead>

<tbody>
<tr>
<td>@%db:Articulos.id_articulo;%@</td>
<td>@%db:Marcas.nombre;%@</td>
<td>@%func:promocion_articulo%@</td>
<td><input type="text" name="registro_lista[precio_costo][@%db:Articulos.id_articulo;%@]" value="@%db:Empresas_articulos.precio_costo;%@" size="8" /></td>
<td><input type="text" name="registro_lista[precio_standard][@%db:Articulos.id_articulo;%@]" value="@%db:Empresas_articulos.precio_standard;%@" size="8" /></td>
<td><input type="text" name="registro_lista[precio_venta][@%db:Articulos.id_articulo;%@]" value="@%db:Empresas_articulos.precio_venta;%@" size="8" /></td>
<td><input type="text" name="registro_lista[precio_4][@%db:Articulos.id_articulo;%@]" value="@%db:Empresas_articulos.precio_4;%@" size="8" /></td>
<td><input type="text" name="registro_lista[precio_5][@%db:Articulos.id_articulo;%@]" value="@%db:Empresas_articulos.precio_5;%@" size="8" /></td>
<td><input type="text" name="registro_lista[precio_6][@%db:Articulos.id_articulo;%@]" value="@%db:Empresas_articulos.precio_6;%@" size="8" /></td>
</tr>
</tbody>
</table>

@%end-where:%@

</form>
@%plt:botonera%@ 

<div class="AccionesEnvio">
<ul>
<li><a href="#" onclick="return onHRefClick('bo_articulos','accion_ejecutar','Modificar','@%get:_krn_ss_name;%@');" class="guardar"
	><img src="images/pixel.png" class="icono" /><span>Modify</span></a></li>
</ul>
</div>

