@%where:nodb|nodb_order_data;nombre|totales;%@
@%if:esta_vacio;estado;%@
@%else:%@
<fieldset id="PedidoTotales" class="fsficha">
<legend>Totals</legend>
 @%where:nodb|nodb_order_totals;%@
<table class="fullstruct">

<tr><td>

<table class="full">

<tr>
<td class="etiqueta">Import gros:</td>
<td>@%db:bruto;%@</td>
</tr>

<tr>
<td class="etiqueta">Total Descompte:</td>
<td>@%db:descuentos%@</td>
</tr>
<tr>
<td class="etiqueta">Total base imposable:</td>
<td>@%db:base_imponible;%@ </td>
</tr>
<tr>
<td class="etiqueta">Totals Imposts:</td>
<td>@%db:total_impuestos%@ </td>
</tr>
<tr>
<td class="etiqueta">Retenció:</td>
<td>@%db:retenido%@ </td>
</tr>
</table>
</td><td>
<table class="full">
<tr><td class="caption">Import Total</td></tr>
<tr><td>@%db:importe;%@ @%db:leyenda_divisa%@</td></tr>
@%if:esta_vacio;divisa_cliente_importe%@
@%else:%@
<tr><td>
Import en @%db:divisa_cliente_nombre%@
@%db:divisa_cliente_importe;%@ @%db:divisa_cliente_leyenda%@
</td></tr>
@%end-if:%@
@%end-where:%@

</table>
</td></tr></table>

</fieldset>
@%end-if:%@
