@%where:nodb|nodb_order_data;format_name|classDocument;%@
<!-- @%set:observaciones_pedido=observaciones;%@ -->
<table class="full">
<thead class="encabezado">
<tr>
 <td >Comanda</td>
 @%if:!esta_vacio;referencia_externa;%@
 <td >Ref. Ext</td>
 @%end-if:%@
 <td >Data</td>
 <td class="@%css:peso;label;%@" >Pes Total</td>
 <td class="@%css:nombre_forma_pago;label;%@">Mig de paga</td>
 <td class="@%css:agente;label;%@">Realitzat per</td>
 <td >Divisa</td>
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
