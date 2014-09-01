@%where:nodb|nodb_order_data;nombre|totales;format_name|classDocument;%@
<fieldset id="PedidoImpuestosDescuentos" class="fsficha">
<legend>Totales</legend>
<table class="fullstruct"><tr><td>
<table class="full">
<tr>
<td class="caption">Base imponible</td>
<td class="caption">%</td>
<td class="caption">IVA/IGIC</td>
<td class="caption">R. equiv.</td>
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
<td class="caption">T. Bruto</td>
<td class="caption">%</td>
<td class="caption">Importe</td>
</tr>
@%where:nodb|nodb_discounts_detail;%@
<tr>
<td>@%db:base_imponible;%@</td>
<td>@%db:nombre%@ @%db:descuento;%@ %</td>
<td>@%db:importe;%@ </td>
@%end-where:%@

</table></td></tr></table>
</fieldset>

