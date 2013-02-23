
<!-- @%db:Clientes.id_cliente;%@ -->

@%if:esta_vacio;form_name;%@
<form name="efectos" method="post" action="?seccion=@%get:_krn_ss_name;%@" >
<input type="hidden" name="accion_ejecutar" value="Abonar" />
@%set:form_name=efectos;%@
@%set:form_end=1;%@
@%end-if:%@


@%set:hay_efectos = 1;%@
<fieldset class="fsficha" >
<legend>Effets en suspens</legend>
<div class="AccionesFicha" ><ul>
<li><a href="?seccion=bo_efectos_cliente&id_cli=@%db:Clientes.id_cliente;%@" class="listaefectos" 
	><img src="imag/pixel.png" class="icono" /><span>Effets</span></a></li>
<li><a href="#" onClick="return sendForm('@%get:form_name;%@','accion_ejecutar','AbonarEfectos');" class="abonar" 
	><img src="imag/pixel.png" class="icono" /><span>Régler</span></a></li>
</ul></div>
<!-- 
@%if:esta_vacio;efectos_nodate;%@
@%set:where_fecha= NOW();%@ 
@%else:%@
@%set:where_fecha= '9999-00-00';%@ 
@%end-if:%@
-->
<table class="full" >
<thead>
<tr>
<td>Référence</td>
<td>Date</td>
<td>Total en suspens</td>
<td>Moyen de payant</td>
<td>Paiemnet Partiel</td>
<td>Notes</td>
</tr>
</thead>
<tbody>

@%where:tabla|Efectos;where|Efectos.emitido = 1 AND fecha_vencimiento <= $where_fecha AND ABS(monto_pagado) < ABS(monto);nolink|0;contador|i;%@
<input type="hidden" name="efectos[@%db:Efectos.id_efecto;%@][id_efecto]" value="@%db:Efectos.id_efecto%@" />
 <tr>
 <td><a href="?seccion=bo_factura_cliente=@%db:Facturas.id_factura;%@" >@%db:Facturas.referencia%@</a></td>
 <td>@%db:colocar_fecha{Efectos.fecha_vencimiento}%@</td>
 <td>
 <input type="hidden" name="efectos[@%db:Efectos.id_efecto%@][monto_pagado]" value="@%db:Efectos.monto_pagado%@">
 <input type="hidden" name="efectos[@%db:Efectos.id_efecto%@][monto]" value="@%db:Efectos.monto%@">
 <!-- @%set:pagado = Efectos.monto_pagado;%@ @%set:importe = Efectos.monto;%@ -->
 @%calc:importe - pagado;output|1;round|2;%@ @%db:Divisa.leyenda%@
 </td>

 <td>
 <select name="efectos[@%db:Efectos.id_efecto%@][medio_pago]" size="1">
 <option value="efectivo">Liquidités</option>
 <option value="cheque">Chéque</option>
 <option value="transferencia">Transfert</option>
 <option value="pagare">Billet</option>
 <option value="recibo">Réception</option>
 </select>
 </td>
 <td><input type="text" name="efectos[@%db:Efectos.id_efecto%@][importe]" size="10"></td>
 <td><input type="text" name="efectos[@%db:Efectos.id_efecto%@][notas]" size="30"></td>
 </tr>

@%end-where:%@

@%if:!esta_vacio;hay_efectos;%@
</tbody>
</table>
</fieldset>
@%end-if:%@

@%if:!esta_vacio;form_end;%@
</form>
@%end-if:%@

