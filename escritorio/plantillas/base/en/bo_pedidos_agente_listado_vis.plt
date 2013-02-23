<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="30">

@%plt:botonera%@

</td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="13" bgcolor="#CCD2D7" height="22" ></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" width="100">Reference</td>
 <td class="etiqueta" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta">Name</td>
 <td width="1" align="center"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="80">Date</td>
 <td width="1" align="center"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="140">Delivery address </td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" width="91" height="22" align="center" class="etiqueta">Amount</td>
 <td width="1" height="22" align="center" class="etiqueta"></td>
 <td bgcolor="#DBE0E3" width="80" height="22" align="center" class="etiqueta">Condition</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>

 @%where:tabla|Pedidos;nombre|busc;no_results|1;%@ <!--referencia = @%db:Pedidos.referencia;%@ referencia_externa= @%db:Pedidos.referencia_externa;%@-->
 <tr> <td colspan="13" height="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto" width="100">@%if:AllowedLink;bo_pedido_cliente;%@<a href="?seccion=bo_pedido_cliente&id_pedido=@%db:Pedidos.id_pedido;%@" class="accesos">@%db:Pedidos.referencia;%@</a></td>
 @%end-if:%@
 <td class="texto" bgcolor="#DBE0E3"></td>
 <td class="texto">@%db:Pedidos.nombre;%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td align="center" class="texto" width="80">@%db:colocar_fecha{Pedidos.fecha};%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto" width="138">@%db:Direcciones_entrega.direccion;%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td align="center" height="22" class="texto" width="91">@%func:calcular_monto_pedido%@</td>
 <td align="center" height="22" class="texto" bgcolor="#DBE0E3" width="1"></td>
 <td align="center" height="22" class="texto" width="80">@%func:dar_estado%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr> <td colspan="13" height="1"></td>
 </tr>
 <tr> <td colspan="13" bgcolor="#DBE0E3" height="1"></td>
 </tr>

 @%end-where:%@ </table>
 </td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="30"> 

@%plt:botonera%@ 

</td>
 </tr>
</table>

