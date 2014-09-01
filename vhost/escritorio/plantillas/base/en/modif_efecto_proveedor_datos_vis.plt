@%where:tabla|Efectos;where|Efectos.id_efecto= $id_efecto%@

<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="3" height="22" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="161" class="etiqueta" align="right" height="22"> Client: </td>
 <td class="texto">@%db:Proveedores.razon_social%@</td>
 <td width="1" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td height="1" colspan="3" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" class="etiqueta" align="right" height="22">Concept: </td>
 <td class="texto">@%db:Efectos.concepto%@</td>
 <td width="1" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td height="1" colspan="3" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" class="etiqueta" align="right" height="22">Invoices Ref.: </td>
 <td class="texto">@%db:Facturas.referencia%@</td>
 <td width="1" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td height="1" colspan="3" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" class="etiqueta" align="right" height="22">Payment-Charge: </td>
 <td class="texto">@%db:Efectos.pago_cobro%@</td>
 <td width="1" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td height="1" colspan="3" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" class="etiqueta" align="right" height="22">IBAN: </td>
 <td class="texto">@%db:Proveedores_empresas.iban%@ @%db:Proveedores_empresas.entidad%@ @%db:Proveedores_empresas.oficina%@ @%db:Proveedores_empresas.cuenta_bancaria%@</td>
 <td width="1" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td height="1" colspan="3" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" class="etiqueta" align="right" height="22">Payment Rules: </td>
 <!-- @%db:Facturas.id_forma_pago%@ -->
 @%set:id_pago=Facturas.id_forma_pago%@ <td class="texto">
 @%where:tabla|Forma_pago;nolink|1;where|id_forma_pago= $id_pago;%@ 
@%db:Forma_pago.nombre%@ 
@%end-where:%@ 
</td>
 <td width="1" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td height="1" colspan="3" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" class="etiqueta" align="right" height="22">Payment way: </td>
 <td class="texto">@%db:Efectos.medio_pago%@</td>
 <td width="1" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td height="1" colspan="3" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" class="etiqueta" align="right" height="22">Due date: </td>
 <td class="texto">@%db:colocar_fecha{Efectos.fecha_vencimiento}%@</td>
 <td width="1" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td height="1" colspan="3" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" class="etiqueta" align="right" height="22">Total: </td>
 <td class="texto"> @%db:Efectos.monto_pagado;%@ @%db:Divisa.leyenda%@
 </td>
 <td width="1" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" colspan="3"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" align="right" class="etiqueta" height="22">Total Payment: </td>
 <td class="texto"> @%db:Efectos.monto_pagado;%@ @%db:Divisa.leyenda%@</td>

 <td width="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" colspan="3"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" align="right" class="etiqueta" height="22">Condition:</td>
 <td bgcolor="#FFFFFF" height="1" class="texto">
 @%db:check_flag{Efectos.emitido}%@ > Emitido (@%db:si_no_flag{Efectos.emitido}%@) 
 @%db:check_flag{Efectos.pagado}%@ > Abonado (@%db:si_no_flag{Efectos.pagado}%@) 
 @%db:check_flag{Efectos.devuelto}%@ > Devuelto (@%db:si_no_flag{Efectos.devuelto}%@)
 </td>
 <td width="1" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" colspan="3"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="13"></td>
 </tr>
 </table>
 </td>
 </tr>
</table>