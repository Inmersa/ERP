@%where:nodb|nodb_order_data;nombre|totales;%@

@%if:esta_vacio;estado;%@
@%else:%@
<fieldset id="PedidoImpuestosDescuentos" class="fsficha">
<legend>Totalité</legend>
<table class="fullstruct"><tr><td>
<table class="full">
<tr>
<td class="caption">Revenu imposable</td>
<td class="caption">%</td>
<td class="caption">Taxe</td>
<td class="caption">Reteneu équivalent</td>
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
<td class="caption">Montant brut</td>
<td class="caption">%</td>
<td class="caption">Montant</td>
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
