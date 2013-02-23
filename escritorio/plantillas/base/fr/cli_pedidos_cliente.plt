
<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td height="22" align="right" bgcolor="#CCD2D7"> <table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="6" align="center" ></td>
 <td class="titocho" width="485" >&gt; Historique de commandes</td>
 <td class="titocho" width="110" align="center" ><a href="?seccion=cli_hacer_pedido&pedido=1" class="accesos">Nouveau</a></td>
 <td width="46" align="center" ><a href="javascript: history.go(-1);" class="accesos">Tourner</a></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="3"></td>
 </tr>
 <tr> <td> <table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#EBECED" width="194" valign="top"> <table width="194" border="0" cellspacing="0" cellpadding="0">
 <tr> <td rowspan="5" width="6"></td>
 <td height="5"></td>
 </tr>
 <tr> <td class="texto">Resultats: @%func:numero_resultados;%@</td>
 </tr>
 <tr> <td height="5"></td>
 </tr>
 <tr> <td height="5"></td>
 </tr>
 </table>
 </td>
 <td bgcolor="#FFFFFF" width="3"></td>
 <td bgcolor="@%get:color_accesos_mensaka%@" valign="top">
 @%plt:mensajero%@
 </td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="40">
@%plt:botonera%@
</td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="11" bgcolor="#CCD2D7" height="22" class="etiqueta"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" width="100">Code</td>
 <td width="1" align="center"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="83">Date</td>
 <td width="1" align="center"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" width="240">Direction remise</td>
 <td width="1" align="center"></td>
 <td class="etiqueta" bgcolor="#DBE0E3" align="center" width="83">Quantite</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" width="80" height="22" align="center" class="etiqueta">État</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>

@%where:tabla|Pedidos;nombre|busc;no_results|1;order|Pedidos.referencia desc%@ <tr> <td colspan="11" height="1"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto"><a href="?seccion=cli_pedido_cliente&id_pedido=@%db:Pedidos.id_pedido;%@" class="accesos">@%db:Pedidos.referencia;%@</a></td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td align="center" class="texto">@%db:colocar_fecha{Pedidos.fecha};%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto">@%db:Direcciones_entrega.direccion;%@@%db:Direcciones_entrega.nombre;%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td align="center" class="texto">@%func:calcular_monto_pedido%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td align="center" height="22" class="texto">@%func:dar_estado%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <tr> <td colspan="11" height="1"></td>
 </tr>
 <tr> <td colspan="11" bgcolor="#DBE0E3" height="1"></td>
 </tr>

 @%end-where:%@ </table>
 </td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="50">

 @%plt:botonera%@ </td>
 </tr>
</table>
