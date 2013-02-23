@%where:nodb|nodb_order_data;nombre|totales;%@
<fieldset id="" class="fsficha">
<legend>Totals</legend>
<table class="fullstruct">
<tr><td>
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



<!-- @%set:notas=observaciones;%@ -->
 @%where:nodb|nodb_order_totals;%@
</table></td></tr></table>

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
<tr>
<td class="caption">Notes:</td>
</tr>
<tr>
<td><textarea name="factura[observaciones]" cols="30" wrap="VIRTUAL" rows="4">@%get:notas;%@</textarea></td>
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
