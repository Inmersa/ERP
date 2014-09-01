
<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="13"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF"> <table width="645" border="0" cellspacing="0" cellpadding="0">
 <form name="modif_tipos_iva" action="?seccion=bo_tipos_iva" method=post>
<input type=hidden name=registro[id_iva] value="@%db:Tipos_IVA.id_iva;%@">
<input type=hidden name=estado value=1> <tr> <td colspan="3" height="22" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="213" class="etiqueta" align="right" height="22"> <!--@%Tipos_IVA.id_iva;%@-->
 Nom:</td>
 <td width="430" class="texto"> @%db:Tipos_IVA.nombre;%@
<input type="hidden" name="registro[nombre]" value="@%db:Tipos_IVA.nombre;%@" class="insertext" size="55">
 </td>
 <td rowspan="5" width="2" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td height="1" width="213" bgcolor="#CCD2D7"></td>
 <td height="1" width="430" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="213" class="etiqueta" align="right" height="22"> Percentatge:</td>
 <td width="430" class="texto"> @%db:Tipos_IVA.porcentaje;%@
<input type="hidden" name="registro[porcentaje]" value="@%db:Tipos_IVA.porcentaje;%@" class="insertext" size="55">
 </td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" width="213"></td>
 <td bgcolor="#CCD2D7" height="1" width="430"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="213" align="right" class="etiqueta" height="22">Recàrrec equivalent:</td>
 <td width="430" class="texto"> @%db:Tipos_IVA.recargo_equivalente;%@
<input type="hidden" name="registro[recargo_equivalente]" value="@%db:Tipos_IVA.recargo_equivalente;%@" class="insertext" size="55">
 </td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" width="213" align="right" class="etiqueta" height="1"></td>
 <td width="430" bgcolor="#CCD2D7"></td>
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
