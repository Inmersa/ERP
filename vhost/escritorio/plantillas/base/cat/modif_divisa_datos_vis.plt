@%where:tabla|Divisa;%@

<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="13"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF"> <table width="645" border="0" cellspacing="0" cellpadding="0">
 <form name="modif_divisa" action="?seccion=bo_divisa" method=post>
<input type=hidden name=registro[id_divisa] value="@%db:Divisa.id_divisa;%@">
<input type=hidden name=estado value=1>
<tr> <td colspan="3" height="22" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="161" class="etiqueta" align="right" height="22">
 <!--@%Divisa.id_divisa;%@-->
 Nom:</td>
 <td width="316" class="texto"> @%db:Divisa.nombre;%@
<input type="hidden" name="registro[nombre]" value="@%db:Divisa.nombre;%@" class="insertext" size="55">
 </td>
 <td rowspan="5" width="1" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td height="1" width="161" bgcolor="#CCD2D7"></td>
 <td height="1" width="316" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="161" class="etiqueta" align="right" height="22">Llegenda :</td>
 <td width="316" class="texto"> @%db:Divisa.leyenda;%@
<input type="hidden" name="registro[leyenda]" value="@%db:Divisa.leyenda;%@" class="insertext" size="55">
 </td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" width="161"></td>
 <td bgcolor="#CCD2D7" height="1" width="316"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="161" align="right" class="etiqueta" height="22">Ratio :</td>
 <td width="316" class="texto"> @%db:Divisa.ratio;%@
<input type="hidden" name="registro[ratio]" value="@%db:Divisa.ratio;%@" class="insertext" size="55">
 </td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" width="161" align="right" class="etiqueta" height="1"></td>
 <td width="316" bgcolor="#CCD2D7"></td>
 <td width="1" bgcolor="#CCCCCC"></td>
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
