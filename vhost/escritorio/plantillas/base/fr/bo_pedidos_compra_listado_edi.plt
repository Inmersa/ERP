
@%plt:botonera%@

<form name="bo_pedidos_compras" method="post" action="?seccion=bo_pedidos_compras">
<input type="hidden" name="accion_ejecutar" value="0" />
<div id="AccionesListado">
<ul>
<li class="noicon" ><select name="id_serie_facturacion">
<option value="">PreDef</option>
@%where:tabla|Series_facturacion;no_link|1;where|ventas = 0;nombre|series;%@
<option value="@%db:Series_facturacion.id_serie%@"
>@%db:Series_facturacion.nombre;%@ 
(@%db:si_no_flag{Series_facturacion.contabilizable}%@)</option>
@%end-where:%@

</select></li>
<li><a href="#Consolidar Seleccionados" onclick="return onHRefClick('bo_pedidos_compras','accion_ejecutar','Facturar');"
	class="consolidar" ><img src="imag/pixel.png" class="icono" /><span>Consolider sur Sélectiones</span></a></li>
<li><a href="#Impresion Multiple" onclick="return SendFormToWindow('bo_pedidos_compras','bo_pedido_proveedor&imprimir=1&printit=1','ventana_impresion');"
	class="imprimirvarios" ><img src="imag/pixel.png" class="icono" /><span>Impressionn Multiple</span></a></li>
<li><a href="#Recalcular Seleccionados" onclick="return onHRefClick('bo_pedidos_compras','accion_ejecutar','Recalcular');"
	class="recalcular" ><img src="imag/pixel.png" class="icono" /><span>Insister Selectiones</span></a></li>
<li><a href="#Borrar Seleccionados" onclick="return onHRefClick('bo_pedidos_compras','accion_ejecutar','Borrar');"
	class="borrar" ><img src="imag/pixel.png" class="icono" /><span>Effacer sur Sélectiones</span></a></li>
</ul></div>

<table class="full">
<thead>
<tr>
<td ><a href="?_search_sort=Pedidos.referencia">Code<img src="imag/pixel.png" class="@%func:class_searchsort;Pedidos.referencia;%@" /></a></td>
<td></td>
<td class="estado">Comm</td>
<td class="estado">L</td>
<td class="estado">F</td>
<td ><a href="?_search_sort=Proveedores.razon_social">Fournisseur<img src="imag/pixel.png" class="@%func:class_searchsort;Proveedores.razon_social;%@" /></a></td>
<td ><a href="?_search_sort=Pedidos.fecha">Date<img src="imag/pixel.png" class="@%func:class_searchsort;Pedidos.fecha;%@" /></a></td>
<td ><a href="?_search_sort=monto_pedido">Quantite<img src="imag/pixel.png" class="@%func:class_searchsort;monto_pedido;%@" /></a></td>
</tr>
</thead>
<!-- @%set:none=rojo%@ @%set:do=amarillo%@ @%set:ok=verde%@ @%set:bad=negro%@ -->
<tbody>
 @%where:tabla|Pedidos;nombre|busc;no_results|1;order|Pedidos.fecha desc;cfunc|cf_pedidos;%@
<tr
@%if:!esta_vacio;Pedidos.id_pedido_incompleto;%@
 class="resalte"
@%end-if:%@
>
<td>
 <a href="?seccion=bo_pedido_proveedor&id_pedido=@%db:Pedidos.id_pedido;%@"
@%if:esta_vacio;Pedidos.id_pedido_incompleto;%@
 
@%else:%@
 class="accesos2"
@%end-if:%@
>
@%db:not_empty{Pedidos.referencia};%@
</a></td>
<td class="check">
@%if:esta_vacio;noborrar;%@
<input type="checkbox" name="registro_borrar[@%db:Pedidos.id_pedido;%@]" value="1" />
@%end-if:%@</td>

<td class="estado"><img src="imag/pixel.png" class="@%func:switch_alfa_dec;estado_pedido;none;do;ok;%@" /></td>

<td class="estado"><img src="imag/pixel.png" class="@%func:switch_alfa_dec;estado_albaran;none;do;ok;bad;%@" />
@%if:esta_vacio;link_albaran;%@
@%else:%@
<a href="?seccion=bo_albaranes_pedido&id_pedido=@%db:Pedidos.id_pedido%@"><img src="imag/pixel.png" class="ver" /></a>
@%end-if:%@
</td>

<td class="estado"><img src="imag/pixel.png" class="@%func:switch_alfa_dec;estado_factura;none;do;ok;%@" />
@%if:esta_vacio;link_factura;%@
@%else:%@
<a href="?seccion=bo_facturas_pedido_compra&id_pedido=@%db:Pedidos.id_pedido%@"><img src="imag/pixel.png" class="ver" /></a>
@%end-if:%@
</td>

<td>@%db:Proveedores.razon_social;%@ (@%db:Proveedores.nombre;%@)</td>
<td>@%db:colocar_fecha{Pedidos.fecha};%@</td>
<td>@%db:monto_pedido%@</td>
 </tr>
 @%end-where:%@

</tbody>
 </table>
 </form>

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

