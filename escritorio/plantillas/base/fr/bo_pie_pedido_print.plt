@%where:format_name|classDocument;%@

<div id="pie">
<table class="fullstruct">
<tr><td class="left">

<table class="full">
<thead class="encabezado">
<tr>
<td >Revenu imposable</td>
<td >%</td>
<td >Taxe</td>
<td >Reteneu �quivalent</td>
</tr>
</thead>
<tbody class="bordes">
 @%where:nodb|nodb_taxes_detail;%@ 
 <td >@%db:base_imponible;%@</td>
 <td >@%db:porcentaje%@ / @%db:porcentaje_recargo_equivalente;%@</td>
 <td >@%db:recargo_iva;%@</td>
 <td >@%db:recargo_equivalente;%@</td>
 </tr>
 @%end-where:%@ 

</tbody>
</table>

</td><td class="right">

<!-- Descuentos -->
<table class="full">
<thead class="encabezado">
<tr>
 <td bgcolor="#DBE0E3" class="titul" align="center" height="15" width="55">Montant brut</td>
 <td bgcolor="#DBE0E3" height="15" class="titul" align="center">%Rem.</td>
 <td bgcolor="#DBE0E3" align="center" height="15" class="titul" width="55">Montant</td>
</tr>
</thead>
<tbody class="bordes" >
 @%where:nodb|nodb_discounts_detail;%@ 
 <tr> 
 <td >@%db:base_imponible;%@</td>
 <td >@%db:nombre%@ @%db:descuento%@</td>
 <td >@%db:importe;%@</td>
 </tr>
 @%end-where:%@ 

</tbody>
</table>

</td></tr>
</table>
<table class="fullstruct">

@%where:nodb|nodb_order_totals;%@

<tr><td class="left">

<table class="full">
 <tr><td class="etiqueta">Totals:</td><td >@%db:bruto%@</td></tr>
 <tr><td class="etiqueta">T. Remise:</td><td >@%db:descuentos%@</td></tr>
 <tr><td class="etiqueta">Total revenu imposable:</td><td >@%db:base_imponible%@</td></tr>
 <tr><td class="etiqueta">Totals Imp�t:</td><td >@%db:total_impuestos%@</td></tr>
 <tr><td class="etiqueta">R�tention:</td><td >@%db:retenido%@</td></tr>
</table>

</td><td class="middle">

<table class="full">
<thead class="encabezado"><tr><td>Notes</td></tr></thead>
<tbody><tr><td>@%get:observaciones_pedido;%@</td></tr></tbody>
</table>

</td><td class="right">

<table class="full">
<thead class="encabezado"><tr><td>Montant</td></tr></thead>
<tbody><tr><td>@%db:importe;%@ @%db:leyenda_divisa%@</td></tr></tbody>
</table>

</td></tr>
@%end-where:%@

</table>

</td></tr>
</table>
Document Produit Par Ordinateur
</div>
