@%where:nodb|nodb_order_data;nombre|totales;%@
<fieldset id="" class="fsficha">
<legend>Totais</legend>
<table class="fullstruct">
<tr><td>
<table class="full">
<tr>
<td class="caption">Valor Tribut�vel</td>
<td class="caption">%</td>
<td class="caption"></td>
<td class="caption">Sobretaxa Equivalente</td>
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
<td class="caption">Total Bruto</td>
<td class="caption">%</td>
<td class="caption">Montante</td>
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
<td class="etiqueta">Total Bruto:</td>
<td>@%db:bruto;%@</td>
</tr>

<tr>
<td class="etiqueta">Desconto Total:</td>
<td>@%db:descuentos%@</td>
</tr>
<tr>
<td class="etiqueta">Total do Valor Tribut�vel:</td>
<td>@%db:base_imponible;%@ </td>
</tr>
<tr>
<td class="etiqueta">Total de Impostos:</td>
<td>@%db:total_impuestos%@ </td>
</tr>
<tr>
<td class="etiqueta">Reten��o:</td>
<td>@%db:retenido%@ </td>
</tr>
</table>
</td><td>
<table class="full">
<tr>
<td class="caption">Notas:</td>
</tr>
<tr>
<td><textarea name="factura[observaciones]" cols="30" wrap="VIRTUAL" rows="4">@%get:notas;%@</textarea></td>
</tr>
</table>
</td><td>
<table class="full">
<tr><td class="caption">Montante Total</td></tr>
<tr><td>@%db:importe;%@ @%db:leyenda_divisa%@</td></tr>

@%if:esta_vacio;divisa_cliente_importe%@
@%else:%@
<tr><td>
Montante de @%db:divisa_cliente_nombre%@
@%db:divisa_cliente_importe;%@ @%db:divisa_cliente_leyenda%@
</td></tr>
@%end-if:%@

@%end-where:%@

</table>
</td></tr></table>



</fieldset>
