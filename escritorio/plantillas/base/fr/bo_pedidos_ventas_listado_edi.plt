@%plt:botonera%@

<form name="bo_pedidos_ventas" method="post" action="?seccion=@%get:ss_nm;%@">
<input type="hidden" name="accion_ejecutar" value="0" />

<div id="AccionesListado"><ul>

<li class="noicon" ><select name="id_transportista">
<option value="">{{cfg_transportista_defecto}}</option>
@%where:tabla|Transportistas;no_link|1;nombre|transportista;%@
<option value="@%db:Transportistas.id_transportista%@"
>@%db:Transportistas.nombre;%@</option>
@%end-where:%@

</select></li>
<li><a href="#Generar Albaranes" 
	onclick="return SendFormToWindow('bo_pedidos_ventas','bo_albaran_almacen&imprimir=1&printit=1','ventana_impresion_albaranes','accion_ejecutar','GenerarAlbaranes');"
	class="generaralbaranes" ><img src="imag/pixel.png" class="icono" /><span>Génerér</span></a></li>

<li class="noicon" ><select name="id_serie_facturacion">
<option value="">PreDef</option>
@%where:tabla|Series_facturacion;no_link|1;where|ventas = 1;nombre|series;%@
<option value="@%db:Series_facturacion.id_serie%@"
>@%db:Series_facturacion.nombre;%@ 
(@%db:si_no_flag{Series_facturacion.contabilizable}%@)</option>
@%end-where:%@

</select></li>
<li><a href="#Consolidar Seleccionados" onclick="return onHRefClick('bo_pedidos_ventas','accion_ejecutar','Facturar');" 
	class="consolidar" ><img src="imag/pixel.png" class="icono" /><span>Consolider sur Sélectiones</span></a></li>

<li><a href="#Impresion Multiple" onclick="return SendFormToWindow('bo_pedidos_ventas','bo_pedido_cliente&imprimir=1&printit=1','ventana_impresion');"
	class="imprimirvarios" ><img src="imag/pixel.png" class="icono" /><span>Impressionn Multiple</span></a></li>
<li><a href="#Recalcular Seleccionados" onclick="return onHRefClick('bo_pedidos_ventas','accion_ejecutar','Recalcular');"
	class="recalcular" ><img src="imag/pixel.png" class="icono" /><span>Insister Selectiones</span></a></li>
<li><a href="#Borrar Seleccionados" onclick="return onHRefClick('bo_pedidos_ventas','accion_ejecutar','Borrar');"
	class="borrar" ><img src="imag/pixel.png" class="icono" /><span>Effacer sur Sélectiones</span></a></li>
</ul>
</div>
<table class="full">
<thead>
<tr>
<td ><a href="?_search_sort=Pedidos.referencia" class="order" >Code<img src="imag/pixel.png" class="@%func:class_searchsort;Pedidos.referencia;%@" /></a></td>
<td class="estado" ><img src="imag/pixel.png" class="marcartodos" onclick="return formCheckAll('registro_borrar');"  /></td>
<td class="estado">Comm</td>
<td class="estado">L</td>
<td class="estado">F</td>
<td ><a href="?_search_sort=Clientes.razon_social" class="order" >Client<img src="imag/pixel.png" class="@%func:class_searchsort;Clientes.razon_social;%@" /></a></td>
<td ><a href="?_search_sort=Pedidos.fecha" class="order" >Date<img src="imag/pixel.png" class="@%func:class_searchsort;Pedidos.fecha;%@" /></a></td>
<td ><a href="?_search_sort=monto_pedido" class="order" >Quantite<img src="imag/pixel.png" class="@%func:class_searchsort;monto_pedido;%@" /></a></td>
<td ><a href="?_search_sort=referencia_externa" class="order" >Réf. Ext<img src="imag/pixel.png" class="@%func:class_searchsort;referencia_externa;%@" /></a></td>
</tr>
</thead>

<tbody>
<!-- @%set:none=rojo%@ @%set:do=amarillo%@ @%set:ok=verde%@ @%set:bad=negro%@ -->
@%where:tabla|Pedidos;nombre|busc;no_results|1;order|Pedidos.fecha desc;cfunc|cf_pedidos;group|Pedidos.id_pedido;%@ 
<tr
@%if:!esta_vacio;Pedidos.id_pedido_incompleto;%@
 class="resalte"
@%else:%@
  @%if:esta_vacio;link_albaran;%@
  	@%if:!esta_vacio;Pedidos.residual;%@
  	class="impropio"
	@%end-if:%@
  @%end-if:%@
@%end-if:%@
>
<td><a href="?seccion=bo_pedido_cliente&id_pedido=@%db:Pedidos.id_pedido;%@" >
@%db:not_empty{Pedidos.referencia};%@</a></td>
<td class="check"><!--si no tiene una factura emitida -->
 @%if:esta_vacio;noborrar;%@
 <input type="checkbox" name="registro_borrar[@%db:Pedidos.id_pedido;%@]" value="1" />
 @%end-if:%@</td>
<td class="estado" ><img src="imag/pixel.png" class="@%func:switch_alfa_dec;estado_pedido;none;do;ok;%@" /></td>
<td class="estado" ><img src="imag/pixel.png" class="@%func:switch_alfa_dec;estado_albaran;none;do;ok;bad;%@" />
@%if:!esta_vacio;link_albaran;%@
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


