<fieldset id="PedidoTotales" class="fsficha">
<legend>Totalit�</legend>
 @%where:nodb|nodb_order_totals;format_name|classDocument;%@
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
<td class="etiqueta">Totals Imp�t:</td>
<td>@%db:total_impuestos%@ </td>
</tr>
<tr>
<td class="etiqueta">R�tention:</td>
<td>@%db:retenido%@ </td>
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
