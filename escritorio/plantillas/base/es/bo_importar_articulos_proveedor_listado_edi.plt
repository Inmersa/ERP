
@%plt:botonera%@

<div id="AccionesListado"><ul>
<li><a href="#" onClick="return sendForm('importar_articulos_proveedor');" class="enviar" ><img src="images/pixel.png" class="icono" /><span>Importar</span></a></li>
</ul></div>

<form name="importar_articulos_proveedor" method="post" action="?seccion=bo_compra_articulos_proveedor">
@%where:tabla|Articulos;nombre|busc;no_results|1;%@
<table class="full">
<thead><tr>
<td colspan="3"><a href="?_search_sort=Articulos.nombre" class="order" >Nombre<img src="images/pixel.png" class="@%func:class_searchsort;Articulos.nombre;%@" /></a></td>
<td ><a href="?_search_sort=Articulos.codigo_barras" class="order" 
	>Cod. barras<img src="images/pixel.png" class="@%func:class_searchsort;Articulos.codigo_barras;%@" /></a></td>
<td colspan="2"><a href="?_search_sort=Empresas_articulos.fecha_alta" class="order" 
	>Fecha alta<img src="images/pixel.png" class="@%func:class_searchsort;Empresas_articulos.fecha_alta;%@" /></a></td>
<td colspan="2"><a href="?_search_sort=Empresas_articulos.fecha_baja" class="order" 
	>Fecha baja<img src="images/pixel.png" class="@%func:class_searchsort;Empresas_articulos.fecha_baja;%@" /></a></td>
</tr></thead>

<tbody>
<tr
@%if:!esta_vacio;Empresas_articulos.fecha_baja;%@
class="impropio"
@%end-if:%@
>
<td >@%db:Articulos.id_articulo;%@</td>
<td colspan="2"><a href="?seccion=modif_articulos&id_articulo=@%db:Articulos.id_articulo;%@">@%db:Articulos.nombre;%@</a></td>
<td>@%db:Articulos.codigo_barras;%@</td>
<td colspan="2">@%db:colocar_fecha{Empresas_articulos.fecha_alta};%@</td>
<td colspan="2">@%db:colocar_fecha{Empresas_articulos.fecha_baja};%@</td>
</tr></tbody>

@%if:!articulo_proveedor;%@
<thead class="secundario" ><tr>
<td class="estado" ><img src="images/pixel.png" class="marcartodos" onclick="return formCheckAll('articulos_proveedor_importar');"  /></td>
<td >Ref.</td>
<td >Precio</td>
<td >Dto</td>
<td >PVP</td>
<td >Precio Reventa</td>
<td >Dto Vol.</td>
<td >Fabric.</td>
</tr></thead>

<tbody>
<!-- @%set:id_art=Articulos.id_articulo;%@ @%unset:es_baja;%@ -->
@%where:tabla|Compra_articulos;nombre|bajas;where|Compra_articulos.id_proveedor = $id_proveedor AND Compra_articulos.id_Articulo = $id_art AND Compra_articulos.fecha_baja IS NOT NULL;%@
<input type="hidden" name="articulos_proveedor[@%db:Articulos.id_articulo;%@][fecha_baja]" value="@%db:Compra_articulos.fecha_baja;%@" />
<tr
@%if:!esta_vacio;Compra_articulos.fecha_baja;%@
class="resalte"
@%end-if:%@
>
<td ><input type="checkbox" name="articulos_proveedor_importar[@%db:Articulos.id_articulo;%@]" size="9" maxlength="9" value="1" /></td>
<td><input type="text" name="articulos_proveedor[@%db:Articulos.id_articulo;%@][referencia]" size="9" maxlength="9" 
	value="@%db:Compra_articulos.referencia;%@" /></td>
<td><input type="text" name="articulos_proveedor[@%db:Articulos.id_articulo;%@][precio]" size="9" maxlength="9" 
	value="@%func:primer_novacio;Compra_articulos.precio;Empresas_articulos.precio_costo%@" />
	@%db:Empresas_articulos.precio_costo;%@
	</td>
<td><input type="text" name="articulos_proveedor[@%db:Articulos.id_articulo;%@][descuento]" size="4" maxlength="6" 
	value="@%db:Compra_articulos.descuento;%@" /> %</td>
<td><input type="text" name="articulos_proveedor[@%db:Articulos.id_articulo;%@][PVP_oficial]" size="9" 
	value="@%db:Compra_articulos.PVP_oficial;%@" /></td>
<td><input type="text" name="articulos_proveedor[@%db:Articulos.id_articulo;%@][PV_oficial]" size="9" 
	value="@%db:Compra_articulos.PV_oficial;%@" /></td>
<td><input type="text" name="articulos_proveedor[@%db:Articulos.id_articulo;%@][dto_vol]" size="5" 
	value="@%db:Compra_articulos.dto_vol;%@" /> X <input type="text"
name="articulos_proveedor[@%db:Articulos.id_articulo;%@][dto_vol_bultos]" size="3" 
	value="@%db:Compra_articulos.dto_vol_bultos;%@" /></td>
<td class="check"><input type="checkbox" name="articulos_proveedor[@%db:Articulos.id_articulo;%@][fabricante]" value="1" 
	@%db:check_flag{Compra_articulos.fabricante};%@ /></td>
<!-- @%set:es_baja=1;%@ -->
@%end-where:%@

@%if:esta_vacio;es_baja;%@
<tr>
<td ><input type="checkbox" name="articulos_proveedor_importar[@%db:Articulos.id_articulo;%@]" size="9" maxlength="9" value="1" /></td>
<td><input type="text" name="articulos_proveedor[@%db:Articulos.id_articulo;%@][referencia]" size="9" maxlength="9" 
	value="@%db:Compra_articulos.referencia;%@" /></td>
<td><input type="text" name="articulos_proveedor[@%db:Articulos.id_articulo;%@][precio]" size="9" maxlength="9" 
	value="@%func:primer_novacio;Compra_articulos.precio;Empresas_articulos.precio_costo%@" />
	@%db:Empresas_articulos.precio_costo;%@
	</td>
<td><input type="text" name="articulos_proveedor[@%db:Articulos.id_articulo;%@][descuento]" size="4" maxlength="6" 
	value="@%db:Compra_articulos.descuento;%@" /> %</td>
<td><input type="text" name="articulos_proveedor[@%db:Articulos.id_articulo;%@][PVP_oficial]" size="9" 
	value="@%db:Compra_articulos.PVP_oficial;%@" /></td>
<td><input type="text" name="articulos_proveedor[@%db:Articulos.id_articulo;%@][PV_oficial]" size="9" 
	value="@%db:Compra_articulos.PV_oficial;%@" /></td>
<td><input type="text" name="articulos_proveedor[@%db:Articulos.id_articulo;%@][dto_vol]" size="5" 
	value="@%db:Compra_articulos.dto_vol;%@" /> X <input type="text"
name="articulos_proveedor[@%db:Articulos.id_articulo;%@][dto_vol_bultos]" size="3" 
	value="@%db:Compra_articulos.dto_vol_bultos;%@" /></td>
<td class="check"><input type="checkbox" name="articulos_proveedor[@%db:Articulos.id_articulo;%@][fabricante]" value="1" 
	@%db:check_flag{Compra_articulos.fabricante};%@ /></td>
@%end-if:%@

</tr>
</tbody>
@%end-if:%@
</table>
@%end-where:%@

<input type="hidden" name="accion_ejecutar" value="Importar" />
</form>

@%plt:botonera%@


