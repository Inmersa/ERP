 <table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td height="22" bgcolor="#CCD2D7"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="6" align="center" ></td>
 <td class="titocho" >&gt; Sélection Articles Ticket</td>
 <td align="right" > <a href="#" onclick="return abrir_ventana('?seccion=hacer_ticket_codbarras',400,200);" class="accesos">Code-barres</a>
 </td>
 <td align="right" > <table width="50" border="0" cellspacing="0" cellpadding="0">
 <tr align="center"> <td ><a href="javascript: history.go(-1);" class="accesos">Tourner</a></td>
 </tr>
 </table>
 </td>
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
 <tr> <td class="texto">Resultats : @%func:numero_resultados;%@ </td>
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
 <tr> <td bgcolor="#FFFFFF" height="10"></td>
 </tr>
</table>
 @%plt:buscador_descolocao%@
 <form name="hacer_pedido" method="post" action="?seccion=hacer_ticket">
 <input type="hidden" name="force_" value="1">
 @%plt:hacer_pedido_inicial%@
 </form>

 <form name="cesta" method="post" action="?seccion=ticket_print">
 @%plt:cesta%@ </form>

