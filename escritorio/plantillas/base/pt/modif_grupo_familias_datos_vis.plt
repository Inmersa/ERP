
<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="13"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF"> <table width="645" border="0" cellspacing="0" cellpadding="0">
 <form name="modif_grupo_familias" action="?seccion=bo_grupo_familias" method=post>
 <input type=hidden name=registro[id_grupo_familia] value="@%db:Grupo_familias.id_grupo_familia;%@">
 <input type=hidden name=estado value=1>
 <tr bgcolor="#CCD2D7"> <td colspan="3" height="22"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="215" class="etiqueta" align="right" height="22">Nome:</td>
 <td width="428" class="texto"> @%db:Grupo_familias.nombre;%@
<input type="hidden" name="registro[nombre]" value="@%db:Grupo_familias.nombre;%@" class="insertext" size="55">
 </td>
 <td width="2" bgcolor="#CCCCCC"></td>
 </tr>
 <tr bgcolor="#CCD2D7"> <td colspan="3" height="1"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="215" class="etiqueta" align="right" height="22">Descrição:</td>
 <td width="428" class="texto"> @%db:Grupo_familias.descripcion;%@
<input type="hidden" name="registro[descripcion]" value="@%db:Grupo_familias.descripcion;%@" class="insertext" size="55">
 </td>
 <td width="2" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td height="1" width="215" bgcolor="#CCD2D7"></td>
 <td height="1" width="428" bgcolor="#CCD2D7"></td>
 <td width="2" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td height="22" colspan="3"></td>
 </tr>
 <tr align="center"> <td height="22" bgcolor="#CCD2D7" colspan="3"> </td>
 </tr>
 </form>
 </table>
 </td>
 </tr>
 <tr> <td height="30"> </td>
 </tr>
</table>