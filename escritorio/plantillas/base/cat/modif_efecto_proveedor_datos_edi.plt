@%where:tabla|Efectos;where|Efectos.id_efecto= $id_efecto%@

<fieldset id="DatosEfecto" class="fsficha">
<legend>Dates Efecte</legend>
<table class="full">
 <tr><td class="etiqueta" >Proveïdor: </td>
 <td >@%db:Proveedores.razon_social%@</td>
 </tr>
 <tr><td class="etiqueta" >Concepte: </td>
 <td >@%db:Efectos.concepto%@</td>
 </tr>

<tr><td class="etiqueta">Tipus: </td> 	 
<td><!-- @%db:Efectos.pago_cobro;%@ -->
@%if:esta_vacio;Efectos.pago_cobro%@
Efecte de Pagament
@%else:%@
Efecte de Cobrament
@%end-if:%@
</td></tr> 	 

 <tr><td class="etiqueta" >Ref. Factures: </td>
 <td >
@%if:AllowedLink;bo_factura_proveedor;%@
<a href="?seccion=bo_factura_proveedor&id_factura=@%db:Efectos.id_factura;%@" >@%db:Facturas.referencia%@</a> (@%db:colocar_fecha{Facturas.fecha};%@)
@%else:%@
@%db:Facturas.referencia%@
@%end-if:%@
 </td>
 </tr>
 <tr><td class="etiqueta" >Compte bancari IBAN: </td>
 <td >@%db:Proveedores_empresas.iban%@ @%db:Proveedores_empresas.entidad%@ @%db:Proveedores_empresas.oficina%@ @%db:Proveedores_empresas.cuenta_bancaria%@</td>
 </tr>
 <tr><td class="etiqueta" >Mig de paga: </td>
 <td><!-- @%db:Facturas.id_forma_pago%@ -->
 @%set:id_pago=Facturas.id_forma_pago%@ 
 @%where:tabla|Forma_pago;nolink|1;where|id_forma_pago= $id_pago;%@ 
@%db:Forma_pago.nombre%@ 
@%end-where:%@ 

</td></tr>
 <tr><td class="etiqueta" >Mig de pagament: </td>
 <td >@%db:Efectos.medio_pago%@</td>
 </tr>
 <tr><td class="etiqueta" >Banc: </td>
 <td >
<!-- @%set:_selected_value=Efectos.id_banco;%@ @%db:Efectos.id_banco;%@ -->
  <select name="efecto[id_banco]" class="insertext">
  <option value="">Sense Bancs</option>
  @%where:tabla|Bancos;nolink|1;nombre|bancos;order|Bancos.nombre asc;%@
	<option value="@%db:Bancos.id_banco%@"
	 @%db:selected_value{Bancos.id_banco};%@
	 >@%db:Bancos.nombre%@</option>
  @%end-where:%@

 </td></tr>
 <tr> <td class="etiqueta" >Data venciment: </td>
 <td ><input type="text" name="efecto[fecha_vencimiento]" value="@%db:colocar_fecha{Efectos.fecha_vencimiento}%@" class="fecha"></td> 
 </tr>
 <tr><td class="etiqueta">Data abonament:</td><td>
@%if:esta_vacio;Efectos.pagado;%@
 <input type="text" name="efecto[fecha_abono]" value="@%db:colocar_fecha{Efectos.fecha_abono}%@" class="fecha" />
@%else:%@
 @%db:colocar_fecha{Efectos.fecha_abono}%@
@%end-if:%@
 </td></tr>
 <tr ><td class="etiqueta">Data devolució:</td>
 <td>@%db:colocar_fecha{Efectos.fecha_devolucion};%@</td>
 </tr>
 <tr><td class="etiqueta" >Totals: </td>
 <td >@%db:Efectos.monto%@ @%db:Divisa.leyenda%@</td>
 </tr>
 <tr><td class="etiqueta" >Total pagat: </td>
 <td >@%db:Efectos.monto_pagado;%@ @%db:Divisa.leyenda%@</td>
 </tr>

 <tr> <td bgcolor="#EBECED" align="right" class="etiqueta" height="22">Estat:</td>
 <td bgcolor="#FFFFFF" height="1" class="texto">
 <input type="hidden" name="efecto[old][emitido]" value="@%db:Efectos.emitido%@"/> 
 <input type="hidden" name="efecto[old][pagado]" value="@%db:Efectos.pagado%@"/> 
 <input type="hidden" name="efecto[old][devuelto]" value="@%db:Efectos.devuelto%@"/> 
 <input type="checkbox" name="efecto[emitido]" value="1" @%db:check_flag{Efectos.emitido}%@ /> 
 Emès (@%db:si_no_flag{Efectos.emitido}%@) 
 <input type="checkbox" name="efecto[pagado]" value="1" @%db:check_flag{Efectos.pagado}%@ /> 
 Abonat (@%db:si_no_flag{Efectos.pagado}%@) 
 <input type="checkbox" name="efecto[devuelto]" value="1" @%db:check_flag{Efectos.devuelto}%@ /> 
 Tornat (@%db:si_no_flag{Efectos.devuelto}%@) 
 </td>
 </tr>
 </table>
</fieldset>

