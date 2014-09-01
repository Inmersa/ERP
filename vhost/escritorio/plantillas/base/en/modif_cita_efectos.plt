
<!-- @%db:Citas.id_cita;%@ -->
@%where:tabla|Efectos_parciales;%@
<!-- @%db:Efectos_parciales.id_efecto;%@ -->
@%if:primera_vez;%@
@%set:hay_efectospagados = 1;%@
<fieldset class="fsficha" >
<legend>Paid Bank Drafts</legend>
<table class="full" >
<thead>
<tr>
<td>Reference</td>
<td>Date</td>
<td>Total amount</td>
<td>Payment way</td>
<td>Partial payment</td>
<td>Notes</td>
</tr>
</thead>
<tbody>
@%end-if:%@

 <tr>
 <td><a href="?seccion=bo_factura_cliente=@%db:Facturas.id_factura;%@" >@%db:Facturas.referencia%@</a></td>
 <td>@%db:colocar_fecha{Efectos_parciales.fecha}%@</td>
 <td>
 @%if:AllowedLink;modif_efectos_cliente;%@
 <a href="?seccion=modif_efectos_cliente&id_efecto=@%db:Efectos.id_efecto;%@" >@%db:Efectos.monto%@</a>
 @%else:%@
 @%db:Efectos.monto%@
 @%end-if:%@
 </td>
 <!-- 
 @%db:Efectos.monto_pagado;%@ 
 @%set:pagado = Efectos.monto_pagado;%@ @%set:importe = Efectos.monto;%@ 
 @%calc:importe - pagado;output|1;round|2;%@ @%db:Divisa.leyenda%@
 -->

 <td>@%db:Efectos_parciales.medio_pago;%@</td>
 <td>@%db:Efectos_parciales.monto_satisfecho%@</td>
 <td>@%db:Efectos_parciales.notas;%@</td>
 </tr>
@%end-where:%@

@%if:!esta_vacio;hay_efectospagados;%@
</tbody>
</table>
</fieldset>
@%end-if:%@

