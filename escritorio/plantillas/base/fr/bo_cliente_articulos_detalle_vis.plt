
@%where:nombre|Articulo;tabla|Empresas_articulos;where|Empresas_articulos.id_articulo = $id_articulo_promocion AND Empresas_articulos.id_empresa = $id_empresa;%@
<!-- @%db:Empresas_articulos.id_articulo;%@ -->
<table class="full">
<tr>
<td class="etiqueta">Article:</td>
<td colspan="7">@%db:Articulos.nombre;%@</td>
</tr>
<tr>
<td class="etiqueta">Prix 1</td>
<td>@%db:Empresas_articulos.precio_costo;%@ </td>
<td class="etiqueta">Prix 2</td>
<td>@%db:Empresas_articulos.precio_standard;%@ </td>
<td class="etiqueta">Prix 3</td>
<td>@%db:Empresas_articulos.precio_venta;%@ </td>
<td class="etiqueta">Stock E.:</td>
<td>@%db:Empresas_articulos.stock_ficticio;%@</td>
</tr>
<tr><td class="etiqueta">Prix 4</td>
<td>@%db:Empresas_articulos.precio_4;%@ </td>
<td class="etiqueta">Prix 5</td>
<td>@%db:Empresas_articulos.precio_5;%@ </td>
<td class="etiqueta">Prix 6</td>
<td>@%db:Empresas_articulos.precio_6;%@ </td>
<td class="etiqueta">Remises par volume:</td>
<td>
 @%if:!esta_vacio;Empresas_articulos.dto_vol;%@
 @%db:Empresas_articulos.dto_vol;%@ % x @%db:Empresas_articulos.dto_vol_bultos;%@ Bts
 @%end-if:%@
 </td>
</tr>
</table>
 @%end-where:%@


@%plt:botonera%@

<table class="full">
<thead>
<tr>
<td ><a href="?_search_sort=Clientes.razon_social" >Nom client<img src="imag/pixel.png" class="@%func:class_searchsort;Clientes.razon_social;%@" /></a></td>
<td ><a href="?_search_sort=Clientes_articulos.descuento" >Rem.<img src="imag/pixel.png" class="@%func:class_searchsort;Clientes_articulos.descuento;%@" /></a></td>
<td ><a href="?_search_sort=Clientes_articulos.monto" >Rem. Montant<img src="imag/pixel.png" class="@%func:class_searchsort;Clientes_articulos.monto;%@" /></a></td>
<td >Prix Tarif</td>
</tr>
</thead>
<tbody>
@%where:tabla|Cliente_articulos;nombre|busc;no_results|1;%@
<tr>
<td><a href="?seccion=bo_descuento_articulos&id_cliente=@%db:Cliente_articulos.id_cliente;%@">@%db:Clientes.razon_social;%@</a></td>
<td>@%db:Cliente_articulos.descuento;%@ %</td>
<td>@%db:Cliente_articulos.monto;%@</td>
<td>@%func:precio_tarifa;%@ (@%db:Tarifas.nombre;%@)</td>
</tr>
@%end-where:%@

</tbody>
</table>

@%plt:botonera%@


 
