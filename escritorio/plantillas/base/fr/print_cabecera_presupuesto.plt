@%where:nodb|nodb_order_data;%@
<!-- @%set:observaciones_pedido=observaciones;%@ -->
<table class="full">
<thead class="encabezado">
<tr>
@%if:esta_vacio;es_proforma;%@
 <td >Devis</td>
@%else:%@
 <td >Facture Proforma</td>
@%end-if:%@
 <td >Date</td>
 <td >Pèse Total</td>
 <td >Modalité de paiment</td>
 <td >Réalisé par</td>
 <td >Devise</td>
</tr>
</thead>
<tbody class="centrado">
<tr > 
 <td >@%db:referencia;%@</td>
 <td >@%db:colocar_fecha{fecha};%@</td>
 <td >@%db:peso%@ Kg</td>
 <td >@%db:nombre_forma_pago;%@</td>
 <td >@%db:nombre_agente;%@ </td>
 <td >@%db:nombre_divisa;%@</td>
</tr>
</tbody>
</table>
@%end-where:%@
