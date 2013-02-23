<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="13"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF"> <table width="645" border="0" cellspacing="0" cellpadding="0">
 <form name="modif_forma_pago" action="?seccion=bo_forma_pago" method=post>
<input type=hidden name=registro[id_forma_pago] value="@%db:Forma_pago.id_forma_pago;%@">
<input type=hidden name=estado value=1>
<tr> <td colspan="3" height="22" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="215" class="etiqueta" align="right" height="22"> <!--@%Forma_pago.id_forma_pago;%@-->
 Nombre:</td>
 <td width="428"> <input type="text" name="registro[nombre]" value="@%db:Forma_pago.nombre;%@" class="insertext" size="55">
 </td>
 <td rowspan="5" width="2" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td height="1" width="215" bgcolor="#CCD2D7"></td>
 <td height="1" width="428" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="215" class="etiqueta" align="right" height="22">Nº de efectos:</td>
 <td width="428"> <input type="text" name="registro[num_efectos]" value="@%db:Forma_pago.num_efectos;%@" class="insertext" size="55">
 </td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" width="215"></td>
 <td bgcolor="#CCD2D7" height="1" width="428"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="215" align="right" class="etiqueta" height="22">Días entre efectos:</td>
 <td width="428"> <input type="text" name="registro[dias_efectos]" value="@%db:Forma_pago.dias_efectos;%@" class="insertext" size="55">
 </td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" width="215" align="right" class="etiqueta" height="1"></td>
 <td width="428" bgcolor="#CCD2D7"></td>
 <td width="2" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td height="22" colspan="3"></td>
 </tr>
 <tr align="center"> <td height="22" bgcolor="#CCD2D7" colspan="3"><a href="javascript:document.forms['modif_forma_pago'].submit();" class="accesos">Guardar</a> 
 <a href="javascript:document.forms['modif_forma_pago'].reset();" class="accesos">Deshacer Cambios</a>
 <a href="?seccion=bo_forma_pago&estado=2&registro[id_forma_pago]=@%db:Forma_pago.id_forma_pago%@" onClick="return confirm('Esta ud. seguro de que de desea borrar el registro?');return false;" class="accesos">Borrar</a> </td>
 </tr>
</form>
 </table>
 </td>
 </tr>
 <tr> <td height="30"> </td>
 </tr>
</table>
