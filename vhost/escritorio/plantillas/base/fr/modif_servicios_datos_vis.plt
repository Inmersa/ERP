
<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="13"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF"> <table width="645" border="0" cellspacing="0" cellpadding="0">
<form name="modif_servicios" action="?seccion=bo_servicios" method=post>
<input type=hidden name=registro[id_servicio] value="@%db:Servicios.id_servicio;%@">
<input type=hidden name=estado value=1>
<tr> <td colspan="3" height="22" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="185" class="etiqueta" align="right" height="22"> <!--@%Servicios.id_servicio;%@-->
 Nom:</td>
 <td width="458" class="etiqueta"> @%db:Servicios.nombre;%@<input type="hidden" name="registro[nombre]" value="@%db:Servicios.nombre;%@" class="insertext" size="55">
 </td>
 <td rowspan="5" width="2" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td height="1" width="185" bgcolor="#CCD2D7"></td>
 <td height="1" width="458" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="185" class="etiqueta" align="right" height="22">Duré:</td>
 <td width="458" class="etiqueta"> @%db:Servicios.duracion;%@<input type="hidden" name="registro[duracion]" value="@%db:Servicios.duracion;%@" class="insertext" size="5">
 Jours <input type="radio" name="registro1" value="d" checked>
 Mois <input type="radio" name="registro1" value="m" >
 année <input type="radio" name="registro1" value="a" >
 </td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" width="185"></td>
 <td bgcolor="#CCD2D7" height="1" width="458"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="185" align="right" class="etiqueta" height="22">Délai de facture:</td>
 <td width="458" class="etiqueta"> @%db:Servicios.plazo_factura;%@<input type="hidden" name="registro[plazo_factura]" value="@%db:Servicios.plazo_factura;%@" class="insertext" size="5">
 Jours <input type="radio" name="registro2" value="d" checked>
 Mois <input type="radio" name="registro2" value="m" >
 année <input type="radio" name="registro2" value="a" >
 </td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" width="185" align="right" class="etiqueta" height="1"></td>
 <td width="458" bgcolor="#CCD2D7"></td>
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
