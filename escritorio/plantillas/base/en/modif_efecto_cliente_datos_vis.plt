@%where:tabla|Efectos;where|Efectos.id_efecto= $id_efecto%@ 
<!-- @%db:Efectos.id_efecto%@ -->
<fieldset id="DatosEfecto" class="fsficha">
<legend>Bank Drafts Data</legend>
<table class="full">
<tr>
<td class="etiqueta">Client:</td>
<td>@%db:Clientes.razon_social%@</td>
</tr>

<tr>
<td class="etiqueta">Concept: </td>
<td>@%db:Efectos.concepto%@</td>
</tr>

<tr>
<td class="etiqueta">Invoices Ref.: </td>
<td>@%db:Facturas.referencia%@</td>
</tr>

<tr>
<td class="etiqueta">IBAN: </td>
<td>@%db:Clientes_empresas.iban%@ @%db:Clientes_empresas.entidad%@ @%db:Clientes_empresas.oficina%@ @%db:Clientes_empresas.cuenta_bancaria%@</td>
</tr>

<tr>
<td class="etiqueta">Payment Rules: </td>
 <!-- @%db:Facturas.id_forma_pago%@ -->
 @%set:id_pago=Facturas.id_forma_pago%@<td>
 @%where:tabla|Forma_pago;nolink|1;where|id_forma_pago= $id_pago;%@ 
@%db:Forma_pago.nombre%@ 
@%end-where:%@

 </td>
</tr>

<tr>
<td class="etiqueta">Payment way: </td>
<td>@%db:Efectos.medio_pago%@</td>
</tr>

<tr>
<td class="etiqueta">Bank: </td>
<td>
@%where:tabla|Bancos;nolink|0;%@
@%db:Bancos.nombre%@
@%end-where:%@

 </td>
</tr>

<tr>
<td class="etiqueta">Due date: </td>
<td>@%db:colocar_fecha{Efectos.fecha_vencimiento}%@</td>
</tr>
<tr><td class="etiqueta">Payment date:</td><td> @%db:colocar_fecha{Efectos.fecha_abono}%@ </td></tr>

<tr><td class="etiqueta">Return date:</td><td> @%db:colocar_fecha{Efectos.fecha_devolucion}%@ </td></tr>

<tr><td class="etiqueta">Total:</td><td>@%db:Efectos.monto%@ @%db:Divisa.leyenda%@</td></tr>

<tr><td class="etiqueta">Total Payment:</td><td>@%db:Efectos.monto_pagado;%@ @%db:Divisa.leyenda%@</td></tr>

<tr><td class="etiqueta">Condition:</td>
<td>
Issued (@%db:si_no_flag{Efectos.emitido}%@) 
Credited (@%db:si_no_flag{Efectos.pagado}%@) 
Returned (@%db:si_no_flag{Efectos.devuelto}%@)</td></tr>
</table>
</fieldset>

