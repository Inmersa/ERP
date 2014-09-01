@%where:nodb|nodb_order_data;nombre|totales;%@
<fieldset id="" class="fsficha">
<legend>Totalité</legend>
<table class="fullstruct">
<tr><td>
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



<!-- @%set:notas=observaciones;%@ -->
 @%where:nodb|nodb_order_totals;%@
</table></td></tr></table>

<table class="fullstruct">

<tr><td>

<table class="full">

<tr>
<td class="etiqueta">Montant brut:</td>
<td>@%db:bruto;%@</td>
</tr>

<tr>
<td class="etiqueta">Total Remise:</td>
<td>@%db:descuentos%@</td>
</tr>
<tr>
<td class="etiqueta">Total revenu imposable:</td>
<td>@%db:base_imponible;%@ </td>
</tr>
<tr>
<td class="etiqueta">Totals Impôt:</td>
<td>@%db:total_impuestos%@ </td>
</tr>
<tr>
<td class="etiqueta">Rétention:</td>
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
<tr><td class="caption">Montant</td></tr>
<tr><td>@%db:importe;%@ @%db:leyenda_divisa%@</td></tr>

@%if:esta_vacio;divisa_cliente_importe%@
@%else:%@
<tr><td>
Montant @%db:divisa_cliente_nombre%@
@%db:divisa_cliente_importe;%@ @%db:divisa_cliente_leyenda%@
</td></tr>
@%end-if:%@

@%end-where:%@

</table>
</td></tr></table>



</fieldset>
