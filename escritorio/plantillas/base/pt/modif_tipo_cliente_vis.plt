
<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="3"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="13"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF"> <table width="645" border="0" cellspacing="0" cellpadding="0">
<form name="modif_tipo_cliente" action="?seccion=bo_tipo_cliente" method=post>
<input type=hidden name=registro[id_tipo_cliente] value="@%db:Tipo_cliente.id_tipo_cliente;%@">
<input type=hidden name=estado value=1>
 <tr bgcolor="#CCD2D7"> <td colspan="3" height="22"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="161" class="etiqueta" align="right" height="22">Nome:</td>
 <td width="400" class="texto"> <!--@%Tipo_cliente.id_tipo_cliente;%@-->
 @%db:Tipo_cliente.nombre;%@
<input type="hidden" name="registro[nombre]" value="@%db:Tipo_cliente.nombre;%@" class="insertext" size="40">
 </td>
 <td width="1" bgcolor="#CCCCCC"></td>
 </tr>
 <tr bgcolor="#CCD2D7"> <td colspan="3" class="etiqueta" align="right" height="1"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="161" class="etiqueta" align="right" height="22">Descrição:</td>
 <td width="400" class="texto"> @%db:Tipo_cliente.descripcion;%@
<input type="hidden" name="registro[descripcion]" value="@%db:Tipo_cliente.descripcion;%@" size="70" class="insertext">
 </td>
 <td width="1" bgcolor="#CCCCCC"></td>
 </tr>
 <tr bgcolor="#CCD2D7"> <td colspan="3" class="etiqueta" align="right" height="1"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="161" class="etiqueta" align="right" height="22">IVA:</td>
 <td width="400" class="texto"> <!--@%db:Tipo_cliente.aplicar_iva%@-->
 @%db:si_no_flag{aplicar_iva}%@ </td>
 <td width="1" bgcolor="#CCCCCC"></td>
 </tr>
 <tr bgcolor="#CCD2D7"> <td colspan="3" class="etiqueta" align="right" height="1"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="161" class="etiqueta" align="right" height="22">Sobretaxa Equivalente:</td>
 <td width="400" class="texto"> <!--@%db:Tipo_cliente.aplicar_recargo%@-->
 @%db:si_no_flag{aplicar_recargo}%@ </td>
 <td width="1" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td height="1" width="161" bgcolor="#CCD2D7"></td>
 <td height="1" width="316" bgcolor="#CCD2D7"></td>
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
