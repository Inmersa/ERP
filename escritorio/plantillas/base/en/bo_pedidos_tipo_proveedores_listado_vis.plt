<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="30">
@%plt:botonera%@
</td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <form name="pedidos_tipo_proveedor" action="">
 <tr> <td height="22" align="right" bgcolor="#CCD2D7"> <table width="150" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="146" align="right"><input type="hidden" name="Borrar" value="Borrar">

</td>
 <td width="4"></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td height="3"> </td>
 </tr>
 <tr> <td> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#DBE0E3" width="1" class="etiqueta" align="center"></td>
 <td bgcolor="#DBE0E3" width="100" class="etiqueta" align="center">Own Ref. </td>
 <td width="1"></td>
 <td width="20" bgcolor="#DBE0E3"></td>
 <td bgcolor="#DBE0E3" class="etiqueta">Name<span class="texto"></span></td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="80">Date</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" width="80" align="center">Ext. Ref.</td>
 <td class="etiqueta" align="center" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="right" width="70">Amount</td>
 <td width="1"></td>
 </tr>


 @%where:tabla|Pedidos_tipo_proveedor;nombre|busc;no_results|1;%@

 <!-- aqui viene el registro -->
 <tr> <td></td>
 <td height="2"></td>
 <td></td>
 <td bgcolor="#DBE0E3" height="2"></td>
 <td colspan="8"></td>
 </tr>
 <tr> 
 <td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto" align="center" width="100">@%db:Pedidos.referencia;%@</td>
 <td></td>
 <td bgcolor="#DBE0E3" valign="top" height="22"> </td>
 <td class="texto">@%if:AllowedLink;bo_pedido_proveedor;%@<a href="?seccion=bo_pedido_proveedor&id_pedido=@%db:Pedidos_tipo_proveedor.id_pedido;%@" class="accesos">@%db:Pedidos_tipo_proveedor.nombre;%@</a></td>
 <td bgcolor="#DBE0E3"></td>
 @%end-if:%@
 <td class="texto" align="center">@%db:colocar_fecha{Pedidos.fecha};%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto">@%db:Pedidos.referencia_externa;%@--<font color="red">@%db:Pedidos.referencia;%@</font></td>
 <td class="texto" align="center" bgcolor="#DBE0E3"></td>
 <td class="texto" align="right">@%func:monto_pedido%@ &gt; Euro</td>
 <td bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td height="3"></td>
 <td height="3"></td>
 <td height="3"></td>
 <td height="3" bgcolor="#DBE0E3"></td>
 <td height="3"></td>
 <td height="3"></td>
 <td height="3"></td>
 <td height="3"></td>
 <td height="3"></td>
 <td height="3"></td>
 <td height="3"></td>
 <td height="3"></td>
 </tr>
 <tr> 
 <td height="1" colspan="12" bgcolor="#DBE0E3"></td>
 </tr>
 @%end-where:%@


 </table>
 </td>
 </tr>
 </form>
 </table>
 </td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="30"> @%plt:botonera%@ </td>
 </tr>
 <tr>
 <td bgcolor="#FFFFFF" height="3"></td>
 </tr>
 </table>

