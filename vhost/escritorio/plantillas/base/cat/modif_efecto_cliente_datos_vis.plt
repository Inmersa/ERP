@%where:tabla|Efectos;where|Efectos.id_efecto= $id_efecto%@ 
<!-- @%db:Efectos.id_efecto%@ -->
<fieldset id="DatosEfecto" class="fsficha">
<legend>Dates Efecte</legend>
<table class="full">
<tr>
<td class="etiqueta">Client:</td>
<td>@%db:Clientes.razon_social%@</td>
</tr>

<tr>
<td class="etiqueta">Concepte: </td>
<td>@%db:Efectos.concepto%@</td>
</tr>

<tr>
<td class="etiqueta">Ref. Factures: </td>
<td>@%db:Facturas.referencia%@</td>
</tr>

<tr>
<td class="etiqueta">Compte bancari IBAN: </td>
<td>@%db:Clientes_empresas.iban%@ @%db:Clientes_empresas.entidad%@ @%db:Clientes_empresas.oficina%@ @%db:Clientes_empresas.cuenta_bancaria%@</td>
</tr>

<tr>
<td class="etiqueta">Mig de paga: </td>
 <!-- @%db:Facturas.id_forma_pago%@ -->
 @%set:id_pago=Facturas.id_forma_pago%@<td>
 @%where:tabla|Forma_pago;nolink|1;where|id_forma_pago= $id_pago;%@ 
@%db:Forma_pago.nombre%@ 
@%end-where:%@

 </td>
</tr>

<tr>
<td class="etiqueta">Mig de pagament: </td>
<td>@%db:Efectos.medio_pago%@</td>
</tr>

<tr>
<td class="etiqueta">Banc: </td>
<td>
@%where:tabla|Bancos;nolink|0;%@
@%db:Bancos.nombre%@
@%end-where:%@

 </td>
</tr>

<tr>
<td class="etiqueta">Data venciment: </td>
<td>@%db:colocar_fecha{Efectos.fecha_vencimiento}%@</td>
</tr>
<tr><td class="etiqueta">Data abonament:</td><td> @%db:colocar_fecha{Efectos.fecha_abono}%@ </td></tr>

<tr><td class="etiqueta">Data devolució:</td><td> @%db:colocar_fecha{Efectos.fecha_devolucion}%@ </td></tr>

<tr><td class="etiqueta">Totals:</td><td>@%db:Efectos.monto%@ @%db:Divisa.leyenda%@</td></tr>

<tr><td class="etiqueta">Total pagat:</td><td>@%db:Efectos.monto_pagado;%@ @%db:Divisa.leyenda%@</td></tr>

<tr><td class="etiqueta">Estat:</td>
<td>
Emès (@%db:si_no_flag{Efectos.emitido}%@) 
Abonat (@%db:si_no_flag{Efectos.pagado}%@) 
Tornat (@%db:si_no_flag{Efectos.devuelto}%@)</td></tr>
</table>
</fieldset>

