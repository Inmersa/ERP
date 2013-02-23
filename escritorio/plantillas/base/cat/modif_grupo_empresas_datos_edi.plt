<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="13"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF"> <table width="645" border="0" cellspacing="0" cellpadding="0">
<form name="modif_grupo_empresas" action="?seccion=bo_grupo_empresas" method=post>
<input type=hidden name=registro[id_grupo_empresa] value="@%db:Grupo_empresas.id_grupo_empresa;%@">
<input type=hidden name=estado value=1>
 <tr> <td colspan="3" height="22" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="215" class="etiqueta" align="right" height="22"> <!--@%Grupo_empresas.id_grupo_empresa;%@-->
 Nom:</td>
 <td width="428"> <input type="text" name="registro[nombre]" value="@%db:Grupo_empresas.nombre;%@" class="insertext" size="55">
 </td>
 <td width="2" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td height="1" width="215" bgcolor="#CCD2D7"></td>
 <td height="1" width="428" bgcolor="#CCD2D7"></td>
 <td width="2" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td height="22" colspan="3"></td>
 </tr>
 <tr align="center"> <td height="22" bgcolor="#CCD2D7" colspan="3"><a href="javascript:document.forms['modif_grupo_empresas'].submit();" class="accesos">Guardar</a> 
 <a href="javascript:document.forms['modif_grupo_empresas'].reset();" class="accesos">Desfer canvis</a>
 <a href="?seccion=bo_grupo_empresas&estado=2&registro[id_grupo_empresa]=@%db:Grupo_empresas.id_grupo_empresa%@" onClick="return confirm('Esta ud. seguro de que de desea borrar el registro?');return false;" class="accesos">Esborrar</a> </td>
 </tr>
 </form>
 </table>
 </td>
 </tr>
 <tr> <td height="30"> </td>
 </tr>
</table>