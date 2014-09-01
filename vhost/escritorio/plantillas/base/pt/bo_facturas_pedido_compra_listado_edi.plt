<table class="full">
<tr>
<td class="caption">Ref.</td>

<td class="caption">Data</td>

<td class="caption">Valor Tributável</td>

<td class="caption">Impostos</td>

<td class="caption">Total</td>

<td class="caption">Estado</td>

</tr>
 @%where:tabla|Pedidos_facturas;where|id_pedido = $id_pedido;%@
<!-- @%db:Pedidos_facturas.id_pedido;%@ -->
<tr>
<td><a href="?seccion=bo_factura_proveedor&id_factura=@%db:Facturas.id_factura;%@">
 @%if:esta_vacio;Facturas.referencia;%@
 - -
 @%else:%@
 @%db:Facturas.referencia;%@
 @%end-if:%@
 </a></td>

<td>@%db:colocar_fecha{Facturas.fecha};%@</td>

<td>@%db:Facturas.base_imponible;%@</td>

<td>@%db:Facturas.total_impuestos;%@</td>

<td>@%db:Facturas.monto_total;%@</td>

<td><!--@%db:Facturas.estado;%@-->
@%func:estado_factura%@ </td>

</tr>
@%end-where:%@


</table>
<div class="barraoscura">Legenda</div>
<table class="full">

<tr>
<td class="etiqueta">Factura</td>
<td><img src="imag/verde.gif" width="14" height="14" /></td>
<td class="etiqueta">Emitida</td>
<td><img src="imag/amarillo.gif" width="14" height="14" /></td>
<td class="etiqueta">Por Emitir</td>
<td><img src="imag/rojo.gif" width="14" height="14" /></td>
<td class="etiqueta">Sem Factura</td>
</tr>

</table>



