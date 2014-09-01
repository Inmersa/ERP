<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td height="22" bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0" bgcolor="#CCD2D7">
 <form name="rappel_cliente" method="post" action="">
 <input type="hidden" name="accion_ejecutar" value="0">
 <tr> <td align="right" height="22" class="texto"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#EBECED" colspan="5" class="etiqueta" height="22">{{bo_rappel_cliente_listado_vis.plt0}} <span class="texto">12 meses</span></td>
 </tr>
 <tr> <td height="1" colspan="5"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="50"></td>
 <td width="1"></td>
 <td> <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#EBECED" width="24" align="center"> </td>
 <td rowspan="2" width="1" bgcolor="#EBECED"> </td>
 <td width="232" class="etiqueta" bgcolor="#EBECED" height="22"></td>
 <td class="texto" bgcolor="#EBECED"> </td>
 <td width="1" class="texto"></td>
 <td width="170" class="etiqueta" align="center" bgcolor="#EBECED"> Fecha de inicio</td>
 </tr>

 @%where:nodb|listar_rappel_cliente;%@ <tr> <td height="1" align="center" width="24"></td>
 <td height="1" colspan="2"></td>
 <td height="1" width="1"></td>
 <td height="1" bgcolor="#EBECED" width="170"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="24" align="center"> </td>
 <td rowspan="2" width="1"> </td>
 <td width="232" class="etiqueta" bgcolor="#EBECED" height="22">de @%db:Rappel.monto_inicial;%@<input type="hidden" name="rappel_inicio[@%db:Rappel.id_rappel%@]" value="@%db:Rappel.monto_inicial;%@" size="15" class="insertextnumeros" maxlength="9">
 a @%db:Rappel.monto_final;%@<input type="hidden" name="rappel_final[@%db:Rappel.id_rappel%@]" value="@%db:Rappel.monto_final;%@" size="15" class="insertextnumeros" maxlength="9">
 </td>
 <td class="texto" bgcolor="#EBECED"> @%db:Rappel.porcentaje;%@<input type="hidden" name="rappel_porcentaje[@%db:Rappel.id_rappel%@]" value="@%db:Rappel.porcentaje;%@" size="6" class="insertextnumeros" maxlength="3">
 % </td>
 <td width="1" class="texto"></td>
 <td width="170" class="texto" align="center" bgcolor="#EBECED"> @%db:colocar_fecha{Rappel.fecha_inicial};%@<input type="hidden" name="rappel_fecha_inicio[@%db:Rappel.id_rappel%@]" value="@%db:colocar_fecha{Rappel.fecha_inicial};%@" size="10" class="insertextnumeros" maxlength="10">
 </td>
 </tr>

 @%end-where:%@ </table>
 </td>
 <td width="1"></td>
 <td bgcolor="#EBECED" width="100"></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td align="center" height="18"></td>
 </tr>
 </form>
 </table>
 </td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="25"></td>
 </tr>
</table>

