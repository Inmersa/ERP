
<table class="full">
<thead class="encabezado">
<tr>
 <td >Receipt </td>
 <td >Type </td>
 <td >Due date </td>
 <td >Amount </td>
</tr>
</thead>
<tbody class="centrado">
 <tr >
 <td >@%db:Efectos.id_efecto;%@</td>
 <td><!-- @%db:Efectos.pago_cobro;%@ -->
 @%if:esta_vacio;Efectos.pago_cobro%@
	Effect of Payment
 @%else:%@
 	Effect of Charge
 @%end-if:%@
 </td>
 <td >@%db:colocar_fecha{Efectos.fecha_vencimiento};%@</td>
 <!-- @%db:Efectos.monto;%@ @%db:Efectos.monto_pagado;%@ -->
 @%if:!esta_vacio;id_efecto_parcial;%@
 	@%where:tabla|Efectos_parciales;where|id_efecto_parcial = $id_efecto_parcial;%@
	<!-- @%db:Efectos_parciales.monto_satisfecho;%@ @%set:importe=Efectos_parciales.monto_satisfecho;value|var;%@ -->
	@%end-where:%@

 @%else:%@
 	@%calc:importe = Efectos.monto - Efectos.monto_pagado;%@
 @%end-if:%@
 <td >@%get:importe;%@</td>
 </tr>
</tbody>
</table>

@%where:nodb|nodb_order_data;%@
<table class="full">
<thead class="encabezado">
<tr>
 <td >Invoices 
 @%if:esta_vacio;es_proforma;%@
	 @%if:!esta_vacio;es_abono;%@
	Payments
	@%end-if:%@
 @%else:%@
 Pre-Invoice 
 @%end-if:%@
 </td>
 <td >Ext. Ref.</td>
 <td >Date</td>
 <td >Payment Rules</td>
 <td >Currency</td>
</tr>
</thead>
<tbody class="centrado">
 <tr >
 <td >@%db:referencia;%@</td>
 <td >@%db:referencia_externa;%@</td>
 <td >@%db:colocar_fecha{fecha};%@</td>
 <td >@%db:nombre_forma_pago%@</td>
 <td >@%db:nombre_divisa;%@</td>
 </tr>
</tbody>
</table>
@%end-where:%@

