<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="30"> 
@%plt:botonera%@
 </td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">

<form name="bo_pedidos_compras" method="post" action="">
 <input type="hidden" name="accion_ejecutar" value="0"> <tr> <td height="22" align="right" bgcolor="#CCD2D7"> <table width="120" border="0" cellspacing="0" cellpadding="0">
 <tr> <td></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td height="3"> </td>
 </tr>
 <tr> <td> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="1" bgcolor="#DBE0E3"></td>
 <td bgcolor="#DBE0E3" align="center" width="100" class="etiqueta" height="22">Code</td>
 <td bgcolor="#DBE0E3" width="22" class="etiqueta"></td>
 <td bgcolor="#DBE0E3" align="center" width="20" class="etiqueta">Rd</td>
 <td bgcolor="#DBE0E3" align="center" width="20" class="etiqueta">D</td>
 <td bgcolor="#DBE0E3" align="center" width="20" class="etiqueta">Inv</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta">Client</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" align="center" width="90" class="etiqueta">Date</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" align="center" width="60" class="etiqueta">Amount</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" align="center" width="55" class="etiqueta">Delivery note</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" align="center" width="55" class="etiqueta">Invoices</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 @%where:tabla|Pedidos;nombre|busc;no_results|1;order|Pedidos.referencia desc%@
 <!--@%func:estado_pedido%@-->
 <tr> <td bgcolor="#DBE0E3"></td>
 <td height="22" align="center" class="rojo">@%if:AllowedLink;bo_pedido_proveedor;%@<a href="?seccion=bo_pedido_proveedor&id_pedido=@%db:Pedidos.id_pedido;%@"M class="accesos">@%db:Pedidos.referencia;%@</a></td>
@%end-if:%@
 <td bgcolor="#DBE0E3" align="center"> @%if:se_puede_borrar%@ @%else:%@ @%end-if:%@ </td>

 <td align="center">@%func:estado_pedido_pedido%@</td>
 <td align="center">@%func:estado_pedido_albaran%@</td>
 <td align="center">@%func:estado_pedido_factura%@</td>



 <td bgcolor="#DBE0E3"></td>
 <td class="texto">@%db:Proveedores.nombre;%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td align="center" class="texto">@%db:colocar_fecha{Pedidos.fecha};%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td align="center" class="texto">@%func:monto_pedido%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td align="center" class="texto">@%func:link_albaran%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td align="center" class="texto">@%func:link_factura%@</td>
 <td bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3"></td>
 <td></td>
 <td bgcolor="#DBE0E3"></td>
 <td colspan="14" height="2"></td>
 </tr>
 <tr bgcolor="#DBE0E3"> <td colspan="17" height="1"></td>
 </tr>
 @%end-where:%@
 </table>
</td>
 </tr>
 </form>
 </table>
 </td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="30"> 
@%plt:botonera%@
 </td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="3">
<table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td height="20" align="center" bgcolor="#DBE0E3"></td>
 <td height="20" align="center" bgcolor="#DBE0E3"></td>
 <td class="etiqueta" colspan="9" height="20" bgcolor="#DBE0E3">Caption</td>
 <td class="etiqueta" height="20" width="1" bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td class="etiqueta" width="1" bgcolor="#DBE0E3"></td>
 <td class="etiqueta" width="10" height="20"></td>
 <td class="etiqueta">O - <span class="texto">Order</span></td>
 <td width="20"><img src="imag/verde.gif" width="14" height="14"></td>
 <td class="texto" width="100">Received </td>
 <td width="20"><img src="imag/amarillo.gif" width="14" height="14"></td>
 <td class="texto" width="100">Ready</td>
 <td width="20"><img src="imag/rojo.gif" width="14" height="14"></td>
 <td class="texto" width="100">In Preparation</td>
 <td width="20"></td>
 <td class="texto" width="100"></td>
 <td class="texto" bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td class="etiqueta" bgcolor="#DBE0E3"></td>
 <td colspan="10" height="1" bgcolor="#DBE0E3"></td>
 <td class="texto" bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td class="etiqueta" bgcolor="#DBE0E3"></td>
 <td class="etiqueta" height="20"></td>
 <td class="etiqueta">D - <span class="texto">Delivery note</span></td>
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
 <tr> <td class="etiqueta" bgcolor="#DBE0E3"></td>
 <td class="etiqueta" height="20"></td>
 <td class="etiqueta">Inv- <span class="texto">Invoices</span></td>
 <td><img src="imag/verde.gif" width="14" height="14"></td>
 <td class="texto">Issued</td>
 <td><img src="imag/amarillo.gif" width="14" height="14"></td>
 <td class="texto">Not Issued</td>
 <td><img src="imag/rojo.gif" width="14" height="14"></td>
 <td class="texto">Without invoice</td>
 <td ></td>
 <td class="texto"></td>
 <td class="texto" bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td colspan="12" height="1" bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td colspan="12" height="10"></td>
 </tr>
 </table>


</td>
 </tr>
</table>


