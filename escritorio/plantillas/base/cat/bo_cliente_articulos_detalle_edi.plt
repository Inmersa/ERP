
@%where:nombre|Articulo;tabla|Empresas_articulos;where|Empresas_articulos.id_articulo = $id_articulo_promocion AND Empresas_articulos.id_empresa = $id_empresa;%@
<!-- @%db:Empresas_articulos.id_articulo;%@ -->
<table class="full">
<tr>
<td class="etiqueta">Article:</td>
<td colspan="7">@%db:Articulos.nombre;%@</td>
</tr>
<tr>
<td class="etiqueta">Preu 1</td>
<td>@%db:Empresas_articulos.precio_costo;%@ </td>
<td class="etiqueta">Preu 2</td>
<td>@%db:Empresas_articulos.precio_standard;%@ </td>
<td class="etiqueta">Preu 3</td>
<td>@%db:Empresas_articulos.precio_venta;%@ </td>
<td class="etiqueta">Stock E.:</td>
<td>@%db:Empresas_articulos.stock_ficticio;%@</td>
</tr>
<tr><td class="etiqueta">Preu 4</td>
<td>@%db:Empresas_articulos.precio_4;%@ </td>
<td class="etiqueta">Preu 5</td>
<td>@%db:Empresas_articulos.precio_5;%@ </td>
<td class="etiqueta">Preu 6</td>
<td>@%db:Empresas_articulos.precio_6;%@ </td>
<td class="etiqueta">Descomptes per volum:</td>
<td>
 @%if:!esta_vacio;Empresas_articulos.dto_vol;%@
 @%db:Empresas_articulos.dto_vol;%@ % x @%db:Empresas_articulos.dto_vol_bultos;%@ Bts
 @%end-if:%@
 </td>
</tr>
</table>
 @%end-where:%@

@%plt:botonera%@

<form name="bo_cliente_articulos" method="post" action="#">
<input type="hidden" name="accion_ejecutar" value="0" />
<table class="full">
<thead>
<tr>
<td></td>
<td ><a href="?_search_sort=Clientes.razon_social" >Nom client<img src="images/pixel.png" class="@%func:class_searchsort;Clientes.razon_social;%@" /></a></td>
<td ><a href="?_search_sort=Clientes_articulos.descuento" >Desc.<img src="images/pixel.png" class="@%func:class_searchsort;Clientes_articulos.descuento;%@" /></a></td>
<td ><a href="?_search_sort=Clientes_articulos.monto" >Desc. Monto<img src="images/pixel.png" class="@%func:class_searchsort;Clientes_articulos.monto;%@" /></a></td>
<td >Preu Tarifa</td>
</tr>
</thead>
<tbody>
@%where:tabla|Cliente_articulos;nombre|busc;no_results|1;%@
<tr>
<td class="check"><input type="checkbox" name="descuentos_cliente_borrar[@%db:Cliente_articulos.id_cliente%@]" value="1" /></td>
<td><a href="?seccion=bo_descuento_articulos&id_cliente=@%db:Cliente_articulos.id_cliente;%@">@%db:Clientes.razon_social;%@</a></td>
<td><input type="text" name="descuentos_articulo_modificar_descuento[@%db:Cliente_articulos.id_cliente%@]" value="@%db:Cliente_articulos.descuento;%@" size="6" /> %</td>
<td><input type="text" name="descuentos_articulo_modificar_monto[@%db:Cliente_articulos.id_cliente%@]" value="@%db:Cliente_articulos.monto;%@" size="10" /></td>
<td>@%func:precio_tarifa;%@ (@%db:Tarifas.nombre;%@)</td>
</tr>
@%end-where:%@

</tbody>
</table>
 </form>

@%plt:botonera%@

<div class="AccionesEnvio"><ul>
<li><a href="#" onclick="return onHRefClick('bo_cliente_articulos','accion_ejecutar','Modificar');" class="guardar" ><img src="images/pixel.png" class="icono" /><span>Modificar</span></a></li>
<li><a href="#" onclick="return onHRefClick('bo_cliente_articulos','accion_ejecutar','Borrar');" class="borrar" ><img src="images/pixel.png" class="icono" /><span>Esborrar seleccionats</span></a></li>
</ul></div>

