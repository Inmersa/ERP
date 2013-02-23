@%where:nodb|nodb_order_data;nombre|totales;format_name|classDocument;%@

@%set:_page_css = primerapagina;%@
@%plt:print_pagebreak;%@

@%if:!esta_vacio;factura_abono;%@
@%set:es_abono=1;%@
@%end-if:%@

@%plt:voip_print_cabecera;%@

@%plt:cabecera_documento;%@

<div class="titulo">Resum de Factura</div>
<div class="resumen" >

<table class="subtotal">

@%where:nodb|nodb_order_totals;nombre|detalleTotales;%@
 <tr><td class="etiqueta">Consum:</td><td >@%db:bruto%@</td></tr>
@%end-where:%@

@%where:nodb|nodb_discounts_detail;%@
<tr><td class="etiqueta">Descomptes @%db:nombre%@ (@%db:descuento%@ %)</td><td>@%db:importe;%@ </td></tr>
@%end-where:%@

@%where:nodb|nodb_taxes_detail;%@
<tr>
<td class="etiqueta">IVA
(@%db:porcentaje;%@ 
@%if:!esta_vacio;recargo_equivalente;%@
/ @%db:porcentaje_recargo_equivalente%@ 
@%end-if:%@
%)</td><td>@%db:recargo_iva;%@
@%if:!esta_vacio;recargo_equivalente;%@
/ @%db:recargo_equivalente%@ 
@%end-if:%@
</td></tr>
@%end-where:%@

@%where:nodb|nodb_order_totals;nombre|detalleTotales;%@
 <tr><td class="etiqueta">T. Descomptes:</td><td >@%db:descuentos%@</td></tr>
 @%if:!esta_vacio;retenido;%@
 <tr><td class="etiqueta">Retenci�:</td><td >@%db:retenido%@</td></tr>
 @%end-if:%@
@%end-where:%@

</table>

@%where:nodb|nodb_order_totals;nombre|Totales;%@
<table class="total">
 <tr>
 <td class="etiqueta">Total base imposable</td>
 <td class="etiqueta">Estalvi respecte a Telef�nica</td>
 <td class="etiqueta">Totals Imposts</td>
 <td class="etiqueta">Total a Pagar</td>
 </tr>

 <tr>
 <td >@%db:base_imponible%@</td>
 <td >@%func:voip_ahorro_competencia%@</td>
 <td >@%db:total_impuestos%@</td>
 <td >@%db:importe;%@ @%db:leyenda_divisa%@</td>
 </tr>
</table>
@%end-where:%@

</td></tr>
</table>

</div></div>

