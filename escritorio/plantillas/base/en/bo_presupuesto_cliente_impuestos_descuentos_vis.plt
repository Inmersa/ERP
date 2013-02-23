@%where:nodb|nodb_order_data;nombre|totales;%@

@%if:esta_vacio;estado;%@
@%else:%@
<fieldset id="PedidoImpuestosDescuentos" class="fsficha">
<legend>Totals</legend>
<table class="fullstruct"><tr><td>
<table class="full">
<tr>
<td class="caption">Taxable Income</td>
<td class="caption">%</td>
<td class="caption">VAT</td>
<td class="caption">Surcharge</td>
</tr>
@%where:nodb|nodb_taxes_detail;%@
<td>@%db:base_imponible;%@</td>
<td>@%db:porcentaje;%@ / @%db:porcentaje_recargo_equivalente%@ %</td>
<td>@%db:recargo_iva;%@</td>
<td>@%db:recargo_equivalente;%@</td>
</tr>
@%end-where:%@

</table>
</td><td>
<table class="full">
<tr>
<td class="caption">Total gross amount</td>
<td class="caption">%</td>
<td class="caption">Amount</td>
</tr>
@%where:nodb|nodb_discounts_detail;%@
<tr>
<td>@%db:base_imponible;%@</td>
<td>@%db:nombre%@ @%db:descuento%@ %</td>
<td>@%db:importe;%@ </td>
@%end-where:%@

</table></td></tr></table>
</fieldset>
@%end-if:%@
