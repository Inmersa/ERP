@%where:nodb|nodb_order_data;format_name|classDocument;%@
<!-- @%set:observaciones_pedido=observaciones;%@ -->
<table class="full">
<thead class="encabezado">
<tr>
 <td >
 @%if:!esta_vacio;factura_abono;%@
 Facture d'Engrais
 @%else:%@
 Factures 
 @%end-if:%@
 </td>
 <td >Réf. Ext</td>
 <td >Date</td>
 @%if:!esta_vacio;factura_abono;%@
 <td >Factures qu'il crédite</td>
 @%else:%@
 <td class="@%css:peso;label;%@" >Pèse Total</td>
 @%end-if:%@
 <td >Modalité de paiment</td>
 <td >Devise</td>
</tr>
</thead>
<tbody class="centrado">
 <tr >
 <td >@%db:referencia;%@</td>
 <td >@%db:referencia_externa;%@</td>
 <td >@%db:colocar_fecha{fecha};%@</td>
 @%if:!esta_vacio;factura_abono;%@
 <td>
 @%where:nodb|nodb_invoice_installments;contador|i;nombre|Abonos;%@
 @%if:!equals;i;1;%@
 ,
 @%end-if:%@
 @%db:referencia;%@
 @%end-where:%@

 </td>
 @%else:%@
 <td class="@%css:peso;%@" >@%db:peso%@ Kg</td>
 @%end-if:%@
 <td >@%db:nombre_forma_pago%@</td>
 <td >@%db:nombre_divisa;%@</td>
 </tr>
</tbody>
</table>
@%end-where:%@
