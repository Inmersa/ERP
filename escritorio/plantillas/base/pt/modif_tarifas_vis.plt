

<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="13"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF"> <table width="645" border="0" cellspacing="0" cellpadding="0">
 
<form name="modif_tarifas" action="?seccion=bo_tarifas" method=post>
<input type=hidden name=registro[id_tarifa] value="@%db:Tarifas.id_tarifa;%@">
<input type=hidden name=estado value=1><tr> <td colspan="3" height="22" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="215" class="etiqueta" align="right" height="22">
 <!--@%Tarifas.id_tarifa;%@-->
 Nome:</td>
 <td width="428" class="texto"> @%db:Tarifas.nombre;%@
<input type="hidden" name="registro[nombre]" value="@%db:Tarifas.nombre;%@" class="insertext" size="55">
 </td>
 <td rowspan="5" width="2" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td height="1" width="215" bgcolor="#CCD2D7"></td>
 <td height="1" width="428" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="215" class="etiqueta" align="right" height="22">% Primeiro:</td>
 <td width="428" class="texto"> @%db:Tarifas.pto_primero;%@
<input type="hidden" name="registro[pto_primero]" value="@%db:Tarifas.pto_primero;%@" class="insertext" size="55">
 </td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" width="215"></td>
 <td bgcolor="#CCD2D7" height="1" width="428"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="215" align="right" class="etiqueta" height="22">% Segundo:</td>
 <td width="428" class="texto"> @%db:Tarifas.pto_segundo;%@
<input type="hidden" name="registro[pto_segundo]" value="@%db:Tarifas.pto_segundo;%@" class="insertext" size="55">
 </td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" width="215" align="right" class="etiqueta" height="1"></td>
 <td width="428" bgcolor="#CCD2D7"></td>
 <td width="2" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="215" align="right" class="etiqueta" height="22">Total:</td>
 <td width="428" class="texto"> @%db:Tarifas.monto;%@
<input type="hidden" name="registro[monto]" value="@%db:Tarifas.monto;%@" class="insertext" size="55">
 </td>
 <td width="2" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td height="1" bgcolor="#CCD2D7" width="215"></td>
 <td height="1" bgcolor="#CCD2D7" width="428"></td>
 <td height="1" bgcolor="#CCD2D7" width="2"></td>
 </tr>
 <tr> <td height="22" bgcolor="#EBECED" width="215" align="right" class="etiqueta">Campo de Acção:</td>
 <td height="1" width="428" class="texto"> <!--@%db:Tarifas.campo_accion;%@-->
 @%func:selected_campo_accion%@ </td>
 <td height="1" bgcolor="#CCD2D7" width="2"></td>
 </tr>
 <tr> <td height="1" bgcolor="#CCD2D7" width="215"></td>
 <td height="1" bgcolor="#CCD2D7" width="428"></td>
 <td height="1" bgcolor="#CCD2D7" width="2"></td>
 </tr>
 <tr> <td height="22" colspan="3"></td>
 </tr>
 <tr align="center"> <td height="22" bgcolor="#CCD2D7" colspan="3"></td>
 </tr>
</form>
 </table>
 </td>
 </tr>
 <tr> <td height="30"> </td>
 </tr>
</table>

