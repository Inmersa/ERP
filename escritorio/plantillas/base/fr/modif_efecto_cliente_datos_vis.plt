@%where:tabla|Efectos;where|Efectos.id_efecto= $id_efecto%@ 
<!-- @%db:Efectos.id_efecto%@ -->
<fieldset id="DatosEfecto" class="fsficha">
<legend>Données effet</legend>
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
<td class="etiqueta">Réf.Factures: </td>
<td>@%db:Facturas.referencia%@</td>
</tr>

<tr>
<td class="etiqueta">Compte bancaire IBAN: </td>
<td>@%db:Clientes_empresas.iban%@ @%db:Clientes_empresas.entidad%@ @%db:Clientes_empresas.oficina%@ @%db:Clientes_empresas.cuenta_bancaria%@</td>
</tr>

<tr>
<td class="etiqueta">Modalité de paiment: </td>
 <!-- @%db:Facturas.id_forma_pago%@ -->
 @%set:id_pago=Facturas.id_forma_pago%@<td>
 @%where:tabla|Forma_pago;nolink|1;where|id_forma_pago= $id_pago;%@ 
@%db:Forma_pago.nombre%@ 
@%end-where:%@

 </td>
</tr>

<tr>
<td class="etiqueta">Moyen de payant: </td>
<td>@%db:Efectos.medio_pago%@</td>
</tr>

<tr>
<td class="etiqueta">Banqe: </td>
<td>
@%where:tabla|Bancos;nolink|0;%@
@%db:Bancos.nombre%@
@%end-where:%@

 </td>
</tr>

<tr>
<td class="etiqueta">Date de expiration: </td>
<td>@%db:colocar_fecha{Efectos.fecha_vencimiento}%@</td>
</tr>
<tr><td class="etiqueta">Date de d´abonnement:</td><td> @%db:colocar_fecha{Efectos.fecha_abono}%@ </td></tr>

<tr><td class="etiqueta">Date de retour:</td><td> @%db:colocar_fecha{Efectos.fecha_devolucion}%@ </td></tr>

<tr><td class="etiqueta">Totals:</td><td>@%db:Efectos.monto%@ @%db:Divisa.leyenda%@</td></tr>

<tr><td class="etiqueta">Total payé:</td><td>@%db:Efectos.monto_pagado;%@ @%db:Divisa.leyenda%@</td></tr>

<tr><td class="etiqueta">État:</td>
<td>
Émis (@%db:si_no_flag{Efectos.emitido}%@) 
Abonné (@%db:si_no_flag{Efectos.pagado}%@) 
Envoi en retour (@%db:si_no_flag{Efectos.devuelto}%@)</td></tr>
</table>
</fieldset>

