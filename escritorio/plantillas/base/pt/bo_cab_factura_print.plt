@%where:nodb|nodb_order_data;format_name|classDocument;%@
<!-- @%set:observaciones_pedido=observaciones;%@ -->
<table class="full">
<thead class="encabezado">
<tr>
 <td >
 @%if:!esta_vacio;factura_abono;%@
 Nota de Crédito
 @%else:%@
 Factura 
 @%end-if:%@
 </td>
 <td >Ref. Externa</td>
 <td >Data</td>
 @%if:!esta_vacio;factura_abono;%@
 <td >Facturas que credita</td>
 @%else:%@
 <td class="@%css:peso;label;%@" >Peso Total</td>
 @%end-if:%@
 <td >Método de Pagamento</td>
 <td >Divisa</td>
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
