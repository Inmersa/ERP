
@%plt:botonera%@

 <table class="full">
<thead>
 <tr>
 <td class="check" ></td>
 <td ><a href="?_search_sort=Pedidos.referencia" >Codi<img src="images/pixel.png" class="@%func:class_searchsort;Pedidos.referencia;%@" /></a></td>
 <td ><a href="?_search_sort=Pedidos.fecha" >Data<img src="images/pixel.png" class="@%func:class_searchsort;Pedidos.fecha;%@" /></a></td>
 <td ><a href="?_search_sort=Direcciones_entrega.direccion" >Direcci� entrega<img src="images/pixel.png" class="@%func:class_searchsort;Direcciones_entrega.direccion;%@" /></a></td>
 <td ><a href="?_search_sort=monto_pedido" >Base imposable<img src="images/pixel.png" class="@%func:class_searchsort;monto_pedido;%@" /></a></td>
 <td class="estado" >C</td>
 <td class="estado" >A</td>
 <td class="estado" >F</td>
 </tr>
</thead>

<form name="bo_pedidos_cliente" method="post" action="?seccion=bo_pedidos_cliente">
<input type="hidden" name="accion_ejecutar" value="j" />
<tbody>
<!-- @%set:none=rojo%@ @%set:do=amarillo%@ @%set:ok=verde%@ @%set:bad=negro%@ -->
 @%where:tabla|Pedidos;nombre|busc;no_results|1;order|Pedidos.fecha desc;cfunc|cf_pedidos%@ 
 <tr>
 <td class="check">
 @%if:se_puede_borrar%@
 <input type="checkbox" name="registro_borrar[@%db:Pedidos.id_pedido;%@]" value="1" />
 @%else:%@
 @%end-if:%@
 </td>
 <td>
 @%if:AllowedLink;bo_pedido_cliente;%@
 <a href="?seccion=bo_pedido_cliente&id_pedido=@%db:Pedidos.id_pedido;%@" class="accesos">@%db:Pedidos.referencia;%@</a>
 @%end-if:%@
 </td>
 <td>@%db:colocar_fecha{Pedidos.fecha};%@</td>
 <td>@%db:Direcciones_entrega.direccion;%@@%db:Direcciones_entrega.nombre;%@</td>
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
 @%end-where:%@ 

</tbody>
</table>
</form>

 @%plt:botonera%@ 


