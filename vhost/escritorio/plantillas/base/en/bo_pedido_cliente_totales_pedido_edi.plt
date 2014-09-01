<fieldset id="PedidoTotales" class="fsficha">
<legend>Totals</legend>
 @%where:nodb|nodb_order_totals;format_name|classDocument;%@
<table class="fullstruct">

<tr><td>

<table class="full">

<tr>
<td class="etiqueta">Total gross amount:</td>
<td>@%db:bruto;%@</td>
</tr>

<tr>
<td class="etiqueta">Total Discount:</td>
<td>@%db:descuentos%@</td>
</tr>
<tr>
<td class="etiqueta">Total Taxable Income:</td>
<td>@%db:base_imponible;%@ </td>
</tr>
<tr>
<td class="etiqueta">Total Taxes:</td>
<td>@%db:total_impuestos%@ </td>
</tr>
<tr>
<td class="etiqueta">Deduction:</td>
<td>@%db:retenido%@ </td>
</tr>
</table>
</td><td>
<table class="full">
<tr><td class="caption">Total amount</td></tr>
<tr><td>@%db:importe;%@ @%db:leyenda_divisa%@</td></tr>
@%if:esta_vacio;divisa_cliente_importe%@
@%else:%@
<tr><td>
Total amount in @%db:divisa_cliente_nombre%@
@%db:divisa_cliente_importe;%@ @%db:divisa_cliente_leyenda%@
</td></tr>
@%end-if:%@
@%end-where:%@

</table>
</td></tr></table>

</fieldset>
