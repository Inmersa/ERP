@%where:nodb|nodb_order_data;format_name|classDocument;%@
<!-- @%set:observaciones_pedido=observaciones;%@ -->
<table class="full">
<thead class="encabezado">
<tr>
 <td >Order</td>
 @%if:!esta_vacio;referencia_externa;%@
 <td >Ext. Ref.</td>
 @%end-if:%@
 <td >Date</td>
 <td class="@%css:peso;label;%@" >T. Weight</td>
 <td class="@%css:nombre_forma_pago;label;%@">Payment Rules</td>
 <td class="@%css:agente;label;%@">Realized by</td>
 <td >Currency</td>
</tr>
</thead>
<tbody class="centrado">
<tr > 
 <td >@%db:referencia;%@</td>
 @%if:!esta_vacio;referencia_externa;%@
 <td >@%db:referencia_externa;%@</td>
 @%end-if:%@
 <td >@%db:colocar_fecha{fecha};%@</td>
 <td class="@%css:peso;%@" >@%db:peso%@ Kg</td>
 <td class="@%css:nombre_forma_pago;%@" >@%db:nombre_forma_pago;%@</td>
 <td class="@%css:agente;%@" >@%db:nombre_agente;%@ </td>
 <td >@%db:nombre_divisa;%@</td>
</tr>
</tbody>
</table>
@%end-where:%@
