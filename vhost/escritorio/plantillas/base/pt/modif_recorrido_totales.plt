
<!-- @%db:Recorridos.id_recorrido;%@ -->

@%set:hay_efectospagados = 1;%@
<fieldset class="fsficha" >
<legend>Pagamentos Pagos</legend>
<table class="full" ><thead><tr>
<td>Cliente</td>
<td>Referência</td>
<td>Data</td>
<td>Montante Total</td>
<td>Meio de Pagamento</td>
<td>Pagamento Parcial</td>
</tr></thead>
<tbody>

@%where:tabla|Efectos_parciales;ruta_path|Efectos.id_factura;%@
<!-- @%db:Efectos_parciales.id_efecto;%@ @%db:Efectos.id_factura;%@ -->

 <tr>
 <td><a href="?seccion=modif_cliente&id_cliente=@%db:Clientes.id_cliente;%@" >@%db:Clientes.razon_social;%@</a></td>
 <td><a href="?seccion=bo_factura_cliente=@%db:Facturas.id_factura;%@" >@%db:Facturas.referencia%@</a></td>
 <td>@%db:colocar_fecha{Efectos_parciales.fecha}%@</td>
 <td>@%db:Efectos.monto%@</td>
 <!-- 
 @%db:Efectos.monto_pagado;%@ 
 @%set:pagado = Efectos.monto_pagado;%@ @%set:importe = Efectos.monto;%@ 
 @%calc:importe - pagado;output|1;round|2;%@ @%db:Divisa.leyenda%@
 -->

 <td>@%db:Efectos_parciales.medio_pago;%@</td>
 <td>@%db:Efectos_parciales.monto_satisfecho%@</td>
 </tr>
@%end-where:%@

@%if:!esta_vacio;hay_efectospagados;%@
</tbody></table>
</fieldset>
@%end-if:%@

