
<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="13"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF"> <table width="645" border="0" cellspacing="0" cellpadding="0">
 <form name="modif_unidades_medida" action="?seccion=bo_unidades_medida" method=post>
 <input type=hidden name=registro[id_unidad_medida] value="@%db:Unidades_medida.id_unidad_medida;%@">
 <input type=hidden name=estado value=1>
 <tr bgcolor="#CCD2D7"> <td colspan="3" height="22"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="219" class="etiqueta" align="right" height="22"> <!--@%Unidades_medida.id_unidad_medida;%@-->
 Nombre:</td>
 <td width="424" class="texto"> @%db:Unidades_medida.nombre;%@
<input type="hidden" name="registro[nombre]" value="@%db:Unidades_medida.nombre;%@" class="insertext" size="55">
 </td>
 <td width="2" bgcolor="#CCCCCC"></td>
 </tr>
 <tr bgcolor="#CCD2D7"> <td colspan="3" height="1"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="219" class="etiqueta" align="right" height="22">Leyenda:</td>
 <td width="424" class="texto"> @%db:Unidades_medida.leyenda;%@
<input type="hidden" name="registro[leyenda]" value="@%db:Unidades_medida.leyenda;%@" class="insertext" size="10" maxlength="10">
 </td>
 <td width="2" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td height="1" width="219" bgcolor="#CCD2D7"></td>
 <td height="1" width="424" bgcolor="#CCD2D7"></td>
 <td width="2" bgcolor="#CCCCCC"></td>
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
