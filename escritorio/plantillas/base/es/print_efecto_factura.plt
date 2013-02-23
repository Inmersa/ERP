
<table class="full">
<thead class="encabezado">
<tr>
 <td >Recibo </td>
 <td >Tipo </td>
 <td >Fecha Vencimiento </td>
 <td >Importe </td>
</tr>
</thead>
<tbody class="centrado">
 <tr >
 <td >@%db:Efectos.id_efecto;%@</td>
 <td><!-- @%db:Efectos.pago_cobro;%@ -->
 @%if:esta_vacio;Efectos.pago_cobro%@
	Efecto de Pago
 @%else:%@
 	Efecto de Cobro
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
 <td >Factura 
 @%if:esta_vacio;es_proforma;%@
	 @%if:!esta_vacio;es_abono;%@
	Abono
	@%end-if:%@
 @%else:%@
 Proforma 
 @%end-if:%@
 </td>
 <td >Ref. Ext.</td>
 <td >Fecha</td>
 <td >Forma de pago</td>
 <td >Divisa</td>
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

