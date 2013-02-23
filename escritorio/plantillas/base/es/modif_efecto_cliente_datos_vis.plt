@%where:tabla|Efectos;where|Efectos.id_efecto= $id_efecto%@ 
<!-- @%db:Efectos.id_efecto%@ -->
<fieldset id="DatosEfecto" class="fsficha">
<legend>Datos de Efecto</legend>
<table class="full">
<tr>
<td class="etiqueta">Cliente:</td>
<td>@%db:Clientes.razon_social%@</td>
</tr>

<tr>
<td class="etiqueta">Concepto: </td>
<td>@%db:Efectos.concepto%@</td>
</tr>

<tr>
<td class="etiqueta">Ref. Factura: </td>
<td>@%db:Facturas.referencia%@</td>
</tr>

<tr>
<td class="etiqueta">Cuenta Bancaria IBAN: </td>
<td>@%db:Clientes_empresas.iban%@ @%db:Clientes_empresas.entidad%@ @%db:Clientes_empresas.oficina%@ @%db:Clientes_empresas.cuenta_bancaria%@</td>
</tr>

<tr>
<td class="etiqueta">Forma de pago: </td>
 <!-- @%db:Facturas.id_forma_pago%@ -->
 @%set:id_pago=Facturas.id_forma_pago%@<td>
 @%where:tabla|Forma_pago;nolink|1;where|id_forma_pago= $id_pago;%@ 
@%db:Forma_pago.nombre%@ 
@%end-where:%@

 </td>
</tr>

<tr>
<td class="etiqueta">Medio pago: </td>
<td>@%db:Efectos.medio_pago%@</td>
</tr>

<tr>
<td class="etiqueta">Nombre Banco: </td>
<td>
@%where:tabla|Bancos;nolink|0;%@
@%db:Bancos.nombre%@
@%end-where:%@

 </td>
</tr>

<tr>
<td class="etiqueta">Fecha Vencimiento: </td>
<td>@%db:colocar_fecha{Efectos.fecha_vencimiento}%@</td>
</tr>
<tr><td class="etiqueta">Fecha Abono:</td><td> @%db:colocar_fecha{Efectos.fecha_abono}%@ </td></tr>

<tr><td class="etiqueta">Fecha Devolucion:</td><td> @%db:colocar_fecha{Efectos.fecha_devolucion}%@ </td></tr>

<tr><td class="etiqueta">Total:</td><td>@%db:Efectos.monto%@ @%db:Divisa.leyenda%@</td></tr>

<tr><td class="etiqueta">T. Pagado:</td><td>@%db:Efectos.monto_pagado;%@ @%db:Divisa.leyenda%@</td></tr>

<tr><td class="etiqueta">Estado:</td>
<td>
Emitido (@%db:si_no_flag{Efectos.emitido}%@) 
Abonado (@%db:si_no_flag{Efectos.pagado}%@) 
Devuelto (@%db:si_no_flag{Efectos.devuelto}%@)</td></tr>
</table>
</fieldset>

