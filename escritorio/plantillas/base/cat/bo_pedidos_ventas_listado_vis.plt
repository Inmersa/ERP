@%plt:botonera%@

<table class="full">
<thead>
<tr>
<td ><a href="?_search_sort=Pedidos.referencia">Codi<img src="images/pixel.png" class="@%func:class_searchsort;Pedidos.referencia;%@" /></a></td>
<td class="estado">Com</td>
<td class="estado">A</td>
<td class="estado">F</td>
<td ><a href="?_search_sort=Clientes.razon_social">Client<img src="images/pixel.png" class="@%func:class_searchsort;Clientes.razon_social;%@" /></a></td>
<td ><a href="?_search_sort=Pedidos.fecha">Data<img src="images/pixel.png" class="@%func:class_searchsort;Pedidos.fecha;%@" /></a></td>
<td ><a href="?_search_sort=monto_pedido">Quantitat<img src="images/pixel.png" class="@%func:class_searchsort;monto_pedido;%@" /></a></td>
<td ><a href="?_search_sort=referencia_externa" class="order" >Ref. Ext<img src="images/pixel.png" class="@%func:class_searchsort;referencia_externa;%@" /></a></td>
</tr>
</thead>

<tbody>
<!-- @%set:none=rojo%@ @%set:do=amarillo%@ @%set:ok=verde%@ @%set:bad=negro%@ -->
@%where:tabla|Pedidos;nombre|busc;no_results|1;order|Pedidos.fecha desc;cfunc|cf_pedidos;group|Pedidos.id_pedido;%@ 
<tr>
<td><a href="?seccion=bo_pedido_cliente&id_pedido=@%db:Pedidos.id_pedido;%@"
@%if:esta_vacio;Pedidos.id_pedido_incompleto;%@
>
@%else:%@
 class="accesos2">
@%end-if:%@
@%db:not_empty{Pedidos.referencia};%@</a></td>
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
<td>@%db:Clientes.razon_social%@</td>
<td>@%db:colocar_fecha{Pedidos.fecha};%@</td>
<td>@%db:monto_pedido%@</td>
<td>@%db:Pedidos.referencia_externa;%@</td>

</tr>
@%end-where:%@

</tbody>
</table>

@%plt:botonera%@

<div class="barraoscura">Llegenda</div>
<table class="full">

<tr>
<td class="etiqueta">C -Comanda</td>
<td><img src="imag/triangulo.png" width="14" height="14" /></td>
<td>En preparaci�</td>
<td><img src="imag/cuadrado.png" width="14" height="14" /></td>
<td>Preparat</td>
<td><img src="imag/circulo.png" width="14" height="14" /></td>
<td>Rebuda </td>
</tr>
<tr>
<td class="etiqueta">A - <span>Albar�ns</span></td>
<td><img src="imag/triangulo.png" width="14" height="14" /></td>
<td>Nul / en proces</td>
<td><img src="imag/cuadrado.png" width="14" height="14" /></td>
<td>Preparat</td>
<td><img src="imag/circulo.png" width="14" height="14" /></td>
<td>Enviat</td>
<td><img src="imag/negro.gif" width="14" height="14" /></td>
<td>Tornat</td>
</tr>

<tr>
<td class="etiqueta">F- <span>Factures</span></td>
<td><img src="imag/triangulo.png" width="14" height="14" /></td>
<td>Sense factura</td>
<td><img src="imag/cuadrado.png" width="14" height="14" /></td>
<td>Sense emetre</td>
<td><img src="imag/circulo.png" width="14" height="14" /></td>
<td>Emesa</td>

</tr>
</table>


