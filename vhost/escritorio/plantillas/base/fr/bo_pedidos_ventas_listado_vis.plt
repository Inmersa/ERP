@%plt:botonera%@

<table class="full">
<thead>
<tr>
<td ><a href="?_search_sort=Pedidos.referencia">Code<img src="imag/pixel.png" class="@%func:class_searchsort;Pedidos.referencia;%@" /></a></td>
<td class="estado">Comm</td>
<td class="estado">L</td>
<td class="estado">F</td>
<td ><a href="?_search_sort=Clientes.razon_social">Client<img src="imag/pixel.png" class="@%func:class_searchsort;Clientes.razon_social;%@" /></a></td>
<td ><a href="?_search_sort=Pedidos.fecha">Date<img src="imag/pixel.png" class="@%func:class_searchsort;Pedidos.fecha;%@" /></a></td>
<td ><a href="?_search_sort=monto_pedido">Quantite<img src="imag/pixel.png" class="@%func:class_searchsort;monto_pedido;%@" /></a></td>
<td ><a href="?_search_sort=referencia_externa" class="order" >Réf. Ext<img src="imag/pixel.png" class="@%func:class_searchsort;referencia_externa;%@" /></a></td>
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
<td class="estado" ><img src="imag/pixel.png" class="@%func:switch_alfa_dec;estado_pedido;none;do;ok;%@" /></td>
<td class="estado" ><img src="imag/pixel.png" class="@%func:switch_alfa_dec;estado_albaran;none;do;ok;bad;%@" />
@%if:esta_vacio;link_albaran;%@
@%else:%@
<a href="?seccion=bo_albaranes_pedido&id_pedido=@%db:Pedidos.id_pedido%@"><img src="imag/pixel.png" class="ver" /></a>
@%end-if:%@
</td>

<td class="estado" ><img src="imag/pixel.png" class="@%func:switch_alfa_dec;estado_factura;none;do;ok;%@" />
@%if:esta_vacio;link_factura;%@
@%else:%@
<a href="?seccion=bo_facturas_pedido_venta&id_pedido=@%db:Pedidos.id_pedido%@"><img src="imag/pixel.png" class="ver" /></a>
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

<div class="barraoscura">Légende</div>
<table class="full">

<tr>
<td class="etiqueta">C -Commande</td>
<td><img src="imag/triangulo.png" width="14" height="14" /></td>
<td>Émis</td>
<td><img src="imag/cuadrado.png" width="14" height="14" /></td>
<td>Prêt</td>
<td><img src="imag/circulo.png" width="14" height="14" /></td>
<td>Reçu </td>
</tr>
<tr>
<td class="etiqueta">L - <span>Livraisons</span></td>
<td><img src="imag/triangulo.png" width="14" height="14" /></td>
<td>Nul / en l´espace</td>
<td><img src="imag/cuadrado.png" width="14" height="14" /></td>
<td>Prêt</td>
<td><img src="imag/circulo.png" width="14" height="14" /></td>
<td>Envoyé</td>
<td><img src="imag/negro.gif" width="14" height="14" /></td>
<td>Envoi en retour</td>
</tr>

<tr>
<td class="etiqueta">F- <span>Factures</span></td>
<td><img src="imag/triangulo.png" width="14" height="14" /></td>
<td>Sans facture</td>
<td><img src="imag/cuadrado.png" width="14" height="14" /></td>
<td>Sans émettre</td>
<td><img src="imag/circulo.png" width="14" height="14" /></td>
<td>Émis</td>

</tr>
</table>


