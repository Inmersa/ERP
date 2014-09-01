
<table class="full">
<thead class="encabezado">
<tr>
 <td >Rebut </td>
 <td >Tipus </td>
 <td >Data venciment </td>
 <td >Import </td>
</tr>
</thead>
<tbody class="centrado">
 <tr >
 <td >@%db:Efectos.id_efecto;%@</td>
 <td><!-- @%db:Efectos.pago_cobro;%@ -->
 @%if:esta_vacio;Efectos.pago_cobro%@
	Efecte de Pagament
 @%else:%@
 	Efecte de Cobrament
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
 <td >Factures 
 @%if:esta_vacio;es_proforma;%@
	 @%if:!esta_vacio;es_abono;%@
	Paga
	@%end-if:%@
 @%else:%@
 Proforma 
 @%end-if:%@
 </td>
 <td >Ref. Ext</td>
 <td >Data</td>
 <td >Mig de paga</td>
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

