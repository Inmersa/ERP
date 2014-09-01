
@%plt:botonera;%@

 <form name="hacer_pedido_compra" method="post" action="?seccion=hacer_pedido_compra">
 <input type="hidden" name="force_" value="1" />
<table class="full">
<thead>
<tr>
<td >ID</td>
<td ><a href="?_search_sort=Articulos.nombre" >Name<img src="images/pixel.png" class="@%func:class_searchsort;Articulos.nombre;%@" /></a></td>
<td ><a href="?_search_sort=Compra_articulos.precio" >Price<img src="images/pixel.png" class="@%func:class_searchsort;Compra_articulos.precio;%@" /></a></td>
<td ><a href="?_search_sort=Marcas.nombre" >Brand<img src="images/pixel.png" class="@%func:class_searchsort;Marcas.nombre;%@" /></a></td>
<td ><a href="?_search_sort=Empresas_articulos.stock_ficticio" 
	>Stk Est.<img src="images/pixel.png" class="@%func:class_searchsort;Empresas_articulos.stock_ficticio;%@" /></a></td>
<td >Real Stock</td>
<td >Amount</a></td>
<td >u/Pack</td>
<td >pack/L</td>
<td >Postal Code</td>
<td >Off. / Promotions</td>
 </tr>
</thead>
<tbody>
 @%where:tabla|Articulos;cfunc|cf_articulos_compra;nombre|busc;no_results|1;order|Articulos.nombre;contador|count;%@
<tr>
<td>@%db:Compra_articulos.id_articulo;%@
<td>@%db:Articulos.nombre;%@
@%if:esta_vacio;Compra_articulos.referencia;%@
(@%db:Empresas_articulos.referencia;%@)
@%else:%@
(@%db:Compra_articulos.referencia;%@)
@%end-if:%@
</td>
<td>@%db:Compra_articulos.precio;%@@%db:Divisa.leyenda%@</td>
<td>@%db:Marcas.nombre;%@</td>
<td>@%db:Empresas_articulos.stock_ficticio;%@</td>
<td>@%db:Localizacion_articulos.cantidad;%@</td>
<td>
<input type="hidden" name="array_ids[@%db:count;%@]" value="@%db:Compra_articulos.id_articulo;%@" />
<input type="hidden" name="array[id_unidad_medida][@%db:count;%@]" value="@%db:Articulos.id_unidad_medida;%@" />
<input type="text" name="array[cantidad][@%db:count;%@]" size="5" /></td>
<td class="check"><input type="checkbox" name="array_bultos[@%db:count;%@][bultos]" value="1" />@%db:Empresas_articulos.unidades_bulto;%@</td>
<td class="check"><input type="checkbox" name="array_bultos[@%db:count;%@][capas]" value="1" />@%db:Empresas_articulos.bultos_capa_palet;%@</td>
<td class="check"><input type="checkbox" name="array_bultos[@%db:count;%@][palets]" value="1" />@%db:Empresas_articulos.capas_palet;%@</td>
<td>@%db:descuento%@</td>
</tr>
@%end-where:%@

</table>
</tbody>
<input type="hidden" name="Anyadir" value="A�adir" />

<div class="AccionesEnvio"><ul>
<li><a href="#" onclick="return sendForm('hacer_pedido_compra');" class="sumaracesta" ><img src="images/pixel.png" class="icono" /><span>Add</span></a></li>
</ul></div>
</form>

@%plt:botonera;%@

