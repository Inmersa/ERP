@%plt:botonera%@

<table class="full">
<thead>
<tr>
<td ><a href="?_search_sort=Pedidos.referencia" >Refer�ncia<img src="images/pixel.png" class="@%func:class_searchsort;Pedidos.referencia;%@" /></a></td>
<td ><a href="?_search_sort=Pedidos.fecha" >Data<img src="images/pixel.png" class="@%func:class_searchsort;Pedidos.fecha;%@" /></a></td>
<td ><a href="?_search_sort=Clientes.razon_social" >Nom<img src="images/pixel.png" class="@%func:class_searchsort;Clientes.razon_social;%@" /></a></td>
<td ><a href="?_search_sort=Direcciones_entrega.direccion" 
	>Adre�a de entrega<img src="images/pixel.png" class="@%func:class_searchsort;Direcciones_entrega.direccion;%@" /></a></td>
<td ><a href="?_search_sort=monto_pedido" >Quantitat<img src="images/pixel.png" class="@%func:class_searchsort;monto_pedido;%@" /></a></td>
<td class="estado"><a href="?_search_sort=Pedidos.preparado" >Com<img src="images/pixel.png" class="@%func:class_searchsort;Pedidos.preparado;%@" /></a></td>
<td class="estado">A</td>
<td class="estado">F</td>
</tr>
</thead>
<!-- @%set:none=rojo%@ @%set:do=amarillo%@ @%set:ok=verde%@ @%set:bad=negro%@ -->
<tbody>
@%where:tabla|Pedidos;nombre|busc;no_results|1;cfunc|cf_pedidos;%@ 
<tr>
<td><a href="?seccion=bo_pedido_cliente&id_pedido=@%db:Pedidos.id_pedido;%@">@%db:Pedidos.referencia;%@</a></td>
<td>@%db:colocar_fecha{Pedidos.fecha};%@</td>
<td>@%db:Clientes.razon_social;%@</td>
<td>@%db:Direcciones_entrega.direccion;%@</td>
<td>@%db:monto_pedido%@</td>
<td class="estado" ><img src="images/pixel.png" class="@%func:switch_alfa_dec;estado_pedido;none;do;ok;%@" /></td>
<td class="estado" ><img src="images/pixel.png" class="@%func:switch_alfa_dec;estado_albaran;none;do;ok;bad;%@" />
@%if:esta_vacio;link_albaran;%@
@%else:%@
<a href="?seccion=bo_albaranes_pedido&id_pedido=@%db:Pedidos.id_pedido%@"><img src="images/pixel.png" class="ver" /></a>
@%end-if:%@
</td>

<td class="estado" ><img src="images/pixel.png" class="@%func:switch_alfa_dec;estado_factura;none;do;ok;%@" />
@%if:esta_vacio;link_factura;%@
@%else:%@
<a href="?seccion=bo_facturas_pedido_venta&id_pedido=@%db:Pedidos.id_pedido%@"><img src="images/pixel.png" class="ver" /></a>
@%end-if:%@
</td>
</tr>
@%end-where:%@

</tbody>
</table>

@%plt:botonera%@

