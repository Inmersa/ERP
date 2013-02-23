
<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="13"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF"> <table width="645" border="0" cellspacing="0" cellpadding="0">
 <form name="modif_tipo_agente" action="?seccion=bo_tipo_agente" method=post>
 <input type=hidden name=registro[id_tipo_agente] value="@%db:Tipo_agente.id_tipo_agente;%@">
 <input type=hidden name=estado value=1>
 <tr bgcolor="#CCD2D7"> <td colspan="3" height="22"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="208" class="etiqueta" align="right" height="22">Nome:</td>
 <td width="437" class="texto"> <!--@%Tipo_agente.id_tipo_agente;%@-->
 @%db:Tipo_agente.nombre;%@
<input type="hidden" name="registro[nombre]" value="@%db:Tipo_agente.nombre;%@" class="insertext" size="40">
 </td>
 <td width="1" bgcolor="#CCCCCC"></td>
 </tr>
 <tr bgcolor="#CCD2D7"> <td colspan="3" class="etiqueta" align="right" height="1"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="208" class="etiqueta" align="right" height="22">Descrição:</td>
 <td width="437" class="texto"> @%db:Tipo_agente.descripcion;%@
<input type="hidden" name="registro[descripcion]" value="@%db:Tipo_agente.descripcion;%@" class="insertext" size="65">
 </td>
 <td width="1" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td height="1" width="208" bgcolor="#CCD2D7"></td>
 <td height="1" width="437" bgcolor="#CCD2D7"></td>
 <td width="1" bgcolor="#CCCCCC"></td>
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

