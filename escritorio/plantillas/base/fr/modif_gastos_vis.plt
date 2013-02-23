
<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="13"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF"> <table width="645" border="0" cellspacing="0" cellpadding="0">
 <form name="modif_gastos" action="" method=post>
 <input type=hidden name=registro[id_gasto] value="@%db:Gastos.id_gasto;%@">
 <input type=hidden name=estado value=1>
 <tr bgcolor="#CCD2D7"> <td colspan="3" height="22"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="215" class="etiqueta" align="right" height="22">Nom:</td>
 <td width="428" class="texto"> @%db:Gastos.nombre;%@{{modif_gastos_vis.plt1}} </td>
 <td width="2" bgcolor="#CCCCCC"></td>
 </tr>
 <tr bgcolor="#CCD2D7"> <td colspan="3" height="1"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="215" class="etiqueta" align="right" height="22">{{modif_gastos_vis.plt2}}:</td>
 <td width="428" class="texto"> @%db:Gastos.descripcion;%@{{modif_gastos_vis.plt3}} </td>
 <td width="2" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td height="1" width="215" bgcolor="#CCD2D7"></td>
 <td height="1" width="428" bgcolor="#CCD2D7"></td>
 <td width="2" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td height="22" colspan="3"></td>
 </tr>
 <tr align="center"> <td height="22" bgcolor="#CCD2D7" colspan="3"><a href="javascript:document.forms['modif_gastos'].submit();" class="accesos">Garder</a> <a href="javascript:document.forms['modif_gastos'].reset();" class="accesos">Défaire changement</a> <a href="?seccion=bo_gastos&estado=2&registro[id_gasto]=@%db:Gastos.id_gasto%@" onClick="return confirm('Esta ud. seguro de que de desea borrar el registro?');return false;" class="accesos">Effacer</a> </td>
 </tr>
 </form>
 </table>
 </td>
 </tr>
 <tr> <td height="30"> </td>
 </tr>
</table>


