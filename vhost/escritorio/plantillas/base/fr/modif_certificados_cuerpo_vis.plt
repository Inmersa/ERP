@%where:tabla|Certificados;%@

<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="13"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF"> <table width="645" border="0" cellspacing="0" cellpadding="0">
 <form name="modif_certificados" action="?seccion=bo_certificados" method=post>
 <input type=hidden name=registro[id_certificado] value="@%db:Certificados.id_certificado;%@">
 <input type=hidden name=estado value=1>
 <tr bgcolor="#CCD2D7"> <td colspan="3" height="22"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="215" class="etiqueta" align="right" height="22"> <!--@%Certificados.id_certificado;%@-->
 Nom:</td>
 <td width="428" class="texto"> @%db:Certificados.nombre;%@
<input type="hidden" name="registro[nombre]" value="@%db:Certificados.nombre;%@" class="insertext" size="40">
 </td>
 <td width="2" bgcolor="#CCCCCC"></td>
 </tr>
 <tr bgcolor="#CCD2D7"> <td colspan="3" height="1"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="215" class="etiqueta" align="right" height="22">Description:</td>
 <td width="428" class="texto"> @%db:Certificados.descripcion;%@
<input type="hidden" name="registro[descripcion]" value="@%db:Certificados.descripcion;%@" class="insertext" size="65">
 </td>
 <td width="2" bgcolor="#CCCCCC"></td>
 </tr>
 <tr bgcolor="#CCD2D7"> <td colspan="3" height="1"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="215" class="etiqueta" align="right" height="22">Reponsable:</td>
 <td width="428" class="texto"> @%db:Certificados.responsable;%@
<input type="hidden" name="registro[responsable]" value="@%db:Certificados.responsable;%@" class="insertext" size="40">
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
@%end-where:%@ 

