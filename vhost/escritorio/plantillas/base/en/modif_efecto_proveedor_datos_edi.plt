@%where:tabla|Efectos;where|Efectos.id_efecto= $id_efecto%@

<fieldset id="DatosEfecto" class="fsficha">
<legend>Bank Drafts Data</legend>
<table class="full">
 <tr><td class="etiqueta" >Supplier: </td>
 <td >@%db:Proveedores.razon_social%@</td>
 </tr>
 <tr><td class="etiqueta" >Concept: </td>
 <td >@%db:Efectos.concepto%@</td>
 </tr>

<tr><td class="etiqueta">Type: </td> 	 
<td><!-- @%db:Efectos.pago_cobro;%@ -->
@%if:esta_vacio;Efectos.pago_cobro%@
Effect of Payment
@%else:%@
Effect of Charge
@%end-if:%@
</td></tr> 	 

 <tr><td class="etiqueta" >Invoices Ref.: </td>
 <td >
@%if:AllowedLink;bo_factura_proveedor;%@
<a href="?seccion=bo_factura_proveedor&id_factura=@%db:Efectos.id_factura;%@" >@%db:Facturas.referencia%@</a> (@%db:colocar_fecha{Facturas.fecha};%@)
@%else:%@
@%db:Facturas.referencia%@
@%end-if:%@
 </td>
 </tr>
 <tr><td class="etiqueta" >IBAN: </td>
 <td >@%db:Proveedores_empresas.iban%@ @%db:Proveedores_empresas.entidad%@ @%db:Proveedores_empresas.oficina%@ @%db:Proveedores_empresas.cuenta_bancaria%@</td>
 </tr>
 <tr><td class="etiqueta" >Payment Rules: </td>
 <td><!-- @%db:Facturas.id_forma_pago%@ -->
 @%set:id_pago=Facturas.id_forma_pago%@ 
 @%where:tabla|Forma_pago;nolink|1;where|id_forma_pago= $id_pago;%@ 
@%db:Forma_pago.nombre%@ 
@%end-where:%@ 

</td></tr>
 <tr><td class="etiqueta" >Payment way: </td>
 <td >@%db:Efectos.medio_pago%@</td>
 </tr>
 <tr><td class="etiqueta" >Bank: </td>
 <td >
<!-- @%set:_selected_value=Efectos.id_banco;%@ @%db:Efectos.id_banco;%@ -->
  <select name="efecto[id_banco]" class="insertext">
  <option value="">Without Bank</option>
  @%where:tabla|Bancos;nolink|1;nombre|bancos;order|Bancos.nombre asc;%@
	<option value="@%db:Bancos.id_banco%@"
	 @%db:selected_value{Bancos.id_banco};%@
	 >@%db:Bancos.nombre%@</option>
  @%end-where:%@

 </td></tr>
 <tr> <td class="etiqueta" >Due date: </td>
 <td ><input type="text" name="efecto[fecha_vencimiento]" value="@%db:colocar_fecha{Efectos.fecha_vencimiento}%@" class="fecha"></td> 
 </tr>
 <tr><td class="etiqueta">Payment date:</td><td>
@%if:esta_vacio;Efectos.pagado;%@
 <input type="text" name="efecto[fecha_abono]" value="@%db:colocar_fecha{Efectos.fecha_abono}%@" class="fecha" />
@%else:%@
 @%db:colocar_fecha{Efectos.fecha_abono}%@
@%end-if:%@
 </td></tr>
 <tr ><td class="etiqueta">Return date:</td>
 <td>@%db:colocar_fecha{Efectos.fecha_devolucion};%@</td>
 </tr>
 <tr><td class="etiqueta" >Total: </td>
 <td >@%db:Efectos.monto%@ @%db:Divisa.leyenda%@</td>
 </tr>
 <tr><td class="etiqueta" >Total Payment: </td>
 <td >@%db:Efectos.monto_pagado;%@ @%db:Divisa.leyenda%@</td>
 </tr>

 <tr> <td bgcolor="#EBECED" align="right" class="etiqueta" height="22">Condition:</td>
 <td bgcolor="#FFFFFF" height="1" class="texto">
 <input type="hidden" name="efecto[old][emitido]" value="@%db:Efectos.emitido%@"/> 
 <input type="hidden" name="efecto[old][pagado]" value="@%db:Efectos.pagado%@"/> 
 <input type="hidden" name="efecto[old][devuelto]" value="@%db:Efectos.devuelto%@"/> 
 <input type="checkbox" name="efecto[emitido]" value="1" @%db:check_flag{Efectos.emitido}%@ /> 
 Issued (@%db:si_no_flag{Efectos.emitido}%@) 
 <input type="checkbox" name="efecto[pagado]" value="1" @%db:check_flag{Efectos.pagado}%@ /> 
 Credited (@%db:si_no_flag{Efectos.pagado}%@) 
 <input type="checkbox" name="efecto[devuelto]" value="1" @%db:check_flag{Efectos.devuelto}%@ /> 
 Returned (@%db:si_no_flag{Efectos.devuelto}%@) 
 </td>
 </tr>
 </table>
</fieldset>

