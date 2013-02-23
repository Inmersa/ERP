<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="30">
@%plt:botonera%@
</td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="11" bgcolor="#CCD2D7" height="22" class="etiqueta" align="right"> </td>
 </tr>
 @%where:tabla|Efectos;nombre|busc;%@ 

@%if:nuevo_proveedor%@

 <tr> <td bgcolor="#DBE0E3" class="etiqueta" align="center" height="22" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" height="22">Company Name</td>
 <td width="1" align="center"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="110">Code</td>
 <td class="etiqueta" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="80">Risk</td>
 <td class="etiqueta" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="55">Delay</td>
 <td class="etiqueta" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" width="100" align="center">Amount</td>
 <td width="1" align="center" bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1"></td>
 <td colspan="10" height="1"></td>
 </tr>
 <tr> <td class="etiqueta" height="22" bgcolor="#DBE0E3" width="1" align="center"> </td>
 <td class="etiqueta" height="22">@%db:Proveedores.razon_social%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto" align="center">@%if:AllowedLink;modif_proveedor;%@<a href="?seccion=modif_proveedor&id_proveedor=@%db:Proveedores.id_proveedor;%@" class="accesos">@%db:Proveedor.id_proveedor;%@</a></td>
 @%end-if:%@
 <td class="texto" bgcolor="#DBE0E3"></td>
 <td class="texto" align="center">@%db:Proveedores_empresas.riesgo%@</td>
 <td class="texto" bgcolor="#DBE0E3"></td>
 <td class="texto" align="center">@%db:Proveedores_empresas.plazo_demora%@</td>
 <td class="texto"></td>
 <td class="texto" align="center">@%db:Proveedores_empresas.monto_cuenta_efectos%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr> <td height="1" colspan="11"></td>
 </tr>
 <tr bgcolor="#DBE0E3"> <td colspan="11" height="1"></td>
 </tr>

@%else:%@

 <tr> <td height="22" colspan="11" > <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="16" height="10"></td>
 </tr>
 <tr> <td colspan="16" height="1" bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" width="22"></td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" height="22">Invoices Ref. </td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" height="22">Concept</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" height="22" align="center">Payment way</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" height="22" align="center">Due date</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" height="22" align="center">Total</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" height="22" align="center">Total Payment </td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" height="22" align="center" width="22">S</td>
 <td width="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" width="22"> </td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td class="etiqueta" height="22">@%if:AllowedLink;bo_factura_proveedor;%@<a href="?seccion=bo_factura_proveedor&id_factura=@%db:Facturas.id_factura;%@" class="accesos">@%db:Facturas.referencia%@</a></td>
 @%end-if:%@
<td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto">@%if:AllowedLink;modif_efectos_proveedor;%@<a href="?seccion=modif_efectos_proveedor&id_efecto=@%db:Efectos.id_efecto;%@" class="accesos">@%db:Efectos.concepto;%@</a></td>
 @%end-if:%@
<td bgcolor="#DBE0E3" width="1"></td>
 <td align="center" class="texto">@%db:Efectos.medio_pago%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td align="center" class="texto">@%db:Efectos.fecha_vencimiento%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td align="center" class="texto">@%db:Efectos.monto%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td align="center" class="texto">@%db:Efectos.monto_pagado%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td align="center"></td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr> <td colspan="16" height="1" bgcolor="#DBE0E3"></td>
 </tr>
 <tr > <td colspan="16" height="10"></td>
 </tr>
 </table>
 </td>
 </tr>

@%end-if:%@

@%end-where:%@

 <tr align="center"> <td colspan="11" height="22" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" height="1" ></td>
 <td height="1"></td>
 <td height="1" width="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1"></td>
 <td height="1" width="1"></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td height="30">
@%plt:botonera%@
<table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td height="20" align="center" bgcolor="#DBE0E3"></td>
 <td height="20" align="center" bgcolor="#DBE0E3"></td>
 <td class="etiqueta" colspan="9" height="20" bgcolor="#DBE0E3">Caption</td>
 <td class="etiqueta" height="20" width="1" bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td class="etiqueta" bgcolor="#DBE0E3"></td>
 <td class="etiqueta" height="20"></td>
 <td class="etiqueta">Condition<span class="texto"></span></td>
 <td><img src="imag/verde.gif" width="14" height="14"></td>
 <td class="texto">Sended</td>
 <td><img src="imag/amarillo.gif" width="14" height="14"></td>
 <td class="texto">Ready</td>
 <td><img src="imag/rojo.gif" width="14" height="14"></td>
 <td class="texto">Without Delivery note</td>
 <td ><img src="imag/negro.gif" width="14" height="14"></td>
 <td class="texto">Returned</td>
 <td class="texto" bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td class="etiqueta" bgcolor="#DBE0E3"></td>
 <td colspan="10" height="1" bgcolor="#DBE0E3"></td>
 <td class="texto" bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td colspan="12" height="10"></td>
 </tr>
 </table>



 
</td>
 </tr>
</table>


