
<table class="full">
<tr>
<td class="caption">Ref.</td>
<td class="caption">Date</td>
<td class="caption">Revenu imposable</td>
<td class="caption">Impôt</td>
<td class="caption">Totals</td>
<td class="caption">État</td>
</tr>
<!-- @%set:do=cuadrado.png%@ @%set:ok=circulo.png%@ -->
 @%where:tabla|Pedidos_facturas;where|id_pedido = $id_pedido;order|Facturas.fecha desc;%@
<!-- @%db:Pedidos_facturas.id_pedido;%@ @%db:Facturas.estado;%@ @%db:Facturas.factura_abono;%@ -->
<tr
@%if:!esta_vacio;Facturas.factura_abono;%@
 class="impropio"
@%end-if:%@
>
<td><a href="?seccion=bo_factura_cliente&id_factura=@%db:Pedidos_facturas.id_factura;%@"
>@%db:not_empty{Facturas.referencia};%@</a></td>
<td>@%db:colocar_fecha{Facturas.fecha};%@</td>
<td>@%db:Facturas.base_imponible;%@</td>
<td>@%db:Facturas.total_impuestos;%@</td>
<td>@%db:Facturas.monto_total;%@</td>
<td><img src="imag/@%func:switch_alfa_dec;Facturas.estado;do;ok;%@" /></td>
 </tr>

 @%end-where:%@

 </table>
<div class="barraoscura">Légende</div>
 
<table class="full">
<td class="etiqueta">Factures</td>
<td><img src="imag/@%get:ok;%@" width="14" height="14" /></td>
<td class="etiquetacheck">Émis</td>
<td><img src="imag/@%get:do;%@" width="14" height="14" /></td>
<td class="etiquetacheck">Sans émettre</td>
<!-- 
td><img src="imag/rojo.gif" width="14" height="14" /></td>
<td class="etiqueta">Sans facture</td-->
</tr>
</table>





