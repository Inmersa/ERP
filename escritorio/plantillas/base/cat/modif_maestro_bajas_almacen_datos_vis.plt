
<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF"> <table width="645" border="0" cellspacing="0" cellpadding="0">
<form name="modif_maestro_bajas_almacen" action="?seccion=bo_maestro_bajas_almacen" method=post>
<input type=hidden name=registro[id_baja_almacen] value="@%db:Bajas_almacen.id_baja_almacen;%@">
<input type=hidden name=estado value=1>
 <tr> <td colspan="3" height="22" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="215" class="etiqueta" align="right" height="22"> <!--@%Bajas_almacen.id_baja_almacen;%@-->
 Nom:</td>
 <td width="428" class="texto"> @%db:Bajas_almacen.nombre;%@
<input type="hidden" name="registro[nombre]" value="@%db:Bajas_almacen.nombre;%@" class="insertext" size="55">
 </td>
 <td width="2" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" width="215"></td>
 <td bgcolor="#CCD2D7" width="428"></td>
 <td width="2" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="215" class="etiqueta" align="right" height="22">Descripció:</td>
 <td width="428" class="texto"> @%db:Bajas_almacen.descripcion;%@
<input type="hidden" name="registro[descripcion]" value="@%db:Bajas_almacen.descripcion;%@" class="insertext" size="55">
 </td>
 <td width="2" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td height="1" width="215" bgcolor="#CCD2D7"></td>
 <td height="1" width="428" bgcolor="#CCD2D7"></td>
 <td width="2" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td height="22" colspan="3"></td>
 </tr>
 <tr align="center"> <td height="22" bgcolor="#CCD2D7" colspan="3">
 </td>
 </tr>
 </form>
 </table>
 </td>
 </tr>
 <tr> <td height="30"> </td>
 </tr>
</table>
