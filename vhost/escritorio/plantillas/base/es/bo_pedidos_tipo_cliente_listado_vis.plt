<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="30">
@%plt:botonera%@
</td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <form name="pedidos_tipo_cliente" action="">
 <tr> <td height="22" align="right" bgcolor="#CCD2D7"> <table width="150" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="146" align="right">
 <input type="hidden" name="Borrar" value="Borrar">
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
 <td bgcolor="#DBE0E3" width="70" class="etiqueta">Código</td>
 <td width="1"></td>
 <td width="20" bgcolor="#DBE0E3"></td>
 <td bgcolor="#DBE0E3" class="etiqueta">Nombre<span class="texto"></span></td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="75">Fecha</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" width="150">Dirección de entrega </td>
 <td class="etiqueta" align="center" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="right" width="70">Importe</td>
 <td width="1"></td>
 </tr>
 <!--Esto es para cuando no hay resultados, pero queda como el culo cuando los hay (imagino)-->
 @%where:tabla|Pedidos_tipo_cliente;nombre|busc;no_results|1;%@ <tr> <td colspan="3"></td>
 <td bgcolor="#DBE0E3" height="2"></td>
 <td colspan="8"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto" align="center">@%db:Pedidos.referencia;%@</td>
 <td></td>
 <td bgcolor="#DBE0E3" valign="top" height="22"> </td>
 <td class="texto">@%if:AllowedLink;bo_pedido_cliente;%@<a href="?seccion=bo_pedido_cliente&id_pedido=@%db:Pedidos_tipo_cliente.id_pedido%@" class="accesos">@%db:Pedidos_tipo_cliente.nombre;%@ </a></td>
@%end-if:%@
 <td bgcolor="#DBE0E3"></td>
 <td class="texto" align="center">@%db:colocar_fecha{Pedidos.fecha};%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto">@%db:Direcciones_entrega.direccion;%@</td>
 <td class="texto" align="center" bgcolor="#DBE0E3"></td>
 <td class="texto" align="right">@%func:calcular_monto_pedido%@
 &gt; Euro</td>
 <td bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td height="3" colspan="3"></td>
 <td height="3" bgcolor="#DBE0E3"></td>
 <td height="3" colspan="8"></td>
 </tr>
 <tr> <td height="1" colspan="12" bgcolor="#DBE0E3"></td>
 </tr>
 <!-- Fin del registro -->

 @%end-where:%@ </table>
 </td>
 </tr>
 </form>
 </table>
 </td>
 </tr>
 <tr>
 <td height="33" >
@%plt:botonera%@
</td>
 </tr>
</table>
 

